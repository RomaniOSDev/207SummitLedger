import SwiftUI

struct PeakCatalogView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.showSuccessFeedback) private var showSuccessFeedback

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                ScrollView {
                    LazyVStack(spacing: TravelCardStyle.rowSpacing) {
                        ScreenIntroHeader(
                            title: "World Peak Catalog",
                            subtitle: "Add famous summits to your personal ledger"
                        )
                        ForEach(PeakCatalog.featured) { peak in
                            catalogRow(peak)
                        }
                    }
                    .padding(.horizontal, TravelCardStyle.horizontalPadding)
                    .padding(.vertical, 12)
                }
                .clearScrollBackground()
            }
            .navigationTitle("Peak Catalog")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        FeedbackManager.tapLight()
                        dismiss()
                    }
                    .foregroundStyle(Color("AppPrimary"))
                }
            }
        }
    }

    private func catalogRow(_ peak: PeakCatalogEntry) -> some View {
        let alreadyAdded = store.destinations.contains {
            $0.name.caseInsensitiveCompare(peak.name) == .orderedSame
        }
        return HStack(spacing: 14) {
            Text(peak.flagEmoji)
                .font(.system(size: 36))
                .frame(width: 52, height: 52)
                .travelIconPlate()
            VStack(alignment: .leading, spacing: 4) {
                Text(peak.name)
                    .font(.headline)
                    .foregroundStyle(Color("AppTextPrimary"))
                Text("\(peak.mountainRange) · \(peak.country)")
                    .font(.caption)
                    .foregroundStyle(Color("AppTextSecondary"))
                HStack(spacing: 8) {
                    Label(peak.elevationMeters.formatted(), systemImage: "arrow.up")
                        .font(.caption.bold())
                        .foregroundStyle(Color("AppPrimary"))
                    Text(peak.difficulty.title)
                        .font(.caption2)
                        .foregroundStyle(Color("AppAccent"))
                }
            }
            Spacer(minLength: 0)
            Button(alreadyAdded ? "Added" : "Add") {
                guard !alreadyAdded else { return }
                FeedbackManager.saveMedium()
                store.addPeakFromCatalog(peak)
                showSuccessFeedback()
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(alreadyAdded ? Color("AppTextSecondary") : Color("AppBackground"))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(alreadyAdded ? Color("AppSurface") : Color("AppPrimary"))
            .clipShape(Capsule())
            .disabled(alreadyAdded)
        }
        .travelCard()
    }
}
