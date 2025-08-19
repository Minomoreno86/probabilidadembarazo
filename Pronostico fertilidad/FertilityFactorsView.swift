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
            .background(colors.cardBackground)
            .cornerRadius(12)
        }
        .padding()
        .background(colors.surfaceBackground)
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
                ForEach(result.keyFactors, id: \.0) { factor in
                    SuperFactorCard(
                        name: factor.0,
                        impact: factor.1,
                        description: factor.2,
                        colors: colors
                    )
                }
            }
        }
        .padding()
        .background(colors.surfaceBackground)
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
                    icon: "checkmark.circle.fill",
                    colors: colors
                )
                
                CategorySummaryCard(
                    title: "Moderados",
                    count: neutralFactorsCount,
                    color: .orange,
                    icon: "exclamationmark.triangle.fill",
                    colors: colors
                )
                
                CategorySummaryCard(
                    title: "Críticos",
                    count: criticalFactorsCount,
                    color: .red,
                    icon: "xmark.circle.fill",
                    colors: colors
                )
            }
        }
        .padding()
        .background(colors.surfaceBackground)
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
        result.keyFactors.compactMap { factor in
            let color = factorColor(for: factor.1, factorName: factor.0)
            return color == .red ? 1 : nil
        }.count
    }
    
    private func factorColor(for impact: Double, factorName: String) -> Color {
        switch factorName {
        case "Edad":
            return ageFactorColor(impact: impact)
        case "AMH":
            return amhFactorColor(impact: impact)
        default:
            return generalFactorColor(impact: impact)
        }
    }
    
    private func ageFactorColor(impact: Double) -> Color {
        switch impact {
        case 0.20...1.0:
            return .green
        case 0.15..<0.20:
            return .green
        case 0.10..<0.15:
            return .orange
        default:
            return .red
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

// MARK: - 🎯 TARJETA DE FACTOR SUPER

struct SuperFactorCard: View {
    let name: String
    let impact: Double
    let description: String
    let colors: ThemeColors
    
    var body: some View {
        VStack(spacing: 12) {
            // Icono y título
            HStack {
                Image(systemName: factorIcon)
                    .foregroundColor(severityColor)
                    .font(.title2)
                Spacer()
                Text(name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(colors.textPrimary)
            }
            
            // Valor del impacto
            HStack {
                Text(String(format: "%.2f", impact))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(severityColor)
                Spacer()
            }
            
            // Descripción
            Text(description)
                .font(.caption)
                .foregroundColor(colors.textSecondary)
                .multilineTextAlignment(.leading)
            
            // Indicador de severidad
            HStack {
                Circle()
                    .fill(severityColor)
                    .frame(width: 8, height: 8)
                Text(severityDescription)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(severityColor)
                Spacer()
            }
        }
        .padding()
        .background(colors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(severityColor.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var factorIcon: String {
        switch name {
        case "Edad":
            return "person.fill"
        case "AMH":
            return "drop.fill"
        case "TSH":
            return "brain.head.profile"
        case "IMC":
            return "scalemass.fill"
        case "HSG":
            return "tube.connect.and.outlet"
        default:
            return "chart.bar.fill"
        }
    }
    
    private var severityColor: Color {
        return factorColor
    }
    
    private var severityDescription: String {
        switch factorColor {
        case .green:
            return "Favorable"
        case .orange:
            return "Moderado"
        case .red:
            return "Crítico"
        default:
            return "Neutral"
        }
    }
    
    private var factorColor: Color {
        switch name {
        case "Edad":
            return ageFactorColor(impact: impact)
        case "AMH":
            return amhFactorColor(impact: impact)
        default:
            return generalFactorColor(impact: impact)
        }
    }
    
    private func ageFactorColor(impact: Double) -> Color {
        switch impact {
        case 0.20...1.0:
            return .green
        case 0.15..<0.20:
            return .green
        case 0.10..<0.15:
            return .orange
        default:
            return .red
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

// MARK: - 📊 TARJETA DE RESUMEN DE CATEGORÍA

struct CategorySummaryCard: View {
    let title: String
    let count: Int
    let color: Color
    let icon: String
    let colors: ThemeColors
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(colors.textSecondary)
            
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(colors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - 🔧 PREVIEW

#Preview {
    FertilityFactorsView(
        result: ImprovedFertilityEngine.ComprehensiveFertilityResult(
            annualProbability: 0.75,
            monthlyProbability: 0.15,
            keyFactors: [
                ("Edad", 0.20, "Edad 30 años"),
                ("AMH", 0.75, "AMH 1.0 ng/mL"),
                ("TSH", 0.80, "TSH 4.0 mIU/L"),
                ("IMC", 0.90, "IMC 25 kg/m²")
            ],
            detailedAnalysis: "Análisis detallado...",
            recommendations: ["Recomendación 1", "Recomendación 2"]
        ),
        profile: FertilityProfile()
    )
    .environmentObject(ThemeManager())
}
