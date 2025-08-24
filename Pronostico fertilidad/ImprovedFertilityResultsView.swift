import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

struct ImprovedFertilityResultsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(\.themeColors) var colors
    let result: ImprovedFertilityEngine.ComprehensiveFertilityResult
    let profile: FertilityProfile
    
    @StateObject private var viewModel: FertilityResultsViewModel
    @State private var selectedTab = 0
    
    init(result: ImprovedFertilityEngine.ComprehensiveFertilityResult, profile: FertilityProfile) {
        self.result = result
        self.profile = profile
        self._viewModel = StateObject(wrappedValue: FertilityResultsViewModel(result: result, profile: profile))
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                // Pestaña 1: Resumen
                FertilitySummaryView(result: result, profile: profile)
                    .tabItem {
                        Image(systemName: "chart.pie.fill")
                        Text(localizationManager.getLocalizedString("Resumen"))
                    }
                    .tag(0)
                
                // Pestaña 2: Análisis Detallado
                analysisView
                    .tabItem {
                        Image(systemName: "doc.text.magnifyingglass")
                        Text(localizationManager.getLocalizedString("Análisis"))
                    }
                    .tag(1)
                
                // Pestaña 3: Factores
                FertilityFactorsView(result: result, profile: profile)
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle")
                        Text(localizationManager.getLocalizedString("Factores"))
                    }
                    .tag(2)
                
                // Pestaña 4: Recomendaciones
                recommendationsView
                    .tabItem {
                        Image(systemName: "heart.text.square")
                        Text(localizationManager.getLocalizedString("Recomendaciones"))
                    }
                    .tag(3)
                
                // Pestaña 5: Simulador de Tratamientos
                TreatmentSimulatorView(profile: profile)
                    .tabItem {
                        Image(systemName: "cross.case.fill")
                        Text(localizationManager.getLocalizedString("Simulador"))
                    }
                    .tag(4)
                
                // Pestaña 6: Modo de Pensamiento Médico
                MedicalThinkingView(fertilityProfile: profile)
                    .tabItem {
                        Image(systemName: "brain.head.profile")
                        Text(localizationManager.getLocalizedString("Pensamiento"))
                    }
                    .tag(5)
            }
            .navigationTitle("Análisis de Fertilidad")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button(action: { viewModel.shareResults() }) {
                            Label("Compartir", systemImage: "square.and.arrow.up")
                        }
                        
                        Button(action: { viewModel.exportPDF() }) {
                            Label("Exportar PDF", systemImage: "doc.text.fill")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Vista de Análisis Detallado
    private var analysisView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Disclaimer médico crítico - REQUERIDO POR APPLE
                MedicalDisclaimerView(style: .critical)
                
                // Header con icono médico
                HStack {
                    Image(systemName: "stethoscope")
                        .font(.title)
                        .foregroundColor(.blue)
                    
                    Text(localizationManager.getLocalizedString("Análisis Médico Completo"))
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Indicador de confianza
                    HStack(spacing: 4) {
                        Circle()
                            .fill(confidenceColor)
                            .frame(width: 8, height: 8)
                        Text("\(Int(result.confidenceLevel * 100))%")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(confidenceColor.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Métricas principales en cards
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    MetricCard(
                        icon: "heart.fill",
                        title: "Puntuación",
                        value: String(format: "%.1f", result.fertilityScore),
                        color: .red,
                        subtitle: "Fertilidad"
                    )
                    
                    MetricCard(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Tendencia",
                        value: result.category.rawValue.capitalized,
                        color: categoryColor,
                        subtitle: "Categoría"
                    )
                    
                    MetricCard(
                        icon: "clock.fill",
                        title: "Tiempo",
                        value: "\(Int(result.annualProbability * 100))%",
                        color: .blue,
                        subtitle: "Anual"
                    )
                    
                    MetricCard(
                        icon: "calendar",
                        title: "Mensual",
                        value: "\(Int(result.monthlyProbability * 100))%",
                        color: .green,
                        subtitle: "Probabilidad"
                    )
                }
                .padding(.horizontal)
                
                // Análisis detallado con diseño mejorado
                VStack(alignment: .leading, spacing: 20) {
                    // Header elegante
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "stethoscope")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(localizationManager.getLocalizedString("Evaluación Clínica"))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(localizationManager.getLocalizedString("Análisis médico detallado"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Badge de estado
                        Text(localizationManager.getLocalizedString("Completa"))
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.green)
                            )
                    }
                    
                    // Contenido principal con diseño moderno
                    VStack(alignment: .leading, spacing: 16) {
                        // Icono decorativo
                        HStack {
                            Image(systemName: "quote.bubble.fill")
                                .font(.title2)
                                .foregroundColor(.blue.opacity(0.6))
                            
                            Spacer()
                        }
                        
                        // Texto del análisis con mejor formato
                        Text(result.detailedAnalysis)
                            .font(.body)
                            .lineSpacing(8)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        // Separador decorativo
                        HStack {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: 2)
                            
                            Spacer()
                        }
                        
                        // Footer con información adicional
                        HStack {
                            Image(systemName: "clock.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text(localizationManager.getLocalizedString("Análisis generado automáticamente"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.9),
                                        Color.blue.opacity(0.02),
                                        Color.purple.opacity(0.02)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.blue.opacity(0.2), .purple.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                            .shadow(
                                color: Color.blue.opacity(0.1),
                                radius: 15,
                                x: 0,
                                y: 8
                            )
                    )
                }
                .padding(.horizontal)
                
                // Botón para ir al Simulador de Tratamientos
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "cross.case.fill")
                            .font(.title2)
                            .foregroundColor(.purple)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(localizationManager.getLocalizedString("¿Quieres ver recomendaciones de tratamiento?"))
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text(localizationManager.getLocalizedString("Simula diferentes opciones terapéuticas basadas en tu perfil"))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            selectedTab = 4 // Ir a la pestaña Simulador
                        }) {
                            HStack(spacing: 8) {
                                Text(localizationManager.getLocalizedString("Ver Simulador"))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.title3)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                LinearGradient(
                                    colors: [.purple, .blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [.purple.opacity(0.1), .blue.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.purple.opacity(0.3), .blue.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    )
                }
                .padding(.horizontal)
                
                // Factores clave destacados
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "target")
                            .font(.title3)
                            .foregroundColor(.orange)
                        
                        Text(localizationManager.getLocalizedString("Factores Clave"))
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                        ForEach(Array(result.keyFactors.prefix(3).enumerated()), id: \.offset) { index, factor in
                            KeyFactorCard(
                                factor: factor.key.capitalized.replacingOccurrences(of: "_", with: " "),
                                impact: factor.value,
                                index: index
                            )
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 20)
            }
            .padding(.vertical)
        }
        .background(colors.backgroundGradient)
    }
    
    // MARK: - Vista de Recomendaciones
    private var recommendationsView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Disclaimer médico crítico - REQUERIDO POR APPLE
                MedicalDisclaimerView(style: .critical)
                
                Text(localizationManager.getLocalizedString("Recomendaciones Personalizadas"))
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(Array(result.recommendations.enumerated()), id: \.offset) { index, recommendation in
                    RecommendationRowView(recommendation: recommendation, index: index)
                }
                
                Spacer(minLength: 20)
            }
            .padding()
        }
        .background(colors.backgroundGradient)
    }
    
    // MARK: - Computed Properties
    
    private var categoryColor: Color {
        switch result.category {
        case .excellent:
            return .green
        case .good:
            return .blue
        case .moderate:
            return .orange
        case .low:
            return .red
        case .veryLow:
            return .purple
        case .critical:
            return .purple
        }
    }
    
    private var confidenceColor: Color {
        switch result.confidenceLevel {
        case 0.8...:
            return .green
        case 0.6..<0.8:
            return .orange
        default:
            return .red
        }
    }
}

