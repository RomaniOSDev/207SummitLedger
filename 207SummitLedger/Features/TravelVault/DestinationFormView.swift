import Combine
import SwiftUI

struct DestinationFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: AppDataStore

    let destination: Destination?
    let flagProvider: (String) -> String
    let onSave: (Destination) -> Void

    @State private var name = ""
    @State private var country = ""
    @State private var note = ""
    @State private var hasDate = false
    @State private var plannedDate = Date()
    @State private var shakeTrigger = 0
    @State private var nameError: String?

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                ScrollView {
                    VStack(spacing: TravelCardStyle.rowSpacing) {
                        FormFieldCard(title: "Destination") {
                            VStack(spacing: 12) {
                                TextField("Destination name", text: $name)
                                    .foregroundStyle(Color("AppTextPrimary"))
                                    .travelInputField()
                                    .shake(trigger: shakeTrigger)
                                if let nameError {
                                    Text(nameError)
                                        .font(.caption)
                                        .foregroundStyle(.red)
                                }
                                TextField("Country", text: $country)
                                    .foregroundStyle(Color("AppTextPrimary"))
                                    .travelInputField()
                                TextField("Notes", text: $note, axis: .vertical)
                                    .lineLimit(3...6)
                                    .foregroundStyle(Color("AppTextPrimary"))
                                    .travelInputField()
                            }
                        }
                        FormFieldCard(title: "Schedule") {
                            VStack(spacing: 12) {
                                Toggle("Planned date", isOn: $hasDate)
                                    .foregroundStyle(Color("AppTextPrimary"))
                                if hasDate {
                                    DatePicker("Date", selection: $plannedDate, displayedComponents: .date)
                                        .foregroundStyle(Color("AppTextPrimary"))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, TravelCardStyle.horizontalPadding)
                    .padding(.vertical, 12)
                }
                .clearScrollBackground()
            }
            .navigationTitle(destination == nil ? "New Destination" : "Edit Destination")
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        FeedbackManager.tapLight()
                        dismiss()
                    }
                    .foregroundStyle(Color("AppTextSecondary"))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .foregroundStyle(Color("AppPrimary"))
                }
            }
            .onAppear {
                if let destination {
                    name = destination.name
                    country = destination.country
                    note = destination.note
                    if let date = destination.plannedDate {
                        hasDate = true
                        plannedDate = date
                    }
                }
            }
        }
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCountry = country.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            FeedbackManager.warning()
            nameError = "Please enter a destination name."
            shakeTrigger += 1
            return
        }
        guard !trimmedCountry.isEmpty else {
            FeedbackManager.warning()
            nameError = "Please enter a country."
            shakeTrigger += 1
            return
        }
        nameError = nil
        FeedbackManager.actionMedium()
        let flag = flagProvider(trimmedCountry)
        let item = Destination(
            id: destination?.id ?? UUID(),
            name: trimmedName,
            country: trimmedCountry,
            flagEmoji: flag,
            visited: destination?.visited ?? false,
            plannedDate: hasDate ? plannedDate : nil,
            note: note.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        onSave(item)
        dismiss()
    }
}
