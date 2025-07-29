import Foundation

/// ViewModel for HistoryView, manages list of past games
class HistoryViewModel: ObservableObject {
    // List of past game results
    @Published var history: [GameResult] = []
    
    private let historyKey = "gameHistory"
    
    init() {
        loadHistory()
    }
    
    /// Loads history from UserDefaults
    func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([GameResult].self, from: data) {
            history = decoded
        } else {
            history = []
        }
    }
    
    /// Adds a new game result and saves to UserDefaults
    func addResult(_ result: GameResult) {
        history.insert(result, at: 0)
        saveHistory()
    }
    
    /// Clears all history
    func clearHistory() {
        history = []
        saveHistory()
    }
    
    /// Saves history to UserDefaults
    private func saveHistory() {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }
} 