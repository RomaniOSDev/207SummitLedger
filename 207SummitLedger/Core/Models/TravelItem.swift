import Foundation

struct TravelItem: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var category: String
    var completed: Bool

    init(id: UUID = UUID(), name: String, category: String, completed: Bool = false) {
        self.id = id
        self.name = name
        self.category = category
        self.completed = completed
    }
}
