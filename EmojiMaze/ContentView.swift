
import SwiftUI

struct ContentView: View {
    // Observe onboarding status from UserDefaults
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        if hasSeenOnboarding {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}

// Preview for SwiftUI canvas
#Preview {
    ContentView()
}
