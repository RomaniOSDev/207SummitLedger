import SwiftUI

struct TripCell: View {
    let trip: Trip
    var destinationLine: String?

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            IconCircleBadge(systemImage: "calendar", size: 48, iconSize: 20)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(trip.title)
                        .font(.headline)
                        .foregroundStyle(Color("AppTextPrimary"))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Spacer(minLength: 8)
                    StatusPill(text: trip.status.title, style: pillStyle(trip.status))
                }
                Label(
                    "\(trip.startDate.formatted(date: .abbreviated, time: .omitted)) – \(trip.endDate.formatted(date: .abbreviated, time: .omitted))",
                    systemImage: "clock"
                )
                .font(.caption)
                .foregroundStyle(Color("AppTextSecondary"))
                if let destinationLine {
                    Text(destinationLine)
                        .font(.caption)
                        .foregroundStyle(Color("AppAccent"))
                }
                HStack(spacing: 12) {
                    metaChip(icon: "list.bullet", text: "\(trip.dayCount) days")
                    if trip.budget != nil {
                        metaChip(icon: "dollarsign.circle", text: "Budget")
                    }
                }
            }
        }
        .travelCard()
    }

    private func pillStyle(_ status: TripStatus) -> StatusPill.PillStyle {
        switch status {
        case .planned: return .planned
        case .active: return .active
        case .completed: return .completed
        }
    }

    private func metaChip(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.caption2)
        .foregroundStyle(Color("AppTextPrimary"))
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color("AppBackground").opacity(0.35))
        .clipShape(Capsule())
    }
}
