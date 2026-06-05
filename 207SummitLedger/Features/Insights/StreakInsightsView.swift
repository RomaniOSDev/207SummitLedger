import Combine
import SwiftUI

struct StreakInsightsView: View {
    @EnvironmentObject private var store: AppDataStore

    var body: some View {
        ZStack {
            AppBackgroundView()
            ScrollView {
                VStack(spacing: TravelCardStyle.rowSpacing) {
                    streakCard
                    FormFieldCard(title: "Activity Overview") {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            insightTile("Sessions", value: "\(store.totalSessionsCompleted)", icon: "bolt.fill")
                            insightTile("Minutes", value: "\(store.totalMinutesUsed)", icon: "clock.fill")
                            insightTile("Trips", value: "\(store.trips.count)", icon: "calendar")
                            insightTile("Completed", value: "\(store.tripsCompleted)", icon: "checkmark.seal")
                        }
                    }
                    Text("Every small step — adding a destination, packing an item, or converting currency — keeps your travel plans on track.")
                        .font(.subheadline)
                        .foregroundStyle(Color("AppTextSecondary"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                .padding(.horizontal, TravelCardStyle.horizontalPadding)
                .padding(.vertical, 12)
            }
            .clearScrollBackground()
        }
        .navigationTitle("Streak Insights")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }

    private var streakCard: some View {
        VStack(spacing: 12) {
            IconCircleBadge(systemImage: "flame.fill", size: 72, iconSize: 32)
            Text("\(store.streakDays)")
                .font(.system(size: 52, weight: .bold))
                .foregroundStyle(Color("AppPrimary"))
            Text(streakMessage)
                .font(.headline)
                .foregroundStyle(Color("AppTextPrimary"))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .travelCard(elevated: true)
    }

    private var streakMessage: String {
        if store.streakDays >= 7 { return "You planned \(store.streakDays) days in a row!" }
        if store.streakDays >= 2 { return "You are on a \(store.streakDays)-day streak." }
        if store.streakDays == 1 { return "Great start — keep planning tomorrow." }
        return "Complete an action today to start a streak."
    }

    private func insightTile(_ label: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Color("AppAccent"))
            Text(value)
                .font(.title3.bold())
                .foregroundStyle(Color("AppPrimary"))
            Text(label)
                .font(.caption2)
                .foregroundStyle(Color("AppTextSecondary"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .travelMiniTile()
    }
}
