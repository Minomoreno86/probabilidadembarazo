//
//  ClinicalBenchmarks.swift
//  Pronostico fertilidad
//
//  Sistema de Benchmarks Clínicos por Subgrupos
//  Basado en evidencia científica ESHRE 2023, ASRM 2024, CDC 2024
//

import Foundation
import SwiftData

// MARK: - 📊 BENCHMARKS CLÍNICOS POR SUBGRUPO

struct ClinicalBenchmarks {
    
    // MARK: - 🧓 1. EDAD MATERNA (sin otros factores)
    
    struct AgeBenchmarks {
        static func getOutcomes(age: Double) -> (coitoEspontaneo: Double, fivNacidoVivo: Double, comentario: String) {
            // Referencias: CDC ART Report 2024, ASRM 2024, ESHRE 2023
            
            switch Int(age) {
            case 18..<35:
                return (20.0, 42.5, "Alta fecundabilidad, buena reserva")
            case 35..<38:
                return (16.5, 37.5, "Comienza descenso leve")
            case 38..<41:
                return (12.0, 27.5, "Reservar para FIV temprana")
            case 41..<43:
                return (6.5, 12.5, "Alta cancelación; considerar PGT-A")
            case 43...:
                return (2.0, 4.0, "Alta recomendación: ovodonación")
            default:
                return (15.0, 30.0, "Rango no típico")
            }
        }
    }
    
    // MARK: - ⚙️ 2. SOP (Fenotipos A-D)
    
    enum PCOSPhenotype: String, CaseIterable {
        case A = "Hiperandrogénico + Anovulatorio + Poliquístico"
        case B = "Hiperandrogénico + Anovulatorio"
        case C = "Hiperandrogénico + Ovario poliquístico"
        case D = "Anovulatorio + Ovario poliquístico"
        
        var ovulationRateLetrozole: Double {
            switch self {
            case .A: return 77.5 // 70-85%
            case .B: return 72.5 // 65-80%
            case .C: return 55.0 // 45-65%
            case .D: return 67.5 // 60-75%
            }
        }
        
        var pregnancyRateIUI: Double {
            switch self {
            case .A: return 16.0 // 12-20%
            case .B: return 14.0 // 10-18%
            case .C: return 11.5 // 8-15%
            case .D: return 13.0 // 10-16%
            }
        }
        
        var clinicalConsiderations: String {
            switch self {
            case .A: return "Mayor resistencia, usar letrozol"
            case .B: return "Responde bien con dosis baja"
            case .C: return "Más respuesta a estimulación"
            case .D: return "Suele requerir FSH/Letrozol"
            }
        }
    }
    
    // MARK: - 📉 3. BAJA RESERVA OVÁRICA (AMH < 1.1 ng/mL o AFC < 5)
    
    struct LowOvarianReserve {
        static func getOutcomes(age: Double, amh: Double) -> (embrionesUtiles: Int, nacidoVivoFIV: Double, acumulativa3Ciclos: Double, protocolo: String) {
            // Referencia: Poseidon Criteria, ESHRE 2023, Wang et al., Reprod Biol Endocrinol 2024
            
            let embryos: Int
            let liveBirth: Double
            let cumulative: Double
            
            switch Int(age) {
            case 18..<35:
                embryos = 3 // 2-4
                liveBirth = 27.5 // 25-30%
                cumulative = 42.5 // 40-45%
            case 35..<40:
                embryos = 2 // 1-3
                liveBirth = 20.0 // 15-25%
                cumulative = 32.5 // 30-35%
            case 40...:
                embryos = 1 // 0-2
                liveBirth = 7.5 // <10%
                cumulative = 15.0 // <20%
            default:
                embryos = 2
                liveBirth = 20.0
                cumulative = 30.0
            }
            
            return (embryos, liveBirth, cumulative, "DuoStim + acumulación + transferencia única")
        }
    }
    
    // MARK: - ⚠️ 4. ENDOMETRIOSIS
    
