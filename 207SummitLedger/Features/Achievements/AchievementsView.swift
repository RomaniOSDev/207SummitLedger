import Combine
import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject private var store: AppDataStore

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                ScrollView {
                    VStack(spacing: TravelCardStyle.rowSpacing) {
                        StatsSummaryCard(
                            sessions: store.totalSessionsCompleted,
                            minutes: store.totalMinutesUsed,
                            streak: store.streakDays
                        )

                        metricsCard

                        NavigationLink { StreakInsightsView() } label: {
                            HStack(spacing: 14) {
                                IconCircleBadge(systemImage: "flame.fill", size: 48, iconSize: 20)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Streak Insights")
                                        .font(.headline)
                                        .foregroundStyle(Color("AppTextPrimary"))
                                    Text("See your planning momentum")
                                        .font(.caption)
                                        .foregroundStyle(Color("AppTextSecondary"))
                                }
                                Spacer()
                                Text("\(store.streakDays)d")
                                    .font(.title3.bold())
                                    .foregroundStyle(Color("AppPrimary"))
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color("AppTextSecondary"))
                            }
                            .travelCard(elevated: true)
                        }

                        SectionHeaderView(title: "Core Badges", subtitle: "Unlock by exploring the app")
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(AchievementDefinition.all) { achievement in
                                AchievementCell(
                                    title: achievement.title,
                                    description: achievement.description,
                                    systemImage: achievement.systemImage,
                                    isUnlocked: achievement.isUnlocked(store: store)
                                )
                            }
                        }

                        SectionHeaderView(title: "Seasonal Badges", subtitle: "Extra milestones for planners")
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(SeasonalAchievement.all) { achievement in
                                AchievementCell(
                                    title: achievement.title,
                                    description: achievement.description,
                                    systemImage: achievement.systemImage,
                                    isUnlocked: achievement.isUnlocked(store: store)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, TravelCardStyle.horizontalPadding)
                    .padding(.vertical, 12)
                }
                .clearScrollBackground()
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    private var metricsCard: some View {
        FormFieldCard(title: "Summary") {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                metricTile("Destinations", value: store.destinationsAdded, icon: "mappin.and.ellipse")
                metricTile("Trips", value: store.tripsCompleted, icon: "airplane")
                metricTile("Checklists", value: store.checklistsCompleted, icon: "checkmark.circle")
                metricTile("Conversions", value: store.conversionsRun, icon: "dollarsign.circle")
            }
        }
    }

    private func metricTile(_ label: String, value: Int, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Color("AppAccent"))
            Text("\(value)")
                .font(.title3.bold())
                .foregroundStyle(Color("AppPrimary"))
            Text(label)
                .font(.caption2)
                .foregroundStyle(Color("AppTextSecondary"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color("AppBackground").opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
