//
//  SettingsDetailViews.swift
//  Pronostico fertilidad
//
//  Vistas detalladas para cada sección de configuración
//

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - 👤 VISTA DE PERFIL
struct ProfileSettingsView: View {
    @Binding var userFullName: String
    @Binding var userEmail: String
    @Binding var userSpecialty: String
    @Binding var userInstitution: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Avatar del usuario
                VStack(spacing: 16) {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                        )
                    
                    Text("Perfil Profesional")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    SettingsTextField(
                        title: "Nombre Completo",
                        subtitle: "Aparecerá en los reportes",
                        icon: "person.fill",
                        text: $userFullName,
                        placeholder: "Dr. Juan Pérez"
                    )
                    
                    SettingsTextField(
                        title: "Email",
                        subtitle: "Correo electrónico profesional",
                        icon: "envelope.fill",
                        text: $userEmail,
                        placeholder: "doctor@ejemplo.com"
                    )
                    
                    SettingsTextField(
                        title: "Especialidad",
                        subtitle: "Área médica de especialización",
                        icon: "stethoscope",
                        text: $userSpecialty,
                        placeholder: "Medicina Reproductiva"
                    )
                    
                    SettingsTextField(
                        title: "Institución",
                        subtitle: "Hospital o clínica",
                        icon: "building.2.fill",
                        text: $userInstitution,
                        placeholder: "Centro de Fertilidad ABC"
                    )
                }
                .padding(.horizontal, 20)
                
                // Disclaimer médico
                MedicalDisclaimerView(style: .footer, isCompact: true)
                
                Spacer(minLength: 20)
            }
        }
        .background(medicalGradient)
        .navigationTitle("Perfil")
    }
    
    private var medicalGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.2, blue: 0.4),
                Color(red: 0.2, green: 0.3, blue: 0.5),
                Color(red: 0.1, green: 0.25, blue: 0.45)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

