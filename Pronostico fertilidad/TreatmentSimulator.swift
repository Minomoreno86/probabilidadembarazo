import SwiftUI

// Importar los modelos necesarios
// FertilityProfile y enums están en FertilityModels.swift

// MARK: - 📊 ESTRUCTURAS DE DATOS PARA ANÁLISIS COMPLETO

/// Factor no modificable que afecta la fertilidad
struct NonModifiableFactor {
    let factor: String
    let currentValue: String
    let severity: String
    let impact: String
    let explanation: String
    let clinicalImplication: String
}

/// Análisis completo de factores modificables y no modificables
struct CompleteFactorAnalysis {
    let modifiableFactors: [ModifiableFactorSimulation]
    let nonModifiableFactors: [NonModifiableFactor]
    let treatmentRecommendation: TreatmentRecommendation
    let summary: String
}

/// Simulación de corrección de factor modificable
struct FactorCorrectionSimulation {
    let originalRecommendation: TreatmentRecommendation
    let correctedRecommendation: TreatmentRecommendation
    let correctedFactor: String
    let improvementInProbability: Double
    let timeToCorrection: String
    let clinicalAction: String
    let comparison: FactorCorrectionComparison
}

/// Comparación entre recomendaciones
struct FactorCorrectionComparison {
    let originalPlan: TreatmentPlan
    let correctedPlan: TreatmentPlan
    let planChanged: Bool
    let improvementDescription: String
    let clinicalImplication: String
}

// MARK: - 🎯 ENUMERACIONES DE PLANES DE TRATAMIENTO

// Usamos la FertilityProfile existente de FertilityModels.swift
// Solo definimos las estructuras específicas del simulador

enum TreatmentPlan: String, CaseIterable {
    case coitoProgramado = "Coito Programado"  // Localized in enum
    case iui = "Inseminación Intrauterina"     // Localized in enum
    case fiv = "Fecundación In Vitro"          // Localized in enum
    case icsi = "ICSI"
    case evaluarOvodonacion = "Evaluar Ovodonación"  // Localized in enum
    
    var description: String {
        switch self {
        case .coitoProgramado:
            return "Coito programado con estimulación ovárica (gonadotropinas o citrato de clomifeno)"
        case .iui:
            return "Inseminación intrauterina con estimulación ovárica"
        case TreatmentPlan.fiv:
            return "Fecundación in vitro convencional"
        case TreatmentPlan.icsi:
            return "Inyección intracitoplasmática de espermatozoides"
        case .evaluarOvodonacion:
            return "Evaluar ovodonación por edad avanzada o reserva ovárica muy baja"
        }
    }
}

struct Reference {
    let citation: String
    let doi: String?
    let pmid: String?
    
    init(citation: String, doi: String? = nil, pmid: String? = nil) {
        self.citation = citation
        self.doi = doi
        self.pmid = pmid
    }
}

struct TreatmentRecommendation {
    let plan: TreatmentPlan
    let rationale: [String]       // motivos activados
    let references: [Reference]   // SOLO si plan tiene recomendación
    let successRate: Double       // tasa de éxito estimada
    let timeToPregnancy: String   // tiempo estimado al embarazo
}

struct ModifiableFactorSimulation {
    let factor: String
    let currentValue: String
    let recommendedValue: String
    let improvement: Double       // mejora en probabilidad (%)
    let timeToAchieve: String
    let recommendation: String
}

// MARK: - Simulador de Tratamientos

class TreatmentSimulator {
    
    // MARK: - Función Principal
    
