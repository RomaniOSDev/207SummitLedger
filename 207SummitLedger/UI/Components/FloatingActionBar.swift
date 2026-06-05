import SwiftUI

struct FloatingActionBar: View {
    let primaryTitle: String
    var secondaryTitle: String?
    let primaryAction: () -> Void
    var secondaryAction: (() -> Void)?

    var body: some View {
        HStack(spacing: 10) {
            if let secondaryTitle, let secondaryAction {
                Button(action: {
                    FeedbackManager.tapLight()
                    secondaryAction()
                }) {
                    Text(secondaryTitle)
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .foregroundStyle(Color("AppPrimary"))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .frame(minHeight: 44)
                        .travelMiniTile()
                        .overlay {
                            RoundedRectangle(cornerRadius: TravelDesign.miniCornerRadius, style: .continuous)
                                .strokeBorder(Color("AppPrimary").opacity(0.45), lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)
            }
            PrimaryButton(title: primaryTitle, action: primaryAction)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background {
            LinearGradient(
                colors: [
                    Color("AppBackground").opacity(0.97),
                    Color("AppBackground").opacity(0.88)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(Color("AppAccent").opacity(0.2))
                    .frame(height: 1)
            }
        }
        .compositingGroup()
        .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: -3)
    }
}
