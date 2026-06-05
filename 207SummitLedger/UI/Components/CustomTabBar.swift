import SwiftUI

enum MainTab: Int, CaseIterable {
    case home
    case vault
    case tools
    case achievements
    case settings

    var title: String {
        switch self {
        case .home: return "Home"
        case .vault: return "Vault"
        case .tools: return "Tools"
        case .achievements: return "Badges"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .vault: return "airplane"
        case .tools: return "suitcase.fill"
        case .achievements: return "star.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selected: MainTab

    var body: some View {
        HStack(spacing: 6) {
            ForEach(MainTab.allCases, id: \.rawValue) { tab in
                tabButton(tab)
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity)
        .background {
            TravelDesign.tabBarGradient
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color("AppAccent").opacity(0.35), Color("AppPrimary").opacity(0.1)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 1)
                }
                .ignoresSafeArea(edges: .bottom)
        }
        .compositingGroup()
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -4)
    }

    private func tabButton(_ tab: MainTab) -> some View {
        let isSelected = selected == tab
        return Button {
            FeedbackManager.tapLight()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                selected = tab
            }
        } label: {
            VStack(spacing: 5) {
                Image(systemName: tab.icon)
                    .font(.system(size: isSelected ? 22 : 20, weight: .semibold))
                Text(tab.title)
                    .font(.caption2.weight(isSelected ? .bold : .regular))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .foregroundStyle(isSelected ? Color("AppBackground") : Color("AppTextSecondary"))
            .frame(maxWidth: .infinity)
            .frame(minHeight: 48)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(TravelDesign.primaryGradient)
                        .overlay(alignment: .top) {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.15), Color.clear],
                                        startPoint: .top,
                                        endPoint: .center
                                    )
                                )
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(Color("AppAccent").opacity(0.45), lineWidth: 1)
                        }
                }
            }
            .scaleEffect(isSelected ? 1.02 : 0.96)
        }
        .buttonStyle(.plain)
    }
}