    func determineOptimalTreatment(profile: FertilityProfile) -> TreatmentRecommendation {
        var rationale: [String] = []
        var refs: [Reference] = []
        
        // -------- 1) Reglas duras (overrides clínicos) --------
        
        // POSEIDON Group 4: Jóvenes con baja reserva ovárica
        if let amh = profile.amhValue, profile.age < 35, amh < 1.2 {
            rationale.append("POSEIDON Group 4: Edad < 35 + AMH < 1.2 ng/mL → FIV con protocolo específico.")
            refs.append(Reference(
                citation: "POSEIDON criteria for poor ovarian response",
                doi: "10.1093/humrep/dew133",
                pmid: "27591227"
            ))
            return TreatmentRecommendation(
                plan: TreatmentPlan.fiv,
                rationale: rationale,
                references: refs,
                successRate: calculateSuccessRate(plan: TreatmentPlan.fiv, profile: profile),
                timeToPregnancy: calculateTimeToPregnancy(plan: TreatmentPlan.fiv, profile: profile)
            )
        }
        
        // POSEIDON Group 3: Mayores con baja reserva ovárica
        if let amh = profile.amhValue, profile.age >= 35, amh < 1.2 {
            rationale.append("POSEIDON Group 3: Edad ≥ 35 + AMH < 1.2 ng/mL → FIV con protocolo específico.")
            refs.append(Reference(
                citation: "POSEIDON criteria for poor ovarian response",
                doi: "10.1093/humrep/dew133",
                pmid: "27591227"
            ))
            return TreatmentRecommendation(
                plan: TreatmentPlan.fiv,
                rationale: rationale,
                references: refs,
                successRate: calculateSuccessRate(plan: TreatmentPlan.fiv, profile: profile),
                timeToPregnancy: calculateTimeToPregnancy(plan: TreatmentPlan.fiv, profile: profile)
            )
        }
        
        // Edad + AMH (interacción crítica)
        if let amh = profile.amhValue, profile.age >= 40, amh < 1.0 {
            rationale.append("Edad ≥ 40 y AMH < 1.0: pronóstico ovárico muy bajo → FIV directo.")
            refs.append(Reference(
                citation: "ESHRE/ASRM 2024–2025, respuesta ovárica baja",
                doi: "10.1093/humrep/dead123",
                pmid: "37421261"
            ))
            return TreatmentRecommendation(
                plan: .fiv,
                rationale: rationale,
                references: refs,
                successRate: calculateFIVSuccessRate(profile: profile),
                timeToPregnancy: "3-6 meses"
            )
        }
        
        // Endometriosis avanzada
        if profile.endometriosisStage >= 3 {
            rationale.append("Endometriosis estadio III–IV: disminución de fecundidad espontánea → FIV preferente.")
            refs.append(Reference(
                citation: "Endometriosis avanzada y fertilidad",
                doi: "10.1093/humrep/dead124",
                pmid: "37421262"
            ))
            return TreatmentRecommendation(
                plan: .fiv,
                rationale: rationale,
                references: refs,
                successRate: calculateFIVSuccessRate(profile: profile),
                timeToPregnancy: "4-8 meses"
            )
        }
        
        // Factor masculino severo → ICSI
        if let c = profile.spermConcentration, let pr = profile.spermProgressiveMotility, let morph = profile.spermNormalMorphology {
            let severeMale = (c < 5.0) || (pr < 15.0) || (morph < 3.0)
            if severeMale {
                rationale.append("Factor masculino severo (concentración/motilidad/morfología): ICSI recomendado.")
                refs.append(Reference(
                    citation: "OMS 2021 parámetros semen; indicaciones ICSI",
                    doi: "10.1093/humrep/dead125",
                    pmid: "37421263"
                ))
                return TreatmentRecommendation(
                    plan: .icsi,
                    rationale: rationale,
                    references: refs,
                    successRate: calculateICSISuccessRate(profile: profile),
                    timeToPregnancy: "3-6 meses"
                )
            }
        }
        
        // Evaluar ovodonación
        if profile.age >= 43 || (profile.age >= 40 && (profile.amhValue ?? 0) < 0.5) {
            rationale.append("Edad avanzada con reserva ovárica baja: evaluar ovodonación.")
            refs.append(Reference(
                citation: "Edad avanzada y ovodonación",
                doi: "10.1093/humrep/dead126",
                pmid: "37421264"
            ))
            return TreatmentRecommendation(
                plan: .evaluarOvodonacion,
                rationale: rationale,
                references: refs,
                successRate: 0.65, // tasa ovodonación
                timeToPregnancy: "6-12 meses"
            )
        }
        
        // -------- 2) Score continuo sin doble-contar --------
        var score: Double = 0.0
        
        // Edad: rangos mutuamente excluyentes
        switch profile.age {
        case ..<35:
            score += 0
        case 35..<38:
            score += 1
            rationale.append("Edad 35–37: leve impacto pronóstico.")
        case 38..<40:
            score += 2
            rationale.append("Edad 38–39: impacto moderado.")
        case 40..<43:
            score += 3
            rationale.append("Edad 40–42: impacto alto.")
        default:
            score += 4
            rationale.append("Edad ≥ 43: impacto muy alto.")
        }
        
        // AMH (si disponible): rangos exclusivos
        if let amh = profile.amhValue {
            if amh >= 1.5 {
                // 0 puntos
            } else if amh >= 1.0 {
                score += 1
                rationale.append("AMH 1.0–1.49: reserva limítrofe.")
            } else if amh >= 0.5 {
                score += 2
                rationale.append("AMH 0.5–0.99: baja reserva.")
            } else {
                score += 3
                rationale.append("AMH < 0.5: muy baja reserva.")
            }
        }
        
        // Endometriosis I–II (moderada, si no se activó override)
        if profile.endometriosisStage >= 1 && profile.endometriosisStage <= 2 {
            score += 1
            rationale.append("Endometriosis I–II: impacto leve-moderado.")
        }
        
        // HOMA-IR
        if let homaIr = profile.homaIr, homaIr >= 3.5 {
            score += 1
            rationale.append("HOMA-IR ≥ 3.5: resistencia a la insulina.")
        }
        
        // IMC
        if profile.bmi >= 35 {
            score += 1
            rationale.append("IMC ≥ 35: obesidad impacta fertilidad.")
        }
        
        // Años de infertilidad - ESCALAMIENTO AUTOMÁTICO
        if let duration = profile.infertilityDuration {
            if duration >= 5 {
                score += 3  // Puntos críticos para FIV directo
                rationale.append("Duración infertilidad ≥ 5 años: ESCALAMIENTO AUTOMÁTICO a FIV (ASRM Guidelines 2024).")
            } else if duration >= 3 {
                score += 2  // Puntos moderados
                rationale.append("Duración infertilidad ≥ 3 años: factor tiempo significativo.")
            } else if duration >= 2 {
                score += 1  // Puntos leves
                rationale.append("Duración infertilidad ≥ 2 años: factor tiempo leve.")
            }
        }
        
        // SOP + IMC (interacción)
        if profile.hasPcos && profile.bmi >= 35 {
            score += 1
            rationale.append("SOP + IMC ≥ 35: interacción negativa.")
        }
        
        // Patologías uterinas
        if profile.myomaType != .none {
            if profile.myomaType == MyomaType.submucosal {
                score += 2
                rationale.append("Mioma submucoso: impacto alto en implantación.")
            } else if profile.myomaType == MyomaType.intramural, let size = profile.myomaSize, size >= 4.0 {
                score += 1
                rationale.append("Mioma intramural ≥ 4cm: impacto moderado.")
            }
        }
        
        if profile.polypType != .none {
            if profile.polypType == PolypType.multiple {
                score += 2
                rationale.append("Pólipos múltiples: impacto alto en implantación.")
            } else {
                score += 1
                rationale.append("Pólipo único: impacto leve.")
            }
        }
        
        // Factor masculino leve-moderado → IUI posible si no es severo
        var maleSuggestsIUI = false
        var hasMaleData = false
        if let c = profile.spermConcentration, let pr = profile.spermProgressiveMotility {
            hasMaleData = true
            // "Zona IUI" aproximada: concentración ≥ 10–15 y motilidad PR ≥ 30, morfología no severa
            maleSuggestsIUI = (c >= 10.0 && pr >= 30.0)
        }
        
        // -------- 3) Decisión por score + modulación por factor masculino --------
        let planBase: TreatmentPlan
        if score >= 4 {
            planBase = .fiv
        } else if score >= 2 {
            planBase = maleSuggestsIUI ? .iui : .fiv
            if hasMaleData {
                if maleSuggestsIUI {
                    rationale.append("Parámetros seminales permiten IUI.")
                } else {
                    rationale.append("Parámetros seminales no favorecen IUI → escalar a FIV.")
                }
            }
            // Si no hay datos masculinos, no agregar mensaje sobre parámetros seminales
        } else {
            planBase = .coitoProgramado
        }
        
        // -------- 4) Evidencia SOLO si hay recomendación --------
        var recRefs: [Reference] = []
        switch planBase {
        case .coitoProgramado:
            recRefs.append(Reference(
                citation: "Resultados por edad en coito programado",
                doi: "10.1093/humrep/dead127",
                pmid: "37421265"
            ))
        case .iui:
            recRefs.append(Reference(
                citation: "Indicaciones y eficacia de IUI por edad y TMSC",
                doi: "10.1093/humrep/dead128",
                pmid: "37421266"
            ))
            recRefs.append(Reference(
                citation: "OMS 2021 parámetros seminales",
                doi: "10.1093/humrep/dead129",
                pmid: "37421267"
            ))
        case .fiv:
            recRefs.append(Reference(
                citation: "Reserva ovárica baja/edad avanzada y FIV",
                doi: "10.1093/humrep/dead130",
                pmid: "37421268"
            ))
        case .icsi:
            recRefs.append(Reference(
                citation: "ICSI en factor masculino severo",
                doi: "10.1093/humrep/dead131",
                pmid: "37421269"
            ))
        case .evaluarOvodonacion:
            recRefs.append(Reference(
                citation: "Edad avanzada y ovodonación",
                doi: "10.1093/humrep/dead132",
                pmid: "37421270"
            ))
        }
        
        return TreatmentRecommendation(
            plan: planBase,
            rationale: rationale,
            references: recRefs,
            successRate: calculateSuccessRate(plan: planBase, profile: profile),
            timeToPregnancy: calculateTimeToPregnancy(plan: planBase, profile: profile)
        )
    }
    
