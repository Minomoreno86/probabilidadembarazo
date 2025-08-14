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
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 20) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.cyan)
                        .padding(.top, 20)
                    
                    Text("Información")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Text("Versión, soporte y redes sociales")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 16) {
                    // Información de la versión
                    HStack {
                        Image(systemName: "app.badge.fill")
                            .foregroundColor(.cyan)
                            .frame(width: 32)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Versión de la Aplicación")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("2.1.0 (Build 2024.12)")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
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
                .padding(.horizontal, 20)
                
                Spacer(minLength: 20)
            }
        }
        .background(medicalGradient)
        .navigationTitle("Información")
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
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 20) {
                    Image(systemName: "accessibility")
                        .font(.system(size: 60))
                        .foregroundColor(.indigo)
                        .padding(.top, 20)
                    
                    Text("Accesibilidad")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Text("Compatibilidad con iOS y funciones de asistencia")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 16) {
                    // Información de compatibilidad
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("VoiceOver Compatible")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("Navegación por voz habilitada")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green.opacity(0.1))
                        )
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Dynamic Type")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("Tamaños de texto adaptativos")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green.opacity(0.1))
                        )
                    }
                    
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
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.indigo.opacity(0.1))
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 20)
            }
        }
        .background(medicalGradient)
        .navigationTitle("Accesibilidad")
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
    let userFullName: String
    @Binding var showingLogoutAlert: Bool
    let performLogout: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 20) {
                    Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                        .padding(.top, 20)
                    
                    Text("Cerrar Sesión")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Text("Salir de la aplicación de forma segura")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 16) {
                    // Información del usuario actual
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
                                    .foregroundColor(.white)
                                
                                Text(userFullName)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
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
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
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
                .padding(.horizontal, 20)
                
                Spacer(minLength: 20)
            }
        }
        .background(medicalGradient)
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

#Preview {
    NavigationView {
        InfoSettingsView()
    }
}
