//
//  SettingsDetailViews2.swift
//  Pronostico fertilidad
//
//  Vistas detalladas adicionales para configuración
//

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - ℹ️ VISTA DE INFORMACIÓN
struct InfoSettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.themeColors) var colors
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header con icono animado según el tema
                headerSection
                
                // Información de versión
                versionInfoSection
                
                // Opciones de información
                infoOptionsSection
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
        }
        .background(colors.backgroundGradient)
        .navigationTitle("Información")
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Icono animado con efectos especiales del tema
            ZStack {
                switch themeManager.currentTheme {
                case .dark:
                    SuperDesignEffects.neonGlow(color: .cyan, intensity: 1.2)
                        .frame(width: 80, height: 80)
                case .pink:
                    SuperDesignEffects.pinkGlow(intensity: 1.0)
                        .frame(width: 80, height: 80)
                case .light:
                    Circle()
                        .fill(colors.accentGradient)
                        .frame(width: 80, height: 80)
                }
                
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(
                        themeManager.currentTheme == .dark ? .black : 
                        themeManager.currentTheme == .pink ? .white : .white
                    )
            }
            .padding(.top, 20)
            
            VStack(spacing: 8) {
                Text("Información")
                    .font(.title2.bold())
                    .foregroundColor(colors.text)
                
                Text("Versión, soporte y redes sociales")
                    .font(.subheadline)
                    .foregroundColor(colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // MARK: - Version Info Section
    private var versionInfoSection: some View {
        HStack {
            Image(systemName: "app.badge.fill")
                .foregroundColor(.cyan)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Versión de la Aplicación")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(colors.text)
                
                Text("2.1.0 (Build 2024.12)")
                    .font(.system(size: 13))
                    .foregroundColor(colors.textSecondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            SuperDesignEffects.glassmorphism(for: themeManager.currentTheme)
        )
    }
    
    // MARK: - Info Options Section
    private var infoOptionsSection: some View {
        VStack(spacing: 16) {
            SettingsActionRow(
                title: "Soporte Técnico",
                subtitle: "Contacta con nuestro equipo de ayuda",
                icon: "headphones",
                action: { contactSupport() }
            )
            
            SettingsActionRow(
                title: "Síguenos en Instagram",
                subtitle: "@drjorgevazquez - Contenido médico profesional",
                icon: "camera.fill",
                action: { openInstagram() }
            )
            
            SettingsActionRow(
                title: "Síguenos en TikTok",
                subtitle: "@fertilidadrjorgevasquez - Videos educativos",
                icon: "video.fill",
                action: { openTikTok() }
            )
        }
    }
    
    // MARK: Funciones de Información
    private func contactSupport() {
        if let url = URL(string: "mailto:soporte@pronosticofertilidad.com?subject=Soporte%20Técnico") {
            #if os(iOS)
            UIApplication.shared.open(url)
            #elseif os(macOS)
            NSWorkspace.shared.open(url)
            #endif
        }
    }
    
    private func openInstagram() {
        #if os(iOS)
        if let url = URL(string: "instagram://user?username=drjorgevazquez") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else if let webURL = URL(string: "https://linktr.ee/drjorgevazquez") {
                UIApplication.shared.open(webURL)
            }
        }
        #elseif os(macOS)
        if let url = URL(string: "https://linktr.ee/drjorgevazquez") {
            NSWorkspace.shared.open(url)
        }
        #endif
    }
    
    private func openTikTok() {
        #if os(iOS)
        if let url = URL(string: "tiktok://user?username=fertilidadrjorgevasquez") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else if let webURL = URL(string: "https://www.tiktok.com/@fertilidadrjorgevasquez") {
                UIApplication.shared.open(webURL)
            }
        }
        #elseif os(macOS)
        if let url = URL(string: "https://www.tiktok.com/@fertilidadrjorgevasquez") {
            NSWorkspace.shared.open(url)
        }
        #endif
    }
}

