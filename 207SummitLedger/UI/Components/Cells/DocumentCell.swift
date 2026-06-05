import SwiftUI

struct DocumentCell: View {
    let name: String
    let completed: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 14) {
                Image(systemName: completed ? "doc.fill.badge.checkmark" : "doc")
                    .font(.title2)
                    .foregroundStyle(completed ? Color("AppPrimary") : Color("AppAccent"))
                    .frame(width: 36)
                Text(name)
                    .font(.body.weight(.medium))
                    .foregroundStyle(Color("AppTextPrimary"))
                    .strikethrough(completed)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(completed ? Color("AppPrimary") : Color("AppTextSecondary"))
            }
            .travelCard()
        }
        .buttonStyle(.plain)
    }
}
