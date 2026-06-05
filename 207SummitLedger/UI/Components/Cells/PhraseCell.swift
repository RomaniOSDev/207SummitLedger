import SwiftUI

struct PhraseCell: View {
    let english: String
    let translation: String
    let isFavorite: Bool
    let onTap: () -> Void
    let onFavorite: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(english)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color("AppTextPrimary"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(translation)
                        .font(.caption)
                        .foregroundStyle(Color("AppAccent"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .buttonStyle(.plain)
            Button(action: onFavorite) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .font(.body)
                    .foregroundStyle(Color("AppPrimary"))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .travelMiniTile()
    }
}