// MARK: - ♿ VISTA DE ACCESIBILIDAD
struct AccessibilitySettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.themeColors) var colors
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header con icono animado según el tema
                headerSection
                
                // Información de compatibilidad
                compatibilityInfoSection
                
                // Opciones de accesibilidad
                accessibilityOptionsSection
                
                // Información adicional
                additionalInfoSection
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
        }
        .background(colors.backgroundGradient)
        .navigationTitle("Accesibilidad")
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Icono animado con efectos especiales del tema
            ZStack {
                switch themeManager.currentTheme {
                case .dark:
                    SuperDesignEffects.neonGlow(color: .indigo, intensity: 1.2)
                        .frame(width: 80, height: 80)
                case .pink:
                    SuperDesignEffects.pinkGlow(intensity: 1.0)
                        .frame(width: 80, height: 80)
                case .light:
                    Circle()
                        .fill(colors.accentGradient)
                        .frame(width: 80, height: 80)
                }
                
                Image(systemName: "accessibility")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(
                        themeManager.currentTheme == .dark ? .black : 
                        themeManager.currentTheme == .pink ? .white : .white
                    )
            }
            .padding(.top, 20)
            
            VStack(spacing: 8) {
                Text("Accesibilidad")
                    .font(.title2.bold())
                    .foregroundColor(colors.text)
                
                Text("Compatibilidad con iOS y funciones de asistencia")
                    .font(.subheadline)
                    .foregroundColor(colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // MARK: - Compatibility Info Section
    private var compatibilityInfoSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("VoiceOver Compatible")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(colors.text)
                    
                    Text("Navegación por voz habilitada")
                        .font(.system(size: 12))
                        .foregroundColor(colors.textSecondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                SuperDesignEffects.glassmorphism(for: themeManager.currentTheme)
            )
            
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Dynamic Type")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(colors.text)
                    
                    Text("Tamaños de texto adaptativos")
                        .font(.system(size: 12))
                        .foregroundColor(colors.textSecondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                SuperDesignEffects.glassmorphism(for: themeManager.currentTheme)
            )
        }
    }
    
    // MARK: - Accessibility Options Section
    private var accessibilityOptionsSection: some View {
        SettingsActionRow(
            title: "Configurar Accesibilidad iOS",
            subtitle: "Abrir configuración del sistema",
            icon: "gear",
            action: { openAccessibilitySettings() }
        )
    }
    
    // MARK: - Additional Info Section
    private var additionalInfoSection: some View {
        HStack {
            Image(systemName: "info.circle")
                .foregroundColor(.indigo)
            
            Text("Esta app es totalmente compatible con todas las funciones de accesibilidad de iOS")
                .font(.caption)
                .foregroundColor(colors.textSecondary)
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
    
    // MARK: Funciones de Accesibilidad
    private func openAccessibilitySettings() {
        #if os(iOS)
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
        #elseif os(macOS)
        // En macOS, abrir preferencias del sistema
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.universalaccess") {
            NSWorkspace.shared.open(url)
        }
        #endif
    }
}

// MARK: - 🚪 VISTA DE LOGOUT
struct LogoutSettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.themeColors) var colors
    let userFullName: String
    @Binding var showingLogoutAlert: Bool
    let performLogout: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header con icono animado según el tema
                headerSection
                
                // Información del usuario
                userInfoSection
                
                // Advertencia
                warningSection
                
                // Botón de logout
                logoutButtonSection
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
        }
        .background(colors.backgroundGradient)
        .navigationTitle("Cerrar Sesión")
        .alert("Cerrar Sesión", isPresented: $showingLogoutAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Cerrar Sesión", role: .destructive) {
                performLogout()
            }
        } message: {
            Text("¿Estás seguro de que deseas cerrar sesión? Se eliminarán todos los datos locales.")
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 20) {
            // Icono animado con efectos especiales del tema
            ZStack {
                switch themeManager.currentTheme {
                case .dark:
                    SuperDesignEffects.neonGlow(color: .red, intensity: 1.2)
                        .frame(width: 80, height: 80)
                case .pink:
                    SuperDesignEffects.pinkGlow(intensity: 1.0)
                        .frame(width: 80, height: 80)
                case .light:
                    Circle()
                        .fill(colors.accentGradient)
                        .frame(width: 80, height: 80)
                }
                
                Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(
                        themeManager.currentTheme == .dark ? .black : 
                        themeManager.currentTheme == .pink ? .white : .white
                    )
            }
            .padding(.top, 20)
            
            VStack(spacing: 8) {
                Text("Cerrar Sesión")
                    .font(.title2.bold())
                    .foregroundColor(colors.text)
                
                Text("Salir de la aplicación de forma segura")
                    .font(.subheadline)
                    .foregroundColor(colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // MARK: - User Info Section
    private var userInfoSection: some View {
        Group {
            if !userFullName.isEmpty {
                HStack {
                    Circle()
                        .fill(Color.red.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sesión Activa")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(colors.text)
                        
                        Text(userFullName)
                            .font(.system(size: 14))
                            .foregroundColor(colors.textSecondary)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(
                    SuperDesignEffects.glassmorphism(for: themeManager.currentTheme)
                )
            }
        }
    }
    
    // MARK: - Warning Section
    private var warningSection: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            
            Text("Al cerrar sesión se eliminarán todos los datos locales no sincronizados")
                .font(.caption)
                .foregroundColor(colors.textSecondary)
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
    
    // MARK: - Logout Button Section
    private var logoutButtonSection: some View {
        Button(action: { showingLogoutAlert = true }) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                    .font(.system(size: 16, weight: .medium))
                
                Text("Cerrar Sesión")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationView {
        InfoSettingsView()
    }
}
