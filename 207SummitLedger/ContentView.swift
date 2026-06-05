import Combine
import SwiftUI

struct ContentView: View {
    @StateObject private var store = AppDataStore()

    var body: some View {
        Group {
            if store.hasSeenOnboarding {
                MainTabContainerView()
            } else {
                OnboardingView()
            }
        }
        .environmentObject(store)
        .preferredColorScheme(.dark)
        .onAppear {
            AppAppearance.configure()
            store.checkAchievements()
        }
    }
}

#Preview {
    ContentView()
}
