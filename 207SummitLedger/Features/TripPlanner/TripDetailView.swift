import Combine
import SwiftUI

struct TripDetailView: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.showSuccessFeedback) private var showSuccessFeedback

    let trip: Trip
    @State private var showEdit = false
    @State private var budgetDays = 3
    @State private var foodPerDay = 40.0
    @State private var transportPerDay = 20.0
    @State private var lodgingPerDay = 80.0
    @State private var budgetCurrency = "USD"

    private var current: Trip {
        store.trips.first(where: { $0.id == trip.id }) ?? trip
    }

    var body: some View {
        ZStack {
            AppBackgroundView()
            ScrollView {
                VStack(alignment: .leading, spacing: TravelCardStyle.rowSpacing) {
                    headerSection
                    statusActions
                    itinerarySection
                    budgetSection
                }
                .padding(.horizontal, TravelCardStyle.horizontalPadding)
                .padding(.vertical, 12)
            }
            .clearScrollBackground()
        }
        .navigationTitle(current.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    FeedbackManager.tapLight()
                    showEdit = true
                }
                .foregroundStyle(Color("AppPrimary"))
            }
        }
        .sheet(isPresented: $showEdit) {
            TripFormView(trip: current) { store.updateTrip($0) }
        }
        .onAppear(perform: loadBudgetFields)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                IconCircleBadge(systemImage: "airplane.departure", size: 48, iconSize: 20)
                VStack(alignment: .leading, spacing: 6) {
                    Text(current.title)
                        .font(.title3.bold())
                        .foregroundStyle(Color("AppTextPrimary"))
                    StatusPill(text: current.status.title, style: tripPillStyle(current.status))
                }
                Spacer(minLength: 0)
            }
            Label(
                "\(current.startDate.formatted(date: .long, time: .omitted)) – \(current.endDate.formatted(date: .long, time: .omitted))",
                systemImage: "calendar"
            )
            .font(.subheadline)
            .foregroundStyle(Color("AppTextSecondary"))
            if let dest = store.destination(for: current) {
                Label("\(dest.flagEmoji) \(dest.name), \(dest.country)", systemImage: "mappin.and.ellipse")
                    .foregroundStyle(Color("AppAccent"))
            }
            if !current.fromCurrency.isEmpty, !current.toCurrency.isEmpty {
                Label("\(current.fromCurrency) → \(current.toCurrency)", systemImage: "dollarsign.circle")
                    .font(.caption)
                    .foregroundStyle(Color("AppTextPrimary"))
            }
            if !current.note.isEmpty {
                Text(current.note)
                    .foregroundStyle(Color("AppTextPrimary"))
            }
        }
        .travelCard(elevated: true)
    }

    private func tripPillStyle(_ status: TripStatus) -> StatusPill.PillStyle {
        switch status {
        case .planned: return .planned
        case .active: return .active
        case .completed: return .completed
        }
    }

    private var statusActions: some View {
        HStack(spacing: 8) {
            if current.status != .active {
                statusButton("Start", status: .active)
            }
            if current.status != .completed {
                statusButton("Complete", status: .completed)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .travelCard()
    }

    private func statusButton(_ label: String, status: TripStatus) -> some View {
        Button {
            FeedbackManager.tapLight()
            store.setTripStatus(current, status: status)
            if status == .completed {
                FeedbackManager.success()
                showSuccessFeedback()
            }
        } label: {
            Text(label)
                .font(.subheadline.bold())
                .foregroundStyle(Color("AppBackground"))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color("AppPrimary"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    private var itinerarySection: some View {
        VStack(alignment: .leading, spacing: TravelCardStyle.rowSpacing) {
            SectionHeaderView(title: "Itinerary", subtitle: "\(current.itinerary.count) days")
            ForEach(current.itinerary) { day in
                ItineraryDayCard(tripId: current.id, day: day)
            }
        }
    }

    private var budgetSection: some View {
        FormFieldCard(title: "Budget Estimator") {
            VStack(alignment: .leading, spacing: 12) {
            Stepper("Days: \(budgetDays)", value: $budgetDays, in: 1...90)
                .foregroundStyle(Color("AppTextPrimary"))
            budgetField("Food / day", value: $foodPerDay)
            budgetField("Transport / day", value: $transportPerDay)
            budgetField("Lodging / day", value: $lodgingPerDay)
            Picker("Currency", selection: $budgetCurrency) {
                ForEach(CurrencyData.currencies) { c in
                    Text(c.code).tag(c.code)
                }
            }
            let total = (foodPerDay + transportPerDay + lodgingPerDay) * Double(budgetDays)
            Text("Estimated total: \(String(format: "%.2f", total)) \(budgetCurrency)")
                .font(.title3.bold())
                .foregroundStyle(Color("AppPrimary"))
                PrimaryButton(title: "Save Budget to Trip") {
                    FeedbackManager.saveMedium()
                    var updated = current
                    updated.budget = TripBudget(
                        days: budgetDays,
                        foodPerDay: foodPerDay,
                        transportPerDay: transportPerDay,
                        lodgingPerDay: lodgingPerDay,
                        currencyCode: budgetCurrency
                    )
                    store.updateTrip(updated)
                    showSuccessFeedback()
                }
            }
        }
    }

    private func budgetField(_ label: String, value: Binding<Double>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(Color("AppTextSecondary"))
            TextField("0", value: value, format: .number)
                .keyboardType(.decimalPad)
                .foregroundStyle(Color("AppTextPrimary"))
                .travelInputField()
        }
    }

    private func loadBudgetFields() {
        var t = current
        if t.itinerary.isEmpty {
            t.itinerary = store.buildItinerary(for: t)
            store.updateTrip(t)
        }
        budgetDays = t.budget?.days ?? t.dayCount
        foodPerDay = t.budget?.foodPerDay ?? 40
        transportPerDay = t.budget?.transportPerDay ?? 20
        lodgingPerDay = t.budget?.lodgingPerDay ?? 80
        budgetCurrency = t.budget?.currencyCode ?? (t.toCurrency.isEmpty ? "USD" : t.toCurrency)
    }
}

private struct ItineraryDayCard: View {
    @EnvironmentObject private var store: AppDataStore
    let tripId: UUID
    let day: TripDay
    @State private var note: String = ""
    @State private var newTaskTitle = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Day \(day.dayNumber)")
                .font(.subheadline.bold())
                .foregroundStyle(Color("AppPrimary"))
            TextField("Notes for the day", text: $note, axis: .vertical)
                .lineLimit(2...4)
                .foregroundStyle(Color("AppTextPrimary"))
                .travelInputField()
                .onChange(of: note) { _ in saveNote() }
            ForEach(day.tasks) { task in
                HStack {
                    Button {
                        FeedbackManager.tapLight()
                        toggleTask(task)
                    } label: {
                        Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(Color("AppPrimary"))
                    }
                    Text(task.title)
                        .foregroundStyle(Color("AppTextPrimary"))
                        .strikethrough(task.completed)
                    Spacer()
                }
            }
            HStack {
                TextField("New task", text: $newTaskTitle)
                    .foregroundStyle(Color("AppTextPrimary"))
                    .travelInputField()
                Button("Add") {
                    addTask()
                }
                .foregroundStyle(Color("AppAccent"))
            }
        }
        .travelCard()
        .onAppear { note = day.note }
    }

    private func mutateTrip(_ transform: (inout Trip) -> Void) {
        guard var trip = store.trips.first(where: { $0.id == tripId }) else { return }
        transform(&trip)
        store.updateTrip(trip)
    }

    private func saveNote() {
        mutateTrip { trip in
            guard let i = trip.itinerary.firstIndex(where: { $0.id == day.id }) else { return }
            trip.itinerary[i].note = note
        }
    }

    private func toggleTask(_ task: TripDayTask) {
        mutateTrip { trip in
            guard let di = trip.itinerary.firstIndex(where: { $0.id == day.id }),
                  let ti = trip.itinerary[di].tasks.firstIndex(where: { $0.id == task.id }) else { return }
            trip.itinerary[di].tasks[ti].completed.toggle()
        }
    }

    private func addTask() {
        let title = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        mutateTrip { trip in
            guard let i = trip.itinerary.firstIndex(where: { $0.id == day.id }) else { return }
            trip.itinerary[i].tasks.append(TripDayTask(title: title))
        }
        newTaskTitle = ""
        FeedbackManager.tapLight()
    }
}
