import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

struct ImprovedFertilityResultsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.themeColors) var colors
    let result: ImprovedFertilityEngine.ComprehensiveFertilityResult
    let profile: FertilityProfile
    
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                // Pestaña 1: Resumen
                summaryView
                    .tabItem {
                        Image(systemName: "chart.pie.fill")
                        Text("Resumen")
                    }
                    .tag(0)
                
                // Pestaña 2: Análisis Detallado
                analysisView
                    .tabItem {
                        Image(systemName: "doc.text.magnifyingglass")
                        Text("Análisis")
                    }
                    .tag(1)
                
                // Pestaña 3: Factores
                factorsView
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle")
                        Text("Factores")
                    }
                    .tag(2)
                
                // Pestaña 4: Recomendaciones
                recommendationsView
                    .tabItem {
                        Image(systemName: "heart.text.square")
                        Text("Recomendaciones")
                    }
                    .tag(3)
            }
            .navigationTitle("Análisis de Fertilidad")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Compartir") {
                        shareResults()
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
    
    // MARK: - Vista de Resumen
    private var summaryView: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Disclaimer médico crítico
                MedicalDisclaimerView(style: .critical)
                
                // Tarjeta principal de probabilidad
                probabilityCard
                
                // Indicadores de calidad
                qualityIndicators
                
                // Categoría y confianza
                categoryAndConfidence
                
                // Interacciones no lineales
                if result.interactionsReport.hasInteractions {
                    interactionsPreviewCard
                }
                
                Spacer(minLength: 20)
            }
            .padding()
            .overlay(
                // Disclaimer flotante
                FloatingMedicalDisclaimer(),
                alignment: .bottom
            )
        }
        .background(colors.backgroundGradient.ignoresSafeArea())
    }
    
    private var probabilityCard: some View {
        VStack(spacing: 16) {
            Text("Probabilidad de Embarazo")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            HStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text("\(Int(result.annualProbability * 100))%")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(probabilityColor)
                    Text("Anual")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    Text("\(Int(result.monthlyProbability * 100))%")
                        .font(.system(size: 32, weight: .semibold, design: .rounded))
                        .foregroundColor(probabilityColor)
                    Text("Por Ciclo")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(result.category.rawValue)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(categoryColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(categoryColor.opacity(0.1))
                .cornerRadius(20)
        }
        .padding(24)
        .background(colors.surface)
        .cornerRadius(16)
        .shadow(color: colors.border.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    private var qualityIndicators: some View {
        HStack(spacing: 16) {
            VStack(spacing: 8) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title2)
                    .foregroundColor(.blue)
                Text("Puntuación")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(String(format: "%.1f", result.fertilityScore))")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(colors.surface)
            .cornerRadius(12)
            
            VStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.title2)
                    .foregroundColor(.green)
                Text("Confianza")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(Int(result.confidenceLevel * 100))%")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(colors.surface)
            .cornerRadius(12)
        }
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private var categoryAndConfidence: some View {
        VStack(spacing: 12) {
            Text("Interpretación Clínica")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(categoryDescription)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding()
        .background(colors.surface)
        .cornerRadius(12)
        .shadow(color: colors.border.opacity(0.3), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Vista de Análisis Detallado
    private var analysisView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Análisis Médico Completo")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Text(result.detailedAnalysis)
                    .font(.body)
                    .lineSpacing(4)
                    .padding()
                    .background(colors.surface)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)
                
                Spacer(minLength: 20)
            }
            .padding(.vertical)
        }
        .background(colors.backgroundGradient)
    }
    
    // MARK: - Vista de Factores
    private var factorsView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                Text("Factores Analizados")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(Array(result.keyFactors.keys.sorted()), id: \.self) { factor in
                    if let impact = result.keyFactors[factor] {
                        FactorRowView(
                            factor: factor.capitalized.replacingOccurrences(of: "_", with: " "),
                            impact: impact
                        )
                    }
                }
                
                Spacer(minLength: 20)
            }
            .padding()
        }
        .background(colors.backgroundGradient)
    }
    
    // MARK: - Vista de Recomendaciones
    private var recommendationsView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                Text("Recomendaciones Personalizadas")
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
    
    private var probabilityColor: Color {
        switch result.category {
        case .excellent:
            return .green
        case .good:
            return Color(red: 0.6, green: 0.8, blue: 0.2)
        case .moderate:
            return .orange
        case .low:
            return Color(red: 1.0, green: 0.6, blue: 0.2)
        case .veryLow:
            return .red
        case .critical:
            return .purple
        }
    }
    
    private var categoryColor: Color {
        probabilityColor
    }
    
    private var categoryDescription: String {
        switch result.category {
        case .excellent:
            return "Excelente pronóstico reproductivo. Las condiciones son muy favorables para la concepción natural."
        case .good:
            return "Buen pronóstico reproductivo. Buenas posibilidades de embarazo con seguimiento médico adecuado."
        case .moderate:
            return "Pronóstico moderado. Se recomienda evaluación especializada y posible optimización de factores."
        case .low:
            return "Pronóstico reservado. Es recomendable considerar técnicas de reproducción asistida."
        case .veryLow:
            return "Pronóstico desfavorable. Se requiere tratamiento especializado e intervención médica inmediata."
        case .critical:
            return "Pronóstico crítico. Se requiere evaluación urgente para técnicas reproductivas avanzadas o alternativas."
        }
    }
    
    // MARK: - Función de Compartir
    
    private func shareResults() {
        let shareText = """
        📊 ANÁLISIS DE FERTILIDAD - RESULTADOS
        
        🎯 Probabilidad de embarazo anual: \(Int(result.annualProbability * 100))%
        📅 Probabilidad por ciclo: \(Int(result.monthlyProbability * 100))%
        📈 Categoría: \(result.category.rawValue)
        ✅ Confianza del análisis: \(Int(result.confidenceLevel * 100))%
        
        📋 FACTORES PRINCIPALES:
        \(result.keyFactors.map { "• \($0.key.capitalized): \(String(format: "%.2f", $0.value))" }.joined(separator: "\n"))
        
        💡 RECOMENDACIONES PRINCIPALES:
        \(result.recommendations.prefix(3).map { "• \($0.title)" }.joined(separator: "\n"))
        
        ---
        Análisis generado por Pronóstico Fertilidad
        """
        
        #if os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(shareText, forType: .string)
        #else
        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
        #endif
    }
}

