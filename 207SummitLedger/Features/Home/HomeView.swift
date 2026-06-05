import Combine
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: AppDataStore

    private var packing: (done: Int, total: Int) { store.packingProgress }
    private var documents: (done: Int, total: Int) { store.documentsProgress }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                ScrollView {
                    VStack(spacing: TravelCardStyle.rowSpacing) {
                        HomeHeroBanner(
                            greeting: store.homeGreeting,
                            subtitle: heroSubtitle,
                            streak: store.streakDays
                        )

                        HomeStatStrip(
                            destinations: store.destinations.count,
                            visited: store.visitedDestinationsCount,
                            trips: store.trips.count,
                            badges: store.unlockedAchievementCount
                        )

                        HomeQuickActionRow(actions: quickActions)

                        if let trip = store.nextUpcomingTrip {
                            NavigationLink {
                                TripDetailView(trip: trip)
                            } label: {
                                HomeNextTripCard(
                                    trip: trip,
                                    daysUntil: store.daysUntilNextTrip,
                                    destinationLine: destinationLine(for: trip)
                                )
                            }
                            .buttonStyle(.plain)
                        }

                        SectionHeaderView(title: "Explore", subtitle: "Jump into your travel tools")
                        widgetGrid

                        progressSection

                        if !store.wishlistDestinations.isEmpty {
                            wishlistSection
                        }

                        NavigationLink {
                            StreakInsightsView()
                        } label: {
                            HStack {
                                IconCircleBadge(systemImage: "flame.fill", size: 44, iconSize: 18)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Streak & activity")
                                        .font(.subheadline.bold())
                                        .foregroundStyle(Color("AppTextPrimary"))
                                    Text("\(store.streakDays) day streak · \(store.totalSessionsCompleted) actions")
                                        .font(.caption)
                                        .foregroundStyle(Color("AppTextSecondary"))
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color("AppTextSecondary"))
                            }
                            .travelCard()
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, TravelCardStyle.horizontalPadding)
                    .padding(.vertical, 12)
                }
                .clearScrollBackground()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    private var heroSubtitle: String {
        if let trip = store.nextUpcomingTrip {
            return "Your next adventure awaits"
        }
        if store.destinations.isEmpty {
            return "Start planning your next journey"
        }
        return "\(store.destinations.count) destinations in your vault"
    }

    private var quickActions: [(icon: String, title: String, tab: MainTab)] {
        [
            ("plus.circle.fill", "Add place", .vault),
            ("suitcase.fill", "Tools", .tools),
            ("star.fill", "Badges", .achievements)
        ]
    }

    private var widgetGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
            NavigationLink {
                TripListView()
            } label: {
                HomeImageWidget(
                    imageName: "HomeWidgetExplorer",
                    title: "Trip Planner",
                    subtitle: "\(store.trips.filter { $0.status != .completed }.count) active",
                    icon: "calendar"
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                TravelInventoryView()
            } label: {
                HomeImageWidget(
                    imageName: "HomeWidgetPacking",
                    title: "Packing",
                    subtitle: packing.total == 0 ? "Build your list" : "\(packing.done) of \(packing.total) packed",
                    icon: "suitcase.fill"
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                DocumentChecklistView()
            } label: {
                HomeProgressWidget(
                    title: "Documents",
                    icon: "doc.text.fill",
                    done: documents.done,
                    total: documents.total,
                    accent: false
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                CurrencyPhrasesView()
            } label: {
                currencyWidget
            }
            .buttonStyle(.plain)
        }
    }

    private var currencyWidget: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundStyle(Color("AppPrimary"))
                Text("Currency")
                    .font(.subheadline.bold())
                    .foregroundStyle(Color("AppTextPrimary"))
            }
            if store.fromCurrency.isEmpty || store.toCurrency.isEmpty {
                Text("Set currencies in converter")
                    .font(.caption)
                    .foregroundStyle(Color("AppTextSecondary"))
            } else {
                Text("\(store.fromCurrency) → \(store.toCurrency)")
                    .font(.headline)
                    .foregroundStyle(Color("AppAccent"))
                if let recent = store.recentConversion {
                    Text("Last: \(String(format: "%.2f", recent.result)) \(recent.toCode)")
                        .font(.caption)
                        .foregroundStyle(Color("AppTextSecondary"))
                }
            }
            Text("\(store.conversionsRun) conversions")
                .font(.caption2)
                .foregroundStyle(Color("AppPrimary"))
        }
        .travelCard()
        .frame(minHeight: 130)
    }

    private var progressSection: some View {
        VStack(spacing: TravelCardStyle.rowSpacing) {
            SectionHeaderView(title: "Readiness", subtitle: "Track prep before you go")
            NavigationLink {
                TravelInventoryView()
            } label: {
                HomeProgressWidget(
                    title: "Packing list",
                    icon: "checklist",
                    done: packing.done,
                    total: packing.total,
                    accent: true
                )
            }
            .buttonStyle(.plain)
            StatsSummaryCard(
                sessions: store.totalSessionsCompleted,
                minutes: store.totalMinutesUsed,
                streak: store.streakDays
            )
        }
    }

    private var wishlistSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeaderView(title: "Wishlist", subtitle: "Places you want to visit")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(store.wishlistDestinations) { dest in
                        NavigationLink {
                            DestinationDetailView(destination: dest)
                        } label: {
                            HomeDestinationChip(destination: dest)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            NavigationLink {
                TravelVaultView()
            } label: {
                Text("View all destinations")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("AppPrimary"))
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 44)
            }
        }
    }

    private func destinationLine(for trip: Trip) -> String? {
        guard let dest = store.destination(for: trip) else { return nil }
        return "\(dest.flagEmoji) \(dest.name), \(dest.country)"
    }
}
