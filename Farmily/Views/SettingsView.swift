import SwiftUI

struct SettingsView: View {
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var languageManager: LanguageManager
    @State private var showThemePicker = false
    @State private var showLanguagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("settings_theme")) {
                    Button(action: {
                        showThemePicker = true
                    }) {
                        HStack {
                            Text("settings_theme")
                            Spacer()
                            Text(themeManager.currentTheme.localizationKey.localized)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("settings_language")) {
                    Button(action: {
                        showLanguagePicker = true
                    }) {
                        HStack {
                            Text("settings_language")
                            Spacer()
                            Text(languageManager.currentLanguage.nativeName)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("settings_title")
            .sheet(isPresented: $showThemePicker) {
                ThemePickerView(themeManager: themeManager, languageManager: languageManager, isPresented: $showThemePicker)
            }
            .sheet(isPresented: $showLanguagePicker) {
                LanguagePickerView(languageManager: languageManager, isPresented: $showLanguagePicker)
            }
        }
        .id(languageManager.currentLanguage.rawValue)
        .onAppear {
            AppDelegate.setOrientation(.portrait)
        }
    }
}

struct ThemePickerView: View {
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var languageManager: LanguageManager
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(AppTheme.allCases, id: \.self) { theme in
                    Button(action: {
                        themeManager.setTheme(theme)
                        isPresented = false
                    }) {
                        HStack {
                            Text(theme.localizationKey.localized)
                            Spacer()
                            if themeManager.currentTheme == theme {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
            }
            .navigationTitle("settings_theme")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("common_cancel") {
                        isPresented = false
                    }
                }
            }
        }
        .id(languageManager.currentLanguage.rawValue)
        .onAppear {
            AppDelegate.setOrientation(.portrait)
        }
    }
}

struct LanguagePickerView: View {
    @ObservedObject var languageManager: LanguageManager
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(AppLanguage.allCases, id: \.self) { language in
                    Button(action: {
                        languageManager.setLanguage(language)
                        isPresented = false
                    }) {
                        HStack {
                            Text(language.nativeName)
                            Spacer()
                            if languageManager.currentLanguage == language {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
            }
            .navigationTitle("settings_language")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("common_cancel") {
                        isPresented = false
                    }
                }
            }
        }
        .onAppear {
            AppDelegate.setOrientation(.portrait)
        }
    }
}

#Preview {
    SettingsView(
        themeManager: ThemeManager(),
        languageManager: LanguageManager()
    )
}

