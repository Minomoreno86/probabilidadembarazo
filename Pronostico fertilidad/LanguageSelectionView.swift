//
//  LanguageSelectionView.swift
//  Pronostico fertilidad
//
//  View for selecting the application language
//

import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.themeColors) var colors
    
    var body: some View {
        NavigationView {
            ZStack {
                colors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Language list
                    languageList
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        #if os(iOS)
        .navigationBarHidden(true)
        #endif
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Text(localizationManager.getLocalizedString("Idioma / Language"))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Placeholder to keep title centered
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.clear)
            }
            
            Text(localizationManager.getLocalizedString("Selecciona tu idioma preferido / Select your preferred language"))
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Language List
    private var languageList: some View {
        VStack(spacing: 16) {
            ForEach(LocalizationManager.Language.allCases, id: \.self) { language in
                LanguageOptionRow(
                    language: language,
                    isSelected: localizationManager.currentLanguage == language,
                    action: {
                        localizationManager.setLanguage(language)
                        dismiss()
                    }
                )
            }
        }
    }
}

// MARK: - Language Option Row
struct LanguageOptionRow: View {
    let language: LocalizationManager.Language
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(language.flag)
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(language.displayName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(language == .spanish ? "Español" : "English")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
struct LanguageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSelectionView()
            .environmentObject(LocalizationManager.shared)
    }
}
