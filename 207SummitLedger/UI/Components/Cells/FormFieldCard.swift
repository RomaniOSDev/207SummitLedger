import SwiftUI

struct FormFieldCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color("AppTextSecondary"))
                .textCase(.uppercase)
            content()
        }
        .travelCard()
    }
}

struct InputFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .background {
                RoundedRectangle(cornerRadius: TravelDesign.miniCornerRadius, style: .continuous)
                    .fill(TravelDesign.inputGradient)
                    .overlay {
                        RoundedRectangle(cornerRadius: TravelDesign.miniCornerRadius, style: .continuous)
                            .strokeBorder(Color("AppAccent").opacity(0.22), lineWidth: 1)
                    }
            }
    }
}

extension View {
    func travelInputField() -> some View {
        modifier(InputFieldStyle())
    }
}
