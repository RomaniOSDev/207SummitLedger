import SwiftUI

private struct MainTabSelectionKey: EnvironmentKey {
    static let defaultValue: ((MainTab) -> Void)? = nil
}

extension EnvironmentValues {
    var switchMainTab: ((MainTab) -> Void)? {
        get { self[MainTabSelectionKey.self] }
        set { self[MainTabSelectionKey.self] = newValue }
    }
}
