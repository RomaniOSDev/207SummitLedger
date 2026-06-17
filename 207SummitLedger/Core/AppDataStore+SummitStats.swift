import Foundation

extension AppDataStore {
    var summitedPeaks: [Destination] {
        destinations.filter(\.visited)
    }

    var bucketListPeaks: [Destination] {
        destinations.filter { !$0.visited }
    }

    var highestSummitedElevation: Int {
        summitedPeaks.map(\.elevationMeters).max() ?? 0
    }

    var totalLoggedElevation: Int {
        summitedPeaks.reduce(0) { $0 + $1.elevationMeters }
    }

    var averageSummitedElevation: Int {
        let peaks = summitedPeaks.filter { $0.elevationMeters > 0 }
        guard !peaks.isEmpty else { return 0 }
        return peaks.reduce(0) { $0 + $1.elevationMeters } / peaks.count
    }

    func peaks(atOrAbove meters: Int) -> Int {
        summitedPeaks.filter { $0.elevationMeters >= meters }.count
    }

    func addPeakFromCatalog(_ entry: PeakCatalogEntry) {
        let exists = destinations.contains {
            $0.name.caseInsensitiveCompare(entry.name) == .orderedSame
        }
        guard !exists else { return }
        catalogPeaksAdded += 1
        addDestination(entry.asDestination())
    }

    func markSummited(_ destination: Destination) {
        markVisited(destination)
    }
}