// MARK: - 🎨 VISTA DE APARIENCIA
struct AppearanceSettingsView: View {
    @Binding var isDarkMode: Bool
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.themeColors) var colors
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header espectacular
                headerSection
                
                // Selector de tema principal
                themeSelector
                
                // Preview del tema actual
                themePreview
                
                // Información y beneficios
                themeBenefits
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
        }
        .background(colors.backgroundGradient)
        .navigationTitle("Apariencia")
        .onChange(of: themeManager.currentTheme) { _, newTheme in
            isDarkMode = newTheme == .dark
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Icono animado con efectos especiales
            ZStack {
                switch themeManager.currentTheme {
                case .dark:
                    SuperDesignEffects.neonGlow(color: .cyan, intensity: 1.5)
                        .frame(width: 80, height: 80)
                case .pink:
                    SuperDesignEffects.pinkGlow(intensity: 1.2)
                        .frame(width: 80, height: 80)
                case .light:
                    Circle()
                        .fill(colors.accentGradient)
                        .frame(width: 80, height: 80)
                }
                
                Image(systemName: themeManager.currentTheme.icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(
                        themeManager.currentTheme == .dark ? .black : 
                        themeManager.currentTheme == .pink ? .white : .white
                    )
            }
            .padding(.top, 20)
            
            VStack(spacing: 8) {
                Text("Personaliza tu Experiencia")
                    .font(.title2.bold())
                    .foregroundColor(colors.text)
                
                Text("Elige el tema que mejor se adapte a tu trabajo")
                    .font(.subheadline)
                    .foregroundColor(colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // MARK: - Theme Selector
    private var themeSelector: some View {
        VStack(spacing: 20) {
            Text("Selecciona tu Tema")
                .font(.headline)
                .foregroundColor(colors.text)
            
            HStack(spacing: 16) {
                ForEach(AppTheme.allCases, id: \.self) { theme in
                    themeOptionCard(for: theme)
                }
            }
        }
    }
    
    // MARK: - Theme Option Card
    private func themeOptionCard(for theme: AppTheme) -> some View {
        let isSelected = themeManager.currentTheme == theme
        let themeColors = ThemeColors.current(theme)
        
        return Button(action: {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                themeManager.setTheme(theme)
            }
        }) {
            VStack(spacing: 12) {
                // Icono del tema con efectos especiales
                ZStack {
                    if isSelected {
                        switch theme {
                        case .dark:
                            SuperDesignEffects.neonGlow(color: themeColors.accent, intensity: 0.8)
                                .frame(width: 50, height: 50)
                        case .pink:
                            SuperDesignEffects.pinkGlow(intensity: 0.8)
                                .frame(width: 50, height: 50)
                        case .light:
                            Circle()
                                .fill(themeColors.accentGradient)
                                .frame(width: 50, height: 50)
                        }
                    } else {
                        Circle()
                            .fill(themeColors.accentGradient)
                            .frame(width: 50, height: 50)
                    }
                    
                    Image(systemName: theme.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(
                            theme == .dark ? .black : 
                            theme == .pink ? .white : .white
                        )
                }
                
                Text(theme.displayName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(colors.text)
                
                // Mini preview
                RoundedRectangle(cornerRadius: 8)
                    .fill(themeColors.backgroundGradient)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(themeColors.cardGradient)
                            .frame(height: 20)
                            .padding(.horizontal, 8)
                    )
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .background(
                Group {
                    if theme == .dark {
                        SuperDesignEffects.glassmorphism(for: .dark)
                    } else {
                        SuperDesignEffects.glassmorphism(for: .light)
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? colors.accent : Color.clear,
                        lineWidth: isSelected ? 2 : 0
                    )
                    .animation(.easeInOut(duration: 0.3), value: isSelected)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Theme Preview
    private var themePreview: some View {
        VStack(spacing: 16) {
            Text("Vista Previa")
                .font(.headline)
                .foregroundColor(colors.text)
            
            VStack(spacing: 12) {
                // Preview card
                HStack {
                    Circle()
                        .fill(colors.accentGradient)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "stethoscope")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Análisis de Fertilidad")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(colors.text)
                        
                        Text("Herramienta de apoyo diagnóstico")
                            .font(.caption)
                            .foregroundColor(colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text("85%")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(colors.accent)
                }
                .padding()
                .background(
                    SuperDesignEffects.glassmorphism(for: themeManager.currentTheme)
                )
                
                // Preview buttons
                HStack(spacing: 12) {
                    Button("Calcular") {
                        // Preview only
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(colors.accentGradient)
                    .cornerRadius(20)
                    
                    Button("Configurar") {
                        // Preview only
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(colors.text)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(colors.surface)
                    .cornerRadius(20)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colors.surface.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(colors.border, lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Theme Benefits
    private var themeBenefits: some View {
        VStack(spacing: 16) {
            let benefits = getBenefitsForCurrentTheme()
            
            ForEach(benefits, id: \.title) { benefit in
                HStack(spacing: 12) {
                    Image(systemName: benefit.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(colors.accent)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(benefit.title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(colors.text)
                        
                        Text(benefit.description)
                            .font(.system(size: 12))
                            .foregroundColor(colors.textSecondary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colors.surface.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(colors.border, lineWidth: 0.5)
                        )
                )
            }
        }
    }
    
    // MARK: - Helper Functions
    private func getBenefitsForCurrentTheme() -> [(title: String, description: String, icon: String)] {
        switch themeManager.currentTheme {
        case .dark:
            return darkModeBenefits
        case .pink:
            return pinkModeBenefits
        case .light:
            return lightModeBenefits
        }
    }
    
    // MARK: - Benefits Data
    private var darkModeBenefits: [(title: String, description: String, icon: String)] {
        [
            ("Reduce Fatiga Visual", "Menos cansancio durante sesiones largas", "eye.fill"),
            ("Mejor Concentración", "Interfaz menos distractiva para trabajo médico", "brain.head.profile"),
            ("Ahorro de Batería", "Mayor duración en dispositivos móviles", "battery.100"),
            ("Profesional", "Apariencia elegante y moderna", "star.fill")
        ]
    }
    
    private var lightModeBenefits: [(title: String, description: String, icon: String)] {
        [
            ("Mayor Legibilidad", "Texto más claro en ambientes iluminados", "doc.text.fill"),
            ("Colores Precisos", "Mejor visualización de gráficos médicos", "chart.bar.fill"),
            ("Familiaridad", "Interfaz tradicional y conocida", "checkmark.circle.fill"),
            ("Versatilidad", "Ideal para presentaciones y reportes", "rectangle.on.rectangle")
        ]
    }
    
    private var pinkModeBenefits: [(title: String, description: String, icon: String)] {
        [
            ("Ambiente Cálido", "Colores suaves que transmiten calidez y confianza", "heart.fill"),
            ("Reduce Estrés", "Tonos rosados ayudan a relajar en consultas médicas", "leaf.fill"),
            ("Feminidad Médica", "Ideal para especialidades ginecológicas y reproductivas", "figure.dress.line.vertical.figure"),
            ("Único y Elegante", "Diseño distintivo que destaca profesionalismo", "sparkles")
        ]
    }
    
    private var medicalGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.2, blue: 0.4),
                Color(red: 0.2, green: 0.3, blue: 0.5),
                Color(red: 0.1, green: 0.25, blue: 0.45)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

// MARK: - 📱 VISTA DE COMPARTIR
struct ShareSettingsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 20) {
                    Image(systemName: "square.and.arrow.up.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                        .padding(.top, 20)
                    
                    Text("Compartir")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Text("Comparte la app con colegas médicos")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 16) {
                    SettingsActionRow(
                        title: "Compartir en WhatsApp",
                        subtitle: "Recomienda la app a colegas médicos",
                        icon: "message.fill",
                        action: { shareOnWhatsApp() }
                    )
                    
                    SettingsActionRow(
                        title: "Compartir en Instagram",
                        subtitle: "Publica en tu historia profesional",
                        icon: "camera.fill",
                        action: { shareOnInstagram() }
                    )
                    
                    SettingsActionRow(
                        title: "Compartir en TikTok",
                        subtitle: "Crea contenido educativo médico",
                        icon: "video.fill",
                        action: { shareOnTikTok() }
                    )
                    
                    SettingsActionRow(
                        title: "Compartir Enlace",
                        subtitle: "Copia enlace de descarga",
                        icon: "link",
                        action: { shareAppLink() }
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 20)
            }
        }
        .background(medicalGradient)
        .navigationTitle("Compartir")
    }
    
    private var medicalGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.2, blue: 0.4),
                Color(red: 0.2, green: 0.3, blue: 0.5),
                Color(red: 0.1, green: 0.25, blue: 0.45)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // MARK: Funciones de Compartir
    private func shareOnWhatsApp() {
        let message = "¡Descubre Pronóstico Fertilidad! 🩺 Una herramienta profesional del Dr. Jorge Vásquez para médicos especialistas en fertilidad. Cálculos precisos basados en evidencia médica.\n\n📱 App: https://apps.apple.com/app/pronostico-fertilidad\n📸 Instagram: https://linktr.ee/drjorgevazquez\n🎥 TikTok: https://www.tiktok.com/@fertilidadrjorgevasquez"
        
        #if os(iOS)
        if let url = URL(string: "whatsapp://send?text=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        #elseif os(macOS)
        if let url = URL(string: "https://web.whatsapp.com/") {
            NSWorkspace.shared.open(url)
        }
        #endif
    }
    
    private func shareOnInstagram() {
        #if os(iOS)
        if let url = URL(string: "instagram://app") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        #elseif os(macOS)
        if let url = URL(string: "https://linktr.ee/drjorgevazquez") {
            NSWorkspace.shared.open(url)
        }
        #endif
    }
    
    private func shareOnTikTok() {
        #if os(iOS)
        if let url = URL(string: "tiktok://app") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        #elseif os(macOS)
        if let url = URL(string: "https://www.tiktok.com/@fertilidadrjorgevasquez") {
            NSWorkspace.shared.open(url)
        }
        #endif
    }
    
    private func shareAppLink() {
        let message = "Pronóstico Fertilidad - Dr. Jorge Vásquez\n🩺 Herramienta médica profesional para especialistas en fertilidad\n\n📱 App: https://apps.apple.com/app/pronostico-fertilidad\n📸 Instagram: https://linktr.ee/drjorgevazquez\n🎥 TikTok: https://www.tiktok.com/@fertilidadrjorgevasquez"
        
        #if os(iOS)
        let activityController = UIActivityViewController(
            activityItems: [message],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityController, animated: true)
        }
        #elseif os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(message, forType: .string)
        #endif
    }
}

// MARK: - 📋 VISTA LEGAL
struct LegalSettingsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 20) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                        .padding(.top, 20)
                    
                    Text("Legal y Médico")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Text("Términos, políticas y avisos importantes")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 16) {
                    SettingsActionRow(
                        title: "Política de Privacidad",
                        subtitle: "Cómo protegemos tus datos médicos",
                        icon: "lock.doc.fill",
                        action: { showPrivacyPolicy() }
                    )
                    
                    SettingsActionRow(
                        title: "Términos de Servicio",
                        subtitle: "Condiciones de uso de la aplicación",
                        icon: "doc.plaintext.fill",
                        action: { showTermsOfService() }
                    )
                    
                    SettingsActionRow(
                        title: "Aviso Médico",
                        subtitle: "Disclaimer y limitaciones profesionales",
                        icon: "stethoscope",
                        action: { showMedicalDisclaimer() }
                    )
                    
                    // Información importante
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        
                        Text("Esta herramienta es de apoyo diagnóstico. Siempre consulta con criterio médico profesional.")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.orange.opacity(0.1))
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 20)
            }
        }
        .background(medicalGradient)
        .navigationTitle("Legal")
    }
    
    private var medicalGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.2, blue: 0.4),
                Color(red: 0.2, green: 0.3, blue: 0.5),
                Color(red: 0.1, green: 0.25, blue: 0.45)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // MARK: Funciones Legales
    private func showPrivacyPolicy() {
        if let url = URL(string: "https://pronosticofertilidad.com/privacy") {
            #if os(iOS)
            UIApplication.shared.open(url)
            #elseif os(macOS)
            NSWorkspace.shared.open(url)
            #endif
        }
    }
    
    private func showTermsOfService() {
        if let url = URL(string: "https://pronosticofertilidad.com/terms") {
            #if os(iOS)
            UIApplication.shared.open(url)
            #elseif os(macOS)
            NSWorkspace.shared.open(url)
            #endif
        }
    }
    
    private func showMedicalDisclaimer() {
        if let url = URL(string: "https://pronosticofertilidad.com/medical-disclaimer") {
            #if os(iOS)
            UIApplication.shared.open(url)
            #elseif os(macOS)
            NSWorkspace.shared.open(url)
            #endif
        }
    }
}

#Preview {
    NavigationView {
        ProfileSettingsView(
            userFullName: .constant("Dr. Jorge Vásquez"),
            userEmail: .constant("doctor@ejemplo.com"),
            userSpecialty: .constant("Medicina Reproductiva"),
            userInstitution: .constant("Centro de Fertilidad")
        )
    }
}
