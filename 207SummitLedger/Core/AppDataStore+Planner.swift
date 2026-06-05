import Foundation

extension AppDataStore {
    // MARK: - Trips

    func addTrip(_ trip: Trip) {
        var newTrip = trip
        newTrip.itinerary = buildItinerary(for: newTrip)
        trips.append(newTrip)
        if isWinterTrip(newTrip) {
            winterTripsPlanned += 1
        }
        syncTripCurrenciesToConverter(newTrip)
        recordMeaningfulAction()
        checkAchievements()
    }

    func updateTrip(_ trip: Trip) {
        guard let index = trips.firstIndex(where: { $0.id == trip.id }) else { return }
        let wasCompleted = trips[index].status == .completed
        var updated = trip
        if updated.itinerary.isEmpty {
            updated.itinerary = buildItinerary(for: updated)
        }
        trips[index] = updated
        if updated.status == .completed && !wasCompleted {
            tripsCompleted += 1
            recordMeaningfulAction()
            checkAchievements()
        }
        syncTripCurrenciesToConverter(updated)
    }

    func deleteTrip(_ trip: Trip) {
        trips.removeAll { $0.id == trip.id }
    }

    func completeTrip(_ trip: Trip) {
        var updated = trip
        updated.status = .completed
        updateTrip(updated)
    }

    func setTripStatus(_ trip: Trip, status: TripStatus) {
        var updated = trip
        updated.status = status
        updateTrip(updated)
    }

    func buildItinerary(for trip: Trip) -> [TripDay] {
        if !trip.itinerary.isEmpty { return trip.itinerary }
        return (1...trip.dayCount).map { day in
            TripDay(dayNumber: day, note: "", tasks: [])
        }
    }

    func isWinterTrip(_ trip: Trip) -> Bool {
        let month = Calendar.current.component(.month, from: trip.startDate)
        return month == 12 || month <= 2
    }

    func syncTripCurrenciesToConverter(_ trip: Trip) {
        if !trip.fromCurrency.isEmpty { fromCurrency = trip.fromCurrency }
        if !trip.toCurrency.isEmpty { toCurrency = trip.toCurrency }
    }

    func destination(for trip: Trip) -> Destination? {
        guard let id = trip.destinationId else { return nil }
        return destinations.first { $0.id == id }
    }

    // MARK: - Documents

    func addDocument(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        documents.append(DocumentItem(name: trimmed))
        recordMeaningfulAction()
    }

    func toggleDocument(_ item: DocumentItem) {
        guard let index = documents.firstIndex(where: { $0.id == item.id }) else { return }
        documents[index].completed.toggle()
        recordMeaningfulAction()
    }

    func deleteDocument(_ item: DocumentItem) {
        documents.removeAll { $0.id == item.id }
    }

    func applyDocumentTemplate(_ template: DocumentTemplate) {
        let existing = Set(documents.map(\.name))
        for name in template.items where !existing.contains(name) {
            documents.append(DocumentItem(name: name))
        }
        recordMeaningfulAction()
        checkAchievements()
    }

    // MARK: - Packing templates

    func applyPackingTemplate(_ template: PackingTemplate) {
        let existing = Set(travelItems.map(\.name))
        for entry in template.items where !existing.contains(entry.name) {
            travelItems.append(TravelItem(name: entry.name, category: entry.category))
        }
        packingTemplatesUsed += 1
        recordMeaningfulAction()
        checkAchievements()
    }

    // MARK: - Phrase search

    func filteredPhraseCategories(languageCode: String, query: String) -> [PhraseCategory] {
        let all = PhraseLibrary.categories(for: languageCode)
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return all }
        let q = trimmed.lowercased()
        return all.compactMap { category in
            let phrases = category.phrases.filter {
                $0.english.lowercased().contains(q) || $0.translation.lowercased().contains(q)
            }
            guard !phrases.isEmpty else { return nil }
            return PhraseCategory(id: category.id, title: category.title, phrases: phrases)
        }
    }
}
