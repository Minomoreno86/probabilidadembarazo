//
//  LocalizationManager.swift
//  Pronostico fertilidad
//
//  Localization manager to handle language changes
//

import Foundation
import SwiftUI

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: Language = .spanish
    
    enum Language: String, CaseIterable {
        case spanish = "es"
        case english = "en"
        
        var displayName: String {
            switch self {
            case .spanish:
                return "Español"
            case .english:
                return "English"
            }
        }
        
        var flag: String {
            switch self {
            case .spanish:
                return "🇪🇸"
            case .english:
                return "🇺🇸"
            }
        }
    }
    
    private init() {
        loadSavedLanguage()
    }
    
    func setLanguage(_ language: Language) {
        currentLanguage = language
        UserDefaults.standard.set(language.rawValue, forKey: "AppLanguage")
        
        // Change system language
        if let languageCode = Bundle.main.preferredLocalizations.first,
           languageCode != language.rawValue {
            // Force language change
            UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }
    
    private func loadSavedLanguage() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "AppLanguage"),
           let language = Language(rawValue: savedLanguage) {
            currentLanguage = language
        } else {
            // Use system language by default
            let systemLanguage = Locale.current.languageCode ?? "es"
            currentLanguage = Language(rawValue: systemLanguage) ?? .spanish
        }
    }
    
    func getLocalizedString(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    func getLocalizedString(_ key: String, with arguments: CVarArg...) -> String {
        return String(format: getLocalizedString(key), arguments: arguments)
    }
}

// MARK: - Environment Key for LocalizationManager
struct LocalizationManagerKey: EnvironmentKey {
    static let defaultValue = LocalizationManager.shared
}

extension EnvironmentValues {
    var localizationManager: LocalizationManager {
        get { self[LocalizationManagerKey.self] }
        set { self[LocalizationManagerKey.self] = newValue }
    }
}

// MARK: - View Extension to facilitate usage
extension View {
    func localizedText(_ key: String) -> some View {
        let localizedString = LocalizationManager.shared.getLocalizedString(key)
        return Text(localizedString)
    }
    
    func localizedText(_ key: String, with arguments: CVarArg...) -> some View {
        let localizedString = LocalizationManager.shared.getLocalizedString(key, with: arguments)
        return Text(localizedString)
    }
}
