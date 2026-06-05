import Combine
import SwiftUI

struct TripListView: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.showSuccessFeedback) private var showSuccessFeedback
    @StateObject private var viewModel = TripPlannerViewModel()

    var body: some View {
        ZStack {
            AppBackgroundView()
            Group {
                if store.trips.isEmpty {
                    emptyState
                } else {
                    tripList
                }
            }
        }
        .navigationTitle("Trip Planner")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    FeedbackManager.tapLight()
                    viewModel.editingTrip = nil
                    viewModel.showAddTrip = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color("AppPrimary"))
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .sheet(isPresented: $viewModel.showAddTrip) {
            TripFormView(trip: viewModel.editingTrip) { saved in
                if viewModel.editingTrip != nil {
                    store.updateTrip(saved)
                } else {
                    FeedbackManager.saveMedium()
                    store.addTrip(saved)
                    showSuccessFeedback()
                }
                viewModel.showAddTrip = false
            }
        }
        .navigationDestination(item: $viewModel.selectedTrip) { trip in
            TripDetailView(trip: trip)
        }
    }

    private var emptyState: some View {
        ScrollView {
            EmptyStateView(
                icon: "calendar.badge.plus",
                title: "Plan your next adventure",
                message: "Combine destinations, packing, itinerary, and budget in one trip.",
                buttonTitle: "Create Trip",
                action: { viewModel.showAddTrip = true }
            )
        }
        .clearScrollBackground()
    }

    private var tripList: some View {
        ScrollView {
            LazyVStack(spacing: TravelCardStyle.rowSpacing) {
                ScreenIntroHeader(
                    title: "Your Trips",
                    subtitle: "\(store.trips.count) planned — tap a card for details"
                )
                ForEach(store.trips) { trip in
                    Button {
                        FeedbackManager.tapLight()
                        viewModel.selectedTrip = trip
                    } label: {
                        TripCell(
                            trip: trip,
                            destinationLine: store.destination(for: trip).map { "\($0.flagEmoji) \($0.name)" }
                        )
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button("Edit") {
                            viewModel.editingTrip = trip
                            viewModel.showAddTrip = true
                        }
                        if trip.status != .completed {
                            Button("Mark Complete") {
                                store.completeTrip(trip)
                                showSuccessFeedback()
                            }
                        }
                        Button("Delete", role: .destructive) {
                            store.deleteTrip(trip)
                        }
                    }
                }
            }
            .padding(.horizontal, TravelCardStyle.horizontalPadding)
            .padding(.vertical, 12)
        }
        .clearScrollBackground()
    }
}
