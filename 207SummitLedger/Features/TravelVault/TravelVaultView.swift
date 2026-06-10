import Combine
import SwiftUI

struct TravelVaultView: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.showSuccessFeedback) private var showSuccessFeedback
    @StateObject private var viewModel = TravelVaultViewModel()

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
            .navigationTitle("Travel Vault")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText, prompt: "Search destinations")
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
                icon: "airplane",
                title: "Your future adventures await!",
                message: "Save dream destinations, plan dates, and track where you have been.",
                buttonTitle: "Add Destination",
                action: { viewModel.showAddSheet = true }
            )
        }
        .clearScrollBackground()
    }

    private var destinationList: some View {
        ScrollView {
            LazyVStack(spacing: TravelCardStyle.rowSpacing) {
                if filtered.isEmpty {
                    Text("No matches for your search.")
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
                        Button("Mark Visited") {
                            FeedbackManager.saveMedium()
                            store.markVisited(destination)
                            showSuccessFeedback()
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
