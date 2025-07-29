import SwiftUI

struct MainTabView: View {
    @StateObject private var achievementsVM = AchievementsViewModel()
    @StateObject private var settingsVM = SettingsViewModel()
    var body: some View {
        TabView {
            GameView(achievementsVM: achievementsVM, difficulty: settingsVM.difficulty)
                .id(settingsVM.difficulty) // пересоздаёт GameView при смене сложности
                .tabItem {
                    Label("Game", systemImage: "gamecontroller")
                    Text("🎮")
                }
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "scroll")
                    Text("📜")
                }
            AchievementsView(viewModel: achievementsVM)
                .tabItem {
                    Label("Achievements", systemImage: "rosette")
                    Text("🏅")
                }
            SettingsView(viewModel: settingsVM)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                    Text("⚙️")
                }
        }
    }
}

#Preview {
    MainTabView()
} 