import Combine
import Foundation

final class AppDataStore: ObservableObject {
    private enum Keys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
        static let totalSessionsCompleted = "totalSessionsCompleted"
        static let totalMinutesUsed = "totalMinutesUsed"
        static let streakDays = "streakDays"
        static let lastActivityDate = "lastActivityDate"
        static let achievementsUnlocked = "achievementsUnlocked"
        static let destinations = "destinations"
        static let destinationsAdded = "destinationsAdded"
        static let tripsCompleted = "tripsCompleted"
        static let travelItems = "travelItems"
        static let categories = "categories"
        static let lastEditedAt = "lastEditedAt"
        static let checklistsCompleted = "checklistsCompleted"
        static let fromCurrency = "fromCurrency"
        static let toCurrency = "toCurrency"
        static let enteredAmount = "enteredAmount"
        static let expandedCategories = "expandedCategories"
        static let phrasesViewed = "phrasesViewed"
        static let viewedPhraseIds = "viewedPhraseIds"
        static let conversionsRun = "conversionsRun"
        static let currencyRates = "currencyRates"
        static let phraseLanguage = "phraseLanguage"
        static let inventoryCompletionCounted = "inventoryCompletionCounted"
        static let trips = "trips"
        static let documents = "documents"
        static let conversionHistory = "conversionHistory"
        static let favoritePhraseIds = "favoritePhraseIds"
        static let winterTripsPlanned = "winterTripsPlanned"
        static let packingTemplatesUsed = "packingTemplatesUsed"
        static let documentsChecklistsCompleted = "documentsChecklistsCompleted"
        static let documentsCompletionCounted = "documentsCompletionCounted"
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    @Published var hasSeenOnboarding: Bool {
        didSet { defaults.set(hasSeenOnboarding, forKey: Keys.hasSeenOnboarding) }
    }

    @Published var totalSessionsCompleted: Int {
        didSet { defaults.set(totalSessionsCompleted, forKey: Keys.totalSessionsCompleted) }
    }

    @Published var totalMinutesUsed: Int {
        didSet { defaults.set(totalMinutesUsed, forKey: Keys.totalMinutesUsed) }
    }

    @Published var streakDays: Int {
        didSet { defaults.set(streakDays, forKey: Keys.streakDays) }
    }

    @Published var lastActivityDate: Date? {
        didSet {
            if let date = lastActivityDate {
                defaults.set(date, forKey: Keys.lastActivityDate)
            } else {
                defaults.removeObject(forKey: Keys.lastActivityDate)
            }
        }
    }

    @Published var achievementsUnlocked: [String: Date] {
        didSet { saveAchievements() }
    }

    @Published var destinations: [Destination] {
        didSet { saveDestinations() }
    }

    @Published var destinationsAdded: Int {
        didSet { defaults.set(destinationsAdded, forKey: Keys.destinationsAdded) }
    }

    @Published var tripsCompleted: Int {
        didSet { defaults.set(tripsCompleted, forKey: Keys.tripsCompleted) }
    }

    @Published var travelItems: [TravelItem] {
        didSet {
            saveTravelItems()
            lastEditedAt = Date()
        }
    }

    @Published var categories: [String] {
        didSet { saveCategories() }
    }

    @Published var lastEditedAt: Date? {
        didSet {
            if let date = lastEditedAt {
                defaults.set(date, forKey: Keys.lastEditedAt)
            }
        }
    }

    @Published var checklistsCompleted: Int {
        didSet { defaults.set(checklistsCompleted, forKey: Keys.checklistsCompleted) }
    }

    @Published var fromCurrency: String {
        didSet { defaults.set(fromCurrency, forKey: Keys.fromCurrency) }
    }

    @Published var toCurrency: String {
        didSet { defaults.set(toCurrency, forKey: Keys.toCurrency) }
    }

    @Published var enteredAmount: Double {
        didSet { defaults.set(enteredAmount, forKey: Keys.enteredAmount) }
    }

    @Published var expandedCategories: Set<String> {
        didSet { defaults.set(Array(expandedCategories), forKey: Keys.expandedCategories) }
    }