// MARK: - Vistas de Componentes

struct FactorRowView: View {
    let factor: String
    let impact: Double
    @Environment(\.themeColors) var colors
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(factor)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Impacto: \(impactDescription)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(String(format: "%.2f", impact))")
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(impactColor.opacity(0.1))
                .foregroundColor(impactColor)
                .cornerRadius(8)
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
    
    private var impactDescription: String {
        if impact > 0 {
            return "Favorable"
        } else if impact > -0.3 {
            return "Moderado"
        } else {
            return "Significativo"
        }
    }
}

struct RecommendationRowView: View {
    let recommendation: ImprovedFertilityEngine.Recommendation
    let index: Int
    @Environment(\.themeColors) var colors
    
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
                    Text("Referencias: \(recommendation.citations.joined(separator: " • "))")
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

#Preview {
    let sampleProfile = FertilityProfile()
    let sampleResult = ImprovedFertilityEngine.ComprehensiveFertilityResult(
        annualProbability: 0.90,
        monthlyProbability: 0.175,
        fertilityScore: 3.2,
        category: .good,
        detailedAnalysis: "Análisis de muestra para preview",
        keyFactors: ["edad": 0.2, "bmi": -0.1, "amh": 0.5],
        recommendations: [
            ImprovedFertilityEngine.Recommendation(
                title: "Optimización preconcepcional",
                description: "Seguir plan de suplementación y estilo de vida saludable",
                priority: .medium,
                category: .lifestyle,
                evidenceLevel: .B,
                citations: ["ASRM Practice Guidelines 2023"]
            )
        ],
        confidenceLevel: 0.8,
        treatmentComplexity: .lowComplexity,
        urgencyLevel: .routine,
        evidenceSources: ["ASRM Guidelines 2023"],
        timeToPregnancy: ImprovedFertilityEngine.ComprehensiveFertilityResult.TimeEstimate(
            months: 8,
            description: "Expectativa realista con tratamiento",
            treatmentPath: ["Optimización estilo de vida", "Seguimiento rutinario"]
        ),
        coitoProgramadoRecomendacion: "COITO PROGRAMADO RECOMENDADO\n\nProtocolo: Letrozol\nTasas esperadas: 17.5% mensual",
        coitoProgramadoProtocolo: .letrozol,
        coitoProgramadoConfianza: 0.85,
        iiuRecomendacion: "INSEMINACIÓN INTRAUTERINA RECOMENDADA\n\nProtocolo: Letrozol\nTasas esperadas: 20.1% mensual",
        iiuProtocolo: .letrozol,
        iiuConfianza: 0.88,
        fivRecomendacion: "FERTILIZACIÓN IN VITRO RECOMENDADA\n\nTécnica: FIV\nProtocolo: GnRH Antagonista\nTasas: 40% nacido vivo",
        fivTecnica: .fiv,
        fivProtocolo: .antagonistaEstandar,
        fivConfianza: 0.92,
        interactionsReport: NonLinearInteractionsReport(detectedInteractions: [], finalMultiplier: 1.0, forcesTreatmentChange: false, treatmentChangeReason: nil, clinicalRecommendations: []),
        adjustedProbabilities: false,
        treatmentModified: false
    )
    
    ImprovedFertilityResultsView(result: sampleResult, profile: sampleProfile)
}

// MARK: - 🔄 INTERACCIONES NO LINEALES PREVIEW

extension ImprovedFertilityResultsView {
    
    private var interactionsPreviewCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("🔄 Interacciones No Lineales")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                NavigationLink(destination: InteractionsVisualizationView(interactionsReport: result.interactionsReport)) {
                    HStack {
                        Text("Ver Detalles")
                        Image(systemName: "chevron.right")
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            
            // Resumen rápido
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(result.interactionsReport.detectedInteractions.count) interacciones detectadas")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    if result.interactionsReport.forcesTreatmentChange {
                        Text("⚠️ Cambio de tratamiento requerido")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Probabilidad ajustada:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(String(format: "%.0f", result.interactionsReport.finalMultiplier * 100))%")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(multiplierColor(result.interactionsReport.finalMultiplier))
                }
            }
            
            // Preview de interacciones críticas
            if result.interactionsReport.criticalInteractionsCount > 0 {
                VStack(alignment: .leading, spacing: 6) {
                    Text("😨 Interacciones Críticas:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                    
                    ForEach(result.interactionsReport.detectedInteractions.filter { $0.priority == .critical }.prefix(2), id: \.name) { interaction in
                        Text("• \(interaction.name)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    if result.interactionsReport.criticalInteractionsCount > 2 {
                        Text("... y \(result.interactionsReport.criticalInteractionsCount - 2) más")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - 🎨 HELPER FUNCTIONS
    
    private func multiplierColor(_ multiplier: Double) -> Color {
        switch multiplier {
        case 0.0..<0.2: return .red
        case 0.2..<0.5: return .orange
        case 0.5..<0.8: return .yellow
        default: return .green
        }
    }
}
