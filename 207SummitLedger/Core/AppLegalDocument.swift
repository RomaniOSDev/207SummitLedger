import Foundation

enum AppLegalDocument: String, Identifiable, CaseIterable {
    case privacyPolicy
    case termsOfUse

    var id: String { rawValue }

    var title: String {
        switch self {
        case .privacyPolicy:
            return "Privacy Policy"
        case .termsOfUse:
            return "Terms of Use"
        }
    }

    var settingsIcon: String {
        switch self {
        case .privacyPolicy:
            return "hand.raised.fill"
        case .termsOfUse:
            return "doc.text.fill"
        }
    }

    var markdownResourceName: String {
        switch self {
        case .privacyPolicy:
            return "privacy_policy"
        case .termsOfUse:
            return "terms_of_use"
        }
    }

    /// Optional web URL — kept in enum for reference; in-app markdown is shown to users.
    var webURLString: String {
        switch self {
        case .privacyPolicy:
            return "https://summit207ledger.site/privacy/241"
        case .termsOfUse:
            return "https://summit207ledger.site/terms/241"
        }
    }

    var webURL: URL? {
        URL(string: webURLString)
    }
}
