//
//  FertilityFactorsView.swift
//  Pronostico fertilidad
//
//  Componente reutilizable para la vista de factores
//  Extraído de ImprovedFertilityResultsView.swift
//
//  Created by Jorge Vásquez on 2024
//

import SwiftUI

// MARK: - 📊 VISTA DE FACTORES

struct FertilityFactorsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.themeColors) var colors
    
    let result: ImprovedFertilityEngine.ComprehensiveFertilityResult
    let profile: FertilityProfile
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Disclaimer médico crítico
                MedicalDisclaimerView(style: .critical)
                
                // Header con impacto general
                impactHeader
                
                // Grid de factores
                factorsGrid
                
                // Resumen de categorías
                categorySummary
            }
            .padding()
        }
        .accessibilityIdentifier("fertility_factors_view")
    }
    
    // MARK: - 📈 HEADER DE IMPACTO
    
    private var impactHeader: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(colors.primary)
                Text("Análisis de Factores")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            // Impacto general
            VStack(spacing: 12) {
                HStack {
                    Text("Impacto General")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(String(format: "%.0f%%", overallImpact * 100))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(overallImpactColor)
                }
                
                ProgressView(value: overallImpact)
                    .progressViewStyle(LinearProgressViewStyle(tint: overallImpactColor))
                    .scaleEffect(y: 2)
            }
            .padding()
            .background(colors.surface)
            .cornerRadius(12)
        }
        .padding()
        .background(colors.surface)
        .cornerRadius(16)
    }
    
    // MARK: - 🎯 GRID DE FACTORES
    
    private var factorsGrid: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "list.bullet.rectangle")
                    .foregroundColor(colors.primary)
                Text("Factores Analizados")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(Array(result.keyFactors), id: \.key) { factor in
                    SuperFactorCard(
                        factor: factor.key,
                        impact: factor.value,
                        colors: colors
                    )
                }
            }
        }
        .padding()
        .background(colors.surface)
        .cornerRadius(16)
    }
    
    // MARK: - 📊 RESUMEN DE CATEGORÍAS
    
    private var categorySummary: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .foregroundColor(colors.primary)
                Text("Resumen de Categorías")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            HStack(spacing: 16) {
                CategorySummaryCard(
                    title: "Favorables",
                    count: favorableFactorsCount,
                    color: .green,
                    icon: "checkmark.circle.fill"
                )
                
                CategorySummaryCard(
                    title: "Moderados",
                    count: neutralFactorsCount,
                    color: .orange,
                    icon: "exclamationmark.triangle.fill"
                )
                
                CategorySummaryCard(
                    title: "Críticos",
                    count: criticalFactorsCount,
                    color: .red,
                    icon: "xmark.circle.fill"
                )
            }
        }
        .padding()
        .background(colors.surface)
        .cornerRadius(16)
    }
    
    // MARK: - 🎨 LÓGICA DE COLORES
    
    private var overallImpact: Double {
        let totalFactors = result.keyFactors.count
        guard totalFactors > 0 else { return 0.0 }
        
        let favorableWeight = Double(favorableFactorsCount) * 1.0
        let neutralWeight = Double(neutralFactorsCount) * 0.5
        let criticalWeight = Double(criticalFactorsCount) * 0.0
        
        return (favorableWeight + neutralWeight + criticalWeight) / Double(totalFactors)
    }
    
    private var overallImpactColor: Color {
        switch overallImpact {
        case 0.7...1.0:
            return .green
        case 0.4..<0.7:
            return .orange
        default:
            return .red
        }
    }
    
    private var favorableFactorsCount: Int {
        result.keyFactors.compactMap { factor in
            let color = factorColor(for: factor.1, factorName: factor.0)
            return color == .green ? 1 : nil
        }.count
    }
    
    private var neutralFactorsCount: Int {
        result.keyFactors.compactMap { factor in
            let color = factorColor(for: factor.1, factorName: factor.0)
            return color == .orange ? 1 : nil
        }.count
    }
    
    private var criticalFactorsCount: Int {
        // 🔍 DEBUG: Log para encontrar el bug del "1 crítico"
        print("=== DEBUG FACTORES CRÍTICOS ===")
        print("Total factores: \(result.keyFactors.count)")
        
        var criticalCount = 0
        for factor in result.keyFactors {
            let color = factorColor(for: factor.1, factorName: factor.0)
            let isCritical = color == .red
            print("Factor: '\(factor.0)' = \(factor.1) -> Color: \(color) -> Crítico: \(isCritical)")
            if isCritical {
                criticalCount += 1
            }
        }
        print("Total críticos contados: \(criticalCount)")
        print("================================")
        
        return criticalCount
    }
    
    private func factorColor(for impact: Double, factorName: String) -> Color {
        // Lógica especial para Edad (que puede incluir años)
        if factorName.contains("Edad") {
            return ageFactorColor(impact: impact)
        }
        
        // Lógica especial para AMH
        if factorName.contains("AMH") {
            return amhFactorColor(impact: impact)
        }
        
        // Lógica general para otros factores
        return generalFactorColor(impact: impact)
    }
    
    private func ageFactorColor(impact: Double) -> Color {
        // Umbrales ajustados según especificaciones del usuario
        // 18-30: Verde (excelente/bueno) - ≥15%
        // 31-35: Naranja (moderado) - 10-15%
        // 36-45: Rojo (crítico) - <10%
        switch impact {
        case 0.15...1.0:
            return .green      // 18-30 años: ≥15%
        case 0.10..<0.15:
            return .orange     // 31-35 años: 10-15%
        default:
            return .red        // 36-45 años: <10%
        }
    }
    
    private func amhFactorColor(impact: Double) -> Color {
        switch impact {
        case 1.0...1.0:
            return .green
        case 0.75..<1.0:
            return .orange
        case 0.4..<0.75:
            return .orange
        default:
            return .red
        }
    }
    
    private func generalFactorColor(impact: Double) -> Color {
        switch impact {
        case 0.95...1.0:
            return .green
        case 0.8..<0.95:
            return .orange
        default:
            return .red
        }
    }
}

