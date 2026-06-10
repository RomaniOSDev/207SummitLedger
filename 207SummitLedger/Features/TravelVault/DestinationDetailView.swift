import Combine
import SwiftUI

struct DestinationDetailView: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.showSuccessFeedback) private var showSuccessFeedback

    let destination: Destination
    @State private var showEdit = false
    @State private var sharePayload: String?

    private var current: Destination {
        store.destinations.first(where: { $0.id == destination.id }) ?? destination
    }

    var body: some View {
        ZStack {
            AppBackgroundView()
            ScrollView {
                VStack(spacing: TravelCardStyle.rowSpacing) {
                    heroCard
                    if let date = current.plannedDate {
                        detailRow(title: "Planned", value: date.formatted(date: .long, time: .omitted), icon: "calendar")
                    }
                    if !current.note.isEmpty {
                        detailRow(title: "Notes", value: current.note, icon: "note.text")
                    }
                    VStack(spacing: 10) {
                        if !current.visited {
                            PrimaryButton(title: "Mark as Visited") {
                                FeedbackManager.saveMedium()
                                store.markVisited(current)
                                showSuccessFeedback()
                            }
                        }
                        PrimaryButton(title: "Edit Destination") { showEdit = true }
                        Button {
                            FeedbackManager.tapLight()
                            sharePayload = store.shareText(for: current)
                        } label: {
                            Text("Share Destination")
                                .font(.headline)
                                .foregroundStyle(Color("AppPrimary"))
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: 44)
                        }
                    }
                    .travelCard()
                }
                .padding(.horizontal, TravelCardStyle.horizontalPadding)
                .padding(.vertical, 12)
                .tabBarScrollContentPadding()
            }
            .clearScrollBackground()
        }
        .navigationTitle("Details")
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: Binding(
            get: { sharePayload != nil },
            set: { if !$0 { sharePayload = nil } }
        )) {
            if let text = sharePayload { ShareSheet(items: [text]) }
        }
        .sheet(isPresented: $showEdit) {
            DestinationFormView(destination: current, flagProvider: TravelVaultViewModel().flagForCountry) {
                store.updateDestination($0)
            }
        }
    }

    private var heroCard: some View {
        HStack(spacing: 16) {
            Text(current.flagEmoji)
                .font(.system(size: 56))
                .frame(width: 72, height: 72)
                .travelIconPlate(cornerRadius: 14)
            VStack(alignment: .leading, spacing: 8) {
                Text(current.name)
                    .font(.title2.bold())
                    .foregroundStyle(Color("AppTextPrimary"))
                Text(current.country)
                    .foregroundStyle(Color("AppTextSecondary"))
                if current.visited {
                    StatusPill(text: "Visited", style: .active)
                }
            }
            Spacer(minLength: 0)
        }
        .travelCard(elevated: true)
    }

    private func detailRow(title: String, value: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color("AppAccent"))
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(title.uppercased())
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color("AppTextSecondary"))
                Text(value)
                    .foregroundStyle(Color("AppTextPrimary"))
            }
            Spacer(minLength: 0)
        }
        .travelCard()
    }
}
