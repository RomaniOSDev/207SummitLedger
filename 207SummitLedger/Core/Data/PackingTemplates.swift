import Foundation

struct PackingTemplate: Identifiable {
    let id: String
    let title: String
    let items: [(name: String, category: String)]
}

enum PackingTemplates {
    static let all: [PackingTemplate] = [
        PackingTemplate(
            id: "weekend",
            title: "Weekend",
            items: [
                ("Toothbrush", "Toiletries"),
                ("Phone charger", "Electronics"),
                ("T-shirts (2)", "Clothing"),
                ("Jeans", "Clothing"),
                ("Sneakers", "Clothing"),
                ("Wallet", "Electronics")
            ]
        ),
        PackingTemplate(
            id: "beach",
            title: "Beach",
            items: [
                ("Swimsuit", "Clothing"),
                ("Sunscreen", "Toiletries"),
                ("Sandals", "Clothing"),
                ("Sunglasses", "Clothing"),
                ("Beach towel", "Clothing"),
                ("Hat", "Clothing")
            ]
        ),
        PackingTemplate(
            id: "winter",
            title: "Winter",
            items: [
                ("Winter coat", "Clothing"),
                ("Thermal layers", "Clothing"),
                ("Gloves", "Clothing"),
                ("Scarf", "Clothing"),
                ("Boots", "Clothing"),
                ("Lip balm", "Toiletries")
            ]
        )
    ]
}
