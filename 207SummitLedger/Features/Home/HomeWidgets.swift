import SwiftUI

// MARK: - Hero

struct HomeHeroBanner: View {
    let greeting: String
    let subtitle: String
    let streak: Int

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image("HomeHero")
                .resizable()
                .scaledToFill()

            TravelDesign.heroScrim

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(greeting)
                            .font(.title2.bold())
                            .foregroundStyle(Color("AppTextPrimary"))
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(Color("AppTextSecondary"))
                    }
                    Spacer(minLength: 0)
                    if streak > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                            Text("\(streak)")
                                .font(.headline.bold())
                        }
                        .foregroundStyle(Color("AppBackground"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(TravelDesign.primaryGradient)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color("AppAccent").opacity(0.4), lineWidth: 1))
                    }
                }
            }
            .padding(16)
        }
        .travelMediaFrame(height: 200, elevated: true)
    }
}

// MARK: - Stat strip

struct HomeStatStrip: View {
    let peaks: Int
    let summited: Int
    let highest: Int
    let badges: Int

    var body: some View {
        HStack(spacing: 8) {
            miniStat(value: "\(peaks)", label: "Peaks", icon: "mountain.2")
            miniStat(value: "\(summited)", label: "Summited", icon: "flag.fill")
            miniStat(value: highest > 0 ? "\(highest)" : "—", label: "Highest m", icon: "arrow.up")
            miniStat(value: "\(badges)", label: "Badges", icon: "star.fill")
        }
    }

    private func miniStat(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Color("AppAccent"))
            Text(value)
                .font(.headline.bold())
                .foregroundStyle(Color("AppPrimary"))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.caption2)
                .foregroundStyle(Color("AppTextSecondary"))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .travelMiniTile()
    }
}

// MARK: - Next trip

struct HomeNextTripCard: View {
    let trip: Trip
    let daysUntil: Int?
    let destinationLine: String?

    var body: some View {
        HStack(spacing: 14) {
            IconCircleBadge(systemImage: "calendar.badge.clock", size: 52, iconSize: 22)
            VStack(alignment: .leading, spacing: 6) {
                Text("Next expedition")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color("AppTextSecondary"))
                    .textCase(.uppercase)
                Text(trip.title)
                    .font(.headline)
                    .foregroundStyle(Color("AppTextPrimary"))
                    .lineLimit(2)
                if let destinationLine {
                    Text(destinationLine)
                        .font(.subheadline)
                        .foregroundStyle(Color("AppAccent"))
                        .lineLimit(1)
                }
                Text(countdownText)
                    .font(.caption)
                    .foregroundStyle(Color("AppPrimary"))
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color("AppTextSecondary"))
        }
        .travelCard(elevated: true)
    }

    private var countdownText: String {
        guard let days = daysUntil else { return trip.startDate.formatted(date: .abbreviated, time: .omitted) }
        if days == 0 { return "Starts today" }
        if days == 1 { return "Starts tomorrow" }
        if days < 0 { return "In progress" }
        return "In \(days) days · \(trip.startDate.formatted(date: .abbreviated, time: .omitted))"
    }
}

// MARK: - Image widget tile

struct HomeImageWidget: View {
    let imageName: String
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(imageName)
                .resizable()
                .scaledToFill()
            TravelDesign.mediaScrim
            HStack(alignment: .bottom, spacing: 10) {
                Image(systemName: icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color("AppPrimary"))
                    .frame(width: 32, height: 32)
                    .background(TravelDesign.cardGradient)
                    .clipShape(Circle())
                    .overlay(Circle().strokeBorder(Color("AppAccent").opacity(0.3), lineWidth: 1))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.bold())
                        .foregroundStyle(Color("AppTextPrimary"))
                        .lineLimit(1)
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(Color("AppTextSecondary"))
                        .lineLimit(2)
                }
                Spacer(minLength: 0)
            }
            .padding(12)
        }
        .travelMediaFrame(height: 130, elevated: false)
    }
}

// MARK: - Progress widget

struct HomeProgressWidget: View {
    let title: String
    let icon: String
    let done: Int
    let total: Int
    let accent: Bool

    private var progress: Double {
        guard total > 0 else { return 0 }
        return Double(done) / Double(total)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(accent ? Color("AppPrimary") : Color("AppAccent"))
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundStyle(Color("AppTextPrimary"))
                Spacer()
                Text(total == 0 ? "—" : "\(done)/\(total)")
                    .font(.caption.bold())
                    .foregroundStyle(Color("AppPrimary"))
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color("AppBackground").opacity(0.4))
                    Capsule()
                        .fill(TravelDesign.primaryGradient)
                        .frame(width: max(8, geo.size.width * progress))
                }
            }
            .frame(height: 8)
            Text(progressLabel)
                .font(.caption)
                .foregroundStyle(Color("AppTextSecondary"))
        }
        .travelCard()
    }

    private var progressLabel: String {
        if total == 0 { return "Nothing added yet" }
        if done == total { return "All done — great job!" }
        let pct = Int(progress * 100)
        return "\(pct)% complete"
    }
}

// MARK: - Destination chip

struct HomeDestinationChip: View {
    let destination: Destination

    var body: some View {
        VStack(spacing: 8) {
            Text(destination.flagEmoji)
                .font(.system(size: 32))
            Text(destination.name)
                .font(.caption.bold())
                .foregroundStyle(Color("AppTextPrimary"))
                .lineLimit(1)
            if destination.elevationMeters > 0 {
                Text(destination.elevationDisplay)
                    .font(.caption2)
                    .foregroundStyle(Color("AppPrimary"))
            } else if let date = destination.plannedDate {
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundStyle(Color("AppTextSecondary"))
            }
        }
        .frame(width: 100)
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
        .travelMiniTile()
    }
}

// MARK: - Quick action

struct HomeQuickActionRow: View {
    let actions: [(icon: String, title: String, tab: MainTab)]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(actions.indices, id: \.self) { index in
                    let action = actions[index]
                    HomeQuickActionButton(icon: action.icon, title: action.title, tab: action.tab)
                }
            }
        }
    }
}

struct HomeQuickActionButton: View {
    @Environment(\.switchMainTab) private var switchMainTab
    let icon: String
    let title: String
    let tab: MainTab

    var body: some View {
        Button {
            FeedbackManager.tapLight()
            switchMainTab?(tab)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(Color("AppBackground"))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(TravelDesign.primaryGradient)
            .clipShape(Capsule())
            .overlay(Capsule().strokeBorder(Color("AppAccent").opacity(0.4), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}
