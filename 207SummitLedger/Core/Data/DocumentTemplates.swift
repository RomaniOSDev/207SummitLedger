import Foundation

struct DocumentTemplate: Identifiable {
    let id: String
    let title: String
    let items: [String]
}

enum DocumentTemplates {
    static let all: [DocumentTemplate] = [
        DocumentTemplate(
            id: "beach",
            title: "Beach Trip",
            items: ["Passport / ID", "Travel insurance", "Flight tickets", "Hotel confirmation", "Credit cards", "Sunscreen receipt (optional)"]
        ),
        DocumentTemplate(
            id: "business",
            title: "Business",
            items: ["Passport / ID", "Visa (if required)", "Business invitation", "Hotel booking", "Company insurance", "Presentation materials"]
        ),
        DocumentTemplate(
            id: "eu",
            title: "EU Travel",
            items: ["Passport / ID", "EHIC / health card", "Travel insurance", "Train / flight tickets", "Accommodation proof", "Emergency contacts"]
        )
    ]
}
