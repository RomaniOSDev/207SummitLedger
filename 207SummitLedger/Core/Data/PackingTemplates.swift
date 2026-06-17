import Foundation

struct PackingTemplate: Identifiable {
    let id: String
    let title: String
    let items: [(name: String, category: String)]
}

enum PackingTemplates {
    static let all: [PackingTemplate] = [
        PackingTemplate(
            id: "day_hike",
            title: "Day Hike",
            items: [
                ("Trail runners / boots", "Footwear"),
                ("Softshell jacket", "Layers"),
                ("Water bottles (2L)", "Nutrition"),
                ("Headlamp", "Safety"),
                ("First aid kit", "Safety"),
                ("Map & compass", "Navigation")
            ]
        ),
        PackingTemplate(
            id: "alpine_climb",
            title: "Alpine Climb",
            items: [
                ("Mountaineering boots", "Footwear"),
                ("Crampons", "Safety"),
                ("Ice axe", "Safety"),
                ("Harness & helmet", "Safety"),
                ("Insulated mid-layer", "Layers"),
                ("GPS / altimeter watch", "Navigation")
            ]
        ),
        PackingTemplate(
            id: "expedition",
            title: "Multi-day Expedition",
            items: [
                ("4-season tent", "Camp"),
                ("Sleeping bag (-10°C)", "Camp"),
                ("Stove & fuel", "Nutrition"),
                ("Freeze-dried meals", "Nutrition"),
                ("Down suit / parka", "Layers"),
                ("Satellite messenger", "Safety")
            ]
        )
    ]
}
