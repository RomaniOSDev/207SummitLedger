import SwiftUI

struct AchievementBannerView: View {
    let title: String
    @State private var offset: CGFloat = -120

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "star.fill")
                .foregroundStyle(Color("AppPrimary"))
            VStack(alignment: .leading, spacing: 2) {
                Text("Achievement Unlocked")
                    .font(.caption)
                    .foregroundStyle(Color("AppTextSecondary"))
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("AppTextPrimary"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            Spacer()
        }
        .padding(16)
        .travelSurfaceChrome(elevated: true)
        .padding(.horizontal, 16)
        .offset(y: offset)
        .onAppear {
            FeedbackManager.achievementUnlocked()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                offset = 56
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    offset = -120
                }
            }
        }
    }
}
