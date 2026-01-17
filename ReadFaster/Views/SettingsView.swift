import SwiftUI

/// Settings screen with language selection
struct SettingsView: View {
    @StateObject private var languageManager = LanguageManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showRestartAlert = false
    
    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Theme.textSecondary)
                            .frame(width: 40, height: 40)
                            .background(Theme.surface)
                            .clipShape(Circle())
                    }
                    
                    Text(NSLocalizedString("settings.title", comment: ""))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, Theme.paddingMedium)
                .padding(.top, Theme.paddingSmall)
                .padding(.bottom, Theme.paddingLarge)
                
                // Settings List
                VStack(spacing: 12) {
                    // Language Setting
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("settings.language", comment: ""))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Theme.textSecondary)
                            .padding(.horizontal, 16)
                        
                        VStack(spacing: 0) {
                            LanguageRow(
                                title: "English",
                                isSelected: languageManager.currentLanguage == "en",
                                action: { selectLanguage("en") }
                            )
                            
                            Divider()
                                .background(Theme.textSecondary.opacity(0.2))
                            
                            LanguageRow(
                                title: "Deutsch",
                                isSelected: languageManager.currentLanguage == "de",
                                action: { selectLanguage("de") }
                            )
                        }
                        .background(Theme.surface)
                        .cornerRadius(Theme.cornerRadiusMedium)
                    }
                }
                .padding(.horizontal, Theme.paddingMedium)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .alert("Restart Required", isPresented: $showRestartAlert) {
            Button("OK") { }
        } message: {
            Text("Please restart the app for the language change to take full effect.")
        }
    }
    
    private func selectLanguage(_ language: String) {
        if languageManager.currentLanguage != language {
            languageManager.currentLanguage = language
            showRestartAlert = true
        }
    }
}

struct LanguageRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.accent)
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    SettingsView()
}
