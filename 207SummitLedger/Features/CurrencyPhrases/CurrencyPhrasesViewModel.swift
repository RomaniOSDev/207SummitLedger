import Combine
import Foundation

final class CurrencyPhrasesViewModel: ObservableObject {
    @Published var amountText = ""
    @Published var convertedResult: Double?
    @Published var shakeTrigger = 0
    @Published var amountError: String?
    @Published var phraseSearchText = ""

    func syncAmount(from store: AppDataStore) {
        if store.enteredAmount > 0, amountText.isEmpty {
            amountText = String(format: "%.2f", store.enteredAmount)
        }
    }

    func performConversion(store: AppDataStore) {
        guard let amount = Double(amountText.replacingOccurrences(of: ",", with: ".")),
              amount >= 0 else {
            FeedbackManager.warning()
            amountError = "Enter a valid amount."
            shakeTrigger += 1
            return
        }
        guard !store.fromCurrency.isEmpty, !store.toCurrency.isEmpty else {
            FeedbackManager.warning()
            amountError = "Select both currencies."
            shakeTrigger += 1
            return
        }
        amountError = nil
        store.enteredAmount = amount
        if let result = store.convertedAmount(amount: amount) {
            convertedResult = result
            store.recordConversion(amount: amount)
            FeedbackManager.saveMedium()
        }
    }
}
