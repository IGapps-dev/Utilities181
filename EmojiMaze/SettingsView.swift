import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                Text("Settings")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top)
                Toggle(isOn: $viewModel.soundOn) {
                    Label("Sound", systemImage: viewModel.soundOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .padding(.trailing)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Difficulty")
                        .font(.headline)
                        .foregroundColor(.white)
                    Picker("Difficulty", selection: $viewModel.difficulty) {
                        Text("Easy").tag("easy")
                        Text("Normal").tag("normal")
                        Text("Hard").tag("hard")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding(.trailing)
                VStack(alignment: .leading, spacing: 12) {
                    SettingsLinkButton(title: "Privacy Policy", url: "https://www.example.com/privacy")
                    SettingsLinkButton(title: "Terms of Use", url: "https://www.example.com/terms")
                    SettingsLinkButton(title: "Contact Us", url: "mailto:support@example.com")
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("Settings ⚙️")
    }
}

/// Custom button for opening external links
struct SettingsLinkButton: View {
    let title: String
    let url: String
    var body: some View {
        Button(action: {
            if let link = URL(string: url) {
                UIApplication.shared.open(link)
            }
        }) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.8))
                .foregroundColor(.blue)
                .cornerRadius(16)
                .shadow(radius: 8)
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
} 
