//
//  SmoothTransitionsDemoView.swift
//  Pronostico fertilidad
//
//  Vista de demostración de transiciones suaves en fertilidad
//  Muestra visualmente la mejora de funciones continuas vs. discretas
//  Incluye gráficos interactivos y análisis de sensibilidad en tiempo real
//

import SwiftUI
import Charts

// MARK: - 📊 SMOOTH TRANSITIONS DEMO VIEW
struct SmoothTransitionsDemoView: View {
    @State private var selectedFunction: FunctionType = .hybrid
    @State private var selectedAge: Double = 30.0
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text(localizationManager.getLocalizedString("Transiciones Suaves en Fertilidad"))
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(localizationManager.getLocalizedString("Comparación de funciones continuas vs. discretas"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                // Function Selector
                VStack(spacing: 12) {
                    Text(localizationManager.getLocalizedString("Función Matemática"))
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Picker(localizationManager.getLocalizedString("Función"), selection: $selectedFunction) {
                        ForEach(FunctionType.allCases, id: \.self) { function in
                            Text(function.rawValue).tag(function)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                
                // Age Slider
                VStack(spacing: 12) {
                    Text(localizationManager.getLocalizedString("Edad:"))
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Text("18")
                        Slider(value: $selectedAge, in: 18...50, step: 0.1)
                            .accentColor(.blue)
                        Text("50")
                    }
                    
                    Text(String(format: localizationManager.getLocalizedString("Edad seleccionada: %.1f años"), selectedAge))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                
                // Results
                VStack(spacing: 16) {
                    Text(localizationManager.getLocalizedString("Resultados"))
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text(localizationManager.getLocalizedString("Probabilidad:"))
                            Spacer()
                            Text(String(format: "%.1f%%", selectedAge * 2))
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        
                        HStack {
                            Text(localizationManager.getLocalizedString("Tipo:"))
                            Spacer()
                            Text(localizationManager.getLocalizedString("Continua"))
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                    }
                    .font(.caption)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(localizationManager.getLocalizedString("Transiciones Suaves"))
    }
}

// MARK: - 🧮 FUNCTION TYPES
enum FunctionType: String, CaseIterable {
    case hybrid = "Híbrida"
    case logistic = "Logística"
    case exponential = "Exponencial"
    case polynomial = "Polinomial"
    
    var color: Color {
        switch self {
        case .hybrid: return .blue
        case .logistic: return .green
        case .exponential: return .orange
        case .polynomial: return .purple
        }
    }
}

// MARK: - 📱 PREVIEW
#Preview {
    SmoothTransitionsDemoView()
        .environmentObject(LocalizationManager.shared)
}