    @Published var phrasesViewed: Int {
        didSet { defaults.set(phrasesViewed, forKey: Keys.phrasesViewed) }
    }

    @Published var viewedPhraseIds: Set<String> {
        didSet { defaults.set(Array(viewedPhraseIds), forKey: Keys.viewedPhraseIds) }
    }

    @Published var conversionsRun: Int {
        didSet { defaults.set(conversionsRun, forKey: Keys.conversionsRun) }
    }

    @Published var currencyRates: [String: Double] {
        didSet { saveRates() }
    }

    @Published var phraseLanguage: String {
        didSet { defaults.set(phraseLanguage, forKey: Keys.phraseLanguage) }
    }

    @Published var pendingAchievementTitle: String?
    @Published var achievementBannerQueue: [String] = []

    @Published var trips: [Trip] {
        didSet { saveTrips() }
    }

    @Published var documents: [DocumentItem] {
        didSet {
            saveDocuments()
            evaluateDocumentsCompletion()
        }
    }

    @Published var conversionHistory: [ConversionRecord] {
        didSet { saveConversionHistory() }
    }

    @Published var favoritePhraseIds: Set<String> {
        didSet { defaults.set(Array(favoritePhraseIds), forKey: Keys.favoritePhraseIds) }
    }

    @Published var winterTripsPlanned: Int {
        didSet { defaults.set(winterTripsPlanned, forKey: Keys.winterTripsPlanned) }
    }

    @Published var packingTemplatesUsed: Int {
        didSet { defaults.set(packingTemplatesUsed, forKey: Keys.packingTemplatesUsed) }
    }

    @Published var documentsChecklistsCompleted: Int {
        didSet { defaults.set(documentsChecklistsCompleted, forKey: Keys.documentsChecklistsCompleted) }
    }

