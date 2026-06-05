import Combine
import SwiftUI

struct TravelInventoryView: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.showSuccessFeedback) private var showSuccessFeedback
    @StateObject private var viewModel = TravelInventoryViewModel()

    private var filtered: [TravelItem] {
        viewModel.filteredItems(from: store)
    }

    var body: some View {
        ZStack {
            AppBackgroundView()
            Group {
                if store.travelItems.isEmpty {
                    emptyState
                } else {
                    inventoryScroll
                }
            }
        }
        .navigationTitle("Travel Inventory")
        .searchable(text: $viewModel.searchText, prompt: "Search items")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Templates") {
                    FeedbackManager.tapLight()
                    viewModel.showTemplates = true
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color("AppPrimary"))
            }
        }
        .confirmationDialog("Packing Templates", isPresented: $viewModel.showTemplates, titleVisibility: .visible) {
            ForEach(PackingTemplates.all) { template in
                Button(template.title) {
                    store.applyPackingTemplate(template)
                    showSuccessFeedback()
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            FloatingActionBar(primaryTitle: "Add Item") {
                viewModel.showAddSheet = true
            }
        }
        .sheet(isPresented: $viewModel.showAddSheet) {
            addItemSheet
        }
    }

    private var emptyState: some View {
        ScrollView {
            EmptyStateView(
                icon: "suitcase.fill",
                title: "Start your inventory",
                message: "Add what you need to bring or apply a Weekend, Beach, or Winter template.",
                buttonTitle: "Add Item",
                action: { viewModel.showAddSheet = true }
            )
        }
        .clearScrollBackground()
    }

    private var inventoryScroll: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: TravelCardStyle.rowSpacing) {
                let completed = filtered.filter(\.completed).count
                SectionHeaderView(
                    title: "Packing List",
                    subtitle: "\(completed) of \(filtered.count) packed"
                )
                ForEach(viewModel.categoriesWithItems(store: store), id: \.self) { category in
                    Text(category.uppercased())
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color("AppAccent"))
                        .padding(.top, 4)
                    ForEach(filtered.filter { $0.category == category }) { item in
                        InventoryItemCell(
                            name: item.name,
                            category: item.category,
                            completed: item.completed,
                            isPulsing: viewModel.pulseItemId == item.id,
                            onToggle: { toggleItem(item) }
                        )
                        .contextMenu {
                            Button(item.completed ? "Mark Incomplete" : "Mark Packed") {
                                toggleItem(item)
                            }
                            Button("Delete", role: .destructive) {
                                store.travelItems.removeAll { $0.id == item.id }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, TravelCardStyle.horizontalPadding)
            .padding(.vertical, 12)
            .padding(.bottom, 8)
        }
        .clearScrollBackground()
    }

    private func toggleItem(_ item: TravelItem) {
        FeedbackManager.tapLight()
        let wasComplete = item.completed
        store.toggleItem(item)
        if !wasComplete {
            FeedbackManager.completeMedium()
            showSuccessFeedback()
            withAnimation(.easeInOut(duration: 0.4)) {
                viewModel.pulseItemId = item.id
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                viewModel.pulseItemId = nil
            }
        }
    }

    private var addItemSheet: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                VStack(spacing: 16) {
                    FormFieldCard(title: "New item") {
                        VStack(spacing: 12) {
                            Picker("Category", selection: $viewModel.selectedCategory) {
                                ForEach(store.categories, id: \.self) { cat in
                                    Text(cat).tag(cat)
                                }
                            }
                            .foregroundStyle(Color("AppTextPrimary"))
                            TextField("Item name", text: $viewModel.newItemName)
                                .foregroundStyle(Color("AppTextPrimary"))
                                .travelInputField()
                        }
                    }
                    Spacer()
                }
                .padding(16)
            }
            .navigationTitle("New Item")
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        FeedbackManager.tapLight()
                        viewModel.showAddSheet = false
                        viewModel.newItemName = ""
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let name = viewModel.newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !name.isEmpty else {
                            FeedbackManager.warning()
                            return
                        }
                        FeedbackManager.saveMedium()
                        store.addTravelItem(name: name, category: viewModel.selectedCategory)
                        showSuccessFeedback()
                        viewModel.newItemName = ""
                        viewModel.showAddSheet = false
                    }
                    .foregroundStyle(Color("AppPrimary"))
                }
            }
        }
        .presentationDetents([.medium])
    }
}
