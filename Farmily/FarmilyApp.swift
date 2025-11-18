import SwiftUI
import CoreData

@main
struct FarmilyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var languageManager = LanguageManager()
    @State private var refreshID = UUID()
    
    init() {
        let savedLanguage = StorageService.shared.getLanguage()
        if let language = AppLanguage(rawValue: savedLanguage) {
            UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        } else {
            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if appViewModel.showFarmScreen, let link = appViewModel.farmLink {
                    FarmScreen(linkString: link)
                        .onAppear {
                            setAllOrientations()
                        }
                } else if appViewModel.showLanguageSelection {
                    LanguageSelectionView(
                        languageManager: languageManager,
                        appViewModel: appViewModel
                    )
                } else {
                    MainTabView(viewContext: persistenceController.container.viewContext)
                        .preferredColorScheme(themeManager.currentTheme.colorScheme)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environment(\.locale, Locale(identifier: languageManager.currentLanguage.rawValue))
                        .environmentObject(themeManager)
                        .environmentObject(languageManager)
                        .id(refreshID)
                        .onAppear {
                            setPortraitOrientation()
                        }
                        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
                            refreshID = UUID()
                        }
                }
            }
            .onChange(of: appViewModel.showFarmScreen) { showFarmScreen in
                if !showFarmScreen {
                    setPortraitOrientation()
                }
            }
        }
    }
    
    private func setPortraitOrientation() {
        AppDelegate.setOrientation(.portrait)
    }
    
    private func setAllOrientations() {
        AppDelegate.setOrientation(.all)
    }
}
