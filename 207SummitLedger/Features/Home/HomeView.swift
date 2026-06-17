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
                            peaks: store.destinations.count,
                            summited: store.summitedPeaks.count,
                            highest: store.highestSummitedElevation,
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
                                    destinationLine: expeditionPeakLine(for: trip)
                                )
                            }
                            .buttonStyle(.plain)
                        }

                        NavigationLink {
                            ElevationStatsView()
                        } label: {
                            elevationHighlight
                        }
                        .buttonStyle(.plain)

                        SectionHeaderView(title: "Prepare", subtitle: "Expedition tools for your next ascent")
                        widgetGrid

                        progressSection

                        if !store.bucketListPeaksForHome.isEmpty {
                            bucketListSection
                        }

                        NavigationLink {
                            StreakInsightsView()
                        } label: {
                            HStack {
                                IconCircleBadge(systemImage: "flame.fill", size: 44, iconSize: 18)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Prep streak")
                                        .font(.subheadline.bold())
                                        .foregroundStyle(Color("AppTextPrimary"))
                                    Text("\(store.streakDays) days · \(store.totalSessionsCompleted) log entries")
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
                    .tabBarScrollContentPadding()
                }
                .clearScrollBackground()
            }
            .navigationTitle("Summit Ledger")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    private var heroSubtitle: String {
        if store.highestSummitedElevation > 0 {
            return "Highest summit: \(store.highestSummitedElevation.formatted()) m"
        }
        if let trip = store.nextUpcomingTrip {
            return "Next expedition: \(trip.title)"
        }
        return "Log peaks, plan expeditions, track altitude"
    }

    private var quickActions: [(icon: String, title: String, tab: MainTab)] {
        [
            ("plus.circle.fill", "Log peak", .vault),
            ("backpack.fill", "Prep", .tools),
            ("star.fill", "Badges", .achievements)
        ]
    }

    private var elevationHighlight: some View {
        HStack(spacing: 14) {
            IconCircleBadge(systemImage: "chart.line.uptrend.xyaxis", size: 52, iconSize: 22)
            VStack(alignment: .leading, spacing: 6) {
                Text("Elevation Profile")
                    .font(.headline)
                    .foregroundStyle(Color("AppTextPrimary"))
                Text(store.summitedPeaks.isEmpty
                     ? "Summit peaks to unlock altitude stats"
                     : "\(store.totalLoggedElevation.formatted()) m total · \(store.peaks(atOrAbove: 4000)) above 4,000 m")
                    .font(.caption)
                    .foregroundStyle(Color("AppTextSecondary"))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color("AppTextSecondary"))
        }
        .travelCard(elevated: true)
    }

    private var widgetGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
            NavigationLink {
                TripListView()
            } label: {
                HomeImageWidget(
                    imageName: "HomeWidgetExplorer",
                    title: "Expeditions",
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
                    title: "Alpine Gear",
                    subtitle: packing.total == 0 ? "Pack for your climb" : "\(packing.done)/\(packing.total) ready",
                    icon: "backpack.fill"
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                DocumentChecklistView()
            } label: {
                HomeProgressWidget(
                    title: "Safety & Permits",
                    icon: "shield.checkered",
                    done: documents.done,
                    total: documents.total,
                    accent: false
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                PeakCatalogView()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "book.fill")
                        .foregroundStyle(Color("AppPrimary"))
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Peak Catalog")
                            .font(.subheadline.bold())
                            .foregroundStyle(Color("AppTextPrimary"))
                        Text("\(PeakCatalog.featured.count) famous summits to add")
                            .font(.caption)
                            .foregroundStyle(Color("AppTextSecondary"))
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color("AppTextSecondary"))
                }
                .travelCard()
                .frame(minHeight: 130)
            }
            .buttonStyle(.plain)
        }
    }

    private var progressSection: some View {
        VStack(spacing: TravelCardStyle.rowSpacing) {
            SectionHeaderView(title: "Readiness", subtitle: "Gear and permits before you climb")
            NavigationLink {
                TravelInventoryView()
            } label: {
                HomeProgressWidget(
                    title: "Gear checklist",
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

    private var bucketListSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeaderView(title: "Bucket list", subtitle: "Peaks you plan to summit")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(store.bucketListPeaksForHome) { peak in
                        NavigationLink {
                            DestinationDetailView(destination: peak)
                        } label: {
                            HomeDestinationChip(destination: peak)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            NavigationLink {
                TravelVaultView()
            } label: {
                Text("View summit log")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("AppPrimary"))
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 44)
            }
        }
    }

    private func expeditionPeakLine(for trip: Trip) -> String? {
        guard let dest = store.destination(for: trip) else { return nil }
        let elev = dest.elevationMeters > 0 ? " · \(dest.elevationDisplay)" : ""
        return "\(dest.flagEmoji) \(dest.name)\(elev)"
    }
}
