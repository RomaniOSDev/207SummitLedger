import Combine
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: AppDataStore
    @State private var showResetAlert = false

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                ScrollView {
                    VStack(spacing: TravelCardStyle.rowSpacing) {
                        StatsSummaryCard(
                            sessions: store.totalSessionsCompleted,
                            minutes: store.totalMinutesUsed,
                            streak: store.streakDays
                        )

                        SectionHeaderView(title: "Legal", subtitle: "Rate, privacy, and terms")

                        SettingsCardGroup {
                            SettingsCell(title: "Rate Us", icon: "star.fill") {
                                FeedbackManager.tapLight()
                                AppLinkService.rateApp()
                            }
                            divider
                            SettingsCell(
                                title: AppExternalLink.privacyPolicy.settingsTitle,
                                icon: AppExternalLink.privacyPolicy.settingsIcon
                            ) {
                                FeedbackManager.tapLight()
                                AppLinkService.openPrivacyPolicy()
                            }
                            divider
                            SettingsCell(
                                title: AppExternalLink.termsOfUse.settingsTitle,
                                icon: AppExternalLink.termsOfUse.settingsIcon
                            ) {
                                FeedbackManager.tapLight()
                                AppLinkService.openTermsOfUse()
                            }
                        }

                        SectionHeaderView(title: "Data", subtitle: "Manage your local storage")

                        SettingsCardGroup {
                            SettingsCell(
                                title: "Reset All Data",
                                icon: "trash.fill",
                                destructive: true,
                                showsChevron: false
                            ) {
                                FeedbackManager.tapLight()
                                showResetAlert = true
                            }
                        }

                        Text("Version \(appVersion)")
                            .font(.caption)
                            .foregroundStyle(Color("AppTextSecondary"))
                            .frame(maxWidth: .infinity)
                            .padding(.top, 8)
                    }
                    .padding(.horizontal, TravelCardStyle.horizontalPadding)
                    .padding(.vertical, 12)
                }
                .clearScrollBackground()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .alert("Reset All Data?", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { FeedbackManager.tapLight() }
                Button("Reset", role: .destructive) {
                    FeedbackManager.warning()
                    store.resetAllData()
                }
            } message: {
                Text("This will permanently delete all destinations, checklists, and progress.")
            }
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color("AppAccent").opacity(0.15))
            .frame(height: 1)
            .padding(.leading, 58)
    }
}