// MARK: - Componentes de Soporte

struct SuperFactorCard: View {
    let factor: String
    let impact: Double
    let colors: ThemeColors
    @State private var isAnimating = false
        
    var body: some View {
        VStack(spacing: 16) {
            // Header con icono y título
            HStack {
                Image(systemName: factorIcon)
                    .font(.title2)
                    .foregroundColor(factorColor)
                    .frame(width: 32, height: 32)
                    .background(factorColor.opacity(0.1))
                    .clipShape(Circle())
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(factorDisplayName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(colors.text)
                    
                    Text(severityDescription)
                        .font(.caption)
                        .foregroundColor(severityColor)
                        .fontWeight(.medium)
                }
                
                Spacer()
            }
            
            // Gráfico circular
            ZStack {
                Circle()
                    .stroke(factorColor.opacity(0.2), lineWidth: 8)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: abs(impact))
                    .stroke(factorColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.5), value: impact)
                
                VStack(spacing: 2) {
                    Text("\(Int(abs(impact) * 100))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(factorColor)
                    
                    Text("%")
                        .font(.caption)
                        .foregroundColor(colors.textSecondary)
                }
            }
            
            // Impacto numérico
            HStack {
                Text("Impacto:")
                    .font(.caption)
                    .foregroundColor(colors.textSecondary)
                
                Spacer()
                
                Text(String(format: "%.2f", impact))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(factorColor)
            }
            
            // Barra de progreso
            ProgressView(value: abs(impact), total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: factorColor))
                .scaleEffect(y: 1.5)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colors.surface,
                            colors.surface.opacity(0.8)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(factorColor.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: factorColor.opacity(0.2), radius: 8, x: 0, y: 4)
        .onAppear {
            isAnimating = true
        }
    }
    
    private var factorDisplayName: String {
        factor.capitalized.replacingOccurrences(of: "_", with: " ")
    }
    
    private var factorIcon: String {
        switch factor.lowercased() {
        case "edad", "age":
            return "person.circle.fill"
        case "bmi":
            return "scalemass.fill"
        case "amh", "antimulleriana":
            return "drop.fill"
        case "tsh":
            return "brain.head.profile"
        case "prolactina", "prolactin":
            return "drop.circle.fill"
        case "homa", "homa_ir":
            return "heart.fill"
        case "ciclo", "cycle":
            return "calendar.circle.fill"
        case "infertilidad", "infertility":
            return "clock.circle.fill"
        case "sop", "pcos":
            return "leaf.circle.fill"
        case "hsg":
            return "waveform.path.ecg"
        case "endometriosis":
            return "flame.circle.fill"
        case "adenomiosis":
            return "square.circle.fill"
        case "mioma", "myoma":
            return "circle.circle.fill"
        case "polipo", "polyp":
            return "diamond.circle.fill"
        default:
            return "chart.bar.circle.fill"
        }
    }
    
    private var factorColor: Color {
        // Lógica especial para la edad vs otros factores
        if factor.contains("Edad") {
            // La edad es fecundabilidad mensual directa (0.0-0.25)
            // Basado en valores reales de la función calculateAgeFactor:
            // 0.20+ = excelente, 0.15-0.20 = bueno, 0.10-0.15 = moderado, <0.10 = crítico
            if impact >= 0.20 {
                return .green  // Excelente (≥20%)
            } else if impact >= 0.15 {
                return .green  // Bueno (15-20%)
            } else if impact >= 0.10 {
                return .orange // Moderado (10-15%) - 35 años = 13.33%
            } else {
                return .red    // Crítico (<10%)
            }
        } else if factor.contains("AMH") || factor.contains("Reserva Ovárica") {
            // Lógica especial para AMH: 1.0-6.0 es normal, 0.75-1.0 es bajo pero no crítico
            if impact >= 1.0 {
                return .green  // Normal (≥1.0)
            } else if impact >= 0.75 {
                return .orange // Bajo (75-100%)
            } else if impact >= 0.4 {
                return .orange // Muy bajo (40-75%)
            } else {
                return .red    // Crítico (<40%)
            }
        } else {
            // Los otros factores son multiplicadores donde 1.0 = normal
            // >1.0 = favorable, <1.0 = desfavorable
            if impact >= 0.95 {
                return .green  // Favorable (≥95%)
            } else if impact >= 0.8 {
                return .orange // Moderado (80-95%)
            } else {
                return .red    // Crítico (<80%)
            }
        }
    }
    
    private var severityColor: Color {
        if factor.contains("Edad") {
            if impact >= 0.20 {
                return .green
            } else if impact >= 0.15 {
                return .green
            } else if impact >= 0.10 {
                return .orange
            } else {
                return .red
            }
        } else if factor.contains("AMH") || factor.contains("Reserva Ovárica") {
            if impact >= 1.0 {
                return .green
            } else if impact >= 0.75 {
                return .orange
            } else if impact >= 0.4 {
                return .orange
            } else {
                return .red
            }
        } else {
            if impact >= 0.95 {
                return .green
            } else if impact >= 0.8 {
                return .orange
            } else {
                return .red
            }
        }
    }
    
    private var severityDescription: String {
        if factor.contains("Edad") {
            if impact >= 0.20 {
                return "Excelente"
            } else if impact >= 0.15 {
                return "Bueno"
            } else if impact >= 0.10 {
                return "Moderado"
            } else {
                return "Crítico"
            }
        } else if factor.contains("AMH") || factor.contains("Reserva Ovárica") {
            if impact >= 1.0 {
                return "Normal"
            } else if impact >= 0.75 {
                return "Bajo"
            } else if impact >= 0.4 {
                return "Muy Bajo"
            } else {
                return "Crítico"
            }
        } else {
            if impact >= 0.95 {
                return "Favorable"
            } else if impact >= 0.8 {
                return "Moderado"
            } else {
                return "Crítico"
            }
        }
    }
}

struct CategorySummaryCard: View {
    let title: String
    let count: Int
    let color: Color
    let icon: String
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1))
        .cornerRadius(12)
        .onAppear {
            isAnimating = true
        }
    }
}


// MARK: - 🔧 PREVIEW

#Preview {
    Text("FertilityFactorsView Preview")
        .environmentObject(ThemeManager())
}
