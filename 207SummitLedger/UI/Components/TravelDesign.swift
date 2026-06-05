import SwiftUI

/// Shared visual tokens. Gradients are cheap; shadows are limited to elevated chrome only.
enum TravelDesign {
    static let cornerRadius: CGFloat = 16
    static let miniCornerRadius: CGFloat = 12

    static var cardGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color("AppSurface"),
                Color("AppSurface").opacity(0.94),
                Color("AppBackground").opacity(0.28)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var cardTopShine: LinearGradient {
        LinearGradient(
            colors: [Color.white.opacity(0.1), Color.clear],
            startPoint: .top,
            endPoint: .center
        )
    }

    static func cardBorderGradient(elevated: Bool) -> LinearGradient {
        LinearGradient(
            colors: [
                Color("AppAccent").opacity(elevated ? 0.45 : 0.22),
                Color("AppPrimary").opacity(elevated ? 0.2 : 0.08)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [Color("AppPrimary"), Color("AppPrimary").opacity(0.82)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var accentGradient: LinearGradient {
        LinearGradient(
            colors: [Color("AppAccent"), Color("AppAccent").opacity(0.75)],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    static var iconPlateGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color("AppBackground").opacity(0.5),
                Color("AppPrimary").opacity(0.12)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var inputGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color("AppBackground").opacity(0.45),
                Color("AppBackground").opacity(0.28)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var tabBarGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color("AppSurface"),
                Color("AppSurface").opacity(0.96),
                Color("AppBackground").opacity(0.4)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var screenBackground: LinearGradient {
        LinearGradient(
            colors: [Color("AppBackground"), Color("AppSurface").opacity(0.55)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var mediaScrim: LinearGradient {
        LinearGradient(
            colors: [.clear, Color("AppBackground").opacity(0.8)],
            startPoint: .center,
            endPoint: .bottom
        )
    }

    static var heroScrim: LinearGradient {
        LinearGradient(
            colors: [.clear, Color("AppBackground").opacity(0.85), Color("AppBackground").opacity(0.95)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static let elevatedShadowColor = Color.black.opacity(0.22)
    static let elevatedShadowRadius: CGFloat = 6
    static let elevatedShadowY: CGFloat = 3
}

// MARK: - Reusable chrome (no shadow — safe inside ScrollView lists)

struct TravelCardChrome: View {
    var elevated: Bool = false
    var cornerRadius: CGFloat = TravelDesign.cornerRadius

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(TravelDesign.cardGradient)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(TravelDesign.cardTopShine)
                    .allowsHitTesting(false)
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(TravelDesign.cardBorderGradient(elevated: elevated), lineWidth: 1)
            }
    }
}

/// One shadow per elevated view — applied after compositingGroup.
struct TravelElevatedShadowModifier: ViewModifier {
    let enabled: Bool

    func body(content: Content) -> some View {
        if enabled {
            content
                .compositingGroup()
                .shadow(
                    color: TravelDesign.elevatedShadowColor,
                    radius: TravelDesign.elevatedShadowRadius,
                    x: 0,
                    y: TravelDesign.elevatedShadowY
                )
        } else {
            content
        }
    }
}
