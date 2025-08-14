//
//  ThemeManager.swift
//  Pronostico fertilidad
//
//  Sistema de temas con Dark Mode espectacular usando SuperDesign
//

import SwiftUI

// MARK: - 🎨 THEME MANAGER
class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme = .light
    @AppStorage("selectedTheme") private var selectedThemeString: String = AppTheme.light.rawValue
    
    init() {
        // Cargar el tema guardado o usar light por defecto
        if let savedTheme = AppTheme(rawValue: selectedThemeString) {
            currentTheme = savedTheme
        } else {
            currentTheme = .light
            selectedThemeString = AppTheme.light.rawValue
        }
    }
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
        selectedThemeString = theme.rawValue
    }
    
    // Función de compatibilidad para el toggle tradicional
    func toggleTheme() {
        switch currentTheme {
        case .light:
            setTheme(.dark)
        case .dark:
            setTheme(.pink)
        case .pink:
            setTheme(.light)
        }
    }
}

// MARK: - 🌈 APP THEME
enum AppTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case pink = "Pink"
    
    var displayName: String {
        switch self {
        case .light:
            return "Modo Claro"
        case .dark:
            return "Modo Oscuro"
        case .pink:
            return "Modo Rosado"
        }
    }
    
    var icon: String {
        switch self {
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.stars.fill"
        case .pink:
            return "heart.fill"
        }
    }
}

// MARK: - 🎨 THEME COLORS
struct ThemeColors {
    let primary: Color
    let secondary: Color
    let accent: Color
    let background: Color
    let surface: Color
    let surfaceSecondary: Color
    let text: Color
    let textSecondary: Color
    let border: Color
    let success: Color
    let warning: Color
    let error: Color
    let medical: Color
    
    // Gradientes médicos
    let medicalGradient: LinearGradient
    let backgroundGradient: LinearGradient
    let cardGradient: LinearGradient
    let accentGradient: LinearGradient
}

