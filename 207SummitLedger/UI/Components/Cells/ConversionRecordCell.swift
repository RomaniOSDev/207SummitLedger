import SwiftUI

struct ConversionRecordCell: View {
    let record: ConversionRecord

    var body: some View {
        HStack(spacing: 12) {
            IconCircleBadge(systemImage: "arrow.left.arrow.right", size: 44, iconSize: 18)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(format(record.amount)) \(record.fromCode) → \(record.toCode)")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color("AppTextPrimary"))
                Text(record.date, style: .date)
                    .font(.caption2)
                    .foregroundStyle(Color("AppTextSecondary"))
            }
            Spacer(minLength: 0)
            Text(format(record.result))
                .font(.headline)
                .foregroundStyle(Color("AppPrimary"))
        }
        .padding(12)
        .background(Color("AppBackground").opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("AppPrimary").opacity(0.2), lineWidth: 1)
        )
    }

    private func format(_ value: Double) -> String {
        String(format: "%.2f", value)
    }
}
