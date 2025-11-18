import Foundation
import SwiftUI
import Combine

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case englishUS = "en-US"
    case englishUK = "en-GB"
    case englishAustralia = "en-AU"
    case englishCanada = "en-CA"
    case russian = "ru"
    case arabic = "ar"
    case catalan = "ca"
    case chineseSimplified = "zh-Hans"
    case chineseTraditional = "zh-Hant"
    case croatian = "hr"
    case czech = "cs"
    case danish = "da"
    case dutch = "nl"
    case finnish = "fi"
    case french = "fr"
    case frenchCanada = "fr-CA"
    case german = "de"
    case greek = "el"
    case hebrew = "he"
    case hindi = "hi"
    case hungarian = "hu"
    case indonesian = "id"
    case italian = "it"
    case japanese = "ja"
    case korean = "ko"
    case malay = "ms"
    case norwegian = "no"
    case polish = "pl"
    case portugueseBrazil = "pt-BR"
    case portuguesePortugal = "pt-PT"
    case romanian = "ro"
    case slovak = "sk"
    case spanish = "es"
    case spanishMexico = "es-MX"
    case swedish = "sv"
    case thai = "th"
    case turkish = "tr"
    case ukrainian = "uk"
    case vietnamese = "vi"
    
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .englishUS:
            return "English (U.S.)"
        case .englishUK:
            return "English (U.K.)"
        case .englishAustralia:
            return "English (Australia)"
        case .englishCanada:
            return "English (Canada)"
        case .russian:
            return "Русский"
        case .arabic:
            return "العربية"
        case .catalan:
            return "Català"
        case .chineseSimplified:
            return "中文 (简体)"
        case .chineseTraditional:
            return "中文 (繁體)"
        case .croatian:
            return "Hrvatski"
        case .czech:
            return "Čeština"
        case .danish:
            return "Dansk"
        case .dutch:
            return "Nederlands"
        case .finnish:
            return "Suomi"
        case .french:
            return "Français"
        case .frenchCanada:
            return "Français (Canada)"
        case .german:
            return "Deutsch"
        case .greek:
            return "Ελληνικά"
        case .hebrew:
            return "עברית"
        case .hindi:
            return "हिन्दी"
        case .hungarian:
            return "Magyar"
        case .indonesian:
            return "Bahasa Indonesia"
        case .italian:
            return "Italiano"
        case .japanese:
            return "日本語"
        case .korean:
            return "한국어"
        case .malay:
            return "Bahasa Melayu"
        case .norwegian:
            return "Norsk"
        case .polish:
            return "Polski"
        case .portugueseBrazil:
            return "Português (Brasil)"
        case .portuguesePortugal:
            return "Português (Portugal)"
        case .romanian:
            return "Română"
        case .slovak:
            return "Slovenčina"
        case .spanish:
            return "Español"
        case .spanishMexico:
            return "Español (México)"
        case .swedish:
            return "Svenska"
        case .thai:
            return "ไทย"
        case .turkish:
            return "Türkçe"
        case .ukrainian:
            return "Українська"
        case .vietnamese:
            return "Tiếng Việt"
        }
    }
    
    var nativeName: String {
        switch self {
        case .english:
            return "English"
        case .englishUS:
            return "English (U.S.)"
        case .englishUK:
            return "English (U.K.)"
        case .englishAustralia:
            return "English (Australia)"
        case .englishCanada:
            return "English (Canada)"
        case .russian:
            return "Русский"
        case .arabic:
            return "العربية"
        case .catalan:
            return "Català"
        case .chineseSimplified:
            return "中文 (简体)"
        case .chineseTraditional:
            return "中文 (繁體)"
        case .croatian:
            return "Hrvatski"
        case .czech:
            return "Čeština"
        case .danish:
            return "Dansk"
        case .dutch:
            return "Nederlands"
        case .finnish:
            return "Suomi"
        case .french:
            return "Français"
        case .frenchCanada:
            return "Français (Canada)"
        case .german:
            return "Deutsch"
        case .greek:
            return "Ελληνικά"
        case .hebrew:
            return "עברית"
        case .hindi:
            return "हिन्दी"
        case .hungarian:
            return "Magyar"
        case .indonesian:
            return "Bahasa Indonesia"
        case .italian:
            return "Italiano"
        case .japanese:
            return "日本語"
        case .korean:
            return "한국어"
        case .malay:
            return "Bahasa Melayu"
        case .norwegian:
            return "Norsk"
        case .polish:
            return "Polski"
        case .portugueseBrazil:
            return "Português (Brasil)"
        case .portuguesePortugal:
            return "Português (Portugal)"
        case .romanian:
            return "Română"
        case .slovak:
            return "Slovenčina"
        case .spanish:
            return "Español"
        case .spanishMexico:
            return "Español (México)"
        case .swedish:
            return "Svenska"
        case .thai:
            return "ไทย"
        case .turkish:
            return "Türkçe"
        case .ukrainian:
            return "Українська"
        case .vietnamese:
            return "Tiếng Việt"
        }
    }
}

class LanguageManager: ObservableObject {
    @Published var currentLanguage: AppLanguage
    
    init() {
        let savedLanguage = StorageService.shared.getLanguage()
        self.currentLanguage = AppLanguage(rawValue: savedLanguage) ?? .english
        
        UserDefaults.standard.set([currentLanguage.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    func setLanguage(_ language: AppLanguage) {
        currentLanguage = language
        StorageService.shared.saveLanguage(language.rawValue)
        
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
    }
    
    var locale: Locale {
        Locale(identifier: currentLanguage.rawValue)
    }
    
    static func getSystemLanguage() -> AppLanguage {
        let systemLocale = Locale.current
        let systemIdentifier = systemLocale.identifier
        
        if let language = AppLanguage(rawValue: systemIdentifier) {
            return language
        }
        
        let languageCode = systemLocale.language.languageCode?.identifier ?? "en"
        let regionCode = systemLocale.region?.identifier
        
        if let region = regionCode {
            let fullIdentifier = "\(languageCode)-\(region)"
            if let language = AppLanguage(rawValue: fullIdentifier) {
                return language
            }
        }
        
        if languageCode == "zh" {
            if systemIdentifier.contains("Hans") || systemIdentifier.contains("CN") || systemIdentifier.contains("SG") {
                return .chineseSimplified
            } else {
                return .chineseTraditional
            }
        }
        
        if languageCode == "fr" {
            if regionCode == "CA" {
                return .frenchCanada
            }
            return .french
        }
        
        if languageCode == "pt" {
            if regionCode == "BR" {
                return .portugueseBrazil
            } else if regionCode == "PT" {
                return .portuguesePortugal
            }
        }
        
        if languageCode == "es" {
            if regionCode == "MX" {
                return .spanishMexico
            }
            return .spanish
        }
        
        if let language = AppLanguage(rawValue: languageCode) {
            return language
        }
        
        return .english
    }
}

