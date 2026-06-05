import Foundation

enum TripStatus: String, Codable, CaseIterable, Identifiable, Hashable {
    case planned
    case active
    case completed

    var id: String { rawValue }

    var title: String {
        switch self {
        case .planned: return "Planned"
        case .active: return "Active"
        case .completed: return "Completed"
        }
    }
}

struct TripDayTask: Identifiable, Codable, Equatable, Hashable {
    var id: UUID
    var title: String
    var completed: Bool

    init(id: UUID = UUID(), title: String, completed: Bool = false) {
        self.id = id
        self.title = title
        self.completed = completed
    }
}

struct TripDay: Identifiable, Codable, Equatable, Hashable {
    var id: UUID
    var dayNumber: Int
    var note: String
    var tasks: [TripDayTask]

    init(id: UUID = UUID(), dayNumber: Int, note: String = "", tasks: [TripDayTask] = []) {
        self.id = id
        self.dayNumber = dayNumber
        self.note = note
        self.tasks = tasks
    }
}

struct TripBudget: Codable, Equatable, Hashable {
    var days: Int
    var foodPerDay: Double
    var transportPerDay: Double
    var lodgingPerDay: Double
    var currencyCode: String

    var dailyTotal: Double { foodPerDay + transportPerDay + lodgingPerDay }
    var tripTotal: Double { dailyTotal * Double(max(days, 0)) }
}

struct Trip: Identifiable, Codable, Equatable, Hashable {
    var id: UUID
    var title: String
    var destinationId: UUID?
    var startDate: Date
    var endDate: Date
    var status: TripStatus
    var itinerary: [TripDay]
    var budget: TripBudget?
    var fromCurrency: String
    var toCurrency: String
    var note: String

    init(
        id: UUID = UUID(),
        title: String,
        destinationId: UUID? = nil,
        startDate: Date,
        endDate: Date,
        status: TripStatus = .planned,
        itinerary: [TripDay] = [],
        budget: TripBudget? = nil,
        fromCurrency: String = "",
        toCurrency: String = "",
        note: String = ""
    ) {
        self.id = id
        self.title = title
        self.destinationId = destinationId
        self.startDate = startDate
        self.endDate = endDate
        self.status = status
        self.itinerary = itinerary
        self.budget = budget
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.note = note
    }

    var dayCount: Int {
        let cal = Calendar.current
        let start = cal.startOfDay(for: startDate)
        let end = cal.startOfDay(for: endDate)
        let days = cal.dateComponents([.day], from: start, to: end).day ?? 0
        return max(days + 1, 1)
    }
}
