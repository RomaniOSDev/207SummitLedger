import SwiftUI

struct PhraseCategoryCard: View {
    let category: PhraseCategory
    let isExpanded: Bool
    let favoriteIds: Set<String>
    let onToggle: () -> Void
    let onPhraseTap: (String) -> Void
    let onFavorite: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack {
                    IconCircleBadge(systemImage: "text.bubble", size: 36, iconSize: 16)
                    Text(category.title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Color("AppTextPrimary"))
                    Spacer()
                    Text("\(category.phrases.count)")
                        .font(.caption2)
                        .foregroundStyle(Color("AppTextSecondary"))
                    Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .foregroundStyle(Color("AppAccent"))
                }
                .padding(14)
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(spacing: 6) {
                    ForEach(category.phrases) { phrase in
                        PhraseCell(
                            english: phrase.english,
                            translation: phrase.translation,
                            isFavorite: favoriteIds.contains(phrase.id),
                            onTap: { onPhraseTap(phrase.id) },
                            onFavorite: { onFavorite(phrase.id) }
                        )
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
        }
        .travelSurfaceChrome(elevated: isExpanded)
        .animation(.easeInOut(duration: 0.3), value: isExpanded)
    }
}