    enum EndometriosisStage: Int, CaseIterable {
        case none = 0
        case mild = 1      // I
        case moderate = 2  // II
        case severe = 3    // III
        case deep = 4      // IV
        
        var spontaneousPregnancy: Double {
            switch self {
            case .none: return 25.0
            case .mild, .moderate: return 15.0 // 12-18% por año
            case .severe, .deep: return 7.5 // <10% por año
            }
        }
        
        var fivRecommended: Bool {
            return self.rawValue >= 3
        }
        
        var considerations: String {
            switch self {
            case .none: return "Sin endometriosis"
            case .mild, .moderate: return "Letrozol o IIU si trompas permeables"
            case .severe, .deep: return "FIV directamente tras laparoscopía o diagnóstico"
            }
        }
    }
    
    // MARK: - 🧪 5. FACTOR MASCULINO (OMS 2021)
    
    enum MaleFactorSeverity: String, CaseIterable {
        case normal = "Normal"
        case mild = "Leve (TMSC 5-10M)"
        case moderate = "Moderado (TMSC 2-5M)"
        case severe = "Grave (<2M)"
        case azoospermia = "Azoospermia obstructiva"
        
        static func classify(tmsc: Double) -> MaleFactorSeverity {
            switch tmsc {
            case 10...: return .normal
            case 5..<10: return .mild
            case 2..<5: return .moderate
            case 0.1..<2: return .severe
            case 0: return .azoospermia
            default: return .normal
            }
        }
        
        var recommendedTreatment: String {
            switch self {
            case .normal: return "Coito programado o IIU"
            case .mild: return "IIU"
            case .moderate: return "ICSI"
            case .severe: return "ICSI + selección avanzada"
            case .azoospermia: return "TESA + ICSI"
            }
        }
        
        var successRate: Double {
            switch self {
            case .normal: return 20.0
            case .mild: return 11.5 // 8-15% por ciclo IIU
            case .moderate: return 37.5 // 30-45% FIV/ICSI
            case .severe: return 30.0 // 25-35% ICSI
            case .azoospermia: return 37.5 // 30-45% TESA+ICSI
            }
        }
    }
    
    // MARK: - ⚖️ 6. OBESIDAD E IMC ELEVADO
    
    struct ObesityBenchmarks {
        static func getOutcomes(bmi: Double) -> (embarazoEspontaneo: Double, ovulacionLetrozol: Double, exitoFIV: Double, consideraciones: String) {
            // Referencias: ESHRE PCOS 2023, ASRM Obesity 2024, PMID: 37421261
            
            switch bmi {
            case 0..<25:
                return (100.0, 85.0, 45.0, "Ideal fisiológico")
            case 25..<30:
                return (85.0, 75.0, 37.5, "↓ implantación")
            case 30..<35:
                return (75.0, 67.5, 30.0, "↓ receptividad, ↑ cancelación")
            case 35...:
                return (50.0, 57.5, 20.0, "↑ aborto, ↓ blastos")
            default:
                return (85.0, 75.0, 37.5, "BMI no típico")
            }
        }
        
        static func weightLossRecommendation(bmi: Double) -> String {
            if bmi >= 30 {
                return "Reducción de peso ≥5-10% puede restaurar ovulación. Considerar Saxenda/semaglutida si SOP + IMC >30"
            } else if bmi >= 25 {
                return "Reducción de peso ≥5% puede mejorar tasas de implantación"
            }
            return "Mantener peso saludable"
        }
    }
    
    // MARK: - 🧬 7. HIPOTIROIDISMO
    
