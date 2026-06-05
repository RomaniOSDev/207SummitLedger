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
    @State private var fromCurrency = ""
    @State private var toCurrency = ""
    @State private var note = ""

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                ScrollView {
                    VStack(spacing: TravelCardStyle.rowSpacing) {
                        FormFieldCard(title: "Trip details") {
                            VStack(spacing: 12) {
                                TextField("Trip title", text: $title)
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
                        FormFieldCard(title: "Destination") {
                            Picker("Link destination", selection: $selectedDestinationId) {
                                Text("None").tag(Optional<UUID>.none)
                                ForEach(store.destinations) { dest in
                                    Text("\(dest.flagEmoji) \(dest.name)").tag(Optional(dest.id))
                                }
                            }
                            .foregroundStyle(Color("AppTextPrimary"))
                        }
                        FormFieldCard(title: "Currency") {
                            VStack(spacing: 12) {
                                currencyPicker("From", selection: $fromCurrency)
                                currencyPicker("To", selection: $toCurrency)
                            }
                        }
                        FormFieldCard(title: "Notes") {
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
            .navigationTitle(trip == nil ? "New Trip" : "Edit Trip")
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

    private func currencyPicker(_ label: String, selection: Binding<String>) -> some View {
        Picker(label, selection: selection) {
            Text("Select").tag("")
            ForEach(CurrencyData.currencies) { c in
                Text(c.code).tag(c.code)
            }
        }
    }

    private func load() {
        if let trip {
            title = trip.title
            startDate = trip.startDate
            endDate = trip.endDate
            status = trip.status
            selectedDestinationId = trip.destinationId
            fromCurrency = trip.fromCurrency
            toCurrency = trip.toCurrency
            note = trip.note
        } else {
            fromCurrency = store.fromCurrency
            toCurrency = store.toCurrency
        }
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
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            note: note.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        onSave(item)
        dismiss()
    }
}
