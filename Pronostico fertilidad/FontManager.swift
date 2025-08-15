import SwiftUI

// MARK: - 🎨 Sistema de Tipografía Personalizada
struct FontManager {
    
    // MARK: - Tamaños de Fuente
    struct Size {
        static let small: CGFloat = 12
        static let regular: CGFloat = 16
        static let medium: CGFloat = 18
        static let large: CGFloat = 20
        static let title: CGFloat = 24
        static let headline: CGFloat = 28
        static let display: CGFloat = 32
    }
    
    // MARK: - Estilos de Texto Médico (usando fuentes del sistema)
    struct MedicalText {
        // Texto principal para resultados médicos
        static let body = Font.system(size: Size.regular)
        static let bodyBold = Font.system(size: Size.regular, weight: .bold)
        
        // Títulos de secciones médicas
        static let title = Font.system(size: Size.title, weight: .bold)
        static let headline = Font.system(size: Size.headline, weight: .bold)
        
        // Datos numéricos y resultados
        static let data = Font.system(size: Size.medium)
        static let dataLarge = Font.system(size: Size.large)
        
        // Texto informativo y explicaciones
        static let info = Font.system(size: Size.regular)
        static let infoSmall = Font.system(size: Size.small)
    }
    
    // MARK: - Estilos de Interfaz
    struct UI {
        // Botones y elementos interactivos
        static let button = Font.system(size: Size.medium, weight: .bold)
        static let buttonSmall = Font.system(size: Size.regular, weight: .bold)
        
        // Navegación y títulos de pantalla
        static let navigation = Font.system(size: Size.large, weight: .bold)
        
        // Campos de entrada
        static let input = Font.system(size: Size.regular)
        static let inputLabel = Font.system(size: Size.small, weight: .bold)
    }
    
    // MARK: - Estilos Específicos para Fertilidad
    struct Fertility {
        // Resultados de pronóstico
        static let prognosis = Font.system(size: Size.large, weight: .bold)
        static let prognosisValue = Font.system(size: Size.display)
        
        // Datos de perfil
        static let profileTitle = Font.system(size: Size.title, weight: .bold)
        static let profileData = Font.system(size: Size.medium)
        
        // Alertas y advertencias médicas
        static let alert = Font.system(size: Size.medium, weight: .bold)
        static let alertInfo = Font.system(size: Size.regular)
    }
}

// MARK: - Extensiones para SwiftUI
extension Font {
    // Acceso directo a fuentes médicas
    static let medicalBody = FontManager.MedicalText.body
    static let medicalTitle = FontManager.MedicalText.title
    static let medicalData = FontManager.MedicalText.data
    static let medicalInfo = FontManager.MedicalText.info
    
    // Acceso directo a fuentes de UI
    static let uiButton = FontManager.UI.button
    static let uiNavigation = FontManager.UI.navigation
    static let uiInput = FontManager.UI.input
    
    // Acceso directo a fuentes de fertilidad
    static let fertilityPrognosis = FontManager.Fertility.prognosis
    static let fertilityProfile = FontManager.Fertility.profileTitle
    static let fertilityAlert = FontManager.Fertility.alert
}

// MARK: - 🎨 Gestor de Fuentes del Usuario
class UserFontManager: ObservableObject {
    @Published var selectedFontFamily: FontFamily = .system
    
    enum FontFamily: String, CaseIterable {
        case system = "Sistema"
        case systemRounded = "SistemaRounded"
        case systemSerif = "SistemaSerif"
        case systemMono = "SistemaMono"
        
        var displayName: String {
            switch self {
            case .system: return "SF Pro (Sistema)"
            case .systemRounded: return "SF Pro Rounded"
            case .systemSerif: return "SF Pro Serif"
            case .systemMono: return "SF Mono"
            }
        }
        
        var fontName: String {
            switch self {
            case .system: return "SF Pro"
            case .systemRounded: return "SF Pro Rounded"
            case .systemSerif: return "SF Pro Serif"
            case .systemMono: return "SF Mono"
            }
        }
        
        var boldFontName: String {
            switch self {
            case .system: return "SF Pro"
            case .systemRounded: return "SF Pro Rounded"
            case .systemSerif: return "SF Pro Serif"
            case .systemMono: return "SF Mono"
            }
        }
        
        var previewText: String {
            switch self {
            case .system: return "Fuente nativa del sistema iOS"
            case .systemRounded: return "Versión redondeada y amigable"
            case .systemSerif: return "Serif elegante para lectura"
            case .systemMono: return "Monospace para datos y código"
            }
        }
    }
    
    init() {
        // Cargar la fuente guardada del usuario
        if let savedFont = UserDefaults.standard.string(forKey: "selectedFontFamily"),
           let fontFamily = FontFamily(rawValue: savedFont) {
            selectedFontFamily = fontFamily
        }
    }
    
    func setFontFamily(_ fontFamily: FontFamily) {
        selectedFontFamily = fontFamily
        UserDefaults.standard.set(fontFamily.rawValue, forKey: "selectedFontFamily")
    }
    
    // MARK: - Métodos para obtener fuentes personalizadas
    func customFont(size: CGFloat) -> Font {
        switch selectedFontFamily {
        case .system:
            return .system(size: size)
        case .systemRounded:
            return .system(size: size, design: .rounded)
        case .systemSerif:
            return .system(size: size, design: .serif)
        case .systemMono:
            return .system(size: size, design: .monospaced)
        }
    }
    
    func customBoldFont(size: CGFloat) -> Font {
        switch selectedFontFamily {
        case .system:
            return .system(size: size, weight: .bold)
        case .systemRounded:
            return .system(size: size, weight: .bold, design: .rounded)
        case .systemSerif:
            return .system(size: size, weight: .bold, design: .serif)
        case .systemMono:
            return .system(size: size, weight: .bold, design: .monospaced)
        }
    }
    
    // MARK: - Fuentes predefinidas con la selección del usuario
    var body: Font { customFont(size: 16) }
    var title: Font { customBoldFont(size: 24) }
    var headline: Font { customBoldFont(size: 28) }
    var data: Font { customFont(size: 18) }
    var info: Font { customFont(size: 16) }
    var button: Font { customBoldFont(size: 18) }
    var navigation: Font { customBoldFont(size: 20) }
}
