import SwiftUI

struct FontSelectionView: View {
    @EnvironmentObject var userFontManager: UserFontManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.themeColors) var colors
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo con gradiente del tema actual
                colors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header con información del tema actual
                        headerSection
                        
                        // Selector de fuentes
                        fontSelectionSection
                        
                        // Vista previa con el tema actual
                        previewSection
                        
                        // Información sobre las fuentes
                        fontInfoSection
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                }
                .autoRefreshOnLanguageChange()
            }
            .navigationTitle(localizationManager.getLocalizedString("Tipografia"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localizationManager.getLocalizedString("Listo")) {
                        dismiss()
                    }
                    .foregroundColor(colors.text)
                }
                #else
                ToolbarItem(placement: .primaryAction) {
                    Button(localizationManager.getLocalizedString("Listo")) {
                        dismiss()
                    }
                    .foregroundColor(colors.text)
                }
                #endif
            }
        }
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
                
                Image(systemName: "textformat")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(
                        themeManager.currentTheme == .dark ? .black : 
                        themeManager.currentTheme == .pink ? .white : .white
                    )
            }
            .padding(.top, 20)
            
            VStack(spacing: 8) {
                Text(localizationManager.getLocalizedString("Personaliza la Tipografía"))
                    .font(.title2.bold())
                    .foregroundColor(colors.text)
                
                Text(localizationManager.getLocalizedString("Elige la fuente que mejor se adapte a tu estilo de trabajo"))
                    .font(.subheadline)
                    .foregroundColor(colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // MARK: - Font Selection Section
    private var fontSelectionSection: some View {
        VStack(spacing: 20) {
            Text(localizationManager.getLocalizedString("Selecciona una Fuente"))
                .font(.headline)
                .foregroundColor(colors.text)
            
            LazyVStack(spacing: 12) {
                ForEach(UserFontManager.FontFamily.allCases, id: \.self) { fontFamily in
                    FontOptionCard(
                        fontFamily: fontFamily,
                        isSelected: userFontManager.selectedFontFamily == fontFamily,
                        onSelect: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                userFontManager.setFontFamily(fontFamily)
                            }
                        }
                    )
                }
            }
        }
    }
    
    // MARK: - Preview Section
    private var previewSection: some View {
        VStack(spacing: 16) {
            Text(localizationManager.getLocalizedString("Vista Previa"))
                .font(.headline)
                .foregroundColor(colors.text)
            
            VStack(spacing: 16) {
                // Preview card con el tema actual
                VStack(alignment: .leading, spacing: 12) {
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
                            Text(localizationManager.getLocalizedString("Paciente de Prueba"))
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(colors.text)
                            
                            Text(localizationManager.getLocalizedString("Consulta de Fertilidad"))
                                .font(.system(size: 12))
                                .foregroundColor(colors.textSecondary)
                        }
                        
                        Spacer()
                        
                        Text(localizationManager.getLocalizedString("Hoy"))
                            .font(.system(size: 12))
                            .foregroundColor(colors.textSecondary)
                    }
                    
                    Divider()
                        .background(colors.border)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localizationManager.getLocalizedString("Resultados del Análisis"))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(colors.text)
                        
                        Text(localizationManager.getLocalizedString("AMH: 2.1 ng/mL • FSH: 8.5 mIU/mL • LH: 6.2 mIU/mL"))
                            .font(.system(size: 12))
                            .foregroundColor(colors.textSecondary)
                            .lineLimit(2)
                    }
                }
                .padding(16)
                .background(
                    SuperDesignEffects.glassmorphism(for: AppTheme.light)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(colors.border, lineWidth: 0.5)
                )
            }
        }
    }
    
    // MARK: - Font Info Section
    private var fontInfoSection: some View {
        VStack(spacing: 16) {
            Text(localizationManager.getLocalizedString("Características de la Fuente"))
                .font(.headline)
                .foregroundColor(colors.text)
            
            LazyVStack(spacing: 8) {
                ForEach(getFontInfoForCurrentFont(), id: \.title) { info in
                    HStack(spacing: 12) {
                        Image(systemName: info.icon)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(colors.accent)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(info.title)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(colors.text)
                            
                            Text(info.description)
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
    }
    
    // MARK: - Helper Functions
    private func getFontInfoForCurrentFont() -> [(title: String, description: String, icon: String)] {
        switch userFontManager.selectedFontFamily {
        case .system:
            return [
                (localizationManager.getLocalizedString("Fuente Nativa"), localizationManager.getLocalizedString("Optimizada para iOS y macOS"), "checkmark.circle.fill"),
                (localizationManager.getLocalizedString("Excelente Legibilidad"), localizationManager.getLocalizedString("Diseñada para pantallas"), "eye.fill"),
                (localizationManager.getLocalizedString("Rendimiento Óptimo"), localizationManager.getLocalizedString("Carga rápida y eficiente"), "bolt.fill"),
                (localizationManager.getLocalizedString("Accesibilidad"), localizationManager.getLocalizedString("Compatible con VoiceOver"), "accessibility")
            ]
        case .systemRounded:
            return [
                (localizationManager.getLocalizedString("Diseño Amigable"), localizationManager.getLocalizedString("Bordes redondeados y suaves"), "heart.fill"),
                (localizationManager.getLocalizedString("Menos Fatiga Visual"), localizationManager.getLocalizedString("Ideal para sesiones largas"), "eye.fill"),
                (localizationManager.getLocalizedString("Aspecto Moderno"), localizationManager.getLocalizedString("Estilo contemporáneo"), "sparkles"),
                (localizationManager.getLocalizedString("Legibilidad Mejorada"), localizationManager.getLocalizedString("Perfecta para datos médicos"), "doc.text.fill")
            ]
        case .systemSerif:
            return [
                (localizationManager.getLocalizedString("Elegancia Profesional"), localizationManager.getLocalizedString("Estilo serif tradicional"), "star.fill"),
                (localizationManager.getLocalizedString("Mejor para Lectura"), localizationManager.getLocalizedString("Ideal para textos largos"), "book.fill"),
                (localizationManager.getLocalizedString("Aspecto Clásico"), localizationManager.getLocalizedString("Diseño atemporal"), "crown.fill"),
                (localizationManager.getLocalizedString("Presentaciones"), localizationManager.getLocalizedString("Perfecta para reportes"), "doc.richtext.fill")
            ]
        case .systemMono:
            return [
                (localizationManager.getLocalizedString("Datos Precisos"), localizationManager.getLocalizedString("Alineación perfecta de números"), "number.circle.fill"),
                (localizationManager.getLocalizedString("Código y Datos"), localizationManager.getLocalizedString("Ideal para información técnica"), "terminal.fill"),
                (localizationManager.getLocalizedString("Consistencia"), localizationManager.getLocalizedString("Espaciado uniforme"), "ruler.fill"),
                (localizationManager.getLocalizedString("Análisis Médico"), localizationManager.getLocalizedString("Perfecta para resultados"), "chart.bar.fill")
            ]
        }
    }
}

// MARK: - Font Option Card
struct FontOptionCard: View {
    @Environment(\.themeColors) var colors
    let fontFamily: UserFontManager.FontFamily
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // Icono de la fuente
                ZStack {
                    Circle()
                        .fill(colors.accentGradient)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "textformat")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(fontFamily.displayName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(colors.text)
                    
                    Text(fontFamily.previewText)
                        .font(.system(size: 12))
                        .foregroundColor(colors.textSecondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(colors.accent)
                        .font(.title2)
                        .scaleEffect(1.2)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                SuperDesignEffects.glassmorphism(for: AppTheme.light)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? colors.accent : Color.clear,
                        lineWidth: isSelected ? 2 : 0
                    )
                    .animation(.easeInOut(duration: 0.3), value: isSelected)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FontSelectionView()
        .environmentObject(UserFontManager())
        .environmentObject(ThemeManager())
}