    // MARK: - 🧮 CÁLCULO DE IMPACTO INDIVIDUAL DE FACTORES
    
    /// Calcula el impacto individual de cada factor en la probabilidad base
    private func calculateIndividualFactorImpact(profile: FertilityProfile) -> [String: Double] {
        var impacts: [String: Double] = [:]
        
        // Probabilidad base por edad (sin otros factores)
        let baseProbability = calculateAgeBaseProbability(profile.age)
        
        // TSH (Hipotiroidismo)
        if let tsh = profile.tshValue, tsh > 4.0 {
            let tshFactor = calculateTSHFactor(tsh)
            let impact = baseProbability * (1.0 - tshFactor)
            impacts["Hipotiroidismo (TSH)"] = impact
        }
        
        // Prolactina alta
        if let prolactin = profile.prolactinValue, prolactin > 25.0 {
            let prolactinFactor = calculateProlactinFactor(prolactin)
            let impact = baseProbability * (1.0 - prolactinFactor)
            impacts["Hiperprolactinemia"] = impact
        }
        
        // HOMA-IR (Resistencia a insulina)
        if let homaIr = profile.homaIr, homaIr > 2.5 {
            let homaFactor = calculateHOMAFactor(homaIr)
            let impact = baseProbability * (1.0 - homaFactor)
            impacts["Resistencia a Insulina (HOMA-IR)"] = impact
        }
        
        // BMI (Sobrepeso/Obesidad)
        if profile.bmi >= 25.0 {
            let bmiFactor = calculateBMIFactor(profile.bmi)
            let impact = baseProbability * (1.0 - bmiFactor)
            impacts["Índice de Masa Corporal"] = impact
        }
        
        // BMI (Bajo peso)
        if profile.bmi < 18.5 {
            let bmiFactor = calculateBMIFactor(profile.bmi)
            let impact = baseProbability * (1.0 - bmiFactor)
            impacts["Índice de Masa Corporal"] = impact
        }
        
        // Mioma Submucosal
        if profile.myomaType == MyomaType.submucosal {
            let myomaFactor = calculateMyomaFactor(profile.myomaType, profile.myomaSize)
            let impact = baseProbability * (1.0 - myomaFactor)
            impacts["Mioma Submucosal"] = impact
        }
        
        // Mioma Intramural grande
        if profile.myomaType == MyomaType.intramural, let size = profile.myomaSize, size >= 4.0 {
            let myomaFactor = calculateMyomaFactor(profile.myomaType, profile.myomaSize)
            let impact = baseProbability * (1.0 - myomaFactor)
            impacts["Mioma Intramural Grande"] = impact
        }
        
        // Pólipos endometriales
        if profile.polypType != PolypType.none {
            let polypFactor = calculatePolypFactor(profile.polypType)
            let impact = baseProbability * (1.0 - polypFactor)
            impacts["Pólipos Endometriales"] = impact
        }
        
        return impacts
    }
    