// MARK: - Componentes de Soporte

struct MetricCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let subtitle: String
    @Environment(\.themeColors) var colors
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(colors.surface)
        .cornerRadius(12)
        .shadow(color: colors.border.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

struct KeyFactorCard: View {
    let factor: String
    let impact: Double
    let index: Int
    @Environment(\.themeColors) var colors
    
    var body: some View {
        HStack {
            Text("\(index + 1)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(impactColor)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(factor)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("Impacto: \(String(format: "%.2f", impact))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: impactIcon)
                .font(.title3)
                .foregroundColor(impactColor)
        }
        .padding()
        .background(colors.surface)
        .cornerRadius(12)
        .shadow(color: colors.border.opacity(0.3), radius: 2, x: 0, y: 1)
    }
    
    private var impactColor: Color {
        if impact > 0 {
            return .green
        } else if impact > -0.3 {
            return .orange
        } else {
            return .red
        }
    }
    
    private var impactIcon: String {
        if impact > 0 {
            return "arrow.up.circle.fill"
        } else if impact > -0.3 {
            return "minus.circle.fill"
        } else {
            return "arrow.down.circle.fill"
        }
    }
}

struct RecommendationRowView: View {
    let recommendation: ImprovedFertilityEngine.Recommendation
    let index: Int
    @Environment(\.themeColors) var colors
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Número de recomendación
            Text("\(index + 1)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(priorityColor)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(recommendation.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(recommendation.priority.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(priorityColor.opacity(0.1))
                        .foregroundColor(priorityColor)
                        .cornerRadius(6)
                }
                
                Text(recommendation.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Citaciones médicas
                if !recommendation.citations.isEmpty {
                    Text(localizationManager.getLocalizedString("Referencias: \(recommendation.citations.joined(separator: " • "))"))
                        .font(.caption)
                        .foregroundColor(.secondary.opacity(0.7))
                        .italic()
                        .padding(.top, 4)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding()
        .background(colors.surface)
        .cornerRadius(12)
        .shadow(color: colors.border.opacity(0.3), radius: 2, x: 0, y: 1)
    }
    
    private var priorityColor: Color {
        switch recommendation.priority {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .blue
        case .critical:
            return .purple
        }
    }
}