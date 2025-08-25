import SwiftUI

/// Vista que ejecuta INMEDIATAMENTE el plan de acción de Qwen
/// para diagnosticar y resolver problemas de localización
struct QwenActionPlanView: View {
    @StateObject private var validationRunner = ValidationRunner()
    @StateObject private var localizationValidator = LocalizationValidator()
    @StateObject private var translationMemory = TranslationMemory()
    @State private var showingReport = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header con título del plan de acción
                headerSection
                
                // Estado actual de la validación
                currentPhaseSection
                
                // Botón para ejecutar el plan completo
                executeButton
                
                // Resultados de las fases
                phaseResultsSection
                
                // Reporte ejecutivo
                executiveReportSection
                
                Spacer()
            }
            .padding()
            .navigationTitle("Plan de Acción Qwen")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            // Ejecutar validación automáticamente al aparecer
            Task {
                await executeFullValidation()
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("🚨 PLAN DE ACCIÓN INMEDIATO QWEN")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            Text("Implementación automática de recomendaciones críticas")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.red.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red.opacity(0.3), lineWidth: 2)
                )
        )
    }
    
    // MARK: - Current Phase Section
    private var currentPhaseSection: some View {
        VStack(spacing: 16) {
            Text("FASE ACTUAL")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(validationRunner.currentPhase.description)
                .font(.title3)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
            
            // Progress bar
            ProgressView(value: Double(ValidationRunner.ValidationPhase.allCases.firstIndex(of: validationRunner.currentPhase) ?? 0), total: Double(ValidationRunner.ValidationPhase.allCases.count - 1))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.1))
        )
    }
    
    // MARK: - Execute Button
    private var executeButton: some View {
        Button(action: {
            Task {
                await executeFullValidation()
            }
        }) {
            HStack {
                Image(systemName: "play.circle.fill")
                Text("EJECUTAR PLAN COMPLETO QWEN")
            }
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.green)
            )
        }
        .disabled(validationRunner.currentPhase == .completed)
    }
    
    // MARK: - Phase Results Section
    private var phaseResultsSection: some View {
        VStack(spacing: 16) {
            Text("RESULTADOS POR FASE")
                .font(.headline)
                .fontWeight(.semibold)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(ValidationRunner.ValidationPhase.allCases, id: \.self) { phase in
                        if let result = validationRunner.phaseResults[phase] {
                            phaseResultCard(phase: phase, result: result)
                        }
                    }
                }
            }
            .frame(maxHeight: 300)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private func phaseResultCard(phase: ValidationRunner.ValidationPhase, result: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(phase.rawValue.uppercased())
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                statusIcon(for: result)
            }
            
            Text(result)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        )
    }
    
    private func statusIcon(for result: String) -> some View {
        if result.contains("✅") {
            return Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        } else if result.contains("🚨") || result.contains("❌") {
            return Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
        } else if result.contains("⚠️") {
            return Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.orange)
        } else {
            return Image(systemName: "info.circle.fill")
                .foregroundColor(.blue)
        }
    }
    
    // MARK: - Executive Report Section
    private var executiveReportSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingReport = true
            }) {
                HStack {
                    Image(systemName: "doc.text.fill")
                    Text("VER REPORTE EJECUTIVO COMPLETO")
                }
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange)
                )
            }
            
            if validationRunner.currentPhase == .completed {
                VStack(spacing: 8) {
                    Text("VALIDACIÓN COMPLETADA")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("Total problemas: \(validationRunner.totalIssues)")
                        .font(.subheadline)
                    
                    Text("Problemas críticos: \(validationRunner.criticalIssues)")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green.opacity(0.1))
                )
            }
        }
        .sheet(isPresented: $showingReport) {
            NavigationView {
                ScrollView {
                    Text(validationRunner.generateExecutiveReport())
                        .font(.system(.body, design: .monospaced))
                        .padding()
                }
                .navigationTitle("Reporte Ejecutivo Qwen")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Cerrar") {
                            showingReport = false
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Validation Execution
    private func executeFullValidation() async {
        // Ejecutar el plan de acción completo de Qwen
        await validationRunner.executeQwenActionPlan()
        
        // Ejecutar validación del LocalizationValidator
        await localizationValidator.performFullValidation()
        
        // Generar reporte de consistencia CAT
        let consistencyReport = translationMemory.generateConsistencyReport()
        print("=== REPORTE DE CONSISTENCIA CAT ===\n\(consistencyReport)")
    }
}

// MARK: - Preview
#Preview {
    QwenActionPlanView()
}