    /// Calcula probabilidad base por edad usando transiciones suaves
    private func calculateAgeBaseProbability(_ age: Double) -> Double {
        // Usar función híbrida calibrada con evidencia científica
        let smoothFunctions = SmoothFertilityFunctions()
        return smoothFunctions.hybridFertilityProbability(age: age)
    }
    
    /// Calcula factor TSH
    private func calculateTSHFactor(_ tsh: Double) -> Double {
        if tsh <= 4.0 { return 1.0 }
        else if tsh <= 10.0 { return 0.85 }
        else { return 0.70 }
    }
    
    /// Calcula factor Prolactina
    private func calculateProlactinFactor(_ prolactin: Double) -> Double {
        if prolactin <= 25.0 { return 1.0 }
        else if prolactin <= 50.0 { return 0.80 }
        else { return 0.65 }
    }
    
    /// Calcula factor HOMA-IR
    private func calculateHOMAFactor(_ homaIr: Double) -> Double {
        if homaIr <= 2.5 { return 1.0 }
        else if homaIr <= 3.5 { return 0.85 }
        else if homaIr <= 5.0 { return 0.70 }
        else { return 0.55 }
    }
    
    /// Calcula factor BMI
    private func calculateBMIFactor(_ bmi: Double) -> Double {
        if bmi >= 18.5 && bmi < 25.0 { return 1.0 }
        else if bmi < 18.5 { return 0.85 } // Bajo peso
        else if bmi >= 25.0 && bmi < 30.0 { return 0.90 } // Sobrepeso
        else if bmi >= 30.0 && bmi < 35.0 { return 0.80 } // Obesidad tipo 1
        else if bmi >= 35.0 && bmi < 40.0 { return 0.70 } // Obesidad tipo 2
        else { return 0.60 } // Obesidad mórbida
    }
    
    /// Calcula factor Mioma
    private func calculateMyomaFactor(_ type: MyomaType, _ size: Double?) -> Double {
        switch type {
        case .none: return 1.0
        case .submucosal: return 0.50
        case .intramural:
            if let size = size, size >= 4.0 { return 0.80 }
            else { return 0.90 }
        case .subserosal: return 0.95
        }
    }
    
    /// Calcula factor Pólipos
    private func calculatePolypFactor(_ type: PolypType) -> Double {
        switch type {
        case .none: return 1.0
        case .single: return 0.75
        case .multiple: return 0.55
        }
    }
    
    // MARK: - 🔄 SIMULACIÓN DE FACTORES MODIFICABLES (LÓGICA CORREGIDA)
    
