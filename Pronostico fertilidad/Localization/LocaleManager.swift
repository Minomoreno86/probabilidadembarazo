import SwiftUI
import Combine

enum AppLanguage: String, CaseIterable {
    case es = "es"
    case en = "en"

    var displayName: String {
        switch self {
        case .es: return "Español"
        case .en: return "English"
        }
    }
}

final class LocaleManager: ObservableObject {
    @AppStorage("selectedLanguage") private var storedLanguage: String = "es"
    @Published var language: AppLanguage
    
    var locale: Locale { Locale(identifier: language.rawValue) }

    init() {
        let stored = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "es"
        let initial = AppLanguage(rawValue: stored) ?? .es
        self.language = initial
    }
    
    private func updateStoredLanguage() {
        UserDefaults.standard.set(language.rawValue, forKey: "selectedLanguage")
    }

    func setLanguage(_ lang: AppLanguage) {
        guard language != lang else { return }
        language = lang
        updateStoredLanguage()
        
        // Notifica actualización de localización en toda la app
        objectWillChange.send()
        
        // Post notification para refrescar UI
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}

// MARK: - View Extension para Auto-refresh
// Nota: La función autoRefreshOnLanguageChange ya existe en LocalizationManager.swift
