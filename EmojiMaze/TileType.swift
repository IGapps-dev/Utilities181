import Foundation

/// Represents the type of each tile in the maze grid
enum TileType: String, Codable, CaseIterable {
    case wall   // 🧱 Wall tile
    case path   // 🛣️ Path tile
    case key    // 🗝 Key tile
    case exit   // 🚪 Exit tile
    case trap   // 💥 Trap tile
} 