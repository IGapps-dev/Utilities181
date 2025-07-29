import SwiftUI

struct AchievementsView: View {
    @ObservedObject var viewModel: AchievementsViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Text("Achievements")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top)
                ForEach(viewModel.achievements) { achievement in
                    AchievementCardView(achievement: achievement)
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("Achievements 🏅")
    }
}

/// Card view for displaying a single achievement
struct AchievementCardView: View {
    let achievement: Achievement
    var body: some View {
        HStack {
            Text(achievement.emoji)
                .font(.largeTitle)
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.headline)
                Text(achievement.isUnlocked ? "Unlocked" : "Locked")
                    .font(.caption)
                    .foregroundColor(achievement.isUnlocked ? .green : .secondary)
            }
            Spacer()
            Image(systemName: achievement.isUnlocked ? "checkmark.seal.fill" : "lock.fill")
                .foregroundColor(achievement.isUnlocked ? .green : .gray)
                .font(.title2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.15))
                .shadow(radius: 4)
        )
    }
}

#Preview {
    AchievementsView(viewModel: AchievementsViewModel())
} 