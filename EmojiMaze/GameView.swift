import SwiftUI

struct GameView: View {
    @ObservedObject var achievementsVM: AchievementsViewModel
    let difficulty: String
    @StateObject private var viewModel: GameViewModel
    @State private var animateMove = false
    
    init(achievementsVM: AchievementsViewModel, difficulty: String) {
        self.achievementsVM = achievementsVM
        self.difficulty = difficulty
        _viewModel = StateObject(wrappedValue: GameViewModel(achievementsVM: achievementsVM, difficulty: difficulty))
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gridSize = CGFloat(viewModel.grid.count)
            let padding: CGFloat = 32
            let maxCell: CGFloat = 40
            let cellSize = min((geometry.size.width - padding) / gridSize, maxCell)
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                VStack(spacing: 16) {
                    HStack {
                        Label("Time: \(Int(viewModel.timeElapsed))s", systemImage: "timer")
                            .foregroundColor(.white)
                        Spacer()
                        Label("Moves: \(viewModel.moves)", systemImage: "figure.walk")
                            .foregroundColor(.white)
                    }
                    .font(.headline)
                    .padding(.horizontal)
                    MazeGridView(grid: viewModel.grid, playerPosition: viewModel.playerPosition, animateMove: $animateMove, cellSize: cellSize)
                        .gesture(
                            DragGesture(minimumDistance: 20)
                                .onEnded { value in
                                    let direction = swipeDirection(from: value.translation)
                                    if let dir = direction {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            viewModel.movePlayer(direction: dir)
                                            animateMove.toggle()
                                        }
                                    }
                                }
                        )
                    Button(action: {
                        withAnimation { viewModel.startNewGame() }
                    }) {
                        Label("Restart Level", systemImage: "arrow.clockwise")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.blue)
                            .cornerRadius(16)
                            .shadow(radius: 8)
                    }
                    .padding(.horizontal)
                    Spacer()
                }
            }
            .navigationTitle("Emoji Maze 🎮")
        }
    }

    func swipeDirection(from translation: CGSize) -> Direction? {
        if abs(translation.width) > abs(translation.height) {
            return translation.width > 0 ? .right : .left
        } else if abs(translation.height) > 0 {
            return translation.height > 0 ? .down : .up
        }
        return nil
    }
}

/// Directions for player movement
enum Direction { case up, down, left, right }

/// Maze grid view with emoji tiles
struct MazeGridView: View {
    let grid: [[TileType]]
    let playerPosition: (row: Int, col: Int)
    @Binding var animateMove: Bool
    let cellSize: CGFloat
    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<grid.count, id: \ .self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<grid[row].count, id: \ .self) { col in
                        ZStack {
                            tileEmoji(for: grid[row][col])
                                .font(.system(size: cellSize * 0.8))
                                .frame(width: cellSize, height: cellSize)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                            if playerPosition.row == row && playerPosition.col == col {
                                Text("😃")
                                    .font(.system(size: cellSize * 0.8))
                                    .transition(.scale)
                                    .shadow(radius: 4)
                                    .scaleEffect(animateMove ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: animateMove)
                            }
                        }
                    }
                }
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.1)))
        .shadow(radius: 8)
    }
    /// Returns the emoji for a given tile type
    func tileEmoji(for type: TileType) -> Text {
        switch type {
        case .wall: return Text("🧱")
        case .path: return Text("🛣️")
        case .key:  return Text("🗝")
        case .exit: return Text("🚪")
        case .trap: return Text("💥")
        }
    }
}

#Preview {
    GameView(achievementsVM: AchievementsViewModel(), difficulty: "normal")
} 