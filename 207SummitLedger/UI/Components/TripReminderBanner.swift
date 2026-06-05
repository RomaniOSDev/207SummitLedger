import SwiftUI

struct TripReminderBanner: View {
    let message: String
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            IconCircleBadge(systemImage: "bell.fill", size: 40, iconSize: 18)
            Text(message)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color("AppTextPrimary"))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            Spacer(minLength: 0)
            Button {
                FeedbackManager.tapLight()
                onDismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Color("AppTextSecondary"))
                    .frame(width: 44, height: 44)
            }
        }
        .travelCard(elevated: true)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}
