import SwiftUI

/// Language Manager for handling app language
class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "appLanguage")
            Bundle.setLanguage(currentLanguage)
        }
    }
    
    init() {
        // Check for saved preference, otherwise use device language
        if let saved = UserDefaults.standard.string(forKey: "appLanguage") {
            currentLanguage = saved
        } else {
            // Get device language, default to English
            let preferredLanguage = Locale.preferredLanguages.first ?? "en"
            currentLanguage = preferredLanguage.hasPrefix("de") ? "de" : "en"
        }
        Bundle.setLanguage(currentLanguage)
    }
    
    var isGerman: Bool {
        currentLanguage == "de"
    }
}

// MARK: - Bundle Extension for Language Override

private var bundleKey: UInt8 = 0

extension Bundle {
    static func setLanguage(_ language: String) {
        defer {
            object_setAssociatedObject(Bundle.main, &bundleKey, Bundle.main.path(forResource: language, ofType: "lproj").flatMap(Bundle.init(path:)), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        _ = Self.once
    }
    
    private static var once: Void = {
        object_setClass(Bundle.main, LanguageBundle.self)
    }()
}

private class LanguageBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let bundle = objc_getAssociatedObject(self, &bundleKey) as? Bundle else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}
