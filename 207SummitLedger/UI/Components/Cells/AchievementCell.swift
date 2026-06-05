import SwiftUI

struct AchievementCell: View {
    let title: String
    let description: String
    let systemImage: String
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        isUnlocked
                            ? TravelDesign.primaryGradient
                            : LinearGradient(
                                colors: [Color("AppBackground").opacity(0.45), Color("AppSurface")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
                    .frame(width: 56, height: 56)
                    .overlay {
                        Circle()
                            .strokeBorder(
                                isUnlocked
                                    ? Color("AppAccent").opacity(0.5)
                                    : Color("AppAccent").opacity(0.15),
                                lineWidth: 1.5
                            )
                    }
                Image(systemName: systemImage)
                    .font(.system(size: 24))
                    .foregroundStyle(isUnlocked ? Color("AppBackground") : Color("AppTextSecondary").opacity(0.45))
            }
            Text(title)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Color("AppTextPrimary"))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
            Text(description)
                .font(.caption2)
                .foregroundStyle(Color("AppTextSecondary"))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.75)
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 150)
        .background { TravelCardChrome(elevated: isUnlocked) }
        .opacity(isUnlocked ? 1 : 0.72)
    }
}
