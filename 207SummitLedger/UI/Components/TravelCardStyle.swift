import SwiftUI

enum TravelCardStyle {
    static let cornerRadius: CGFloat = TravelDesign.cornerRadius
    static let horizontalPadding: CGFloat = 16
    static let rowSpacing: CGFloat = 10
    static let contentPadding: CGFloat = 16
}

extension View {
    /// Default card for scroll lists: gradient depth, no shadow (GPU-friendly).
    func travelCard(elevated: Bool = false) -> some View {
        self
            .padding(TravelCardStyle.contentPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                TravelCardChrome(elevated: elevated)
            }
            .modifier(TravelElevatedShadowModifier(enabled: elevated))
    }

    /// Surface chrome without padding — grouped lists, phrase categories, settings groups.
    func travelSurfaceChrome(elevated: Bool = false, cornerRadius: CGFloat = TravelDesign.cornerRadius) -> some View {
        self
            .background {
                TravelCardChrome(elevated: elevated, cornerRadius: cornerRadius)
            }
            .modifier(TravelElevatedShadowModifier(enabled: elevated))
    }

    /// Small stat / chip tiles (Home strip, insights).
    func travelMiniTile() -> some View {
        self
            .background {
                RoundedRectangle(cornerRadius: TravelDesign.miniCornerRadius, style: .continuous)
                    .fill(TravelDesign.cardGradient)
                    .overlay {
                        RoundedRectangle(cornerRadius: TravelDesign.miniCornerRadius, style: .continuous)
                            .fill(TravelDesign.cardTopShine)
                            .allowsHitTesting(false)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: TravelDesign.miniCornerRadius, style: .continuous)
                            .strokeBorder(TravelDesign.cardBorderGradient(elevated: false), lineWidth: 1)
                    }
            }
    }

    /// Emoji / icon plate behind list avatars.
    func travelIconPlate(cornerRadius: CGFloat = 12) -> some View {
        self
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(TravelDesign.iconPlateGradient)
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .strokeBorder(Color("AppAccent").opacity(0.18), lineWidth: 1)
                    }
            }
    }

    /// Photo hero / widget — single composited shadow (few per screen).
    func travelMediaFrame(height: CGFloat, elevated: Bool = true) -> some View {
        self
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: TravelDesign.cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: TravelDesign.cornerRadius, style: .continuous)
                    .strokeBorder(TravelDesign.cardBorderGradient(elevated: elevated), lineWidth: 1)
            }
            .modifier(TravelElevatedShadowModifier(enabled: elevated))
    }

    func travelListCardRow() -> some View {
        self
            .listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}

struct IconCircleBadge: View {
    let systemImage: String
    var size: CGFloat = 52
    var iconSize: CGFloat = 22

    var body: some View {
        ZStack {
            Circle()
                .fill(TravelDesign.iconPlateGradient)
            Circle()
                .strokeBorder(
                    LinearGradient(
                        colors: [Color("AppPrimary").opacity(0.55), Color("AppAccent").opacity(0.25)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
            Image(systemName: systemImage)
                .font(.system(size: iconSize, weight: .semibold))
                .foregroundStyle(Color("AppPrimary"))
        }
        .frame(width: size, height: size)
    }
}

struct StatusPill: View {
    let text: String
    let style: PillStyle

    enum PillStyle {
        case planned, active, completed, neutral

        var gradient: LinearGradient {
            switch self {
            case .planned:
                return TravelDesign.accentGradient
            case .active:
                return TravelDesign.primaryGradient
            case .completed:
                return LinearGradient(
                    colors: [Color("AppTextSecondary"), Color("AppTextSecondary").opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            case .neutral:
                return TravelDesign.cardGradient
            }
        }

        var foreground: Color {
            switch self {
            case .neutral: return Color("AppTextPrimary")
            default: return Color("AppBackground")
            }
        }
    }

    var body: some View {
        Text(text)
            .font(.caption.bold())
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .foregroundStyle(style.foreground)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(style.gradient)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(style == .neutral ? 0.08 : 0.15), lineWidth: 1)
            )
    }
}

struct SectionHeaderView: View {
    let title: String
    var subtitle: String?

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(TravelDesign.accentGradient)
                .frame(width: 4)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color("AppTextPrimary"))
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(Color("AppTextSecondary"))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var buttonTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(TravelDesign.cardGradient)
                    .frame(width: 100, height: 100)
                Circle()
                    .strokeBorder(TravelDesign.cardBorderGradient(elevated: true), lineWidth: 2)
                    .frame(width: 100, height: 100)
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundStyle(Color("AppAccent"))
            }
            VStack(spacing: 8) {
                Text(title)
                    .font(.title3.bold())
                    .foregroundStyle(Color("AppTextPrimary"))
                    .multilineTextAlignment(.center)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(Color("AppTextSecondary"))
                    .multilineTextAlignment(.center)
            }
            if let buttonTitle, let action {
                PrimaryButton(title: buttonTitle, action: action)
                    .padding(.horizontal, 8)
            }
        }
        .padding(28)
    }
}

struct ScreenIntroHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(Color("AppTextPrimary"))
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(Color("AppTextSecondary"))
            Capsule()
                .fill(TravelDesign.primaryGradient)
                .frame(width: 48, height: 3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
    }
}
