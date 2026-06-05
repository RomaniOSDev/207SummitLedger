import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button {
            FeedbackManager.tapLight()
            action()
        } label: {
            Text(title)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .foregroundStyle(Color("AppBackground"))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 44)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(TravelDesign.primaryGradient)
                        .overlay(alignment: .top) {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.18), Color.clear],
                                        startPoint: .top,
                                        endPoint: .center
                                    )
                                )
                                .allowsHitTesting(false)
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(Color("AppAccent").opacity(0.35), lineWidth: 1)
                        }
                }
                .scaleEffect(isPressed ? 0.97 : 1)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        isPressed = false
                    }
                }
        )
    }
}