    struct ThyroidBenchmarks {
        static func getOutcomes(tsh: Double) -> (fertilidad: String, embarazoClinico: Double, abortos: Double, recomendacion: String) {
            // Referencia: ATA 2023, ASRM 2024, PMID: 37092701
            
            switch tsh {
            case 0..<2.5:
                return ("Normal", 42.5, 12.5, "Meta óptima antes FIV")
            case 2.5..<4.5:
                return ("Subclínico (SCTD)", 37.0, 17.5, "Tratar si TPO+ o infertilidad")
            case 4.5...:
                return ("Clínico", 32.0, 22.5, "Tratar con levotiroxina")
            default:
                return ("Desconocido", 40.0, 15.0, "Evaluar TSH")
            }
        }
    }
    
    // MARK: - 🧠 8. HIPERPROLACTINEMIA
    
    struct ProlactinBenchmarks {
        static func getOutcomes(prolactin: Double) -> (efectoOvulacion: String, tasaEmbarazo: Double, tratamiento: String) {
            // Referencia: Endocrine Society 2022, ASRM Hyperprolactinemia 2024
            
            switch prolactin {
            case 0..<25:
                return ("Normal", 20.0, "No requiere tratamiento")
            case 25..<50:
                return ("Oligo/anovulación leve", 16.0, "Cabergolina 0.25-0.5 mg/sem")
            case 50...:
                return ("Anovulación frecuente", 12.0, "Neuroimagen + Cabergolina")
            default:
                return ("Desconocido", 18.0, "Evaluar prolactina")
            }
        }
    }
    
    // MARK: - 🧮 9. HOMA-IR / RESISTENCIA A LA INSULINA
    
    struct InsulinResistance {
        static func getOutcomes(homaIR: Double) -> (ovulacionLetrozol: Double, tasaEmbarazo: Double, consideraciones: String) {
            // Referencia: Legro RS et al., NEJM 2023, PMID: 36222197
            
            switch homaIR {
            case 0..<2.0:
                return (80.0, 22.5, "Buena respuesta")
            case 2.0..<3.5:
                return (67.5, 17.5, "Añadir metformina si SOP")
            case 3.5...:
                return (50.0, 12.5, "Considerar dieta + fármacos")
            default:
                return (70.0, 18.0, "Evaluar HOMA-IR")
            }
        }
        
        static func metforminRecommendation(homaIR: Double, hasPCOS: Bool) -> String {
            if homaIR >= 2.5 {
                return "HOMA ≥2.5 justifica intervención nutricional/farmacológica"
            } else if homaIR >= 2.0 && hasPCOS {
                return "Considerar metformina por SOP asociado"
            }
            return "No requiere metformina"
        }
    }
    
    // MARK: - 🌸 10. PÓLIPOS ENDOMETRIALES
    
    struct EndometrialPolyps {
        static func getOutcomes(size: Double, symptomatic: Bool, fundal: Bool) -> (impactoFertilidad: String, sinReseccion: Double, conHisteroscopia: Double, recomendacion: String) {
            // Referencia: ASRM 2024, PMID: 36851124
            
            if size >= 1.5 || fundal || symptomatic {
                return ("Significativo", 15.0, 40.0, "Resección por histeroscopía mejora tasas clínicas antes de FIV")
            } else if size >= 1.0 {
                return ("Moderado", 20.0, 35.0, "Considerar resección si falla tratamiento")
            } else {
                return ("Bajo", 25.0, 35.0, "Observación vs resección según contexto")
            }
        }
    }
    
    // MARK: - 🔪 11. CIRUGÍAS PÉLVICAS PREVIAS
    
    struct PelvicSurgeryHistory {
        static func getFertilityImpact(surgeryCount: Int, type: String) -> (impactoPorcentaje: Double, comentario: String, recomendacion: String) {
            // Referencia: ASRM Pelvic Surgery 2023, PMID: 36359077
            
            let baseImpact: Double
            let comment: String
            
            switch surgeryCount {
            case 0:
                return (0.0, "Sin cirugías previas", "No limitaciones")
            case 1:
                baseImpact = 5.0
                comment = "Adhesión leve posible"
            case 2...:
                baseImpact = 30.0
                comment = "Adhesión severa, daño tubario"
            default:
                baseImpact = 5.0
                comment = "Evaluación individual"
            }
            
            let adjustedImpact: Double
            if type.lowercased().contains("miomectomía") || type.lowercased().contains("endometriosis") {
                adjustedImpact = min(35.0, baseImpact + 10.0)
            } else {
                adjustedImpact = baseImpact
            }
            
            let recommendation = adjustedImpact > 10 ? "Histero/laparoscopía diagnóstica si infertilidad postquirúrgica" : "Seguimiento estándar"
            
            return (adjustedImpact, comment, recommendation)
        }
    }
    
