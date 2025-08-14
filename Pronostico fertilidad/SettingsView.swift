//
//  SettingsView.swift
//  Pronostico fertilidad
//
//  Pantalla de configuración completa con diseño médico profesional
//

import SwiftUI
import SwiftData
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.themeColors) var colors
    
    // Perfil de usuario
    @AppStorage("userFullName") private var userFullName: String = ""
    @AppStorage("userEmail") private var userEmail: String = ""
    @AppStorage("userSpecialty") private var userSpecialty: String = ""
    @AppStorage("userInstitution") private var userInstitution: String = ""
    
    // Apariencia
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    // Estados de la vista
    @State private var showingLogoutAlert = false
    
    @State private var selectedSection: SettingsSection = .profile
    @State private var showingResetAlert = false
    @State private var showingAbout = false
    
    var body: some View {
        NavigationView {
            settingsListView
                .background(medicalGradient)
                .navigationTitle("Configuración")
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button("Cerrar") {
                            dismiss()
                        }
                        .foregroundColor(.white)
                    }
                }
        }

        }
    
    // MARK: - 📋 LISTA DE CONFIGURACIÓN
    private var settingsListView: some View {
        List {
            // Header con información del usuario
            Section {
                userHeaderView
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            
            // Secciones de configuración
            ForEach(SettingsSection.allCases, id: \.self) { section in
                NavigationLink(destination: destinationView(for: section)) {
                    SettingsRowView(section: section)
                }
                .listRowBackground(Color.black.opacity(0.2))
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
    }
    
    // MARK: - 👤 HEADER DE USUARIO
    private var userHeaderView: some View {
        VStack(spacing: 16) {
            // Avatar del usuario
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                )
            
            VStack(spacing: 4) {
                Text(userFullName.isEmpty ? "Usuario" : userFullName)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text(userEmail.isEmpty ? "No conectado" : userEmail)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                if !userSpecialty.isEmpty {
                    Text(userSpecialty)
                        .font(.caption)
                        .foregroundColor(.cyan)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.cyan.opacity(0.2))
                        )
                }
            }
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - 🎯 DESTINOS DE NAVEGACIÓN
    @ViewBuilder
    private func destinationView(for section: SettingsSection) -> some View {
        switch section {
        case .profile:
            ProfileSettingsView(
                userFullName: $userFullName,
                userEmail: $userEmail,
                userSpecialty: $userSpecialty,
                userInstitution: $userInstitution
            )
        case .appearance:
            AppearanceSettingsView(isDarkMode: $isDarkMode)
                .environmentObject(themeManager)
        case .share:
            ShareSettingsView()
        case .legal:
            LegalSettingsView()
        case .info:
            InfoSettingsView()
        case .accessibility:
            AccessibilitySettingsView()
        case .logout:
            LogoutSettingsView(
                userFullName: userFullName,
                showingLogoutAlert: $showingLogoutAlert,
                performLogout: performLogout
            )
        }
    }

    // MARK: - 📱 SIDEBAR DE NAVEGACIÓN (DEPRECATED)
    private var settingsSidebar: some View {
        VStack(spacing: 0) {
            // Header con título
            HStack {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text("Configuración")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .background(Color.black.opacity(0.2))
            
            // Lista de secciones
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(SettingsSection.allCases, id: \.self) { section in
                        SettingsSidebarRow(
                            section: section,
                            isSelected: selectedSection == section
                        ) {
                            selectedSection = section
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            
            Spacer()
            
            // Footer con versión
            VStack(spacing: 8) {
                Text("Pronóstico Fertilidad")
                    .font(.caption.bold())
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Versión 2.1.0")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
                
                Button("Acerca de") {
                    showingAbout = true
                }
                .font(.caption)
                .foregroundColor(.cyan)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(width: 280)
        .background(Color.black.opacity(0.4))
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
    
    // MARK: - 📋 CONTENIDO PRINCIPAL
    private var settingsContent: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                switch selectedSection {
                case .profile:
                    profileSection
                case .appearance:
                    appearanceSection
                case .share:
                    shareSection
                case .legal:
                    legalSection
                case .info:
                    infoSection
                case .accessibility:
                    accessibilitySection
                case .logout:
                    logoutSection
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 24)
        }
        .background(Color.white.opacity(0.05))
    }
    
    // MARK: - 👤 SECCIÓN PERFIL
    private var profileSection: some View {
        VStack(spacing: 20) {
            SettingsSectionHeader(
                title: "Perfil de Usuario",
                subtitle: "Información profesional integrada con login",
                icon: "person.crop.circle.fill"
            )
            
            // Avatar del usuario
            VStack(spacing: 16) {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    )
                
                Text(userFullName.isEmpty ? "Usuario" : userFullName)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text(userEmail.isEmpty ? "No conectado" : userEmail)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.vertical, 16)
            
            VStack(spacing: 16) {
                SettingsTextField(
                    title: "Nombre Completo",
                    subtitle: "Aparecerá en los reportes",
                    icon: "person.fill",
                    text: $userFullName,
                    placeholder: "Dr. Juan Pérez"
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
            .padding(.horizontal, 4)
        }
    }
    
    // MARK: - 🎨 SECCIÓN APARIENCIA
    private var appearanceSection: some View {
        VStack(spacing: 20) {
            SettingsSectionHeader(
                title: "Apariencia",
                subtitle: "Configuración visual de la aplicación",
                icon: "moon.fill"
            )
            
            VStack(spacing: 16) {
                SettingsToggleRow(
                    title: "Modo Oscuro",
                    subtitle: "Interfaz con colores oscuros",
                    icon: "moon.fill",
                    isOn: $isDarkMode
                )
                
                // Información sobre el modo oscuro
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.cyan)
                    
                    Text("El modo oscuro reduce el cansancio visual durante sesiones largas")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.cyan.opacity(0.1))
                )
            }
            .padding(.horizontal, 4)
        }
    }
    
    // MARK: - 📱 SECCIÓN COMPARTIR
    private var shareSection: some View {
        VStack(spacing: 20) {
            SettingsSectionHeader(
                title: "Compartir",
                subtitle: "Comparte la app en redes sociales",
                icon: "square.and.arrow.up.fill"
            )
            
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
            .padding(.horizontal, 4)
        }
    }
    
    // MARK: - 📋 SECCIÓN LEGAL
    private var legalSection: some View {
        VStack(spacing: 20) {
            SettingsSectionHeader(
                title: "Legal y Médico",
                subtitle: "Términos, políticas y avisos importantes",
                icon: "doc.text.fill"
            )
            
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
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.1))
                )
            }
            .padding(.horizontal, 4)
        }
    }
    
    // MARK: - ℹ️ SECCIÓN INFORMACIÓN
    private var infoSection: some View {
        VStack(spacing: 20) {
            SettingsSectionHeader(
                title: "Información",
                subtitle: "Versión, soporte y redes sociales",
                icon: "info.circle.fill"
            )
            
            VStack(spacing: 16) {
                // Información de la versión
                HStack {
                    Image(systemName: "app.badge.fill")
                        .foregroundColor(.cyan)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Versión de la Aplicación")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("2.1.0 (Build 2024.12)")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.2))
                )
                
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
            .padding(.horizontal, 4)
        }
    }
    
    // MARK: - ♿ SECCIÓN ACCESIBILIDAD
    private var accessibilitySection: some View {
        VStack(spacing: 20) {
            SettingsSectionHeader(
                title: "Accesibilidad",
                subtitle: "Compatibilidad con iOS y funciones de asistencia",
                icon: "accessibility"
            )
            
            VStack(spacing: 16) {
                // Información de compatibilidad
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("VoiceOver Compatible")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Navegación por voz habilitada")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.green.opacity(0.1))
                )
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Dynamic Type")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Tamaños de texto adaptativos")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.green.opacity(0.1))
                )
                
                SettingsActionRow(
                    title: "Configurar Accesibilidad iOS",
                    subtitle: "Abrir configuración del sistema",
                    icon: "gear",
                    action: { openAccessibilitySettings() }
                )
                
                // Información adicional
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.indigo)
                    
                    Text("Esta app es totalmente compatible con todas las funciones de accesibilidad de iOS")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.indigo.opacity(0.1))
                )
            }
            .padding(.horizontal, 4)
        }
    }
    
    // MARK: - 🚪 SECCIÓN LOGOUT
    private var logoutSection: some View {
        VStack(spacing: 20) {
            SettingsSectionHeader(
                title: "Cerrar Sesión",
                subtitle: "Salir de la aplicación de forma segura",
                icon: "rectangle.portrait.and.arrow.right.fill"
            )
            
            VStack(spacing: 16) {
                // Información del usuario actual
                if !userFullName.isEmpty {
                    HStack {
                        Circle()
                            .fill(Color.red.opacity(0.2))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.title2)
                                    .foregroundColor(.red)
                            )
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Sesión Activa")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text(userFullName)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.2))
                    )
                }
                
                // Advertencia sobre logout
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    
                    Text("Al cerrar sesión se eliminarán todos los datos locales no sincronizados")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.1))
                )
                
                // Botón de logout
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
            .padding(.horizontal, 4)
        }
        .alert("Cerrar Sesión", isPresented: $showingLogoutAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Cerrar Sesión", role: .destructive) {
                performLogout()
            }
        } message: {
            Text("¿Estás seguro de que deseas cerrar sesión? Se eliminarán todos los datos locales.")
        }
    }
    
    // MARK: - 🎨 GRADIENTE MÉDICO
    private var medicalGradient: some View {
        // Usar el tema actual pero mantener el estilo médico para configuración
        switch themeManager.currentTheme {
        case .dark:
            return colors.medicalGradient.ignoresSafeArea()
        case .pink:
            return colors.medicalGradient.ignoresSafeArea()
        case .light:
            return LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.99, blue: 1.0),  // Azul muy claro
                    Color(red: 0.95, green: 0.97, blue: 1.0),  // Azul claro
                    Color(red: 0.92, green: 0.95, blue: 1.0)   // Azul suave
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()
        }
    }
    
    // MARK: - 🔄 FUNCIONES AUXILIARES
    
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
    
    // MARK: Función de Logout
    private func performLogout() {
        // Limpiar datos del usuario
        userFullName = ""
        userEmail = ""
        userSpecialty = ""
        userInstitution = ""
        isDarkMode = false
        
        // Aquí se integraría con el sistema de autenticación
        // Por ejemplo: AuthManager.shared.logout()
        
        // Cerrar la vista de configuración
        dismiss()
    }
}