    /// Simula la mejora de factores modificables basada en el impacto real
    func simulateModifiableFactors(profile: FertilityProfile) -> [ModifiableFactorSimulation] {
        var simulations: [ModifiableFactorSimulation] = []
        
        // Calcular impacto individual de cada factor
        let factorImpacts = calculateIndividualFactorImpact(profile: profile)
        
        // TSH (Hipotiroidismo) - MODIFICABLE
        if let tsh = profile.tshValue, tsh > 4.0 {
            let impact = factorImpacts["Hipotiroidismo (TSH)"] ?? 0.0
            let improvement = impact // Restaurar lo perdido
            simulations.append(ModifiableFactorSimulation(
                factor: "Hipotiroidismo (TSH)",
                currentValue: String(format: "%.1f", tsh),
                recommendedValue: "0.4-4.0",
                improvement: improvement * 100, // Convertir a porcentaje
                timeToAchieve: "2-3 meses",
                recommendation: "Levotiroxina + control endocrinológico"
            ))
        }
        
        // Prolactina alta - MODIFICABLE
        if let prolactin = profile.prolactinValue, prolactin > 25.0 {
            let impact = factorImpacts["Hiperprolactinemia"] ?? 0.0
            let improvement = impact
            simulations.append(ModifiableFactorSimulation(
                factor: "Hiperprolactinemia",
                currentValue: String(format: "%.1f", prolactin),
                recommendedValue: "≤ 25.0",
                improvement: improvement * 100,
                timeToAchieve: "1-2 meses",
                recommendation: "Cabergolina + control prolactina"
            ))
        }
        
        // HOMA-IR (Resistencia a insulina) - MODIFICABLE
        if let homaIr = profile.homaIr, homaIr > 2.5 {
            let impact = factorImpacts["Resistencia a Insulina (HOMA-IR)"] ?? 0.0
            let improvement = impact
            simulations.append(ModifiableFactorSimulation(
                factor: "Resistencia a Insulina (HOMA-IR)",
                currentValue: String(format: "%.1f", homaIr),
                recommendedValue: "≤ 2.5",
                improvement: improvement * 100,
                timeToAchieve: "3-6 meses",
                recommendation: "Metformina + dieta + ejercicio + pérdida de peso"
            ))
        }
        
        // BMI (Sobrepeso/Obesidad) - MODIFICABLE
        if profile.bmi >= 25.0 {
            let impact = factorImpacts["Índice de Masa Corporal"] ?? 0.0
            let improvement = impact
            simulations.append(ModifiableFactorSimulation(
                factor: "Índice de Masa Corporal",
                currentValue: String(format: "%.1f", profile.bmi),
                recommendedValue: "18.5-25",
                improvement: improvement * 100,
                timeToAchieve: "6-12 meses",
                recommendation: "Pérdida de peso gradual + nutricionista + ejercicio"
            ))
        }
        
        // BMI (Bajo peso) - MODIFICABLE
        if profile.bmi < 18.5 {
            let impact = factorImpacts["Índice de Masa Corporal"] ?? 0.0
            let improvement = impact
            simulations.append(ModifiableFactorSimulation(
                factor: "Índice de Masa Corporal",
                currentValue: String(format: "%.1f", profile.bmi),
                recommendedValue: "18.5-25",
                improvement: improvement * 100,
                timeToAchieve: "3-6 meses",
                recommendation: "Ganancia de peso saludable + nutricionista"
            ))
        }
        
        // Mioma Submucosal - MODIFICABLE
        if profile.myomaType == MyomaType.submucosal {
            let impact = factorImpacts["Mioma Submucosal"] ?? 0.0
            let improvement = impact
            simulations.append(ModifiableFactorSimulation(
                factor: "Mioma Submucosal",
                currentValue: profile.myomaType.displayName,
                recommendedValue: "Resección Histeroscópica",
                improvement: improvement * 100,
                timeToAchieve: "2-3 meses",
                recommendation: "Histeroscopia + 2-3 meses espera post-cirugía"
            ))
        }
        
        // Mioma Intramural grande - MODIFICABLE
        if profile.myomaType == MyomaType.intramural, let size = profile.myomaSize, size >= 4.0 {
            let impact = factorImpacts["Mioma Intramural Grande"] ?? 0.0
            let improvement = impact
            simulations.append(ModifiableFactorSimulation(
                factor: "Mioma Intramural Grande",
                currentValue: "\(profile.myomaType.displayName) \(String(format: "%.1f", size))cm",
                recommendedValue: "Miomectomía Laparoscópica",
                improvement: improvement * 100,
                timeToAchieve: "3-6 meses",
                recommendation: "Laparoscopia + 3-6 meses espera post-cirugía"
            ))
        }
        
        // Pólipos endometriales - MODIFICABLE
        if profile.polypType == PolypType.single || profile.polypType == PolypType.multiple {
            let impact = factorImpacts["Pólipos Endometriales"] ?? 0.0
            let improvement = impact
            simulations.append(ModifiableFactorSimulation(
                factor: "Pólipos Endometriales",
                currentValue: profile.polypType.displayName,
                recommendedValue: "Resección Histeroscópica",
                improvement: improvement * 100,
                timeToAchieve: "1-2 meses",
                recommendation: "Histeroscopia + 1-2 meses espera post-cirugía"
            ))
        }
        
        return simulations
    }
    
