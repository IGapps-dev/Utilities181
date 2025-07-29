import Foundation
import SwiftUI

/// ViewModel for SettingsView, manages user settings
class SettingsViewModel: ObservableObject {
    // Sound toggle
    @AppStorage("soundOn") var soundOn: Bool = true
    // Difficulty level
    @AppStorage("difficulty") var difficulty: String = "normal"
} 