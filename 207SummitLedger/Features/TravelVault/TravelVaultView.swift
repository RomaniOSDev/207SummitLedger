import Combine
import SwiftUI

struct TravelVaultView: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.showSuccessFeedback) private var showSuccessFeedback
    @StateObject private var viewModel = TravelVaultViewModel()
    @State private var showCatalog = false

    private var filtered: [Destination] {
        viewModel.filteredDestinations(from: store)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                Group {
                    if store.destinations.isEmpty {
                        emptyState
                    } else {
                        destinationList
                    }
                }
            }
            .navigationTitle("Summit Log")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText, prompt: "Search peaks")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Sort", selection: $viewModel.sortMode) {
                            ForEach(DestinationSortMode.allCases) { mode in
                                Text(mode.title).tag(mode)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                            .font(.title3)
                            .foregroundStyle(Color("AppPrimary"))
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        Button {
                            FeedbackManager.tapLight()
                            showCatalog = true
                        } label: {
                            Image(systemName: "book.fill")
                                .font(.title3)
                                .foregroundStyle(Color("AppAccent"))
                        }
                        Button {
                            FeedbackManager.tapLight()
                            viewModel.editingDestination = nil
                            viewModel.showAddSheet = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundStyle(Color("AppPrimary"))
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddSheet) {
                DestinationFormView(
                    destination: viewModel.editingDestination,
                    flagProvider: viewModel.flagForCountry
                ) { saved in
                    if viewModel.editingDestination != nil {
                        store.updateDestination(saved)
                    } else {
                        FeedbackManager.saveMedium()
                        store.addDestination(saved)
                        showSuccessFeedback()
                    }
                    viewModel.showAddSheet = false
                }
            }
            .sheet(isPresented: $showCatalog) {
                PeakCatalogView()
            }
            .sheet(isPresented: Binding(
                get: { viewModel.sharePayload != nil },
                set: { if !$0 { viewModel.sharePayload = nil } }
            )) {
                if let text = viewModel.sharePayload {
                    ShareSheet(items: [text])
                }
            }
            .navigationDestination(item: $viewModel.selectedDestination) { destination in
                DestinationDetailView(destination: destination)
            }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    private var emptyState: some View {
        ScrollView {
            EmptyStateView(
                icon: "mountain.2.fill",
                title: "Your summit log is empty",
                message: "Log peaks you have climbed or add targets from the world catalog.",
                buttonTitle: "Browse Peak Catalog",
                action: { showCatalog = true }
            )
        }
        .clearScrollBackground()
    }

    private var destinationList: some View {
        ScrollView {
            LazyVStack(spacing: TravelCardStyle.rowSpacing) {
                if filtered.isEmpty {
                    Text("No peaks match your search.")
                        .font(.subheadline)
                        .foregroundStyle(Color("AppTextSecondary"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                }
                ForEach(filtered) { destination in
                    Button {
                        FeedbackManager.tapLight()
                        viewModel.selectedDestination = destination
                    } label: {
                        DestinationCell(destination: destination)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button("Share") {
                            viewModel.sharePayload = store.shareText(for: destination)
                        }
                        Button("Duplicate") {
                            store.duplicateDestination(destination)
                            showSuccessFeedback()
                        }
                        if !destination.visited {
                            Button("Mark Summited") {
                                FeedbackManager.saveMedium()
                                store.markSummited(destination)
                                showSuccessFeedback()
                            }
                        }
                        Button("Edit") {
                            viewModel.editingDestination = destination
                            viewModel.showAddSheet = true
                        }
                        Button("Delete", role: .destructive) {
                            store.destinations.removeAll { $0.id == destination.id }
                        }
                    }
                }
            }
            .padding(.horizontal, TravelCardStyle.horizontalPadding)
            .padding(.vertical, 12)
            .tabBarScrollContentPadding()
        }
        .clearScrollBackground()
    }
}
