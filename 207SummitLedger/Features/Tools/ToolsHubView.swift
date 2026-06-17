import SwiftUI

struct ToolsHubView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                ScrollView {
                    VStack(spacing: TravelCardStyle.rowSpacing) {
                        ScreenIntroHeader(
                            title: "Expedition Prep",
                            subtitle: "Plan routes, pack alpine gear, and clear permits"
                        )

                        NavigationLink { TripListView() } label: {
                            ToolNavigationCell(
                                title: "Expedition Planner",
                                subtitle: "Multi-day routes, budget, and status",
                                icon: "calendar",
                                accent: true
                            )
                        }

                        NavigationLink { DocumentChecklistView() } label: {
                            ToolNavigationCell(
                                title: "Safety & Permits",
                                subtitle: "Park permits, insurance, and rescue plan",
                                icon: "shield.checkered"
                            )
                        }

                        NavigationLink { TravelInventoryView() } label: {
                            ToolNavigationCell(
                                title: "Alpine Gear",
                                subtitle: "Layered packing lists with climb templates",
                                icon: "backpack.fill"
                            )
                        }

                        NavigationLink { ElevationStatsView() } label: {
                            ToolNavigationCell(
                                title: "Elevation Profile",
                                subtitle: "Altitude milestones and summit history",
                                icon: "chart.line.uptrend.xyaxis"
                            )
                        }
                    }
                    .padding(.horizontal, TravelCardStyle.horizontalPadding)
                    .padding(.vertical, 12)
                    .tabBarScrollContentPadding()
                }
                .clearScrollBackground()
            }
            .navigationTitle("Prep")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}
