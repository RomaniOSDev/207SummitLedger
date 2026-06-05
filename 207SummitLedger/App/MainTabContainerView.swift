import Combine
import SwiftUI

struct MainTabContainerView: View {
    @EnvironmentObject private var store: AppDataStore
    @State private var selectedTab: MainTab = .home
    @State private var showSuccessCheck = false
    @Environment(\.scenePhase) private var scenePhase
    @State private var usageTimer: Timer?
    @State private var dismissedReminder = false

    var body: some View {
        ZStack(alignment: .top) {
            AppBackgroundView()
            tabContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    CustomTabBar(selected: $selectedTab)
                }
            if !dismissedReminder, let message = store.upcomingTripReminderMessage() {
                TripReminderBanner(message: message) {
                    dismissedReminder = true
                }
                .zIndex(9)
            }
            if let title = store.pendingAchievementTitle {
                AchievementBannerView(title: title)
                    .zIndex(10)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                            store.dequeueAchievementBanner()
                        }
                    }
            }
            SuccessCheckmarkOverlay(isVisible: $showSuccessCheck)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .allowsHitTesting(false)
        }
        .environment(\.showSuccessFeedback, {
            FeedbackManager.success()
            showSuccessCheck = true
        })
        .environment(\.switchMainTab) { tab in
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                selectedTab = tab
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                startUsageTimer()
            } else {
                stopUsageTimer()
            }
        }
        .onAppear {
            dismissedReminder = false
            startUsageTimer()
        }
        .onDisappear {
            stopUsageTimer()
        }
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .home:
            HomeView()
        case .vault:
            TravelVaultView()
        case .tools:
            ToolsHubView()
        case .achievements:
            AchievementsView()
        case .settings:
            SettingsView()
        }
    }

    private func startUsageTimer() {
        stopUsageTimer()
        let timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            store.addUsageMinute()
        }
        RunLoop.main.add(timer, forMode: .common)
        usageTimer = timer
    }

    private func stopUsageTimer() {
        usageTimer?.invalidate()
        usageTimer = nil
    }
}

private struct SuccessFeedbackKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {
    var showSuccessFeedback: () -> Void {
        get { self[SuccessFeedbackKey.self] }
        set { self[SuccessFeedbackKey.self] = newValue }
    }
}
