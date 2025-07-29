import SwiftUI

struct OnboardingView: View {
    // Track the current onboarding page
    @State private var page: Int = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        ZStack {
            // Gradient background for visual style
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(spacing: 40) {
                Spacer()
                Group {
                    if page == 0 {
                        VStack(spacing: 16) {
                            Text("Swipe to move your emoji 🧭")
                                .font(.title)
                                .bold()
                            Text("Navigate the maze by swiping in any direction.")
                                .font(.body)
                        }
                    } else if page == 1 {
                        VStack(spacing: 16) {
                            Text("Collect keys and reach the exit 🗝🚪")
                                .font(.title)
                                .bold()
                            Text("Find the key before heading to the exit.")
                                .font(.body)
                        }
                    } else {
                        VStack(spacing: 16) {
                            Text("Avoid traps and beat your time! ⏱")
                                .font(.title)
                                .bold()
                            Text("Watch out for traps and try to finish quickly.")
                                .font(.body)
                        }
                    }
                }
                Spacer()
                Button(action: {
                    if page < 2 {
                        page += 1
                    } else {
                        // Mark onboarding as seen
                        hasSeenOnboarding = true
                    }
                }) {
                    Text(page < 2 ? "Next" : "Start Playing")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.8))
                        .foregroundColor(.blue)
                        .cornerRadius(16)
                        .shadow(radius: 8)
                }
                .padding(.horizontal, 32)
                Spacer()
            }
        }
    }
}

// Preview for SwiftUI canvas
#Preview {
    OnboardingView()
} 