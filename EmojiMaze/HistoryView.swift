import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Text("Game History")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top)
                List(viewModel.history) { result in
                    HistoryCardView(result: result)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .background(Color.clear)
            }
            .padding(.horizontal)
        }
        .navigationTitle("History 📜")
    }
}

/// Card view for displaying a single game result
struct HistoryCardView: View {
    let result: GameResult
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(result.date, style: .date)
                    .font(.headline)
                Text("Time: \(Int(result.timeTaken))s  |  Moves: \(result.movesCount)")
                    .font(.subheadline)
                Text("Difficulty: \(result.difficulty.capitalized)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "rosette")
                .foregroundColor(.yellow)
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
    HistoryView()
} 