// MARK: - 📋 ENUMS Y MODELOS
enum SettingsSection: String, CaseIterable {
    case profile = "Perfil"
    case appearance = "Apariencia"
    case share = "Compartir"
    case legal = "Legal"
    case info = "Información"
    case accessibility = "Accesibilidad"
    case logout = "Cerrar Sesión"
    
    var icon: String {
        switch self {
        case .profile: return "person.crop.circle.fill"
        case .appearance: return "moon.fill"
        case .share: return "square.and.arrow.up.fill"
        case .legal: return "doc.text.fill"
        case .info: return "info.circle.fill"
        case .accessibility: return "accessibility"
        case .logout: return "rectangle.portrait.and.arrow.right.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .profile: return .blue
        case .appearance: return .purple
        case .share: return .green
        case .legal: return .orange
        case .info: return .cyan
        case .accessibility: return .indigo
        case .logout: return .red
        }
    }
}

// MARK: - 🧩 COMPONENTES AUXILIARES
struct SettingsSidebarRow: View {
    let section: SettingsSection
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: section.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .white : section.color)
                    .frame(width: 24)
                
                Text(section.rawValue)
                    .font(.system(size: 15, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? section.color.opacity(0.3) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSelected ? section.color : Color.clear, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsSectionHeader: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    SettingsView()
}
