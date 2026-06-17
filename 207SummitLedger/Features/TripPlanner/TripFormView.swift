import Combine
import SwiftUI

struct TripFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: AppDataStore

    let trip: Trip?
    let onSave: (Trip) -> Void

    @State private var title = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(86400 * 3)
    @State private var status: TripStatus = .planned
    @State private var selectedDestinationId: UUID?
    @State private var note = ""

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                ScrollView {
                    VStack(spacing: TravelCardStyle.rowSpacing) {
                        FormFieldCard(title: "Expedition") {
                            VStack(spacing: 12) {
                                TextField("Expedition name", text: $title)
                                    .foregroundStyle(Color("AppTextPrimary"))
                                    .travelInputField()
                                DatePicker("Start", selection: $startDate, displayedComponents: .date)
                                    .foregroundStyle(Color("AppTextPrimary"))
                                DatePicker("End", selection: $endDate, displayedComponents: .date)
                                    .foregroundStyle(Color("AppTextPrimary"))
                                Picker("Status", selection: $status) {
                                    ForEach(TripStatus.allCases) { s in
                                        Text(s.title).tag(s)
                                    }
                                }
                                .foregroundStyle(Color("AppTextPrimary"))
                            }
                        }
                        FormFieldCard(title: "Target peak") {
                            Picker("Link peak", selection: $selectedDestinationId) {
                                Text("None").tag(Optional<UUID>.none)
                                ForEach(store.destinations) { dest in
                                    Text("\(dest.flagEmoji) \(dest.name)").tag(Optional(dest.id))
                                }
                            }
                            .foregroundStyle(Color("AppTextPrimary"))
                        }
                        FormFieldCard(title: "Expedition notes") {
                            TextField("Notes", text: $note, axis: .vertical)
                                .lineLimit(2...4)
                                .foregroundStyle(Color("AppTextPrimary"))
                                .travelInputField()
                        }
                    }
                    .padding(.horizontal, TravelCardStyle.horizontalPadding)
                    .padding(.vertical, 12)
                }
                .clearScrollBackground()
            }
            .navigationTitle(trip == nil ? "New Expedition" : "Edit Expedition")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { FeedbackManager.tapLight(); dismiss() }
                        .foregroundStyle(Color("AppTextSecondary"))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .foregroundStyle(Color("AppPrimary"))
                }
            }
            .onAppear(perform: load)
        }
    }

    private func load() {
        guard let trip else { return }
        title = trip.title
        startDate = trip.startDate
        endDate = trip.endDate
        status = trip.status
        selectedDestinationId = trip.destinationId
        note = trip.note
    }

    private func save() {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            FeedbackManager.warning()
            return
        }
        let end = max(endDate, startDate)
        FeedbackManager.actionMedium()
        let item = Trip(
            id: trip?.id ?? UUID(),
            title: trimmed,
            destinationId: selectedDestinationId,
            startDate: startDate,
            endDate: end,
            status: status,
            itinerary: trip?.itinerary ?? [],
            budget: trip?.budget,
            fromCurrency: trip?.fromCurrency ?? "",
            toCurrency: trip?.toCurrency ?? "",
            note: note.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        onSave(item)
        dismiss()
    }
}
