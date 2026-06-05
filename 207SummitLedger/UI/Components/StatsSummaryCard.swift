import SwiftUI

struct StatsSummaryCard: View {
    let sessions: Int
    let minutes: Int
    let streak: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(Color("AppPrimary"))
                Text("Your Progress")
                    .font(.headline)
                    .foregroundStyle(Color("AppTextPrimary"))
            }
            HStack(spacing: 10) {
                statTile(value: sessions, label: "Actions", icon: "bolt.fill")
                statTile(value: minutes, label: "Minutes", icon: "clock.fill")
                statTile(value: streak, label: "Streak", icon: "flame.fill")
            }
        }
        .travelCard(elevated: true)
    }

    private func statTile(value: Int, label: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(Color("AppAccent"))
            Text("\(value)")
                .font(.title3.bold())
                .foregroundStyle(Color("AppPrimary"))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.caption2)
                .foregroundStyle(Color("AppTextSecondary"))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .travelMiniTile()
    }
}
