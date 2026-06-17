import Foundation

struct DocumentTemplate: Identifiable {
    let id: String
    let title: String
    let items: [String]
}

enum DocumentTemplates {
    static let all: [DocumentTemplate] = [
        DocumentTemplate(
            id: "national_park",
            title: "National Park Permit",
            items: [
                "Park entry permit",
                "Climbing registration",
                "Guide license (if required)",
                "Emergency contact card",
                "Rescue insurance proof",
                "Weather briefing notes"
            ]
        ),
        DocumentTemplate(
            id: "high_altitude",
            title: "High Altitude",
            items: [
                "Expedition permit",
                "Medical clearance",
                "Altitude sickness plan",
                "Evacuation insurance",
                "Team roster",
                "Radio / beacon registration"
            ]
        ),
        DocumentTemplate(
            id: "international",
            title: "International Ascent",
            items: [
                "Passport copy",
                "Visa / entry permit",
                "Mountaineering federation card",
                "Liability waiver",
                "Local operator contract",
                "Embassy emergency number"
            ]
        )
    ]
}