    // MARK: - 📆 12. AÑOS DE INFERTILIDAD
    
    struct InfertilityDuration {
        static func getOutcomes(duration: Double, age: Double) -> (probabilidadEspontanea: Double, recomendacion: String) {
            // Referencias: NICE 2021, ESHRE 2023, PMID: 36100212
            
            let baseProbability = 100.0
            let adjustedProbability: Double
            let recommendation: String
            
            switch duration {
            case 0..<2:
                adjustedProbability = baseProbability
                recommendation = age < 35 ? "Expectante si <35" : "Evaluación acelerada"
            case 2..<5:
                adjustedProbability = baseProbability * 0.90
                recommendation = "IIU/FIV según factores"
            case 5...:
                adjustedProbability = baseProbability * 0.75
                recommendation = age > 38 ? "FIV directa si >38 años" : "FIV según reserva ovárica"
            default:
                adjustedProbability = baseProbability * 0.85
                recommendation = "Evaluación individualizada"
            }
            
            return (adjustedProbability, recommendation)
        }
    }
    
    // MARK: - 🧫 13. OBSTRUCCIÓN TUBARIA
    
    enum TubalObstruction: String, CaseIterable {
        case none = "Trompas permeables"
        case unilateral = "Obstrucción unilateral"
        case bilateral = "Obstrucción bilateral"
        case hydrosalpinx = "Hidrosalpinx confirmado"
        
        var spontaneousPregnancy: Double {
            switch self {
            case .none: return 20.0
            case .unilateral: return 15.0 // ↓ 10-15%, aún viable
            case .bilateral: return 2.5 // <5%
            case .hydrosalpinx: return 1.0 // <5% + ↓ implantación 50%
            }
        }
        
        var recommendedProcedure: String {
            switch self {
            case .none: return "Coito programado o IIU"
            case .unilateral: return "IIU o coito programado"
            case .bilateral: return "FIV directa"
            case .hydrosalpinx: return "Salpingectomía + FIV"
            }
        }
        
        var reference: String {
            return "ACOG Tubal Factors 2023, PMID: 36491240"
        }
    }
}

// MARK: - 🎯 INTEGRACIÓN CON PERFIL DE FERTILIDAD

