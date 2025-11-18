import Foundation

class StorageService {
    static let shared = StorageService()
    
    private let tokenKey = "farmily_token"
    private let linkKey = "farmily_link"
    private let languageKey = "farmily_language"
    private let themeKey = "farmily_theme"
    private let hasSeenLanguageSelectionKey = "farmily_has_seen_language_selection"
    
    private init() {}
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func saveLink(_ link: String) {
        UserDefaults.standard.set(link, forKey: linkKey)
    }
    
    func getLink() -> String? {
        return UserDefaults.standard.string(forKey: linkKey)
    }
    
    func hasToken() -> Bool {
        return getToken() != nil
    }
    
    func saveLanguage(_ language: String) {
        UserDefaults.standard.set(language, forKey: languageKey)
    }
    
    func getLanguage() -> String {
        return UserDefaults.standard.string(forKey: languageKey) ?? "en"
    }
    
    func saveTheme(_ theme: String) {
        UserDefaults.standard.set(theme, forKey: themeKey)
    }
    
    func getTheme() -> String {
        return UserDefaults.standard.string(forKey: themeKey) ?? "system"
    }
    
    func hasSeenLanguageSelection() -> Bool {
        return UserDefaults.standard.bool(forKey: hasSeenLanguageSelectionKey)
    }
    
    func setHasSeenLanguageSelection(_ seen: Bool) {
        UserDefaults.standard.set(seen, forKey: hasSeenLanguageSelectionKey)
    }
}

