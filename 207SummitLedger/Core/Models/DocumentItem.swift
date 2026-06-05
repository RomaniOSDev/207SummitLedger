import Foundation

struct DocumentItem: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var completed: Bool

    init(id: UUID = UUID(), name: String, completed: Bool = false) {
        self.id = id
        self.name = name
        self.completed = completed
    }
}
