import Foundation

enum SummitDifficulty: String, Codable, CaseIterable, Identifiable, Hashable {
    case beginner
    case moderate
    case hard
    case expert

    var id: String { rawValue }

    var title: String {
        switch self {
        case .beginner: return "Beginner"
        case .moderate: return "Moderate"
        case .hard: return "Hard"
        case .expert: return "Expert"
        }
    }

    var icon: String {
        switch self {
        case .beginner: return "figure.hiking"
        case .moderate: return "mountain.2"
        case .hard: return "mountain.2.fill"
        case .expert: return "snowflake"
        }
    }
}
