import SwiftUI
import Combine

enum AppTheme: String, CaseIterable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    var localizationKey: String {
        switch self {
        case .system:
            return "theme_system"
        case .light:
            return "theme_light"
        case .dark:
            return "theme_dark"
        }
    }
    
    var displayName: String {
        return localizationKey.localized
    }
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme
    
    init() {
        let savedTheme = StorageService.shared.getTheme()
        self.currentTheme = AppTheme(rawValue: savedTheme) ?? .system
    }
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
        StorageService.shared.saveTheme(theme.rawValue)
    }
}

