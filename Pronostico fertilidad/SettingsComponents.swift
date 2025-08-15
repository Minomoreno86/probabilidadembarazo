//
//  SettingsComponents.swift
//  Pronostico fertilidad
//
//  Componentes reutilizables para la pantalla de configuración
//

import SwiftUI

// MARK: - 📝 CAMPO DE TEXTO DE CONFIGURACIÓN
struct SettingsTextField: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.cyan)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
            }
            
            TextField(placeholder, text: $text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.2))
        )
    }
}

// MARK: - 🔘 FILA DE TOGGLE
struct SettingsToggleRow: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isOn ? .green : .white.opacity(0.6))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .green))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.2))
        )
    }
}

// MARK: - 📋 FILA DE PICKER
struct SettingsPickerRow: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var selection: String
    let options: [(String, String)] // (value, label)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.purple)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
            }
            
            Picker("", selection: $selection) {
                ForEach(options, id: \.0) { option in
                    Text(option.1)
                        .tag(option.0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.2))
        )
    }
}

// MARK: - ⚡ FILA DE ACCIÓN
struct SettingsActionRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let isDestructive: Bool
    let action: () -> Void
    
    init(title: String, subtitle: String, icon: String, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.isDestructive = isDestructive
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isDestructive ? .red : .orange)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(isDestructive ? .red : .white)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.2))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - ℹ️ VISTA ACERCA DE
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Logo y título
                    VStack(spacing: 16) {
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.pink)
                        
                        Text("Pronóstico Fertilidad")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        
                        Text("Versión 2.1.0 (Build 2024.12)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    // Información de la app
                    VStack(alignment: .leading, spacing: 16) {
                        InfoRow(
                            title: "Desarrollador",
                            value: "Equipo Médico Digital"
                        )
                        
                        InfoRow(
                            title: "Especialidad",
                            value: "Medicina Reproductiva"
                        )
                        
                        InfoRow(
                            title: "Última Actualización",
                            value: "Diciembre 2024"
                        )
                        
                        InfoRow(
                            title: "Compatibilidad",
                            value: "macOS 12.0+, iOS 16.0+"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Descripción
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Acerca de la Aplicación")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                        
                        Text("Herramienta profesional para el cálculo de pronóstico de fertilidad basada en evidencia médica actualizada. Incluye algoritmos avanzados, interacciones no lineales y benchmarks clínicos.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 20)
                    
                    // Referencias médicas
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Referencias Médicas")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• ASRM Guidelines 2024")
                            Text("• ESHRE Recommendations 2023")
                            Text("• NICE Fertility Guidelines 2024")
                            Text("• WHO Laboratory Manual 2021")
                            Text("• Cochrane Reviews 2023")
                        }
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical, 32)
            }
            .background(medicalGradient)
            .navigationTitle("Acerca de")
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

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.2))
        )
    }
}

// MARK: - 📱 FILA DE CONFIGURACIÓN PARA LISTA
struct SettingsRowView: View {
    let section: SettingsSection
    
    var body: some View {
        HStack(spacing: 16) {
            // Icono de la sección
            Image(systemName: section.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(section.color)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(section.color.opacity(0.2))
                )
            
            // Información de la sección
            VStack(alignment: .leading, spacing: 4) {
                Text(section.rawValue)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(section.subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            // Indicador de navegación
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.1))
        )
    }
}

// MARK: - 📋 EXTENSIÓN PARA SUBTÍTULOS
extension SettingsSection {
    var subtitle: String {
        switch self {
        case .profile: return "Información personal y profesional"
        case .appearance: return "Tema y personalización visual"
        case .fonts: return "Personaliza las fuentes de la app"
        case .share: return "Comparte la app en redes sociales"
        case .legal: return "Términos, políticas y avisos"
        case .info: return "Versión, soporte y contacto"
        case .accessibility: return "Funciones de accesibilidad"
        case .logout: return "Cerrar sesión de forma segura"
        }
    }
}

#Preview {
    SettingsTextField(
        title: "Nombre del Médico",
        subtitle: "Aparecerá en los reportes",
        icon: "person.fill",
        text: .constant("Dr. Juan Pérez"),
        placeholder: "Ingrese su nombre"
    )
    .padding()
    .background(Color.blue.gradient)
}
