import SwiftUI

struct ToolNavigationCell: View {
    let title: String
    let subtitle: String
    let icon: String
    var accent: Bool = false

    var body: some View {
        HStack(spacing: 16) {
            IconCircleBadge(systemImage: icon, size: 56, iconSize: 24)
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color("AppTextPrimary"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color("AppTextSecondary"))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            Spacer(minLength: 0)
            Image(systemName: "arrow.right.circle.fill")
                .font(.title2)
                .foregroundStyle(Color(accent ? "AppPrimary" : "AppAccent"))
        }
        .travelCard(elevated: accent)
    }
}
