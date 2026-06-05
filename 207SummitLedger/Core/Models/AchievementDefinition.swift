import Foundation

struct AchievementDefinition: Identifiable {
    let id: String
    let title: String
    let description: String
    let systemImage: String

    static let all: [AchievementDefinition] = [
        AchievementDefinition(
            id: "first_step",
            title: "First Step",
            description: "Added your first destination.",
            systemImage: "airplane.departure"
        ),
        AchievementDefinition(
            id: "dream_big",
            title: "Dream Big",
            description: "Added ten destinations to your wishlist.",
            systemImage: "star.fill"
        ),
        AchievementDefinition(
            id: "travel_master",
            title: "Travel Master",
            description: "Completed five trips successfully.",
            systemImage: "map.fill"
        ),
        AchievementDefinition(
            id: "packing_pro",
            title: "Packing Pro",
            description: "Completed ten packing checklists.",
            systemImage: "suitcase.fill"
        ),
        AchievementDefinition(
            id: "language_learner",
            title: "Language Learner",
            description: "Viewed five different phrases in reference tool.",
            systemImage: "text.bubble.fill"
        ),
        AchievementDefinition(
            id: "currency_converter",
            title: "Currency Converter",
            description: "Ran currency conversion twenty times.",
            systemImage: "dollarsign.circle.fill"
        ),
        AchievementDefinition(
            id: "explorer",
            title: "Explorer",
            description: "Added twenty destinations to your wishlist.",
            systemImage: "globe.americas.fill"
        ),
        AchievementDefinition(
            id: "global_adventurer",
            title: "Global Adventurer",
            description: "Completed twenty-five trips around the world.",
            systemImage: "flag.fill"
        )
    ]

    func isUnlocked(store: AppDataStore) -> Bool {
        switch id {
        case "first_step":
            return store.destinationsAdded >= 1
        case "dream_big":
            return store.destinationsAdded >= 10
        case "travel_master":
            return store.tripsCompleted >= 5
        case "packing_pro":
            return store.checklistsCompleted >= 10
        case "language_learner":
            return store.phrasesViewed >= 5
        case "currency_converter":
            return store.conversionsRun >= 20
        case "explorer":
            return store.destinationsAdded >= 20
        case "global_adventurer":
            return store.tripsCompleted >= 25
        default:
            return false
        }
    }
}
