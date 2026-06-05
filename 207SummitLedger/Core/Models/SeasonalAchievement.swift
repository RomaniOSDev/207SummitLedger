import Foundation

struct SeasonalAchievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let systemImage: String

    static let all: [SeasonalAchievement] = [
        SeasonalAchievement(
            id: "winter_wanderer",
            title: "Winter Wanderer",
            description: "Planned a winter-season trip.",
            systemImage: "snowflake"
        ),
        SeasonalAchievement(
            id: "phrase_explorer",
            title: "Phrase Explorer",
            description: "Expanded three phrase categories.",
            systemImage: "text.book.closed.fill"
        ),
        SeasonalAchievement(
            id: "packing_starter",
            title: "Packing Starter",
            description: "Applied a packing template.",
            systemImage: "bag.fill"
        ),
        SeasonalAchievement(
            id: "trip_planner_pro",
            title: "Trip Planner Pro",
            description: "Created three planned trips.",
            systemImage: "calendar.badge.plus"
        ),
        SeasonalAchievement(
            id: "streak_champion",
            title: "Streak Champion",
            description: "Maintained a seven-day planning streak.",
            systemImage: "flame.fill"
        ),
        SeasonalAchievement(
            id: "document_ready",
            title: "Document Ready",
            description: "Completed a full document checklist.",
            systemImage: "doc.text.fill"
        )
    ]

    func isUnlocked(store: AppDataStore) -> Bool {
        switch id {
        case "winter_wanderer":
            return store.winterTripsPlanned >= 1
        case "phrase_explorer":
            return store.expandedCategories.count >= 3
        case "packing_starter":
            return store.packingTemplatesUsed >= 1
        case "trip_planner_pro":
            return store.trips.count >= 3
        case "streak_champion":
            return store.streakDays >= 7
        case "document_ready":
            return store.documentsChecklistsCompleted >= 1
        default:
            return false
        }
    }
}
