import Foundation
import SwiftUI

/// ViewModel for the GameView, handles maze logic and player state
class GameViewModel: ObservableObject {
    // The maze grid, 2D array of TileType
    @Published var grid: [[TileType]] = []
    // Player's current position in the grid (row, col)
    @Published var playerPosition: (row: Int, col: Int) = (0, 0)
    // Number of moves made
    @Published var moves: Int = 0
    // Timer for the current game
    @Published var timeElapsed: TimeInterval = 0
    // Whether the key has been collected
    @Published var hasKey: Bool = false
    let difficulty: String
    // Timer object
    private var timer: Timer?
    // Game state
    @Published var isGameActive: Bool = true
    // Placeholder for collected traps (for achievements)
    @Published var triggeredTrap: Bool = false
    // Для сохранения истории
    private var historyVM = HistoryViewModel()
    // Для ачивок
    private var achievementsVM: AchievementsViewModel

    init(achievementsVM: AchievementsViewModel, difficulty: String) {
        self.achievementsVM = achievementsVM
        self.difficulty = difficulty
        startNewGame()
    }

    /// Generates a new maze and resets state
    func startNewGame() {
        // Размер лабиринта по сложности
        let size = difficulty == "easy" ? 7 : (difficulty == "hard" ? 15 : 11)
        // Генерируем пустой лабиринт (все стены)
        var maze = Array(repeating: Array(repeating: TileType.wall, count: size), count: size)
        // DFS генерация
        var visited = Array(repeating: Array(repeating: false, count: size), count: size)
        func dfs(row: Int, col: Int) {
            visited[row][col] = true
            maze[row][col] = .path
            var dirs = [(0,2),(0,-2),(2,0),(-2,0)]
            dirs.shuffle()
            for (dr, dc) in dirs {
                let nr = row + dr, nc = col + dc
                if nr > 0 && nr < size-1 && nc > 0 && nc < size-1 && !visited[nr][nc] {
                    maze[row+dr/2][col+dc/2] = .path // ломаем стену между
                    dfs(row: nr, col: nc)
                }
            }
        }
        // Стартовая точка всегда (1,1)
        dfs(row: 1, col: 1)
        // Сохраняем сгенерированный лабиринт
        grid = maze
        // Список всех путей
        var pathCells: [(Int,Int)] = []
        for r in 1..<size-1 {
            for c in 1..<size-1 {
                if grid[r][c] == .path { pathCells.append((r,c)) }
            }
        }
        // Размещаем ключ и выход в разных концах лабиринта
        let start = (1,1)
        playerPosition = start
        // Ключ — самый удалённый путь от старта
        let keyPos = farthestCell(from: start, in: grid)
        grid[keyPos.0][keyPos.1] = .key
        // Выход — самый удалённый путь от ключа
        let exitPos = farthestCell(from: keyPos, in: grid)
        grid[exitPos.0][exitPos.1] = .exit
        // Ловушки — случайные клетки, не старт, не ключ, не выход
        let trapCount = difficulty == "easy" ? 2 : (difficulty == "hard" ? 8 : 4)
        let forbidden = [start, keyPos, exitPos]
        var trapCandidates = pathCells.filter { cell in !forbidden.contains(where: { $0 == cell }) }
        trapCandidates.shuffle()
        for i in 0..<min(trapCount, trapCandidates.count) {
            let t = trapCandidates[i]
            grid[t.0][t.1] = .trap
        }
        moves = 0
        hasKey = false
        timeElapsed = 0
        isGameActive = true
        triggeredTrap = false
        startTimer()
    }

    // Поиск самой дальней клетки (BFS)
    private func farthestCell(from start: (Int,Int), in grid: [[TileType]]) -> (Int,Int) {
        let size = grid.count
        var visited = Array(repeating: Array(repeating: false, count: size), count: size)
        var queue: [((Int,Int),Int)] = [(start,0)]
        var farthest = start
        var maxDist = 0
        while !queue.isEmpty {
            let ((r,c),d) = queue.removeFirst()
            if visited[r][c] { continue }
            visited[r][c] = true
            if d > maxDist { maxDist = d; farthest = (r,c) }
            for (dr,dc) in [(-1,0),(1,0),(0,-1),(0,1)] {
                let nr = r+dr, nc = c+dc
                if nr >= 0 && nr < size && nc >= 0 && nc < size && !visited[nr][nc] && grid[nr][nc] == .path {
                    queue.append(((nr,nc),d+1))
                }
            }
        }
        return farthest
    }

    /// Handles player movement in the given direction
    func movePlayer(direction: Direction) {
        guard isGameActive else { return }
        let (row, col) = playerPosition
        var newRow = row
        var newCol = col
        // Update position based on direction
        switch direction {
        case .up: newRow -= 1
        case .down: newRow += 1
        case .left: newCol -= 1
        case .right: newCol += 1
        }
        // Check bounds
        guard newRow >= 0, newRow < grid.count, newCol >= 0, newCol < grid[0].count else { return }
        let tile = grid[newRow][newCol]
        // Block movement if wall
        if tile == .wall { return }
        // Move player
        playerPosition = (newRow, newCol)
        moves += 1
        // Handle tile effects
        switch tile {
        case .key:
            hasKey = true
            // Remove key from grid
            grid[newRow][newCol] = .path
        case .exit:
            if hasKey {
                // Player wins
                isGameActive = false
                stopTimer()
                // Сохраняем результат игры
                let result = GameResult(id: UUID(), date: Date(), timeTaken: timeElapsed, movesCount: moves, difficulty: difficulty)
                historyVM.addResult(result)
                // Проверяем ачивки
                achievementsVM.checkAchievements(result: result, triggeredTrap: triggeredTrap)
            }
        case .trap:
            triggeredTrap = true
            // Optionally: End game or penalize
        default:
            break
        }
    }

    /// Starts the game timer
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, self.isGameActive else { return }
            self.timeElapsed += 1
        }
    }

    /// Stops the game timer
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    deinit {
        timer?.invalidate()
    }
} 