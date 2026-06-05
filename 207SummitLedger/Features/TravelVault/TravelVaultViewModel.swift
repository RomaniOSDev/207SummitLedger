import Combine
import Foundation

enum DestinationSortMode: String, CaseIterable, Identifiable {
    case name
    case country
    case date
    case visited

    var id: String { rawValue }

    var title: String {
        switch self {
        case .name: return "Name"
        case .country: return "Country"
        case .date: return "Date"
        case .visited: return "Visited"
        }
    }
}

final class TravelVaultViewModel: ObservableObject {
    @Published var showAddSheet = false
    @Published var editingDestination: Destination?
    @Published var selectedDestination: Destination?
    @Published var searchText = ""
    @Published var sortMode: DestinationSortMode = .name
    @Published var sharePayload: String?

    func flagForCountry(_ country: String) -> String {
        let map: [String: String] = [
            "United States": "🇺🇸", "USA": "🇺🇸",
            "United Kingdom": "🇬🇧", "UK": "🇬🇧",
            "France": "🇫🇷", "Germany": "🇩🇪", "Italy": "🇮🇹",
            "Spain": "🇪🇸", "Japan": "🇯🇵", "Canada": "🇨🇦",
            "Australia": "🇦🇺", "Mexico": "🇲🇽", "Switzerland": "🇨🇭",
            "Brazil": "🇧🇷", "Thailand": "🇹🇭", "Greece": "🇬🇷"
        ]
        return map[country] ?? "🌍"
    }

    func filteredDestinations(from store: AppDataStore) -> [Destination] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        var list = store.destinations
        if !query.isEmpty {
            list = list.filter {
                $0.name.lowercased().contains(query) ||
                $0.country.lowercased().contains(query) ||
                $0.note.lowercased().contains(query)
            }
        }
        switch sortMode {
        case .name:
            list.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .country:
            list.sort { $0.country.localizedCaseInsensitiveCompare($1.country) == .orderedAscending }
        case .date:
            list.sort { ($0.plannedDate ?? .distantFuture) < ($1.plannedDate ?? .distantFuture) }
        case .visited:
            list.sort { lhs, rhs in
                if lhs.visited == rhs.visited { return lhs.name < rhs.name }
                return !lhs.visited && rhs.visited
            }
        }
        return list
    }
}
