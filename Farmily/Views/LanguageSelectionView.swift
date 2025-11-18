import SwiftUI

struct LanguageSelectionView: View {
    @ObservedObject var languageManager: LanguageManager
    @ObservedObject var appViewModel: AppViewModel
    @State private var selectedLanguage: AppLanguage
    
    init(languageManager: LanguageManager, appViewModel: AppViewModel) {
        self.languageManager = languageManager
        self.appViewModel = appViewModel
        
        let systemLang = LanguageManager.getSystemLanguage()
        _selectedLanguage = State(initialValue: systemLang)
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("language_selection_title")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("language_selection_subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 20) {
                LanguageButton(
                    language: selectedLanguage,
                    isSelected: true,
                    isRecommended: true
                ) {
                    selectedLanguage = selectedLanguage
                }
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(AppLanguage.allCases, id: \.self) { language in
                            if language != selectedLanguage {
                                LanguageButton(
                                    language: language,
                                    isSelected: false,
                                    isRecommended: false
                                ) {
                                    selectedLanguage = language
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 300)
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            Button(action: {
                languageManager.setLanguage(selectedLanguage)
                appViewModel.languageSelected()
            }) {
                Text("language_selection_continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
        .padding()
        .onAppear {
            AppDelegate.setOrientation(.portrait)
        }
    }
}

struct LanguageButton: View {
    let language: AppLanguage
    let isSelected: Bool
    let isRecommended: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(language.nativeName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isRecommended {
                    Text("(Recommended)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                }
            }
            .padding()
            .background(isSelected ? Color.accentColor.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    LanguageSelectionView(
        languageManager: LanguageManager(),
        appViewModel: AppViewModel()
    )
}

