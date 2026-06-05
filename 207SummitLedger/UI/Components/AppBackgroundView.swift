import SwiftUI

struct Background: View {
    var body: some View {
        AppBackgroundView()
    }
}

struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            TravelDesign.screenBackground
            accentOrb(
                colors: [Color("AppAccent").opacity(0.14), Color.clear],
                size: 260,
                offset: CGSize(width: -90, height: -140)
            )
            accentOrb(
                colors: [Color("AppPrimary").opacity(0.1), Color.clear],
                size: 220,
                offset: CGSize(width: 110, height: 220)
            )
        }
        .ignoresSafeArea()
    }

    private func accentOrb(colors: [Color], size: CGFloat, offset: CGSize) -> some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: colors,
                    center: .center,
                    startRadius: 0,
                    endRadius: size * 0.5
                )
            )
            .frame(width: size, height: size)
            .offset(offset)
            .allowsHitTesting(false)
    }
}
