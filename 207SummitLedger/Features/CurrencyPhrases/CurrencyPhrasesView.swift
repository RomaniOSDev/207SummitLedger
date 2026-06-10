import Combine
import SwiftUI

struct CurrencyPhrasesView: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.showSuccessFeedback) private var showSuccessFeedback
    @StateObject private var viewModel = CurrencyPhrasesViewModel()

    private var phraseLanguage: String {
        if let lang = CurrencyData.languageForCurrency[store.toCurrency.isEmpty ? store.fromCurrency : store.toCurrency] {
            return lang
        }
        return store.phraseLanguage
    }

    var body: some View {
        ZStack {
            AppBackgroundView()
            ScrollView {
                VStack(spacing: TravelCardStyle.rowSpacing) {
                    currencySection
                    conversionHistorySection
                    phrasesSection
                }
                .padding(.horizontal, TravelCardStyle.horizontalPadding)
                .padding(.vertical, 12)
                .tabBarScrollContentPadding()
            }
            .clearScrollBackground()
        }
        .navigationTitle("Currency & Phrases")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.syncAmount(from: store)
            if store.enteredAmount > 0 {
                viewModel.convertedResult = store.convertedAmount(amount: store.enteredAmount)
            }
        }
    }

    private var currencySection: some View {
        FormFieldCard(title: "Currency Converter") {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 10) {
                    currencyPicker(title: "From", selection: $store.fromCurrency)
                    currencyPicker(title: "To", selection: $store.toCurrency)
                }
                TextField("Amount", text: $viewModel.amountText)
                    .keyboardType(.decimalPad)
                    .foregroundStyle(Color("AppTextPrimary"))
                    .travelInputField()
                    .shake(trigger: viewModel.shakeTrigger)
                    .onChange(of: viewModel.amountText) { _ in tryConvertIfReady() }

                if let amountError = viewModel.amountError {
                    Text(amountError).font(.caption).foregroundStyle(.red)
                }

                if let result = viewModel.convertedResult, !store.toCurrency.isEmpty {
                    HStack {
                        IconCircleBadge(systemImage: "equal.circle.fill", size: 40, iconSize: 18)
                        Text("\(String(format: "%.2f", result)) \(store.toCurrency)")
                            .font(.title2.bold())
                            .foregroundStyle(Color("AppPrimary"))
                    }
                }

                PrimaryButton(title: "Convert") {
                    viewModel.performConversion(store: store)
                    if viewModel.convertedResult != nil { showSuccessFeedback() }
                }

                PrimaryButton(title: "Update Rates") {
                    store.refreshRates()
                    FeedbackManager.success()
                    showSuccessFeedback()
                }
            }
        }
    }

    private func currencyPicker(title: String, selection: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color("AppTextSecondary"))
            Picker(title, selection: selection) {
                Text("Select").tag("")
                ForEach(CurrencyData.currencies) { currency in
                    Text(currency.code).tag(currency.code)
                }
            }
            .pickerStyle(.menu)
            .tint(Color("AppPrimary"))
            .frame(maxWidth: .infinity, alignment: .leading)
            .travelInputField()
            .onChange(of: selection.wrappedValue) { _ in
                if !store.fromCurrency.isEmpty && !store.toCurrency.isEmpty {
                    store.phraseLanguage = phraseLanguage
                }
                tryConvertIfReady()
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func tryConvertIfReady() {
        guard !store.fromCurrency.isEmpty, !store.toCurrency.isEmpty,
              let amount = Double(viewModel.amountText.replacingOccurrences(of: ",", with: ".")),
              amount > 0 else { return }
        store.enteredAmount = amount
        viewModel.convertedResult = store.convertedAmount(amount: amount)
    }

    private var conversionHistorySection: some View {
        Group {
            if !store.conversionHistory.isEmpty {
                FormFieldCard(title: "Recent Conversions") {
                    VStack(spacing: 8) {
                        ForEach(store.conversionHistory) { record in
                            ConversionRecordCell(record: record)
                        }
                    }
                }
            }
        }
    }

    private var phrasesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeaderView(title: "Travel Phrases", subtitle: "Search, expand, and save favorites")
            TextField("Search phrases", text: $viewModel.phraseSearchText)
                .foregroundStyle(Color("AppTextPrimary"))
                .travelInputField()
            ForEach(store.filteredPhraseCategories(languageCode: phraseLanguage, query: viewModel.phraseSearchText)) { category in
                PhraseCategoryCard(
                    category: category,
                    isExpanded: store.expandedCategories.contains(category.id),
                    favoriteIds: store.favoritePhraseIds,
                    onToggle: {
                        FeedbackManager.tapLight()
                        withAnimation(.easeInOut(duration: 0.3)) {
                            store.toggleCategoryExpanded(category.id)
                        }
                    },
                    onPhraseTap: { store.recordPhraseView(phraseId: $0) },
                    onFavorite: { store.toggleFavoritePhrase($0) }
                )
            }
        }
    }
}
