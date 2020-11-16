import Foundation

struct Project: Codable {
    let name: String
    var timeSpent: Int
    var isActive: Bool
    var startedAt: Date?
}
