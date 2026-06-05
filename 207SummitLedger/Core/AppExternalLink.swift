import Foundation

enum AppExternalLink {
    case privacyPolicy
    case termsOfUse

    var urlString: String {
        switch self {
        case .privacyPolicy:
            return "https://summit207ledger.site/privacy/241"
        case .termsOfUse:
            return "https://summit207ledger.site/terms/241"
        }
    }

    var url: URL? {
        URL(string: urlString)
    }

    var settingsTitle: String {
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
}
