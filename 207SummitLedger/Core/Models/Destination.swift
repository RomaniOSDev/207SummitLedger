import Foundation

/// A peak entry in the summit log (`visited` = summited).
struct Destination: Identifiable, Codable, Equatable, Hashable {
    var id: UUID
    var name: String
    var country: String
    var flagEmoji: String
    var visited: Bool
    var plannedDate: Date?
    var note: String
    var elevationMeters: Int
    var mountainRange: String
    var difficulty: SummitDifficulty

    init(
        id: UUID = UUID(),
        name: String,
        country: String,
        flagEmoji: String,
        visited: Bool = false,
        plannedDate: Date? = nil,
        note: String = "",
        elevationMeters: Int = 0,
        mountainRange: String = "",
        difficulty: SummitDifficulty = .moderate
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.flagEmoji = flagEmoji
        self.visited = visited
        self.plannedDate = plannedDate
        self.note = note
        self.elevationMeters = elevationMeters
        self.mountainRange = mountainRange
        self.difficulty = difficulty
    }

    var isSummited: Bool { visited }

    var elevationDisplay: String {
        guard elevationMeters > 0 else { return "—" }
        return "\(elevationMeters.formatted()) m"
    }

    enum CodingKeys: String, CodingKey {
        case id, name, country, flagEmoji, visited, plannedDate, note
        case elevationMeters, mountainRange, difficulty
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        country = try c.decode(String.self, forKey: .country)
        flagEmoji = try c.decode(String.self, forKey: .flagEmoji)
        visited = try c.decode(Bool.self, forKey: .visited)
        plannedDate = try c.decodeIfPresent(Date.self, forKey: .plannedDate)
        note = try c.decodeIfPresent(String.self, forKey: .note) ?? ""
        elevationMeters = try c.decodeIfPresent(Int.self, forKey: .elevationMeters) ?? 0
        mountainRange = try c.decodeIfPresent(String.self, forKey: .mountainRange) ?? ""
        difficulty = try c.decodeIfPresent(SummitDifficulty.self, forKey: .difficulty) ?? .moderate
    }
}
