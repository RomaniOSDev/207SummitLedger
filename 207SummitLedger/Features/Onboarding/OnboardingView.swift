import Combine
import SwiftUI

private struct OnboardingPage {
    let stepLabel: String
    let headline: String
    let description: String
    let imageName: String
    let icon: String
}

struct OnboardingView: View {
    @EnvironmentObject private var store: AppDataStore
    @State private var pageIndex = 0
    @State private var contentOpacity: Double = 0
    @State private var contentOffset: CGFloat = 16

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            stepLabel: "Log",
            headline: "Your Summit Ledger",
            description: "Record peaks you have summited and mountains on your bucket list with elevation and difficulty.",
            imageName: "HomeHero",
            icon: "mountain.2.fill"
        ),
        OnboardingPage(
            stepLabel: "Catalog",
            headline: "World Peak Catalog",
            description: "Add famous summits from Everest to Fuji — then track your personal altitude milestones.",
            imageName: "HomeWidgetExplorer",
            icon: "book.fill"
        ),
        OnboardingPage(
            stepLabel: "Prepare",
            headline: "Expedition Ready",
            description: "Plan multi-day routes, pack alpine gear, and clear safety permits before every ascent.",
            imageName: "HomeWidgetPacking",
            icon: "backpack.fill"
        )
    ]

    var body: some View {
        ZStack {
            AppBackgroundView()
            VStack(spacing: 0) {
                headerBar
                TabView(selection: $pageIndex) {
                    ForEach(pages.indices, id: \.self) { index in
                        pageView(pages[index], index: index)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.35), value: pageIndex)

                footer
            }
        }
        .onAppear(perform: playContentAnimation)
        .onChange(of: pageIndex) { _ in playContentAnimation() }
    }

    private var headerBar: some View {
        HStack {
            Text("Step \(pageIndex + 1) of \(pages.count)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color("AppTextSecondary"))
            Spacer()
            Text(pages[pageIndex].stepLabel.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundStyle(Color("AppBackground"))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(TravelDesign.accentGradient)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    private func pageView(_ page: OnboardingPage, index: Int) -> some View {
        VStack(spacing: 20) {
            Spacer(minLength: 0)
            OnboardingArtworkPanel(imageName: page.imageName, icon: page.icon)
                .padding(.horizontal, 24)
            OnboardingTextCard(
                step: index + 1,
                headline: page.headline,
                description: page.description
            )
            .padding(.horizontal, 24)
            .opacity(contentOpacity)
            .offset(y: contentOffset)
            Spacer(minLength: 0)
        }
    }

    private var footer: some View {
        VStack(spacing: 20) {
            OnboardingPageIndicator(count: pages.count, current: pageIndex)
            PrimaryButton(title: pageIndex < pages.count - 1 ? "Continue" : "Get Started") {
                if pageIndex < pages.count - 1 {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        pageIndex += 1
                    }
                } else {
                    FeedbackManager.success()
                    store.completeOnboarding()
                }
            }
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 12)
    }

    private func playContentAnimation() {
        contentOpacity = 0
        contentOffset = 16
        withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
            contentOpacity = 1
            contentOffset = 0
        }
    }
}

// MARK: - Artwork

private struct OnboardingArtworkPanel: View {
    let imageName: String
    let icon: String
    @State private var appear = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                LinearGradient(
                    colors: [
                        Color("AppBackground").opacity(0.05),
                        Color("AppBackground").opacity(0.55),
                        Color("AppBackground").opacity(0.88)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .travelMediaFrame(height: 240, elevated: true)
            .scaleEffect(appear ? 1 : 0.94)
            .opacity(appear ? 1 : 0.6)

            IconCircleBadge(systemImage: icon, size: 56, iconSize: 24)
                .padding(14)
                .offset(x: 4, y: 4)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                appear = true
            }
        }
        .onDisappear { appear = false }
    }
}

// MARK: - Text card

private struct OnboardingTextCard: View {
    let step: Int
    let headline: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Text("\(step)")
                    .font(.caption.bold())
                    .foregroundStyle(Color("AppBackground"))
                    .frame(width: 26, height: 26)
                    .background(TravelDesign.primaryGradient)
                    .clipShape(Circle())
                Capsule()
                    .fill(TravelDesign.primaryGradient)
                    .frame(width: 40, height: 3)
            }
            Text(headline)
                .font(.title.bold())
                .foregroundStyle(Color("AppTextPrimary"))
                .fixedSize(horizontal: false, vertical: true)
            Text(description)
                .font(.body)
                .foregroundStyle(Color("AppTextSecondary"))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .travelCard(elevated: true)
    }
}

// MARK: - Page indicator

private struct OnboardingPageIndicator: View {
    let count: Int
    let current: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(index == current ? Color("AppPrimary") : Color("AppTextSecondary").opacity(0.3))
                    .frame(width: index == current ? 28 : 8, height: 8)
                    .overlay {
                        if index == current {
                            Capsule()
                                .strokeBorder(Color("AppAccent").opacity(0.45), lineWidth: 1)
                        }
                    }
                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: current)
            }
        }
    }
}
