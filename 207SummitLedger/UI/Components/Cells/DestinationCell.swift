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
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Color("AppPrimary"))
                            .font(.subheadline)
                    }
                }
                Text(destination.country)
                    .font(.subheadline)
                    .foregroundStyle(Color("AppTextSecondary"))
                HStack(spacing: 8) {
                    if let date = destination.plannedDate {
                        Label(date.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                            .font(.caption)
                            .foregroundStyle(Color("AppAccent"))
                    }
                    if !destination.note.isEmpty {
                        Label("Note", systemImage: "note.text")
                            .font(.caption)
                            .foregroundStyle(Color("AppTextSecondary"))
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
}
