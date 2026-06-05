import SwiftUI

struct ToolsHubView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                ScrollView {
                    VStack(spacing: TravelCardStyle.rowSpacing) {
                        ScreenIntroHeader(
                            title: "Travel Tools",
                            subtitle: "Everything you need to prepare and explore offline"
                        )

                        NavigationLink { TripListView() } label: {
                            ToolNavigationCell(
                                title: "Trip Planner",
                                subtitle: "Itinerary, budget, and trip status",
                                icon: "calendar",
                                accent: true
                            )
                        }

                        NavigationLink { DocumentChecklistView() } label: {
                            ToolNavigationCell(
                                title: "Travel Documents",
                                subtitle: "Passport, visa, insurance, tickets",
                                icon: "doc.text.fill"
                            )
                        }

                        NavigationLink { TravelInventoryView() } label: {
                            ToolNavigationCell(
                                title: "Travel Inventory",
                                subtitle: "Packing lists with smart templates",
                                icon: "suitcase.fill"
                            )
                        }

                        NavigationLink { CurrencyPhrasesView() } label: {
                            ToolNavigationCell(
                                title: "Currency & Phrases",
                                subtitle: "Converter, history, and phrase guide",
                                icon: "globe"
                            )
                        }
                    }
                    .padding(.horizontal, TravelCardStyle.horizontalPadding)
                    .padding(.vertical, 12)
                }
                .clearScrollBackground()
            }
            .navigationTitle("Tools")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}
