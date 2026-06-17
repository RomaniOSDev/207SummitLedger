import Foundation

extension AppDataStore {
    var homeGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning, alpinist"
        case 12..<17: return "Good afternoon, alpinist"
        case 17..<22: return "Good evening, alpinist"
        default: return "Rest well, alpinist"
        }
    }

    var nextUpcomingTrip: Trip? {
        trips
            .filter { $0.status != .completed }
            .sorted { lhs, rhs in
                if lhs.status == .active && rhs.status != .active { return true }
                if rhs.status == .active && lhs.status != .active { return false }
                return lhs.startDate < rhs.startDate
            }
            .first
    }

    var daysUntilNextTrip: Int? {
        guard let trip = nextUpcomingTrip else { return nil }
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let start = cal.startOfDay(for: trip.startDate)
        return cal.dateComponents([.day], from: today, to: start).day
    }

    var bucketListPeaksForHome: [Destination] {
        bucketListPeaks.prefix(8).map { $0 }
    }

    var packingProgress: (done: Int, total: Int) {
        let total = travelItems.count
        let done = travelItems.filter(\.completed).count
        return (done, total)
    }

    var documentsProgress: (done: Int, total: Int) {
        let total = documents.count
        let done = documents.filter(\.completed).count
        return (done, total)
    }

    var unlockedAchievementCount: Int {
        achievementsUnlocked.count
    }

    var totalAchievementCount: Int {
        AchievementDefinition.all.count + SeasonalAchievement.all.count
    }
}
