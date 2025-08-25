//
//  LocalizationManager.swift
//  Pronostico fertilidad
//
//  Localization manager to handle language changes
//

import Foundation
import SwiftUI
import Combine

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: Language = .spanish
    private var cancellables = Set<AnyCancellable>()
    
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
        setupLocaleManagerObserver()
    }
    
    private func setupLocaleManagerObserver() {
        // Observar cambios del LocaleManager
        NotificationCenter.default.publisher(for: NSNotification.Name("forceViewRefresh"))
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
    }
    
    // Este método ya no se usa - el LocaleManager maneja el cambio de idioma
    // func setLanguage(_ language: Language) { ... }
    
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
        // Cargar manualmente el string del idioma actual
        let currentLang = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "es"
        
        // Cargar el bundle del idioma seleccionado
        guard let languagePath = Bundle.main.path(forResource: currentLang, ofType: "lproj"),
              let bundle = Bundle(path: languagePath) else {
            // Fallback a NSLocalizedString
            return NSLocalizedString(key, comment: "")
        }
        
        // Retornar el string localizado del bundle correcto
        return bundle.localizedString(forKey: key, value: key, table: "Localizable")
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
    
    /// Modifier para hacer que una vista se refresque automáticamente cuando cambie el idioma
    func autoRefreshOnLanguageChange() -> some View {
        self.id(LocalizationManager.shared.currentLanguage.rawValue)
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("forceViewRefresh"))) { _ in
                // Forzar refresh inmediato de la vista
                DispatchQueue.main.async {
                    // Esto fuerza un re-render completo
                    NotificationCenter.default.post(name: NSNotification.Name("ForceViewRefresh"), object: nil)
                }
            }
    }
}
