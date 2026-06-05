import SwiftUI
import UIKit

enum AppAppearance {
    static func configure() {
        let navigation = UINavigationBarAppearance()
        navigation.configureWithTransparentBackground()
        navigation.backgroundColor = .clear
        navigation.shadowColor = .clear

        let bar = UINavigationBar.appearance()
        bar.standardAppearance = navigation
        bar.scrollEdgeAppearance = navigation
        bar.compactAppearance = navigation

        let table = UITableView.appearance()
        table.backgroundColor = .clear
        table.separatorStyle = .singleLine

        UICollectionView.appearance().backgroundColor = .clear

        UIScrollView.appearance().backgroundColor = .clear

        DispatchQueue.main.async {
            applyWindowBackground()
        }
    }

    private static func applyWindowBackground() {
        guard let color = UIColor(named: "AppBackground") else { return }
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                window.backgroundColor = color
            }
        }
    }
}

extension View {
    /// Same layout as AchievementsView: `ZStack { AppBackgroundView(); content }`
    func appScreenBackground() -> some View {
        ZStack {
            AppBackgroundView()
            self
        }
    }

    func clearScrollBackground() -> some View {
        scrollContentBackground(.hidden)
            .background(Color.clear)
    }
}
