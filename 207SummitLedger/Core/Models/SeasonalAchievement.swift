import Foundation

struct SeasonalAchievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let systemImage: String

    static let all: [SeasonalAchievement] = [
        SeasonalAchievement(
            id: "winter_alpinist",
            title: "Winter Alpinist",
            description: "Planned a winter-season expedition.",
            systemImage: "snowflake"
        ),
        SeasonalAchievement(
            id: "catalog_explorer",
            title: "Catalog Explorer",
            description: "Added three peaks from the world catalog.",
            systemImage: "book.fill"
        ),
        SeasonalAchievement(
            id: "packing_starter",
            title: "Pack Smart",
            description: "Applied an alpine gear template.",
            systemImage: "backpack.fill"
        ),
        SeasonalAchievement(
            id: "expedition_planner",
            title: "Expedition Planner",
            description: "Created three planned expeditions.",
            systemImage: "calendar.badge.plus"
        ),
        SeasonalAchievement(
            id: "prep_streak",
            title: "Prep Streak",
            description: "Maintained a seven-day preparation streak.",
            systemImage: "flame.fill"
        ),
        SeasonalAchievement(
            id: "permit_ready",
            title: "Permit Ready",
            description: "Completed a full permits checklist.",
            systemImage: "doc.text.fill"
        )
    ]

    func isUnlocked(store: AppDataStore) -> Bool {
        switch id {
        case "winter_alpinist":
            return store.winterTripsPlanned >= 1
        case "catalog_explorer":
            return store.catalogPeaksAdded >= 3
        case "packing_starter":
            return store.packingTemplatesUsed >= 1
        case "expedition_planner":
            return store.trips.count >= 3
        case "prep_streak":
            return store.streakDays >= 7
        case "permit_ready":
            return store.documentsChecklistsCompleted >= 1
        default:
            return false
        }
    }
}
