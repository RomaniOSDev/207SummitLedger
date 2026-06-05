import Foundation

struct Destination: Identifiable, Codable, Equatable, Hashable {
    var id: UUID
    var name: String
    var country: String
    var flagEmoji: String
    var visited: Bool
    var plannedDate: Date?
    var note: String

    init(
        id: UUID = UUID(),
        name: String,
        country: String,
        flagEmoji: String,
        visited: Bool = false,
        plannedDate: Date? = nil,
        note: String = ""
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.flagEmoji = flagEmoji
        self.visited = visited
        self.plannedDate = plannedDate
        self.note = note
    }
}
