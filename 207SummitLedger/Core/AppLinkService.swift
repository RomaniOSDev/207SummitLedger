import StoreKit
import UIKit

enum AppLinkService {
    static func open(_ link: AppExternalLink) {
        guard let url = link.url else { return }
        UIApplication.shared.open(url)
    }

    static func openPrivacyPolicy() {
        open(.privacyPolicy)
    }

    static func openTermsOfUse() {
        open(.termsOfUse)
    }

    static func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
