import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var markdown = ""

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                ScrollView {
                    Group {
                        if markdown.isEmpty {
                            ProgressView()
                                .tint(Color("AppPrimary"))
                                .frame(maxWidth: .infinity)
                                .padding(40)
                        } else if let attributed = try? AttributedString(markdown: markdown) {
                            Text(attributed)
                                .foregroundStyle(Color("AppTextPrimary"))
                                .tint(Color("AppPrimary"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text(markdown)
                                .foregroundStyle(Color("AppTextPrimary"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .travelCard()
                    .padding(.horizontal, TravelCardStyle.horizontalPadding)
                    .padding(.vertical, 12)
                }
                .clearScrollBackground()
            }
            .navigationTitle("Privacy Policy")
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        FeedbackManager.tapLight()
                        dismiss()
                    }
                    .foregroundStyle(Color("AppPrimary"))
                    .frame(minWidth: 44, minHeight: 44)
                }
            }
            .onAppear {
                loadPolicy()
            }
        }
        .preferredColorScheme(.dark)
    }

    private func loadPolicy() {
        guard let url = Bundle.main.url(forResource: "privacy_policy", withExtension: "md"),
              let text = try? String(contentsOf: url, encoding: .utf8) else {
            markdown = "# Privacy Policy\n\nContent unavailable."
            return
        }
        markdown = text
    }
}