// MARK: - 🌞 LIGHT THEME COLORS
extension ThemeColors {
    static let light = ThemeColors(
        primary: Color(red: 0.1, green: 0.2, blue: 0.4),
        secondary: Color(red: 0.2, green: 0.3, blue: 0.5),
        accent: Color.cyan,
        background: Color(red: 0.98, green: 0.99, blue: 1.0),
        surface: Color.white,
        surfaceSecondary: Color(red: 0.95, green: 0.97, blue: 1.0),
        text: Color(red: 0.1, green: 0.1, blue: 0.2),
        textSecondary: Color(red: 0.4, green: 0.4, blue: 0.6),
        border: Color(red: 0.9, green: 0.9, blue: 0.95),
        success: Color.green,
        warning: Color.orange,
        error: Color.red,
        medical: Color(red: 0.2, green: 0.4, blue: 0.8),
        
        medicalGradient: LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.2, blue: 0.4),
                Color(red: 0.2, green: 0.3, blue: 0.5),
                Color(red: 0.1, green: 0.25, blue: 0.45)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        
        backgroundGradient: LinearGradient(
            colors: [
                Color(red: 0.98, green: 0.99, blue: 1.0),  // Azul muy claro
                Color(red: 0.95, green: 0.97, blue: 1.0),  // Azul claro
                Color(red: 0.92, green: 0.95, blue: 1.0)   // Azul suave
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        
        cardGradient: LinearGradient(
            colors: [
                Color.white,
                Color(red: 0.98, green: 0.99, blue: 1.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        
        accentGradient: LinearGradient(
            colors: [
                Color.cyan.opacity(0.8),
                Color.blue.opacity(0.6)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}

// MARK: - 🌙 DARK THEME COLORS (SUPERDESIGN)
extension ThemeColors {
    static let dark = ThemeColors(
        primary: Color(red: 0.05, green: 0.05, blue: 0.1),
        secondary: Color(red: 0.1, green: 0.1, blue: 0.15),
        accent: Color(red: 0.3, green: 0.8, blue: 1.0), // Cyan brillante
        background: Color(red: 0.02, green: 0.02, blue: 0.05),
        surface: Color(red: 0.08, green: 0.08, blue: 0.12),
        surfaceSecondary: Color(red: 0.12, green: 0.12, blue: 0.18),
        text: Color(red: 0.95, green: 0.95, blue: 1.0),
        textSecondary: Color(red: 0.7, green: 0.7, blue: 0.8),
        border: Color(red: 0.2, green: 0.2, blue: 0.3),
        success: Color(red: 0.2, green: 0.8, blue: 0.4),
        warning: Color(red: 1.0, green: 0.6, blue: 0.2),
        error: Color(red: 1.0, green: 0.3, blue: 0.3),
        medical: Color(red: 0.4, green: 0.7, blue: 1.0),
        
        // SUPERDESIGN: Gradientes espectaculares para Dark Mode
        medicalGradient: LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.1, blue: 0.2),   // Azul oscuro profundo
                Color(red: 0.1, green: 0.15, blue: 0.25),  // Azul mediano
                Color(red: 0.15, green: 0.2, blue: 0.3),   // Azul grisáceo
                Color(red: 0.08, green: 0.12, blue: 0.22)  // Azul oscuro con toque púrpura
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        
        backgroundGradient: LinearGradient(
            colors: [
                Color(red: 0.02, green: 0.02, blue: 0.08),  // Casi negro con toque azul
                Color(red: 0.05, green: 0.05, blue: 0.12),  // Gris muy oscuro
                Color(red: 0.03, green: 0.03, blue: 0.1)    // Negro azulado
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        
        cardGradient: LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.1, blue: 0.15),    // Base de carta
                Color(red: 0.08, green: 0.08, blue: 0.13),  // Sombra sutil
                Color(red: 0.12, green: 0.12, blue: 0.18)   // Highlight sutil
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        
        accentGradient: LinearGradient(
            colors: [
                Color(red: 0.2, green: 0.6, blue: 1.0),     // Azul eléctrico
                Color(red: 0.4, green: 0.8, blue: 1.0),     // Cyan brillante
                Color(red: 0.3, green: 0.7, blue: 0.9)      // Azul cielo
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}

// MARK: - 🌸 PINK THEME COLORS (SUPERDESIGN)
extension ThemeColors {
    static let pink = ThemeColors(
        primary: Color(red: 0.8, green: 0.2, blue: 0.4),
        secondary: Color(red: 0.9, green: 0.3, blue: 0.5),
        accent: Color(red: 1.0, green: 0.4, blue: 0.7), // Rosa brillante
        background: Color(red: 0.98, green: 0.94, blue: 0.96),
        surface: Color(red: 1.0, green: 0.97, blue: 0.99),
        surfaceSecondary: Color(red: 0.96, green: 0.91, blue: 0.94),
        text: Color(red: 0.3, green: 0.1, blue: 0.2),
        textSecondary: Color(red: 0.6, green: 0.4, blue: 0.5),
        border: Color(red: 0.9, green: 0.8, blue: 0.85),
        success: Color(red: 0.2, green: 0.8, blue: 0.4),
        warning: Color(red: 1.0, green: 0.6, blue: 0.2),
        error: Color(red: 1.0, green: 0.3, blue: 0.3),
        medical: Color(red: 0.8, green: 0.3, blue: 0.6),
        
        // SUPERDESIGN: Gradientes espectaculares para Pink Mode
        medicalGradient: LinearGradient(
            colors: [
                Color(red: 0.9, green: 0.3, blue: 0.5),   // Rosa intenso
                Color(red: 0.8, green: 0.4, blue: 0.6),   // Rosa medio
                Color(red: 0.7, green: 0.2, blue: 0.4),   // Rosa profundo
                Color(red: 0.85, green: 0.35, blue: 0.55) // Rosa vibrante
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        
        backgroundGradient: LinearGradient(
            colors: [
                Color(red: 0.99, green: 0.95, blue: 0.97),  // Rosa muy claro
                Color(red: 0.96, green: 0.92, blue: 0.95),  // Rosa pastel
                Color(red: 0.98, green: 0.94, blue: 0.96)   // Rosa suave
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        
        cardGradient: LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.98, blue: 0.99),   // Blanco rosado
                Color(red: 0.98, green: 0.95, blue: 0.97),  // Rosa muy claro
                Color(red: 1.0, green: 0.97, blue: 0.98)    // Blanco perlado
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        
        accentGradient: LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.5, blue: 0.8),     // Rosa brillante
                Color(red: 0.9, green: 0.4, blue: 0.7),     // Rosa vibrante
                Color(red: 1.0, green: 0.6, blue: 0.8)      // Rosa luminoso
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}

// MARK: - 🎨 THEME EXTENSION
extension ThemeColors {
    static func current(_ theme: AppTheme) -> ThemeColors {
        switch theme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .pink:
            return .pink
        }
    }
}

// MARK: - 🌟 SUPERDESIGN EFFECTS
struct SuperDesignEffects {
    // Glassmorphism para todos los temas
    static func glassmorphism(for theme: AppTheme) -> some View {
        let colors = ThemeColors.current(theme)
        
        let fillColor: Color
        let strokeColors: [Color]
        let blurRadius: CGFloat
        let strokeWidth: CGFloat
        
        switch theme {
        case .dark:
            fillColor = Color(red: 0.1, green: 0.1, blue: 0.15).opacity(0.7)
            strokeColors = [Color.cyan.opacity(0.3), Color.blue.opacity(0.1)]
            blurRadius = 20
            strokeWidth = 1.5
        case .pink:
            fillColor = Color(red: 1.0, green: 0.95, blue: 0.98).opacity(0.8)
            strokeColors = [Color.pink.opacity(0.4), Color(red: 1.0, green: 0.7, blue: 0.8).opacity(0.2)]
            blurRadius = 15
            strokeWidth = 1.2
        case .light:
            fillColor = Color.white.opacity(0.8)
            strokeColors = [Color.white.opacity(0.8), Color.gray.opacity(0.2)]
            blurRadius = 10
            strokeWidth = 1
        }
        
        return RoundedRectangle(cornerRadius: 16)
            .fill(fillColor)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colors.cardGradient)
                    .blur(radius: blurRadius)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: strokeColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: strokeWidth
                    )
            )
    }
    
    // Neon glow para elementos importantes en Dark Mode
    static func neonGlow(color: Color, intensity: Double = 1.0) -> some View {
        Circle()
            .fill(color.opacity(0.3))
            .blur(radius: 10 * intensity)
            .overlay(
                Circle()
                    .fill(color.opacity(0.6))
                    .blur(radius: 5 * intensity)
            )
            .overlay(
                Circle()
                    .fill(color)
            )
    }
    
    // Pink glow especial para el tema rosado
    static func pinkGlow(intensity: Double = 1.0) -> some View {
        Circle()
            .fill(Color.pink.opacity(0.2))
            .blur(radius: 15 * intensity)
            .overlay(
                Circle()
                    .fill(Color(red: 1.0, green: 0.5, blue: 0.8).opacity(0.4))
                    .blur(radius: 8 * intensity)
            )
            .overlay(
                Circle()
                    .fill(Color(red: 1.0, green: 0.6, blue: 0.8).opacity(0.6))
                    .blur(radius: 3 * intensity)
            )
            .overlay(
                Circle()
                    .fill(LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.5, blue: 0.8),
                            Color(red: 0.9, green: 0.4, blue: 0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
            )
    }
}

// MARK: - 📱 ENVIRONMENT KEY
struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue = ThemeColors.light
}

extension EnvironmentValues {
    var themeColors: ThemeColors {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Light Theme")
            .padding()
            .background(ThemeColors.light.cardGradient)
            .cornerRadius(12)
        
        Text("Dark Theme")
            .padding()
            .background(ThemeColors.dark.cardGradient)
            .cornerRadius(12)
    }
    .padding()
    .background(ThemeColors.dark.backgroundGradient)
}