/*
extension ClinicalBenchmarks {
    
    static func calculateComprehensiveBenchmarks(profile: FertilityProfile) -> ComprehensiveBenchmarkResult {
        
        // 1. Edad materna
        let ageBenchmark = AgeBenchmarks.getOutcomes(age: profile.age)
        
        // 2. SOP (si aplica)
        let pcosBenchmark: (ovulation: Double, pregnancy: Double, considerations: String)?
        if profile.hasPcos {
            // En implementación real, se determinaría el fenotipo
            let phenotype = PCOSPhenotype.A // Simulado
            pcosBenchmark = (phenotype.ovulationRateLetrozole, phenotype.pregnancyRateIUI, phenotype.clinicalConsiderations)
        } else {
            pcosBenchmark = nil
        }
        
        // 3. Reserva ovárica
        let reserveBenchmark: (embryos: Int, liveBirth: Double, cumulative: Double, protocol: String)?
        if let amh = profile.amhValue, amh < 1.1 {
            let outcomes = LowOvarianReserve.getOutcomes(age: profile.age, amh: amh)
            reserveBenchmark = (outcomes.embrionesUtiles, outcomes.nacidoVivoFIV, outcomes.acumulativa3Ciclos, outcomes.protocolo)
        } else {
            reserveBenchmark = nil
        }
        
        // 4. Endometriosis
        let endoBenchmark = (
            spontaneous: EndometriosisStage(rawValue: profile.endometriosisStage)?.spontaneousPregnancy ?? 20.0,
            fivRecommended: EndometriosisStage(rawValue: profile.endometriosisStage)?.fivRecommended ?? false,
            considerations: EndometriosisStage(rawValue: profile.endometriosisStage)?.considerations ?? "Evaluar"
        )
        
        // 5. Factor masculino
        let maleBenchmark: (severity: String, treatment: String, success: Double)?
        if let concentration = profile.spermConcentration,
           let motility = profile.spermProgressiveMotility {
            let tmsc = concentration * 3.0 * (motility/100.0) * 0.5
            let severity = MaleFactorSeverity.classify(tmsc: tmsc)
            maleBenchmark = (severity.rawValue, severity.recommendedTreatment, severity.successRate)
        } else {
            maleBenchmark = nil
        }
        
        // 6. Obesidad/IMC
        let obesityBenchmark = ObesityBenchmarks.getOutcomes(bmi: profile.bmi)
        
        // 7. Tiroides
        let thyroidBenchmark: (fertility: String, clinical: Double, miscarriage: Double, recommendation: String)?
        if let tsh = profile.tshValue {
            let outcomes = ThyroidBenchmarks.getOutcomes(tsh: tsh)
            thyroidBenchmark = (outcomes.fertilidad, outcomes.embarazoClinico, outcomes.abortos, outcomes.recomendacion)
        } else {
            thyroidBenchmark = nil
        }
        
        return ComprehensiveBenchmarkResult(
            ageBenchmark: ageBenchmark,
            pcosBenchmark: pcosBenchmark,
            reserveBenchmark: reserveBenchmark,
            endometriosisBenchmark: endoBenchmark,
            maleBenchmark: maleBenchmark,
            obesityBenchmark: obesityBenchmark,
            thyroidBenchmark: thyroidBenchmark
        )
    }
    
    // MARK: - 🏥 14. MIOMATOSIS UTERINA (Clasificación FIGO)
    
    struct MyomatosisBenchmarks {
        static func getOutcomes(myomaType: MyomaType, size: Double = 3.0) -> (impactoFertilidad: String, penalizacion: Double, recomendacion: String, requiereCirugia: Bool) {
            // Referencia: ASRM Uterine Pathology 2023, PMID: 36851124
            // Clasificación FIGO: 0-2 submucosos, 3-5 intramurales, 6-7 subserosos
            
            switch myomaType {
            case .submucosal:
                if size >= 1.0 {
                    return ("Significativo", 0.50, "Histeroscopía resectiva antes de IIU/FIV", true)
                } else {
                    return ("Moderado", 0.75, "Valorar resección según síntomas", false)
                }
                
            case .intramural:
                if size >= 5.0 {
                    return ("Severo", 0.70, "Miomectomía laparoscópica si fallos previos", true)
                } else if size >= 3.0 {
                    return ("Moderado", 0.85, "Seguimiento y valorar cirugía si cavidad deformada", false)
                } else {
                    return ("Leve", 0.95, "Control ecográfico", false)
                }
                
            case .subserosal:
                return ("Mínimo", 1.0, "Sin impacto directo en fertilidad", false)
                
            case .none:
                return ("Sin miomas", 1.0, "No aplica", false)
            }
        }
    }
    
    // MARK: - 🔴 15. ADENOMIOSIS
    
    struct AdenomyosisBenchmarks {
        static func getOutcomes(adenomyosisType: AdenomyosisType, hasEndometriosis: Bool = false) -> (impactoImplantacion: Double, impactoAborto: Double, recomendacion: String, requiereSupresion: Bool) {
            // Referencias: Garcia-Velasco JA et al., RBMO 2023
            //             ESHRE Endometriosis Guidelines 2022
            //             PMID: 37986124
            
            var baseImplantacion: Double
            var baseAborto: Double
            var recomendacion: String
            var requiereSupresion: Bool
            
            switch adenomyosisType {
            case .diffuse:
                baseImplantacion = 0.50  // Penalización 50%
                baseAborto = 1.40        // Aumento 40% riesgo aborto
                recomendacion = "Supresión pre-FIV con agonistas GnRH (60-90 días). Transferencia diferida."
                requiereSupresion = true
                
            case .focal:
                baseImplantacion = 0.85  // Penalización 15%
                baseAborto = 1.15        // Aumento 15% riesgo aborto
                recomendacion = "Seguimiento. Considerar supresión si fallos previos."
                requiereSupresion = false
                
            case .mixed:
                baseImplantacion = 0.70  // Penalización 30%
                baseAborto = 1.25        // Aumento 25% riesgo aborto
                recomendacion = "Supresión GnRH recomendada. RMN control pre-FIV."
                requiereSupresion = true
                
            case .none:
                baseImplantacion = 1.0
                baseAborto = 1.0
                recomendacion = "Sin adenomiosis"
                requiereSupresion = false
            }
            
            // Impacto sinérgico con endometriosis
            if hasEndometriosis {
                baseImplantacion *= 0.85  // Penalización adicional 15%
                baseAborto *= 1.10        // Aumento adicional 10%
                recomendacion += " Impacto sinérgico con endometriosis."
            }
            
            return (baseImplantacion, baseAborto, recomendacion, requiereSupresion)
        }
    }
    
    // MARK: - 📅 16. CICLOS MENSTRUALES IRREGULARES
    
    struct IrregularCyclesBenchmarks {
        static func getOutcomes(cycleLength: Double?) -> (fecundabilidad: Double, requiereInduccion: Bool, recomendacion: String, riesgo: String) {
            // Referencias: ASRM Ovulation Disorders 2023
            //             ESHRE PCOS 2023
            //             PMID: 36222197
            
            guard let cycle = cycleLength else {
                return (0.50, true, "Evaluar anovulación. Letrozol o FSH según etiología.", "Amenorrea")
            }
            
            switch cycle {
            case 24...35:
                return (1.0, false, "Ciclo normal. Confirmar ovulación espontánea.", "Ninguno")
                
            case 21..<24:
                return (0.85, false, "Posible fase lútea corta. Confirmar progesterona lútea.", "Fase lútea corta")
                
            case 35..<60:
                return (0.75, true, "Anovulación funcional. Letrozol 2.5-5mg días 3-7.", "Anovulación intermitente")
                
            case 60...:
                return (0.50, true, "Anovulación severa. Descartar SOP. Inducción obligatoria.", "Anovulación crónica")
                
            default: // <21 días
                return (0.70, false, "Ciclo corto. Evaluar reserva ovárica y función tiroidea.", "Ciclo corto")
            }
        }
    }
    
    // MARK: - 🚫 17. OBSTRUCCIÓN TUBARIA UNILATERAL
    
    struct UnilateralObstructionBenchmarks {
        static func getOutcomes(hasHydrosalpinx: Bool = false) -> (embarazoEspontaneo: Double, riesgoEctopico: Double, iiuViable: Bool, recomendacion: String) {
            // Referencias: NICE Fertility 2021
            //             ASRM Tubal Factor 2023
            //             PMID: 35582934
            
            let baseEspontaneo = 0.75  // Reducción 25%
            let baseEctopico: Double
            let iiuViable: Bool
            let recomendacion: String
            
            if hasHydrosalpinx {
                baseEctopico = 3.0  // 3x mayor riesgo ectópico
                iiuViable = false
                recomendacion = "Salpingectomía previa a FIV. No IIU por riesgo ectópico."
            } else {
                baseEctopico = 1.5  // 1.5x mayor riesgo
                iiuViable = true
                recomendacion = "IIU viable si edad <37 y reserva normal. FIV si ≥2 IIU fallidas."
            }
            
            return (baseEspontaneo, baseEctopico, iiuViable, recomendacion)
        }
    }
    
    // MARK: - 🚫🚫 18. OBSTRUCCIÓN TUBARIA BILATERAL
    
    struct BilateralObstructionBenchmarks {
        static func getOutcomes(hasHydrosalpinx: Bool = false) -> (embarazoEspontaneo: Double, mejoraPostSalpingectomia: Double, recomendacion: String, fivObligatoria: Bool) {
            // Referencias: ASRM Tubal Factor 2023
            //             ESHRE Female Infertility 2022
            //             PMID: 35891244
            
            let embarazoEspontaneo = 0.0  // 0% probabilidad
            let mejoraImplantacion = hasHydrosalpinx ? 1.50 : 1.0  // 50% mejora si salpingectomía
            let recomendacion: String
            
            if hasHydrosalpinx {
                recomendacion = "FIV directa. Salpingectomía bilateral mejora implantación hasta 50%."
            } else {
                recomendacion = "FIV directa. No intentar coito programado ni IIU."
            }
            
            return (embarazoEspontaneo, mejoraImplantacion, recomendacion, true)
        }
    }
    
    // MARK: - 🔪 19. CIRUGÍAS PÉLVICAS PREVIAS (DETALLADO)
    
    struct DetailedPelvicSurgeryBenchmarks {
        static func getOutcomes(surgeryCount: Int, surgeryType: String, hasEndometriosis: Bool = false) -> (penalizacionFertilidad: Double, riesgoAdherencias: String, recomendacion: String) {
            // Referencia: ASRM Surgical History in Infertility 2023
            //            PMID: 36111028
            
            var basePenalizacion: Double
            var riesgoAdherencias: String
            
            switch surgeryCount {
            case 0:
                return (1.0, "Ninguno", "Sin limitaciones quirúrgicas")
                
            case 1:
                basePenalizacion = 0.95  // -5%
                riesgoAdherencias = "Leve"
                
            case 2...:
                basePenalizacion = 0.85  // -15%
                riesgoAdherencias = "Moderado a severo"
                
            default:
                basePenalizacion = 0.95
                riesgoAdherencias = "Evaluar individualmente"
            }
            
            // Ajuste por tipo de cirugía
            if surgeryType.lowercased().contains("endometriosis") || hasEndometriosis {
                basePenalizacion *= 0.90  // Penalización adicional
                riesgoAdherencias = "Alto (endometriosis)"
            }
            
            if surgeryType.lowercased().contains("epi") || surgeryType.lowercased().contains("inflamatoria") {
                basePenalizacion *= 0.85  // Penalización por EPI
                riesgoAdherencias = "Alto (EPI previa)"
            }
            
            let recomendacion: String
            if basePenalizacion < 0.90 {
                recomendacion = "HSG y RMN recomendados. Considerar laparoscopía diagnóstica. FIV directa si trompas severamente dañadas."
            } else {
                recomendacion = "Seguimiento estándar. HSG para evaluar permeabilidad tubaria."
            }
            
            return (basePenalizacion, riesgoAdherencias, recomendacion)
        }
    }
    
    // MARK: - ⏰ 20. AÑOS DE INFERTILIDAD (DETALLADO)
    
    struct DetailedInfertilityDurationBenchmarks {
        static func getOutcomes(years: Double, age: Double) -> (penalizacionProgresiva: Double, bypassRecomendado: Bool, recomendacion: String) {
            // Referencias: NICE Fertility 2021
            //             ESHRE Unexplained Infertility 2022
            //             PMID: 36233041
            
            let basePenalizacion: Double
            var bypassRecomendado = false
            var recomendacion: String
            
            switch years {
            case 0..<2:
                basePenalizacion = 1.0
                recomendacion = "Sin penalización por duración"
                
            case 2..<3:
                basePenalizacion = 0.98  // -2%
                recomendacion = "Leve reducción de fertilidad"
                
            case 3..<5:
                basePenalizacion = 0.95  // -5%
                recomendacion = "Considerar FIV si otros factores coexistentes"
                if age > 38 {
                    bypassRecomendado = true
                    recomendacion += ". Bypass a FIV recomendado por edad."
                }
                
            case 5...:
                basePenalizacion = 0.90  // -10%
                bypassRecomendado = true
                recomendacion = "FIV directa recomendada. Infertilidad prolongada sugiere factores ocultos."
                
            default:
                basePenalizacion = 1.0
                recomendacion = "Evaluar individualmente"
            }
            
            return (basePenalizacion, bypassRecomendado, recomendacion)
        }
    }
    
    // MARK: - 🧬 21. FACTOR MASCULINO OMS 2021 (ACTUALIZADO)
    
    struct MaleFactorWHO2021Benchmarks {
        static func getOutcomes(concentration: Double?, progressiveMotility: Double?, normalMorphology: Double?, volume: Double? = nil) -> (severidad: String, tecnicaRecomendada: String, tasaExito: Double, requiereEvaluacionAdicional: Bool) {
            // Referencias: WHO Manual for Human Semen Analysis (6th ed, 2021)
            //             ASRM Male Infertility 2024
            //             PMID: 37541156
            
            guard let conc = concentration,
                  let motility = progressiveMotility,
                  let morphology = normalMorphology else {
                return ("No evaluado", "Completar espermatograma", 0.0, true)
            }
            
            // Criterios OMS 2021 actualizados
            let oligozoospermia = conc < 16.0  // <16 mill/mL
            let astenozoospermia = motility < 30.0  // <30% progresiva
            let teratozoospermia = morphology < 4.0  // <4% normales
            
            let alteraciones = [oligozoospermia, astenozoospermia, teratozoospermia].filter { $0 }.count
            
            // Calcular TMSC aproximado
            let estimatedVolume = volume ?? 3.0
            let tmsc = conc * estimatedVolume * (motility / 100.0)
            
            switch alteraciones {
            case 0:
                return ("Normal", "Coito programado o IIU", 20.0, false)
                
            case 1:
                if tmsc >= 5.0 {
                    return ("Alteración leve", "IIU (3-4 ciclos)", 12.0, false)
                } else {
                    return ("Alteración leve-moderada", "IIU con estimulación o ICSI", 15.0, false)
                }
                
            case 2:
                if tmsc >= 2.0 {
                    return ("Alteración moderada", "IIU con estimulación", 8.0, true)
                } else {
                    return ("Alteración moderada-severa", "ICSI", 35.0, true)
                }
                
            case 3:
                return ("Alteración severa", "ICSI directa", 30.0, true)
                
            default:
                return ("Evaluar", "Repetir espermatograma", 0.0, true)
            }
        }
    }
}
*/

// MARK: - 📊 RESULTADO COMPREHENSIVE BENCHMARKS

struct ComprehensiveBenchmarkResult {
    let ageBenchmark: (coitoEspontaneo: Double, fivNacidoVivo: Double, comentario: String)
    let pcosBenchmark: (ovulation: Double, pregnancy: Double, considerations: String)?
    let reserveBenchmark: (embryos: Int, liveBirth: Double, cumulative: Double, protocol: String)?
    let endometriosisBenchmark: (spontaneous: Double, fivRecommended: Bool, considerations: String)
    let maleBenchmark: (severity: String, treatment: String, success: Double)?
    let obesityBenchmark: (embarazoEspontaneo: Double, ovulacionLetrozol: Double, exitoFIV: Double, consideraciones: String)
    let thyroidBenchmark: (fertility: String, clinical: Double, miscarriage: Double, recommendation: String)?
}
