import SwiftUI

struct ElevationStatsView: View {
    @EnvironmentObject private var store: AppDataStore

    var body: some View {
        ZStack {
            AppBackgroundView()
            ScrollView {
                VStack(spacing: TravelCardStyle.rowSpacing) {
                    heroCard
                    milestonesSection
                    if !store.summitedPeaks.isEmpty {
                        summitedList
                    } else {
                        EmptyStateView(
                            icon: "mountain.2.fill",
                            title: "No summits logged yet",
                            message: "Mark peaks as summited in your ledger to build elevation stats."
                        )
                    }
                }
                .padding(.horizontal, TravelCardStyle.horizontalPadding)
                .padding(.vertical, 12)
                .tabBarScrollContentPadding()
            }
            .clearScrollBackground()
        }
        .navigationTitle("Elevation Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }

    private var heroCard: some View {
        VStack(spacing: 16) {
            IconCircleBadge(systemImage: "mountain.2.fill", size: 72, iconSize: 32)
            Text(store.highestSummitedElevation > 0 ? "\(store.highestSummitedElevation.formatted()) m" : "—")
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(Color("AppPrimary"))
            Text("Highest summit logged")
                .font(.subheadline)
                .foregroundStyle(Color("AppTextSecondary"))
            HStack(spacing: 10) {
                miniStat("Summited", value: "\(store.summitedPeaks.count)")
                miniStat("Total gain", value: store.totalLoggedElevation > 0 ? "\(store.totalLoggedElevation.formatted()) m" : "—")
                miniStat("Average", value: store.averageSummitedElevation > 0 ? "\(store.averageSummitedElevation.formatted()) m" : "—")
            }
        }
        .frame(maxWidth: .infinity)
        .travelCard(elevated: true)
    }

    private var milestonesSection: some View {
        FormFieldCard(title: "Altitude Milestones") {
            VStack(spacing: 10) {
                milestoneRow("3,000 m+", count: store.peaks(atOrAbove: 3000), icon: "figure.hiking")
                milestoneRow("4,000 m+", count: store.peaks(atOrAbove: 4000), icon: "mountain.2")
                milestoneRow("5,000 m+", count: store.peaks(atOrAbove: 5000), icon: "mountain.2.fill")
                milestoneRow("6,000 m+", count: store.peaks(atOrAbove: 6000), icon: "snowflake")
            }
        }
    }

    private var summitedList: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeaderView(title: "Summited peaks", subtitle: "Sorted by elevation")
            ForEach(store.summitedPeaks.sorted { $0.elevationMeters > $1.elevationMeters }) { peak in
                HStack {
                    Text(peak.flagEmoji)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(peak.name)
                            .font(.subheadline.bold())
                            .foregroundStyle(Color("AppTextPrimary"))
                        Text(peak.mountainRange)
                            .font(.caption)
                            .foregroundStyle(Color("AppTextSecondary"))
                    }
                    Spacer()
                    Text(peak.elevationDisplay)
                        .font(.subheadline.bold())
                        .foregroundStyle(Color("AppPrimary"))
                }
                .travelMiniTile()
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
        }
    }

    private func miniStat(_ label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline.bold())
                .foregroundStyle(Color("AppPrimary"))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.caption2)
                .foregroundStyle(Color("AppTextSecondary"))
        }
        .frame(maxWidth: .infinity)
        .travelMiniTile()
        .padding(.vertical, 10)
    }

    private func milestoneRow(_ title: String, count: Int, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(Color("AppAccent"))
                .frame(width: 24)
            Text(title)
                .foregroundStyle(Color("AppTextPrimary"))
            Spacer()
            Text("\(count)")
                .font(.headline.bold())
                .foregroundStyle(count > 0 ? Color("AppPrimary") : Color("AppTextSecondary"))
        }
    }
}
