import SwiftUI

struct InventoryItemCell: View {
    let name: String
    let category: String
    let completed: Bool
    var isPulsing: Bool = false
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(completed ? Color("AppPrimary") : Color("AppTextSecondary").opacity(0.5), lineWidth: 2)
                        .frame(width: 28, height: 28)
                    if completed {
                        Circle()
                            .fill(Color("AppPrimary"))
                            .frame(width: 28, height: 28)
                        Image(systemName: "checkmark")
                            .font(.caption.bold())
                            .foregroundStyle(Color("AppBackground"))
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.body.weight(.medium))
                        .foregroundStyle(Color("AppTextPrimary"))
                        .strikethrough(completed)
                        .lineLimit(2)
                    Text(category)
                        .font(.caption)
                        .foregroundStyle(Color("AppTextSecondary"))
                }
                Spacer(minLength: 0)
            }
            .padding(14)
            .background {
                if isPulsing {
                    RoundedRectangle(cornerRadius: TravelCardStyle.cornerRadius, style: .continuous)
                        .fill(Color("AppAccent").opacity(0.28))
                } else {
                    TravelCardChrome(elevated: completed)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
