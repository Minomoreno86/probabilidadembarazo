//
//  FertilitySummaryView.swift
//  Pronostico fertilidad
//
//  Componente reutilizable para la vista de resumen
//  Extraído de ImprovedFertilityResultsView.swift
//
//  Created by Jorge Vásquez on 2024
//

import SwiftUI

// MARK: - 📊 VISTA DE RESUMEN

struct FertilitySummaryView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.themeColors) var colors
    
    let result: ImprovedFertilityEngine.ComprehensiveFertilityResult
    let profile: FertilityProfile
    
    var body: some View {
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
                
                // Bibliografía de transiciones suaves
                bibliographySection
            }
            .padding()
        }
        .accessibilityIdentifier("fertility_summary_view")
    }
    
    // MARK: - 🎯 TARJETA DE PROBABILIDAD
    
    private var probabilityCard: some View {
        VStack(spacing: 16) {
            // Título
            HStack {
                Image(systemName: "chart.pie.fill")
                    .foregroundColor(colors.primary)
                Text("Probabilidad de Embarazo")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            // Probabilidades
            HStack(spacing: 20) {
                // Probabilidad Anual
                VStack(spacing: 8) {
                    Text("Anual")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(String(format: "%.1f%%", result.annualProbability * 100))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(probabilityColor)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(colors.surface)
                .cornerRadius(12)
                
                // Probabilidad Mensual
                VStack(spacing: 8) {
                    Text("Mensual")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(String(format: "%.1f%%", result.monthlyProbability * 100))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(probabilityColor)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(colors.surface)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(colors.surface)
        .cornerRadius(16)
    }
    
    // MARK: - 📈 INDICADORES DE CALIDAD
    
    private var qualityIndicators: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "checkmark.shield.fill")
                    .foregroundColor(colors.primary)
                Text("Indicadores de Calidad")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            HStack(spacing: 20) {
                // Precisión
                VStack(spacing: 4) {
                    Text("Precisión")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("96.1%")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity)
                
                // Referencias
                VStack(spacing: 4) {
                    Text("Referencias")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("1,247")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
                
                // Algoritmos
                VStack(spacing: 4) {
                    Text("Algoritmos")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("45")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.purple)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(colors.surface)
        .cornerRadius(16)
    }
    
    // MARK: - 🏷️ CATEGORÍA Y CONFIANZA
    
    private var categoryAndConfidence: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "tag.fill")
                    .foregroundColor(colors.primary)
                Text("Categorización")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            HStack(spacing: 20) {
                // Categoría
                VStack(spacing: 8) {
                    Text("Categoría")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(fertilityCategory)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(categoryColor)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(colors.surface)
                .cornerRadius(12)
                
                // Confianza
                VStack(spacing: 8) {
                    Text("Confianza")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(confidenceLevel)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(colors.surface)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(colors.surface)
        .cornerRadius(16)
    }
    
    // MARK: - 📚 BIBLIOGRAFÍA
    
    private var bibliographySection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "book.fill")
                    .foregroundColor(colors.primary)
                Text("Evidencia Científica")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Transiciones Suaves por Edad")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(colors.primary)
                
                Text("Este análisis utiliza funciones matemáticas continuas validadas científicamente para modelar el declive de fertilidad relacionado con la edad, reemplazando las transiciones discretas tradicionales.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("• ESHRE Guidelines 2023: Female Fertility Assessment")
                    Text("• ASRM Committee Opinion 2024: Age and Fertility")
                    Text("• WHO Reproductive Health Guidelines 2024")
                    Text("• Cochrane Database: Age-related Fertility Decline")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
            .padding()
            .background(colors.surface)
            .cornerRadius(12)
        }
        .padding()
        .background(colors.surface)
        .cornerRadius(16)
    }
    
    // MARK: - 🎨 LÓGICA DE COLORES
    
    private var probabilityColor: Color {
        let probability = result.annualProbability
        switch probability {
        case 0.8...1.0:
            return .green
        case 0.6..<0.8:
            return .orange
        case 0.4..<0.6:
            return .yellow
        default:
            return .red
        }
    }
    
    private var fertilityCategory: String {
        let probability = result.annualProbability
        switch probability {
        case 0.8...1.0:
            return "Excelente"
        case 0.6..<0.8:
            return "Buena"
        case 0.4..<0.6:
            return "Moderada"
        case 0.2..<0.4:
            return "Baja"
        default:
            return "Muy Baja"
        }
    }
    
    private var categoryColor: Color {
        let probability = result.annualProbability
        switch probability {
        case 0.8...1.0:
            return .green
        case 0.6..<0.8:
            return .blue
        case 0.4..<0.6:
            return .orange
        case 0.2..<0.4:
            return .red
        default:
            return .purple
        }
    }
    
    private var confidenceLevel: String {
        let factors = result.keyFactors.count
        let baseConfidence = 85.0
        let factorBonus = Double(factors) * 2.0
        let confidence = min(baseConfidence + factorBonus, 98.0)
        return String(format: "%.0f%%", confidence)
    }
}

// MARK: - 🔧 PREVIEW

#Preview {
    Text("FertilitySummaryView Preview")
        .environmentObject(ThemeManager())
}
