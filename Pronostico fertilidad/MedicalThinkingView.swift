import SwiftUI

// MARK: - Vista del Modo de Pensamiento Médico
// Muestra el razonamiento paso a paso basado en GLM-4.5

struct MedicalThinkingView: View {
    @StateObject private var thinkingEngine = MedicalThinkingEngine()
    @State private var thinkingResult: MedicalThinkingResult?
    @State private var showingThinkingMode = false
    @EnvironmentObject var localizationManager: LocalizationManager
    
    // Recibir el perfil de fertilidad desde la vista padre
    let fertilityProfile: FertilityProfile
    
    init(fertilityProfile: FertilityProfile) {
        self.fertilityProfile = fertilityProfile
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Disclaimer médico crítico - REQUERIDO POR APPLE
                MedicalDisclaimerView(style: .critical)
                
                // Header
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        Text(localizationManager.getLocalizedString("Modo de Pensamiento Médico"))
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    
                    Text(localizationManager.getLocalizedString("Análisis paso a paso con evidencia científica"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Información del perfil del paciente
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                        
                        Text(localizationManager.getLocalizedString("Perfil del Paciente"))
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(format: localizationManager.getLocalizedString("Edad: %d años"), Int(fertilityProfile.age)))
                            .font(.subheadline)
                        if let amh = fertilityProfile.amhValue {
                            Text(String(format: localizationManager.getLocalizedString("AMH: %.2f ng/mL"), amh))
                                .font(.subheadline)
                        }
                        if let tsh = fertilityProfile.tshValue {
                            Text(String(format: localizationManager.getLocalizedString("TSH: %.2f mIU/L"), tsh))
                                .font(.subheadline)
                        }
                        Text(String(format: localizationManager.getLocalizedString("BMI: %.1f"), fertilityProfile.bmi))
                            .font(.subheadline)
                        
                        // Variables ginecológicas
                        if fertilityProfile.polypType != .none {
                            Text(String(format: localizationManager.getLocalizedString("Pólipos: %@"), fertilityProfile.polypType.displayName))
                                .font(.subheadline)
                                .foregroundColor(.orange)
                        }
                        if fertilityProfile.myomaType != .none {
                            Text(String(format: localizationManager.getLocalizedString("Miomas: %@"), fertilityProfile.myomaType.rawValue))
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                        if fertilityProfile.endometriosisStage > 0 {
                            Text(String(format: localizationManager.getLocalizedString("Endometriosis: Estadio %d"), fertilityProfile.endometriosisStage))
                                .font(.subheadline)
                                .foregroundColor(.purple)
                        }
                        if fertilityProfile.hasPcos {
                            Text(localizationManager.getLocalizedString("SOP: Presente"))
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        
                        // Factor masculino
                        if let spermConc = fertilityProfile.spermConcentration {
                            Text(String(format: localizationManager.getLocalizedString("Concentración esperm.: %.1f M/mL"), spermConc))
                                .font(.subheadline)
                                .foregroundColor(spermConc < 15.0 ? .red : .green)
                        }
                        if let motility = fertilityProfile.spermProgressiveMotility {
                            Text(String(format: localizationManager.getLocalizedString("Motilidad progresiva: %.1f%%"), motility))
                                .font(.subheadline)
                                .foregroundColor(motility < 32.0 ? .red : .green)
                        }
                        if let morphology = fertilityProfile.spermNormalMorphology {
                            Text(String(format: localizationManager.getLocalizedString("Morfología normal: %.1f%%"), morphology))
                                .font(.subheadline)
                                .foregroundColor(morphology < 4.0 ? .red : .green)
                        }
                        if let volume = fertilityProfile.semenVolume {
                            Text(String(format: localizationManager.getLocalizedString("Volumen seminal: %.1f mL"), volume))
                                .font(.subheadline)
                                .foregroundColor(volume < 1.5 ? .orange : .green)
                        }
                        if let dnaFrag = fertilityProfile.spermDNAFragmentation {
                            Text(String(format: localizationManager.getLocalizedString("Fragmentación DNA: %.1f%%"), dnaFrag))
                                .font(.subheadline)
                                .foregroundColor(dnaFrag > 30.0 ? .red : .green)
                        }
                        if fertilityProfile.hasVaricocele {
                            Text(localizationManager.getLocalizedString("Varicocele: Sí"))
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                        if fertilityProfile.seminalCulturePositive {
                            Text(localizationManager.getLocalizedString("Cultivo seminal: Positivo"))
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                        
                        // Duración de infertilidad
                        if let duration = fertilityProfile.infertilityDuration {
                            Text(String(format: localizationManager.getLocalizedString("Duración infertilidad: %.1f años"), duration))
                                .font(.subheadline)
                                .foregroundColor(duration >= 2.0 ? .red : .green)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Botón para activar modo de pensamiento
                Button(action: {
                    print("🔍 DEBUG: Botón presionado!")
                    activateThinkingMode()
                }) {
                    HStack {
                        if showingThinkingMode {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "brain")
                                .font(.title2)
                        }
                        Text(showingThinkingMode ? localizationManager.getLocalizedString("Analizando...") : localizationManager.getLocalizedString("Activar Análisis Profundo"))
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: showingThinkingMode ? [Color.gray, Color.gray.opacity(0.8)] : [Color.blue, Color.blue.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: showingThinkingMode ? .gray.opacity(0.3) : .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    .scaleEffect(showingThinkingMode ? 0.98 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: showingThinkingMode)
                }
                .disabled(showingThinkingMode)
                
                // Mensaje de estado
                if showingThinkingMode {
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(1.2)
                        
                        Text(localizationManager.getLocalizedString("Ejecutando análisis médico profundo..."))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
                
                // Resultados del modo de pensamiento
                if let result = thinkingResult {
                    VStack(spacing: 16) {
                        // Indicador de éxito
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                            
                            Text(localizationManager.getLocalizedString("¡Análisis Completado!"))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                        
                        // Vista de resultados
                        ThinkingResultView(result: result)
                    }
                }
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle(localizationManager.getLocalizedString("Pensamiento Médico"))
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            // Permitir pull-to-refresh
            if !showingThinkingMode {
                activateThinkingMode()
            }
        }
    }
    
    private func activateThinkingMode() {
        print("🔍 DEBUG: Botón presionado - iniciando análisis...")
        showingThinkingMode = true
        
        // Simular procesamiento con indicador visual
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("🔍 DEBUG: Generando resultado del análisis...")
            thinkingResult = thinkingEngine.analyzeWithThinkingMode(profile: fertilityProfile)
            showingThinkingMode = false
            print("🔍 DEBUG: Análisis completado - resultado: \(thinkingResult != nil ? "SUCCESS" : "FAILED")")
        }
    }
}

// MARK: - Vista de Resultados del Pensamiento

struct ThinkingResultView: View {
    let result: MedicalThinkingResult
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(spacing: 16) {
            // Header de resultados
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                    
                    Text(localizationManager.getLocalizedString("Análisis Completado"))
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                
                HStack {
                    Text(localizationManager.getLocalizedString("Confianza General:"))
                        .font(.subheadline)
                    
                    Text(String(format: localizationManager.getLocalizedString("Confianza General: %@%%"), String(Int(result.overallConfidence * 100))))
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
                Text(localizationManager.getLocalizedString("Pasos de Razonamiento"))
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
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header del paso
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(String(format: localizationManager.getLocalizedString("PASO %d"), step.stepNumber))
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
                        Text(localizationManager.getLocalizedString("Confianza:"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(String(format: localizationManager.getLocalizedString("Nivel de Confianza: %@%%"), String(Int(step.confidenceLevel * 100))))
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
                        Text(localizationManager.getLocalizedString("Lógica Médica"))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(step.medicalLogic)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    // Evidencia clínica
                    VStack(alignment: .leading, spacing: 4) {
                        Text(localizationManager.getLocalizedString("Evidencia Clínica"))
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
                            Text(localizationManager.getLocalizedString("Consideraciones Alternativas"))
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
                            Text(localizationManager.getLocalizedString("Referencias Médicas"))
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
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: validation.isValid ? "checkmark.shield.fill" : "xmark.shield.fill")
                    .foregroundColor(validation.isValid ? .green : .red)
                    .font(.title2)
                
                Text(localizationManager.getLocalizedString("Validación Clínica"))
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(String(format: localizationManager.getLocalizedString("Puntuacion de Validacion: %@%%"), String(Int(validation.validationScore * 100))))
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
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(riskColor)
                    .font(.title2)
                
                Text(localizationManager.getLocalizedString("Evaluación de Riesgos"))
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
                        
                        Text(String(format: localizationManager.getLocalizedString("Probabilidad de Riesgo: %@%%"), String(Int(risk.probability * 100))))
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
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text(localizationManager.getLocalizedString("Plan de Seguimiento"))
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                // Acciones inmediatas
                VStack(alignment: .leading, spacing: 6) {
                    Text(localizationManager.getLocalizedString("Acciones Inmediatas"))
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
                    Text(localizationManager.getLocalizedString("Seguimiento a Corto Plazo"))
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
                                
                                Text(String(format: localizationManager.getLocalizedString("Timeline: %@"), item.timeline))
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
        MedicalThinkingView(fertilityProfile: FertilityProfile(age: 30, height: 165, weight: 65, amhValue: 2.5, tshValue: 2.0))
    }
}
