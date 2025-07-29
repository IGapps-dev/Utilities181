import Foundation

/// Represents an achievement that can be unlocked by the player
struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let emoji: String
    var isUnlocked: Bool
} 