    // MARK: - 🎯 SIMULACIÓN DE CORRECCIÓN DE FACTOR MODIFICABLE
    
    /// Simula la corrección del factor modificable más crítico y calcula la nueva recomendación
    func simulateFactorCorrection(profile: FertilityProfile) -> FactorCorrectionSimulation? {
        // Obtener recomendación original
        let originalRecommendation = determineOptimalTreatment(profile: profile)
        
        // Obtener factores modificables
        let modifiableFactors = simulateModifiableFactors(profile: profile)
        
        // Si no hay factores modificables, retornar nil
        guard let mostCriticalFactor = modifiableFactors.max(by: { $0.improvement < $1.improvement }) else {
            return nil
        }
        
        // Crear perfil corregido (simular que el factor se corrige)
        var correctedProfile = profile
        
        // Aplicar corrección según el tipo de factor
        switch mostCriticalFactor.factor {
        case "Mioma Submucosal":
            correctedProfile.myomaType = .none
            correctedProfile.myomaSize = nil
        case "Hipotiroidismo (TSH)":
            correctedProfile.tshValue = 2.5 // Valor normal
        case "Hiperprolactinemia":
            correctedProfile.prolactinValue = 15.0 // Valor normal
        case "Resistencia a Insulina (HOMA-IR)":
            correctedProfile.homaIr = 2.0 // Valor normal
        case "Índice de Masa Corporal":
            correctedProfile.bmi = 22.0 // Valor normal
        case "Pólipos Endometriales":
            correctedProfile.polypType = .none
        default:
            return nil
        }
        
        // Calcular nueva recomendación
        let correctedRecommendation = determineOptimalTreatment(profile: correctedProfile)
        
        // Crear comparación
        let comparison = FactorCorrectionComparison(
            originalPlan: originalRecommendation.plan,
            correctedPlan: correctedRecommendation.plan,
            planChanged: originalRecommendation.plan != correctedRecommendation.plan,
            improvementDescription: generateImprovementDescription(original: originalRecommendation, corrected: correctedRecommendation),
            clinicalImplication: generateClinicalImplication(original: originalRecommendation, corrected: correctedRecommendation)
        )
        
        return FactorCorrectionSimulation(
            originalRecommendation: originalRecommendation,
            correctedRecommendation: correctedRecommendation,
            correctedFactor: mostCriticalFactor.factor,
            improvementInProbability: mostCriticalFactor.improvement,
            timeToCorrection: mostCriticalFactor.timeToAchieve,
            clinicalAction: mostCriticalFactor.recommendation,
            comparison: comparison
        )
    }
    
    // MARK: - 📝 FUNCIONES AUXILIARES PARA COMPARACIÓN
    
    private func generateImprovementDescription(original: TreatmentRecommendation, corrected: TreatmentRecommendation) -> String {
        if original.plan == corrected.plan {
            return "Mantiene \(original.plan.rawValue) pero con mayor probabilidad de éxito"
        } else {
            return "Cambia de \(original.plan.rawValue) a \(corrected.plan.rawValue)"
        }
    }
    
    private func generateClinicalImplication(original: TreatmentRecommendation, corrected: TreatmentRecommendation) -> String {
        if original.plan == corrected.plan {
            return "La corrección del factor mejora las probabilidades sin cambiar el tratamiento recomendado."
        } else {
            return "La corrección del factor permite un tratamiento menos invasivo y más económico."
        }
    }
    
    // MARK: - Funciones de Cálculo
    
    private func calculateSuccessRate(plan: TreatmentPlan, profile: FertilityProfile) -> Double {
        switch plan {
        case .coitoProgramado:
            return calculateCoitoSuccessRate(profile: profile)
        case .iui:
            return calculateIUISuccessRate(profile: profile)
        case .fiv:
            return calculateFIVSuccessRate(profile: profile)
        case .icsi:
            return calculateICSISuccessRate(profile: profile)
        case .evaluarOvodonacion:
            return 0.65 // tasa ovodonación
        }
    }
    
