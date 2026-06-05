import Combine
import Foundation

final class TravelInventoryViewModel: ObservableObject {
    @Published var showAddSheet = false
    @Published var newItemName = ""
    @Published var selectedCategory = "Clothing"
    @Published var pulseItemId: UUID?
    @Published var searchText = ""
    @Published var showTemplates = false

    func filteredItems(from store: AppDataStore) -> [TravelItem] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return store.travelItems }
        return store.travelItems.filter {
            $0.name.lowercased().contains(q) || $0.category.lowercased().contains(q)
        }
    }

    func categoriesWithItems(store: AppDataStore) -> [String] {
        let items = filteredItems(from: store)
        return store.categories.filter { cat in items.contains { $0.category == cat } }
    }
}
