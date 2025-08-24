//
//  MedicalDisclaimer.swift
//  Pronostico fertilidad
//
//  Componente de disclaimer médico obligatorio para Apple Store
//

import SwiftUI

// MARK: - 🩺 COMPONENTE DE DISCLAIMER MÉDICO
struct MedicalDisclaimerView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    let style: DisclaimerStyle
    let isCompact: Bool
    
    init(style: DisclaimerStyle = .standard, isCompact: Bool = false) {
        self.style = style
        self.isCompact = isCompact
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "stethoscope")
                .font(.system(size: isCompact ? 16 : 20, weight: .medium))
                .foregroundColor(style.iconColor)
                .frame(width: isCompact ? 20 : 24)
            
            VStack(alignment: .leading, spacing: 4) {
                if !isCompact {
                                    Text(localizationManager.getLocalizedString("Aviso Médico Importante"))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                }
                
                Text(disclaimerText)
                    .font(.system(size: isCompact ? 11 : 12))
                    .foregroundColor(.white.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, isCompact ? 8 : 12)
        .background(
            RoundedRectangle(cornerRadius: isCompact ? 8 : 12)
                .fill(style.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: isCompact ? 8 : 12)
                        .stroke(style.borderColor, lineWidth: 1)
                )
        )
    }
    
    private var disclaimerText: String {
        if isCompact {
            return "Esta herramienta es de apoyo diagnóstico. Siempre consulta con un médico profesional."
        } else {
            return "Esta herramienta es de apoyo diagnóstico únicamente. Los resultados no reemplazan el criterio médico profesional. Siempre consulta con un especialista en medicina reproductiva para decisiones clínicas."
        }
    }
}

// MARK: - 🎨 ESTILOS DE DISCLAIMER
enum DisclaimerStyle {
    case standard
    case warning
    case critical
    case footer
    
    var backgroundColor: Color {
        switch self {
        case .standard:
            return Color.blue.opacity(0.15)
        case .warning:
            return Color.orange.opacity(0.15)
        case .critical:
            return Color.red.opacity(0.15)
        case .footer:
            return Color.black.opacity(0.3)
        }
    }
    
    var borderColor: Color {
        switch self {
        case .standard:
            return Color.blue.opacity(0.3)
        case .warning:
            return Color.orange.opacity(0.4)
        case .critical:
            return Color.red.opacity(0.4)
        case .footer:
            return Color.white.opacity(0.2)
        }
    }
    
    var iconColor: Color {
        switch self {
        case .standard:
            return .blue
        case .warning:
            return .orange
        case .critical:
            return .red
        case .footer:
            return .white.opacity(0.7)
        }
    }
}

// MARK: - 🔄 DISCLAIMER FLOTANTE PARA RESULTADOS
struct FloatingMedicalDisclaimer: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var isVisible = true
    
    var body: some View {
        if isVisible {
            VStack(spacing: 0) {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.orange)
                        
                        Text(localizationManager.getLocalizedString("Apoyo diagnóstico - Consulta médico profesional"))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white)
                        
                        Button(action: { isVisible = false }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.8))
                            .overlay(
                                Capsule()
                                    .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                            )
                    )
                    
                    Spacer()
                }
                .padding(.bottom, 20)
            }
        }
    }
}

// MARK: - 📱 DISCLAIMER PARA FOOTER
struct FooterMedicalDisclaimer: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(spacing: 12) {
            Divider()
                .background(Color.white.opacity(0.2))
            
            MedicalDisclaimerView(style: .footer, isCompact: true)
            
            Text(localizationManager.getLocalizedString("© 2024 Dr. Jorge Vásquez - Medicina Reproductiva"))
                .font(.caption2)
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

#Preview {
    VStack(spacing: 20) {
        MedicalDisclaimerView(style: .standard)
        MedicalDisclaimerView(style: .warning)
        MedicalDisclaimerView(style: .critical)
        MedicalDisclaimerView(style: .footer, isCompact: true)
        
        FloatingMedicalDisclaimer()
    }
    .padding()
    .background(Color.blue.gradient)
}
