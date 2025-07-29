import Foundation

/// ViewModel for AchievementsView, manages achievements and unlock logic
class AchievementsViewModel: ObservableObject {
    // List of achievements
    @Published var achievements: [Achievement] = []
    private let achievementsKey = "achievements"
    
    init() {
        loadAchievements()
    }
    
    /// Загружает ачивки из UserDefaults или создает дефолтные
    func loadAchievements() {
        if let data = UserDefaults.standard.data(forKey: achievementsKey),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        } else {
            achievements = [
                Achievement(id: "first_win", title: "First Win 🥳", emoji: "🥳", isUnlocked: false),
                Achievement(id: "no_mistakes", title: "No Mistakes 🚫", emoji: "🚫", isUnlocked: false),
                Achievement(id: "under_30s", title: "Under 30 Seconds ⚡️", emoji: "⚡️", isUnlocked: false)
            ]
        }
    }
    
    /// Сохраняет ачивки в UserDefaults
    private func saveAchievements() {
        if let data = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(data, forKey: achievementsKey)
        }
    }
    
    /// Проверяет и разблокирует ачивки по результату игры
    func checkAchievements(result: GameResult, triggeredTrap: Bool) {
        var updated = false
        for i in achievements.indices {
            if achievements[i].id == "first_win" && !achievements[i].isUnlocked {
                achievements[i].isUnlocked = true
                updated = true
            }
            if achievements[i].id == "no_mistakes" && !achievements[i].isUnlocked && !triggeredTrap {
                achievements[i].isUnlocked = true
                updated = true
            }
            if achievements[i].id == "under_30s" && !achievements[i].isUnlocked && result.timeTaken <= 30 {
                achievements[i].isUnlocked = true
                updated = true
            }
        }
        if updated { saveAchievements() }
    }
} 