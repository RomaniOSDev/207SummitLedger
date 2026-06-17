import Foundation

struct AchievementDefinition: Identifiable {
    let id: String
    let title: String
    let description: String
    let systemImage: String

    static let all: [AchievementDefinition] = [
        AchievementDefinition(
            id: "first_summit",
            title: "First Summit",
            description: "Logged your first peak in the summit ledger.",
            systemImage: "flag.fill"
        ),
        AchievementDefinition(
            id: "high_altitude",
            title: "High Altitude",
            description: "Summited a peak at 4,000 m or higher.",
            systemImage: "mountain.2.fill"
        ),
        AchievementDefinition(
            id: "seven_summits_starter",
            title: "Seven Summits Starter",
            description: "Logged five different peaks.",
            systemImage: "star.fill"
        ),
        AchievementDefinition(
            id: "expedition_leader",
            title: "Expedition Leader",
            description: "Completed three expeditions.",
            systemImage: "map.fill"
        ),
        AchievementDefinition(
            id: "gear_ready",
            title: "Gear Ready",
            description: "Completed ten alpine gear checklists.",
            systemImage: "backpack.fill"
        ),
        AchievementDefinition(
            id: "safety_first",
            title: "Safety First",
            description: "Finished a full safety & permits checklist.",
            systemImage: "shield.checkered"
        ),
        AchievementDefinition(
            id: "ridge_walker",
            title: "Ridge Walker",
            description: "Logged fifteen peaks in your ledger.",
            systemImage: "figure.hiking"
        ),
        AchievementDefinition(
            id: "summit_master",
            title: "Summit Master",
            description: "Completed ten expeditions.",
            systemImage: "trophy.fill"
        )
    ]

    func isUnlocked(store: AppDataStore) -> Bool {
        switch id {
        case "first_summit":
            return store.summitedPeaks.count >= 1
        case "high_altitude":
            return store.highestSummitedElevation >= 4000
        case "seven_summits_starter":
            return store.destinationsAdded >= 5
        case "expedition_leader":
            return store.tripsCompleted >= 3
        case "gear_ready":
            return store.checklistsCompleted >= 10
        case "safety_first":
            return store.documentsChecklistsCompleted >= 1
        case "ridge_walker":
            return store.destinationsAdded >= 15
        case "summit_master":
            return store.tripsCompleted >= 10
        default:
            return false
        }
    }
}
