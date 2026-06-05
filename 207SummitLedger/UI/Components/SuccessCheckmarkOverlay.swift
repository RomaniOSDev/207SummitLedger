import SwiftUI

struct SuccessCheckmarkOverlay: View {
    @Binding var isVisible: Bool

    var body: some View {
        Group {
            if isVisible {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Color("AppPrimary"))
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isVisible)
        .onChange(of: isVisible) { visible in
            if visible {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isVisible = false
                    }
                }
            }
        }
    }
}
