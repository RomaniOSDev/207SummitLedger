import SwiftUI

struct SettingsCell: View {
    let title: String
    let icon: String
    var destructive: Bool = false
    var showsChevron: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(
                            destructive
                                ? LinearGradient(
                                    colors: [Color.red.opacity(0.22), Color.red.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : TravelDesign.iconPlateGradient
                        )
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .foregroundStyle(destructive ? .red : Color("AppPrimary"))
                }
                Text(title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(destructive ? .red : Color("AppTextPrimary"))
                Spacer(minLength: 0)
                if showsChevron {
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color("AppTextSecondary"))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(minHeight: 44)
        }
        .buttonStyle(.plain)
    }
}

struct SettingsCardGroup<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            content()
        }
        .travelSurfaceChrome(elevated: false)
    }
}
