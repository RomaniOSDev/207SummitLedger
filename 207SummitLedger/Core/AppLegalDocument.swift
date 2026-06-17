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

    /// Reference only — legal text is shown in-app from bundled markdown.
    var webURLString: String {
        switch self {
        case .privacyPolicy:
            return "https://summitledger.app/privacy"
        case .termsOfUse:
            return "https://summitledger.app/terms"
        }
    }

    var webURL: URL? {
        URL(string: webURLString)
    }
}