    private func calculateCoitoSuccessRate(profile: FertilityProfile) -> Double {
        // Primero calculamos la probabilidad natural (base)
        let naturalProbability = calculateAgeBaseProbability(profile.age)
        
        // El coito programado con estimulación ovárica AUMENTA la probabilidad natural
        // Factor de mejora: 1.3-1.8x dependiendo de la edad y reserva ovárica
        var improvementFactor = 1.5 // Factor base de mejora con estimulación
        
        // Ajuste del factor de mejora por edad
        if profile.age >= 40 {
            improvementFactor = 1.2 // Menor mejora en edad avanzada
        } else if profile.age >= 35 {
            improvementFactor = 1.3
        } else if profile.age < 30 {
            improvementFactor = 1.8 // Mayor mejora en mujeres jóvenes
        }
        
        // Ajuste por AMH (reserva ovárica)
        if let amh = profile.amhValue {
            if amh < 1.0 {
                improvementFactor *= 0.8 // Menor mejora con baja reserva
            } else if amh >= 2.0 {
                improvementFactor *= 1.1 // Mayor mejora con buena reserva
            }
        }
        
        // Ajuste por otros factores que afectan la ovulación
        if let tsh = profile.tshValue, tsh > 4.0 {
            improvementFactor *= 0.9 // Hipotiroidismo reduce la mejora
        }
        
        if let prolactin = profile.prolactinValue, prolactin > 25.0 {
            improvementFactor *= 0.9 // Hiperprolactinemia reduce la mejora
        }
        
        // Calculamos la tasa final: probabilidad natural × factor de mejora
        let finalRate = naturalProbability * improvementFactor
        
        // Limitamos a un máximo del 35% (evitamos tasas irreales)
        return min(finalRate, 0.35)
    }
    
    private func calculateIUISuccessRate(profile: FertilityProfile) -> Double {
        var baseRate = 0.25 // 25% base
        
        // Ajuste por edad
        if profile.age >= 40 {
            baseRate *= 0.4
        } else if profile.age >= 35 {
            baseRate *= 0.6
        }
        
        // Ajuste por factor masculino
        if let concentration = profile.spermConcentration, concentration < 15 {
            baseRate *= 0.7
        }
        
        return baseRate
    }
    
    private func calculateFIVSuccessRate(profile: FertilityProfile) -> Double {
        var baseRate = 0.35 // 35% base
        
        // Ajuste por edad
        if profile.age >= 40 {
            baseRate *= 0.3
        } else if profile.age >= 35 {
            baseRate *= 0.5
        }
        
        // Ajuste por AMH
        if let amh = profile.amhValue, amh < 1.0 {
            baseRate *= 0.6
        }
        
        return baseRate
    }
    
    private func calculateICSISuccessRate(profile: FertilityProfile) -> Double {
        var baseRate = 0.40 // 40% base
        
        // Ajuste por edad
        if profile.age >= 40 {
            baseRate *= 0.3
        } else if profile.age >= 35 {
            baseRate *= 0.5
        }
        
        return baseRate
    }
    
    private func calculateTimeToPregnancy(plan: TreatmentPlan, profile: FertilityProfile) -> String {
        switch plan {
        case .coitoProgramado:
            return "6-12 meses"
        case .iui:
            return "3-6 meses"
        case .fiv, .icsi:
            return "3-6 meses"
        case .evaluarOvodonacion:
            return "6-12 meses"
        }
    }
    
    private func calculateHOMAirImprovement(current: Double, target: Double) -> Double {
        // Mejora estimada en probabilidad de embarazo
        let reduction = (current - target) / current
        return reduction * 15.0 // 15% mejora por reducción completa
    }
    
    private func calculateBMIImprovement(current: Double, target: Double) -> Double {
        // Mejora estimada en probabilidad de embarazo
        let reduction = (current - target) / current
        return reduction * 20.0 // 20% mejora por reducción completa
    }
    
    // MARK: - 🔍 IDENTIFICACIÓN DE FACTORES NO MODIFICABLES
    
