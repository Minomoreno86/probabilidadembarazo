import SwiftUI
import Combine

enum AppLanguage: String, CaseIterable, Identifiable {
    case es = "es"
    case en = "en"
    var id: String { rawValue }
    var displayName: String { self == .es ? "Español" : "English" }
    var flag: String { self == .es ? "🇪🇸" : "🇺🇸" }
}

@MainActor
final class LocaleManager: ObservableObject {
    @AppStorage("selectedLanguage") private var storedLanguage: String = "es"
    @Published private(set) var language: AppLanguage
    @Published private(set) var locale: Locale

    init() {
        let stored = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "es"
        let initial = AppLanguage(rawValue: stored) ?? .es
        self.language = initial
        self.locale = Locale(identifier: initial.rawValue)
    }

    func setLanguage(_ newLang: AppLanguage) {
        guard newLang != language else { return }
        
        // PRIMERO: Cambiar el idioma en UserDefaults
        UserDefaults.standard.set([newLang.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // SEGUNDO: Actualizar las propiedades
        storedLanguage = newLang.rawValue
        language = newLang
        locale = Locale(identifier: newLang.rawValue)
        
        // TERCERO: Notificar cambios y forzar refresh
        objectWillChange.send()
        NotificationCenter.default.post(name: .forceViewRefresh, object: nil)
        
        // CUARTO: Refresh adicional después de un delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            NotificationCenter.default.post(name: .forceViewRefresh, object: nil)
        }
    }
}

extension Notification.Name { static let forceViewRefresh = Notification.Name("forceViewRefresh") }
