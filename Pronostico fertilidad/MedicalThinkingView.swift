import SwiftUI

// MARK: - Vista del Modo de Pensamiento Médico
// Muestra el razonamiento paso a paso basado en GLM-4.5

struct MedicalThinkingView: View {
    @StateObject private var thinkingEngine = MedicalThinkingEngine()
    @State private var thinkingResult: MedicalThinkingResult?
    @State private var showingThinkingMode = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "brain.head.profile")
                        .font(.title)
                        .foregroundColor(.blue)
                    
                    Text("Modo de Pensamiento Médico")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                
                Text("Análisis paso a paso con evidencia científica")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            
            // Botón para activar modo de pensamiento
            Button(action: {
                activateThinkingMode()
            }) {
                HStack {
                    Image(systemName: "brain")
                        .font(.title2)
                    Text("Activar Análisis Profundo")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(12)
            }
            .disabled(showingThinkingMode)
            
            // Resultados del modo de pensamiento
            if let result = thinkingResult {
                ThinkingResultView(result: result)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Pensamiento Médico")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func activateThinkingMode() {
        showingThinkingMode = true
        
        // Simular procesamiento
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            thinkingResult = thinkingEngine.analyzeWithThinkingMode()
            showingThinkingMode = false
        }
    }
}

// MARK: - Vista de Resultados del Pensamiento

struct ThinkingResultView: View {
    let result: MedicalThinkingResult
    
    var body: some View {
        VStack(spacing: 16) {
            // Header de resultados
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                    
                    Text("Análisis Completado")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                
                HStack {
                    Text("Confianza General:")
                        .font(.subheadline)
                    
                    Text("\(Int(result.overallConfidence * 100))%")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Spacer()
                }
            }
            .padding()
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(12)
            
            // Pasos de razonamiento
            VStack(spacing: 12) {
                Text("Pasos de Razonamiento")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(result.reasoningSteps) { step in
                    ReasoningStepCard(step: step)
                }
            }
            
            // Validación clínica
            ClinicalValidationCard(validation: result.clinicalValidation)
            
            // Evaluación de riesgos
            RiskAssessmentCard(assessment: result.riskAssessment)
            
            // Plan de seguimiento
            FollowUpPlanCard(plan: result.followUpPlan)
        }
    }
}

// MARK: - Tarjeta de Paso de Razonamiento

struct ReasoningStepCard: View {
    let step: MedicalReasoningStep
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header del paso
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("PASO \(step.stepNumber)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(8)
                        
                        Text(step.stepTitle)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Confianza:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("\(Int(step.confidenceLevel * 100))%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
            }
            
            // Contenido expandible
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    // Lógica médica
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Lógica Médica")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(step.medicalLogic)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    // Evidencia clínica
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Evidencia Clínica")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(step.clinicalEvidence)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    // Consideraciones alternativas
                    if !step.alternativeConsiderations.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Consideraciones Alternativas")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            ForEach(step.alternativeConsiderations, id: \.self) { consideration in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .foregroundColor(.orange)
                                        .font(.caption)
                                    
                                    Text(consideration)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    
                    // Referencias médicas
                    if !step.medicalReferences.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Referencias Médicas")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            ForEach(step.medicalReferences, id: \.self) { reference in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "doc.text.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                    
                                    Text(reference)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// MARK: - Tarjeta de Validación Clínica

struct ClinicalValidationCard: View {
    let validation: ClinicalValidation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: validation.isValid ? "checkmark.shield.fill" : "xmark.shield.fill")
                    .foregroundColor(validation.isValid ? .green : .red)
                    .font(.title2)
                
                Text("Validación Clínica")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(Int(validation.validationScore * 100))%")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(validation.isValid ? .green : .red)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(validation.validationCriteria) { criterion in
                    HStack {
                        Image(systemName: criterion.isMet ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(criterion.isMet ? .green : .red)
                            .font(.caption)
                        
                        Text(criterion.criterion)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text(criterion.explanation)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// MARK: - Tarjeta de Evaluación de Riesgos

struct RiskAssessmentCard: View {
    let assessment: RiskAssessment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(riskColor)
                    .font(.title2)
                
                Text("Evaluación de Riesgos")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(assessment.overallRisk.rawValue)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(riskColor)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(assessment.specificRisks) { risk in
                    HStack {
                        Circle()
                            .fill(Color(risk.severity.color))
                            .frame(width: 8, height: 8)
                        
                        Text(risk.riskType)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text("\(Int(risk.probability * 100))%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var riskColor: Color {
        switch assessment.overallRisk {
        case .low: return .green
        case .moderate: return .orange
        case .high: return .red
        case .critical: return .purple
        }
    }
}

// MARK: - Tarjeta de Plan de Seguimiento

struct FollowUpPlanCard: View {
    let plan: FollowUpPlan
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text("Plan de Seguimiento")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                // Acciones inmediatas
                VStack(alignment: .leading, spacing: 6) {
                    Text("Acciones Inmediatas")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    ForEach(plan.immediateActions, id: \.self) { action in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "bolt.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                            
                            Text(action)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Seguimiento a corto plazo
                VStack(alignment: .leading, spacing: 6) {
                    Text("Seguimiento a Corto Plazo")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    ForEach(plan.shortTermFollowUp) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.blue)
                                .font(.caption)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.action)
                                    .font(.body)
                                    .fontWeight(.medium)
                                
                                Text("Timeline: \(item.timeline)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        MedicalThinkingView()
    }
}
