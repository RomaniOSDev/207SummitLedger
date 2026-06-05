import Foundation

struct ConversionRecord: Identifiable, Codable, Equatable {
    var id: UUID
    var date: Date
    var fromCode: String
    var toCode: String
    var amount: Double
    var result: Double

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        fromCode: String,
        toCode: String,
        amount: Double,
        result: Double
    ) {
        self.id = id
        self.date = date
        self.fromCode = fromCode
        self.toCode = toCode
        self.amount = amount
        self.result = result
    }
}