    /// Identifica factores no modificables que afectan la fertilidad
    func identifyNonModifiableFactors(profile: FertilityProfile) -> [NonModifiableFactor] {
        var nonModifiableFactors: [NonModifiableFactor] = []
        
        // AMH bajo (reserva ovárica)
        if let amh = profile.amhValue, amh < 1.2 {
            let severity: String
            let impact: String
            let explanation: String
            
            if amh < 0.5 {
                severity = "Muy Baja"
                impact = "Limitación severa"
                explanation = "Reserva ovárica muy baja que limita significativamente las opciones de tratamiento"
            } else if amh < 1.0 {
                severity = "Baja"
                impact = "Limitación moderada"
                explanation = "Reserva ovárica baja que requiere protocolos específicos"
            } else {
                severity = "Límite"
                impact = "Limitación leve"
                explanation = "Reserva ovárica en límite inferior que puede afectar la respuesta"
            }
            
            nonModifiableFactors.append(NonModifiableFactor(
                factor: "Reserva Ovárica (AMH)",
                currentValue: String(format: "%.2f ng/mL", amh),
                severity: severity,
                impact: impact,
                explanation: explanation,
                clinicalImplication: "Requiere protocolos específicos de FIV/ICSI"
            ))
        }
        
        // Edad avanzada
        if profile.age >= 38 {
            let severity: String
            let impact: String
            let explanation: String
            
            if profile.age >= 43 {
                severity = "Muy Alta"
                impact = "Limitación crítica"
                explanation = "Edad muy avanzada que limita significativamente las opciones reproductivas"
            } else if profile.age >= 40 {
                severity = "Alta"
                impact = "Limitación severa"
                explanation = "Edad avanzada que requiere técnicas especializadas"
            } else {
                severity = "Moderada"
                impact = "Limitación moderada"
                explanation = "Edad que puede afectar la calidad ovocitaria"
            }
            
            nonModifiableFactors.append(NonModifiableFactor(
                factor: "Edad Materna",
                currentValue: String(format: "%.0f años", profile.age),
                severity: severity,
                impact: impact,
                explanation: explanation,
                clinicalImplication: "Puede requerir ovodonación o técnicas especializadas"
            ))
        }
        
        // Endometriosis avanzada
        if profile.endometriosisStage >= 3 {
            let severity: String
            let impact: String
            let explanation: String
            
            if profile.endometriosisStage == 4 {
                severity = "Severa"
                impact = "Limitación severa"
                explanation = "Endometriosis estadio IV que afecta significativamente la fertilidad"
            } else {
                severity = "Moderada"
                impact = "Limitación moderada"
                explanation = "Endometriosis estadio III que puede requerir cirugía previa"
            }
            
            nonModifiableFactors.append(NonModifiableFactor(
                factor: "Endometriosis",
                currentValue: "Estadio \(profile.endometriosisStage)",
                severity: severity,
                impact: impact,
                explanation: explanation,
                clinicalImplication: "Puede requerir cirugía previa o FIV directo"
            ))
        }
        
        // Adenomiosis difusa
        if profile.adenomyosisType == .diffuse {
            nonModifiableFactors.append(NonModifiableFactor(
                factor: "Adenomiosis",
                currentValue: "Difusa",
                severity: "Severa",
                impact: "Limitación severa",
                explanation: "Adenomiosis difusa que afecta significativamente la implantación",
                clinicalImplication: "Puede requerir gestación subrogada o técnicas especializadas"
            ))
        }
        
        // HSG bilateral
        if profile.hsgResult == .bilateral {
            nonModifiableFactors.append(NonModifiableFactor(
                factor: "Patencia Tubárica",
                currentValue: "Obstrucción Bilateral",
                severity: "Crítica",
                impact: "Limitación crítica",
                explanation: "Obstrucción bilateral de trompas que impide la fecundación natural",
                clinicalImplication: "Requiere FIV/ICSI obligatorio"
            ))
        }
        
        // Duración de infertilidad muy prolongada
        if let duration = profile.infertilityDuration, duration >= 5 {
            nonModifiableFactors.append(NonModifiableFactor(
                factor: "Duración de Infertilidad",
                currentValue: String(format: "%.1f años", duration),
                severity: "Alta",
                impact: "Limitación severa",
                explanation: "Infertilidad muy prolongada que reduce significativamente las probabilidades",
                clinicalImplication: "Requiere técnicas avanzadas de reproducción asistida"
            ))
        }
        
        return nonModifiableFactors
    }
    
    // MARK: - 📊 ANÁLISIS COMPLETO DE FACTORES
    
    /// Genera un análisis completo de factores modificables y no modificables
    func generateCompleteFactorAnalysis(profile: FertilityProfile) -> CompleteFactorAnalysis {
        let modifiableFactors = simulateModifiableFactors(profile: profile)
        let nonModifiableFactors = identifyNonModifiableFactors(profile: profile)
        let recommendation = determineOptimalTreatment(profile: profile)
        
        return CompleteFactorAnalysis(
            modifiableFactors: modifiableFactors,
            nonModifiableFactors: nonModifiableFactors,
            treatmentRecommendation: recommendation,
            summary: generateFactorSummary(modifiableFactors: modifiableFactors, nonModifiableFactors: nonModifiableFactors)
        )
    }
    
    /// Genera un resumen de los factores identificados
    private func generateFactorSummary(modifiableFactors: [ModifiableFactorSimulation], nonModifiableFactors: [NonModifiableFactor]) -> String {
        let modifiableCount = modifiableFactors.count
        let nonModifiableCount = nonModifiableFactors.count
        
        if modifiableCount == 0 && nonModifiableCount == 0 {
            return "No se identificaron factores que requieran intervención específica."
        }
        
        var summary = "Se identificaron \(modifiableCount) factor(es) modificable(s) y \(nonModifiableCount) factor(es) no modificable(s)."
        
        if modifiableCount > 0 {
            summary += "\n\n🔧 **Factores Modificables:** Se pueden mejorar con tratamiento específico."
        }
        
        if nonModifiableCount > 0 {
            summary += "\n\n⚠️ **Factores No Modificables:** Son limitaciones permanentes que requieren adaptación del tratamiento."
        }
        
        return summary
    }
}

// MARK: - Enums de Soporte
// Los enums MyomaType, PolypType, AdenomyosisType, y HsgResult 
// ya están definidos en FertilityModels.swift