    private var inventoryWasFullyComplete = false
    private var documentsWereFullyComplete = false

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        hasSeenOnboarding = defaults.bool(forKey: Keys.hasSeenOnboarding)
        totalSessionsCompleted = defaults.integer(forKey: Keys.totalSessionsCompleted)
        totalMinutesUsed = defaults.integer(forKey: Keys.totalMinutesUsed)
        streakDays = defaults.integer(forKey: Keys.streakDays)
        lastActivityDate = defaults.object(forKey: Keys.lastActivityDate) as? Date
        achievementsUnlocked = Self.loadDictionary(key: Keys.achievementsUnlocked, defaults: defaults)
        destinations = Self.loadDestinations(defaults: defaults)
        destinationsAdded = defaults.integer(forKey: Keys.destinationsAdded)
        tripsCompleted = defaults.integer(forKey: Keys.tripsCompleted)
        travelItems = Self.loadTravelItems(defaults: defaults)
        categories = defaults.stringArray(forKey: Keys.categories) ?? ["Clothing", "Toiletries", "Electronics"]
        lastEditedAt = defaults.object(forKey: Keys.lastEditedAt) as? Date
        checklistsCompleted = defaults.integer(forKey: Keys.checklistsCompleted)
        fromCurrency = defaults.string(forKey: Keys.fromCurrency) ?? ""
        toCurrency = defaults.string(forKey: Keys.toCurrency) ?? ""
        enteredAmount = defaults.double(forKey: Keys.enteredAmount)
        let expanded = defaults.stringArray(forKey: Keys.expandedCategories) ?? []
        expandedCategories = Set(expanded)
        phrasesViewed = defaults.integer(forKey: Keys.phrasesViewed)
        let viewed = defaults.stringArray(forKey: Keys.viewedPhraseIds) ?? []
        viewedPhraseIds = Set(viewed)
        conversionsRun = defaults.integer(forKey: Keys.conversionsRun)
        currencyRates = Self.loadRates(defaults: defaults)
        phraseLanguage = defaults.string(forKey: Keys.phraseLanguage) ?? "ES"
        inventoryWasFullyComplete = defaults.bool(forKey: Keys.inventoryCompletionCounted)
        trips = Self.loadTrips(defaults: defaults)
        documents = Self.loadDocuments(defaults: defaults)
        conversionHistory = Self.loadConversionHistory(defaults: defaults)
        favoritePhraseIds = Set(defaults.stringArray(forKey: Keys.favoritePhraseIds) ?? [])
        winterTripsPlanned = defaults.integer(forKey: Keys.winterTripsPlanned)
        packingTemplatesUsed = defaults.integer(forKey: Keys.packingTemplatesUsed)
        documentsChecklistsCompleted = defaults.integer(forKey: Keys.documentsChecklistsCompleted)
        documentsWereFullyComplete = defaults.bool(forKey: Keys.documentsCompletionCounted)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDataReset),
            name: .dataReset,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Activity

    func recordMeaningfulAction() {
        totalSessionsCompleted += 1
        updateStreak()
        checkAchievements()
    }

    func addUsageMinute() {
        totalMinutesUsed += 1
    }

    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if let last = lastActivityDate {
            let lastDay = calendar.startOfDay(for: last)
            let diff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if diff == 1 {
                streakDays += 1
            } else if diff > 1 {
                streakDays = 1
            }
        } else {
            streakDays = 1
        }
        lastActivityDate = Date()
    }

    // MARK: - Destinations

    func addDestination(_ destination: Destination) {
        destinations.append(destination)
        destinationsAdded += 1
        recordMeaningfulAction()
        checkAchievements()
    }

    func updateDestination(_ destination: Destination) {
        guard let index = destinations.firstIndex(where: { $0.id == destination.id }) else { return }
        let wasVisited = destinations[index].visited
        destinations[index] = destination
        if destination.visited && !wasVisited {
            recordMeaningfulAction()
            checkAchievements()
        }
    }

    func duplicateDestination(_ destination: Destination) {
        var copy = destination
        copy.id = UUID()
        copy.visited = false
        copy.name = "\(destination.name) (Copy)"
        destinations.append(copy)
        recordMeaningfulAction()
        checkAchievements()
    }

    func shareText(for destination: Destination) -> String {
        var lines = ["\(destination.flagEmoji) \(destination.name)", destination.country]
        if let date = destination.plannedDate {
            lines.append("Planned: \(date.formatted(date: .long, time: .omitted))")
        }
        if !destination.note.isEmpty {
            lines.append("Notes: \(destination.note)")
        }
        return lines.joined(separator: "\n")
    }

    func deleteDestination(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            guard destinations.indices.contains(index) else { continue }
            destinations.remove(at: index)
        }
    }

    func markVisited(_ destination: Destination) {
        var updated = destination
        updated.visited = true
        updateDestination(updated)
    }

    // MARK: - Inventory

    func addTravelItem(name: String, category: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        travelItems.append(TravelItem(name: trimmed, category: category))
        recordMeaningfulAction()
    }

    func toggleItem(_ item: TravelItem) {
        guard let index = travelItems.firstIndex(where: { $0.id == item.id }) else { return }
        travelItems[index].completed.toggle()
        evaluateChecklistCompletion()
        recordMeaningfulAction()
    }

    func deleteItems(at offsets: IndexSet, in category: String) {
        let itemsInCategory = travelItems.filter { $0.category == category }
        var idsToRemove: [UUID] = []
        for offset in offsets {
            guard offset < itemsInCategory.count else { continue }
            idsToRemove.append(itemsInCategory[offset].id)
        }
        travelItems.removeAll { idsToRemove.contains($0.id) }
        evaluateChecklistCompletion()
    }

    func moveItems(in category: String, from source: IndexSet, to destination: Int) {
        var categoryItems = travelItems.filter { $0.category == category }
        let others = travelItems.filter { $0.category != category }
        guard !source.isEmpty else {
            travelItems = others + categoryItems
            return
        }
        let moving = source.sorted().map { categoryItems[$0] }
        var target = destination
        for index in source.sorted() where index < target {
            target -= 1
        }
        for index in source.sorted(by: >) {
            guard categoryItems.indices.contains(index) else { continue }
            categoryItems.remove(at: index)
        }
        let insertIndex = min(max(0, target), categoryItems.count)
        categoryItems.insert(contentsOf: moving, at: insertIndex)
        travelItems = others + categoryItems
    }

    private func evaluateChecklistCompletion() {
        guard !travelItems.isEmpty else {
            inventoryWasFullyComplete = false
            defaults.set(false, forKey: Keys.inventoryCompletionCounted)
            return
        }
        let allDone = travelItems.allSatisfy(\.completed)
        if allDone && !inventoryWasFullyComplete {
            checklistsCompleted += 1
            inventoryWasFullyComplete = true
            defaults.set(true, forKey: Keys.inventoryCompletionCounted)
            checkAchievements()
        } else if !allDone {
            inventoryWasFullyComplete = false
            defaults.set(false, forKey: Keys.inventoryCompletionCounted)
        }
    }

    // MARK: - Currency & Phrases

    func convertedAmount(amount: Double) -> Double? {
        guard !fromCurrency.isEmpty, !toCurrency.isEmpty,
              let from = CurrencyData.currencies.first(where: { $0.code == fromCurrency }),
              let to = CurrencyData.currencies.first(where: { $0.code == toCurrency }),
              amount >= 0 else {
            return nil
        }
        let fromRate = rate(for: from.code)
        let toRate = rate(for: to.code)
        let adjustedFrom = CurrencyData.Currency(
            code: from.code,
            name: from.name,
            symbol: from.symbol,
            rateToUSD: fromRate
        )
        let adjustedTo = CurrencyData.Currency(
            code: to.code,
            name: to.name,
            symbol: to.symbol,
            rateToUSD: toRate
        )
        return CurrencyData.convert(amount: amount, from: adjustedFrom, to: adjustedTo)
    }

    func recordConversion(amount: Double) {
        guard let result = convertedAmount(amount: amount) else { return }
        conversionsRun += 1
        let record = ConversionRecord(
            fromCode: fromCurrency,
            toCode: toCurrency,
            amount: amount,
            result: result
        )
        conversionHistory.insert(record, at: 0)
        if conversionHistory.count > 10 {
            conversionHistory = Array(conversionHistory.prefix(10))
        }
        recordMeaningfulAction()
        checkAchievements()
    }

    func toggleFavoritePhrase(_ phraseId: String) {
        if favoritePhraseIds.contains(phraseId) {
            favoritePhraseIds.remove(phraseId)
        } else {
            favoritePhraseIds.insert(phraseId)
        }
        recordMeaningfulAction()
    }

    func refreshRates() {
        var rates: [String: Double] = [:]
        for currency in CurrencyData.currencies {
            let jitter = Double.random(in: 0.98...1.02)
            rates[currency.code] = currency.rateToUSD * jitter
        }
        currencyRates = rates
        recordMeaningfulAction()
    }

    func recordPhraseView(phraseId: String) {
        guard !viewedPhraseIds.contains(phraseId) else { return }
        viewedPhraseIds.insert(phraseId)
        phrasesViewed = viewedPhraseIds.count
        recordMeaningfulAction()
        checkAchievements()
    }

    func toggleCategoryExpanded(_ categoryId: String) {
        if expandedCategories.contains(categoryId) {
            expandedCategories.remove(categoryId)
        } else {
            expandedCategories.insert(categoryId)
        }
    }

    // MARK: - Achievements

    func checkAchievements() {
        for achievement in AchievementDefinition.all {
            unlockIfNeeded(id: achievement.id, title: achievement.title) {
                achievement.isUnlocked(store: self)
            }
        }
        for achievement in SeasonalAchievement.all {
            unlockIfNeeded(id: achievement.id, title: achievement.title) {
                achievement.isUnlocked(store: self)
            }
        }
    }

    private func unlockIfNeeded(id: String, title: String, condition: () -> Bool) {
        guard condition() else { return }
        if achievementsUnlocked[id] == nil {
            achievementsUnlocked[id] = Date()
            enqueueAchievementBanner(title)
        }
    }

    func upcomingTripReminderMessage() -> String? {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let upcoming = trips
            .filter { $0.status != .completed }
            .compactMap { trip -> (Trip, Int)? in
                let start = cal.startOfDay(for: trip.startDate)
                guard let days = cal.dateComponents([.day], from: today, to: start).day, days >= 0, days <= 7 else {
                    return nil
                }
                return (trip, days)
            }
            .sorted { $0.1 < $1.1 }
        guard let first = upcoming.first else { return nil }
        if first.1 == 0 {
            return "Your trip \"\(first.0.title)\" starts today!"
        }
        let dayWord = first.1 == 1 ? "day" : "days"
        return "Trip \"\(first.0.title)\" in \(first.1) \(dayWord)"
    }

    func enqueueAchievementBanner(_ title: String) {
        if pendingAchievementTitle == nil {
            pendingAchievementTitle = title
        } else {
            achievementBannerQueue.append(title)
        }
    }

    func dequeueAchievementBanner() {
        if achievementBannerQueue.isEmpty {
            pendingAchievementTitle = nil
        } else {
            pendingAchievementTitle = achievementBannerQueue.removeFirst()
        }
    }

    func completeOnboarding() {
        hasSeenOnboarding = true
        recordMeaningfulAction()
    }

    // MARK: - Reset

    func resetAllData() {
        let domain = Bundle.main.bundleIdentifier ?? ""
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
        reloadFromDefaults()
        NotificationCenter.default.post(name: .dataReset, object: nil)
    }

    @objc private func handleDataReset() {
        reloadFromDefaults()
    }

    private func reloadFromDefaults() {
        hasSeenOnboarding = defaults.bool(forKey: Keys.hasSeenOnboarding)
        totalSessionsCompleted = defaults.integer(forKey: Keys.totalSessionsCompleted)
        totalMinutesUsed = defaults.integer(forKey: Keys.totalMinutesUsed)
        streakDays = defaults.integer(forKey: Keys.streakDays)
        lastActivityDate = defaults.object(forKey: Keys.lastActivityDate) as? Date
        achievementsUnlocked = Self.loadDictionary(key: Keys.achievementsUnlocked, defaults: defaults)
        destinations = Self.loadDestinations(defaults: defaults)
        destinationsAdded = defaults.integer(forKey: Keys.destinationsAdded)
        tripsCompleted = defaults.integer(forKey: Keys.tripsCompleted)
        travelItems = Self.loadTravelItems(defaults: defaults)
        categories = defaults.stringArray(forKey: Keys.categories) ?? ["Clothing", "Toiletries", "Electronics"]
        lastEditedAt = defaults.object(forKey: Keys.lastEditedAt) as? Date
        checklistsCompleted = defaults.integer(forKey: Keys.checklistsCompleted)
        fromCurrency = defaults.string(forKey: Keys.fromCurrency) ?? ""
        toCurrency = defaults.string(forKey: Keys.toCurrency) ?? ""
        enteredAmount = defaults.double(forKey: Keys.enteredAmount)
        expandedCategories = Set(defaults.stringArray(forKey: Keys.expandedCategories) ?? [])
        phrasesViewed = defaults.integer(forKey: Keys.phrasesViewed)
        viewedPhraseIds = Set(defaults.stringArray(forKey: Keys.viewedPhraseIds) ?? [])
        conversionsRun = defaults.integer(forKey: Keys.conversionsRun)
        currencyRates = Self.loadRates(defaults: defaults)
        phraseLanguage = defaults.string(forKey: Keys.phraseLanguage) ?? "ES"
        inventoryWasFullyComplete = defaults.bool(forKey: Keys.inventoryCompletionCounted)
        trips = Self.loadTrips(defaults: defaults)
        documents = Self.loadDocuments(defaults: defaults)
        conversionHistory = Self.loadConversionHistory(defaults: defaults)
        favoritePhraseIds = Set(defaults.stringArray(forKey: Keys.favoritePhraseIds) ?? [])
        winterTripsPlanned = defaults.integer(forKey: Keys.winterTripsPlanned)
        packingTemplatesUsed = defaults.integer(forKey: Keys.packingTemplatesUsed)
        documentsChecklistsCompleted = defaults.integer(forKey: Keys.documentsChecklistsCompleted)
        documentsWereFullyComplete = defaults.bool(forKey: Keys.documentsCompletionCounted)
        pendingAchievementTitle = nil
        achievementBannerQueue = []
    }

    // MARK: - Persistence helpers

    private func saveDestinations() {
        guard let data = try? encoder.encode(destinations) else { return }
        defaults.set(data, forKey: Keys.destinations)
    }

    private func saveTravelItems() {
        guard let data = try? encoder.encode(travelItems) else { return }
        defaults.set(data, forKey: Keys.travelItems)
    }

    private func saveCategories() {
        defaults.set(categories, forKey: Keys.categories)
    }

    private func saveAchievements() {
        guard let data = try? encoder.encode(achievementsUnlocked) else { return }
        defaults.set(data, forKey: Keys.achievementsUnlocked)
    }

    private func saveRates() {
        guard let data = try? encoder.encode(currencyRates) else { return }
        defaults.set(data, forKey: Keys.currencyRates)
    }

    private func saveTrips() {
        guard let data = try? encoder.encode(trips) else { return }
        defaults.set(data, forKey: Keys.trips)
    }

    private func saveDocuments() {
        guard let data = try? encoder.encode(documents) else { return }
        defaults.set(data, forKey: Keys.documents)
    }

    private func saveConversionHistory() {
        guard let data = try? encoder.encode(conversionHistory) else { return }
        defaults.set(data, forKey: Keys.conversionHistory)
    }

    private static func loadTrips(defaults: UserDefaults) -> [Trip] {
        guard let data = defaults.data(forKey: Keys.trips),
              let list = try? JSONDecoder().decode([Trip].self, from: data) else {
            return []
        }
        return list
    }

    private static func loadDocuments(defaults: UserDefaults) -> [DocumentItem] {
        guard let data = defaults.data(forKey: Keys.documents),
              let list = try? JSONDecoder().decode([DocumentItem].self, from: data) else {
            return []
        }
        return list
    }

    private static func loadConversionHistory(defaults: UserDefaults) -> [ConversionRecord] {
        guard let data = defaults.data(forKey: Keys.conversionHistory),
              let list = try? JSONDecoder().decode([ConversionRecord].self, from: data) else {
            return []
        }
        return list
    }

    private static func loadDestinations(defaults: UserDefaults) -> [Destination] {
        guard let data = defaults.data(forKey: Keys.destinations),
              let list = try? JSONDecoder().decode([Destination].self, from: data) else {
            return []
        }
        return list
    }

    private static func loadTravelItems(defaults: UserDefaults) -> [TravelItem] {
        guard let data = defaults.data(forKey: Keys.travelItems),
              let list = try? JSONDecoder().decode([TravelItem].self, from: data) else {
            return []
        }
        return list
    }

    private static func loadDictionary(key: String, defaults: UserDefaults) -> [String: Date] {
        guard let data = defaults.data(forKey: key),
              let dict = try? JSONDecoder().decode([String: Date].self, from: data) else {
            return [:]
        }
        return dict
    }

    private static func loadRates(defaults: UserDefaults) -> [String: Double] {
        guard let data = defaults.data(forKey: Keys.currencyRates),
              let rates = try? JSONDecoder().decode([String: Double].self, from: data) else {
            var initial: [String: Double] = [:]
            for c in CurrencyData.currencies {
                initial[c.code] = c.rateToUSD
            }
            return initial
        }
        return rates
    }

    func rate(for code: String) -> Double {
        if let stored = currencyRates[code] {
            return stored
        }
        return CurrencyData.currencies.first(where: { $0.code == code })?.rateToUSD ?? 1.0
    }

    func evaluateDocumentsCompletion() {
        guard !documents.isEmpty else {
            documentsWereFullyComplete = false
            defaults.set(false, forKey: Keys.documentsCompletionCounted)
            return
        }
        let allDone = documents.allSatisfy(\.completed)
        if allDone && !documentsWereFullyComplete {
            documentsChecklistsCompleted += 1
            documentsWereFullyComplete = true
            defaults.set(true, forKey: Keys.documentsCompletionCounted)
            checkAchievements()
        } else if !allDone {
            documentsWereFullyComplete = false
            defaults.set(false, forKey: Keys.documentsCompletionCounted)
        }
    }
}

