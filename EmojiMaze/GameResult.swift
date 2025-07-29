import Foundation

/// Stores the result of a completed game
struct GameResult: Identifiable, Codable {
    let id: UUID
    let date: Date
    let timeTaken: TimeInterval // seconds
    let movesCount: Int
    let difficulty: String // easy, normal, hard
} 