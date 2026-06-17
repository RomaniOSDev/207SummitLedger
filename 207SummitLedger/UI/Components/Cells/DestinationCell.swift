import SwiftUI

struct DestinationCell: View {
    let destination: Destination
    var showsChevron: Bool = true

    var body: some View {
        HStack(spacing: 14) {
            Text(destination.flagEmoji)
                .font(.system(size: 40))
                .frame(width: 56, height: 56)
                .travelIconPlate()

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(destination.name)
                        .font(.headline)
                        .foregroundStyle(Color("AppTextPrimary"))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    if destination.visited {
                        Image(systemName: "flag.fill")
                            .foregroundStyle(Color("AppPrimary"))
                            .font(.subheadline)
                    }
                }
                HStack(spacing: 6) {
                    Text(destination.country)
                    if !destination.mountainRange.isEmpty {
                        Text("·")
                        Text(destination.mountainRange)
                    }
                }
                .font(.subheadline)
                .foregroundStyle(Color("AppTextSecondary"))
                .lineLimit(1)
                HStack(spacing: 8) {
                    if destination.elevationMeters > 0 {
                        Label(destination.elevationDisplay, systemImage: "arrow.up")
                            .font(.caption.bold())
                            .foregroundStyle(Color("AppPrimary"))
                    }
                    StatusPill(text: destination.difficulty.title, style: difficultyPill(destination.difficulty))
                    if let date = destination.plannedDate, !destination.visited {
                        Label(date.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                            .font(.caption)
                            .foregroundStyle(Color("AppAccent"))
                    }
                }
            }
            Spacer(minLength: 0)
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color("AppTextSecondary"))
            }
        }
        .travelCard()
    }

    private func difficultyPill(_ d: SummitDifficulty) -> StatusPill.PillStyle {
        switch d {
        case .beginner: return .neutral
        case .moderate: return .planned
        case .hard: return .active
        case .expert: return .completed
        }
    }
}
