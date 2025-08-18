//
//  MedicalTreatments.swift
//  Pronóstico de Fertilidad
//
//  💊 PROTOCOLOS DE TRATAMIENTO MÉDICO
//  Tratamientos farmacológicos, quirúrgicos y de reproducción asistida
//  Basado en evidencia científica y guías clínicas internacionales
//
//  Created by Jorge Vásquez on 2024
//

import Foundation

// MARK: - 🧬 FERTILIZACIÓN IN VITRO (FIV/ICSI/OVODONACIÓN)

/// Protocolos FIV según ESHRE Guidelines 2023
/// Referencias: DOI: 10.1093/hropen/hoad019, DOI: 10.1016/j.fertnstert.2023.04.013
struct IVFTreatmentProtocols {
    
    // MARK: - Protocolos de Estimulación Ovárica
    
    enum StimulationProtocol: String, CaseIterable {
        case antagonist = "Protocolo Antagonista"
        case longAgorist = "Protocolo Largo Agonista"
        case shortAgorist = "Protocolo Corto Agonista"
        case mildStimulation = "Estimulación Suave"
        case naturalCycle = "Ciclo Natural"
        
        var indication: String {
            switch self {
            case .antagonist:
                return "Primera línea. Menor riesgo SHO. Ideal para SOP"
            case .longAgorist:
                return "Reserva ovárica normal. Mayor control ciclo"
            case .shortAgorist:
                return "Baja reserva ovárica. Protocolo de rescate"
            case .mildStimulation:
                return "Pacientes >40 años. Menor carga hormonal"
            case .naturalCycle:
                return "Reserva ovárica crítica. Último recurso"
            }
        }
        
        var expectedOocytes: ClosedRange<Int> {
            switch self {
            case .antagonist: return 8...15
            case .longAgorist: return 10...18
            case .shortAgorist: return 5...10
            case .mildStimulation: return 3...8
            case .naturalCycle: return 1...2
            }
        }
    }
    
    // MARK: - Medicamentos de Estimulación
    
    struct StimulationMedications {
        
        enum Gonadotropin: String, CaseIterable {
            case recombinantFSH = "FSH Recombinante"
            case urinaryFSH = "FSH Urinario"
            case hMG = "hMG (FSH+LH)"
            case recombinantLH = "LH Recombinante"
            
            var indication: String {
                switch self {
                case .recombinantFSH:
                    return "Primera línea. Mayor pureza y consistencia"
                case .urinaryFSH:
                    return "Alternativa económica. Eficacia similar"
                case .hMG:
                    return "Baja reserva ovárica. Pacientes >35 años"
                case .recombinantLH:
                    return "Deficiencia LH severa. Hipogonadismo"
                }
            }
            
            var dosageRange: ClosedRange<Int> {
                switch self {
                case .recombinantFSH: return 150...300  // UI/día
                case .urinaryFSH: return 150...300      // UI/día
                case .hMG: return 150...450             // UI/día
                case .recombinantLH: return 75...150    // UI/día
                }
            }
        }
        
        enum TriggerMedication: String, CaseIterable {
            case hCG = "hCG 10,000 UI"
            case recombinantHCG = "hCG Recombinante 250 μg"
            case gnrhAgonist = "GnRH Agonista 0.2 mg"
            case dualTrigger = "Trigger Dual (hCG + GnRH)"
            
            var indication: String {
                switch self {
                case .hCG:
                    return "Estándar. Transferencia fresca"
                case .recombinantHCG:
                    return "Alternativa a hCG urinario"
                case .gnrhAgonist:
                    return "Alto riesgo SHO. Solo congelación"
                case .dualTrigger:
                    return "Baja reserva + riesgo SHO moderado"
                }
            }
        }
    }
    
    // MARK: - Técnicas de Laboratorio
    
    enum LaboratoryTechnique: String, CaseIterable {
        case conventionalIVF = "FIV Convencional"
        case ICSI = "ICSI (Inyección Intracitoplasmática)"
        case IMSI = "IMSI (ICSI con alta magnificación)"
        case PICSI = "PICSI (ICSI con ácido hialurónico)"
        case timelapseIncubation = "Incubación Time-lapse"
        case blastocystCulture = "Cultivo a Blastocisto"
        
        var indication: String {
            switch self {
            case .conventionalIVF:
                return "Factor femenino. Espermatograma normal"
            case .ICSI:
                return "Factor masculino severo. Fallo fertilización previo"
            case .IMSI:
                return "Fragmentación DNA espermática alta"
            case .PICSI:
                return "Selección espermática mejorada"
            case .timelapseIncubation:
                return "Mejor selección embrionaria"
            case .blastocystCulture:
                return "Mejor selección. Mayor implantación"
            }
        }
        
        var successRateModifier: Double {
            switch self {
            case .conventionalIVF: return 1.0
            case .ICSI: return 1.05
            case .IMSI: return 1.10
            case .PICSI: return 1.08
            case .timelapseIncubation: return 1.12
            case .blastocystCulture: return 1.15
            }
        }
    }
    
    // MARK: - Diagnóstico Genético Preimplantacional
    
    enum PGTType: String, CaseIterable {
        case PGTA = "PGT-A (Aneuploidías)"
        case PGTM = "PGT-M (Monogénico)"
        case PGTSR = "PGT-SR (Reordenamientos)"
        
        var indication: String {
            switch self {
            case .PGTA:
                return "Edad materna ≥38 años. Abortos recurrentes. Fallo implantación"
            case .PGTM:
                return "Enfermedad monogénica conocida en pareja"
            case .PGTSR:
                return "Translocaciones cromosómicas en pareja"
            }
        }
        
        var ageIndication: ClosedRange<Int> {
            switch self {
            case .PGTA: return 38...45
            case .PGTM: return 18...50
            case .PGTSR: return 18...50
            }
        }
    }
}

// MARK: - 💊 TRATAMIENTOS FARMACOLÓGICOS

struct PharmacologicalTreatments {
    
    // MARK: - Inducción de Ovulación
    
    enum OvulationInduction: String, CaseIterable {
        case letrozole = "Letrozol"
        case clomiphene = "Clomifeno"
        case gonadotropins = "Gonadotropinas"
        case metformin = "Metformina"
        
        var dosage: String {
            switch self {
            case .letrozole:
                return "2.5-5.0 mg días 3-7 del ciclo"
            case .clomiphene:
                return "50-100 mg días 3-7 del ciclo"
            case .gonadotropins:
                return "75-150 UI días 3-7 del ciclo"
            case .metformin:
                return "1500-2000 mg/día continuo"
            }
        }
        
        var indication: String {
            switch self {
            case .letrozole:
                return "Primera línea SOP. Menor riesgo gemelar"
            case .clomiphene:
                return "Alternativa a letrozol. Más económico"
            case .gonadotropins:
                return "Fallo letrozol/clomifeno. Baja reserva"
            case .metformin:
                return "SOP + resistencia insulínica"
            }
        }
        
        var successRate: Double {
            switch self {
            case .letrozole: return 0.75      // 75% ovulación
            case .clomiphene: return 0.70     // 70% ovulación
            case .gonadotropins: return 0.85  // 85% ovulación
            case .metformin: return 0.60      // 60% ovulación (como monoterapia)
            }
        }
    }
    
    // MARK: - Suplementación Preconcepcional
    
    struct PreconceptionalSupplements {
        
        enum FemaleSupplements: String, CaseIterable {
            case folicAcid = "Ácido Fólico"
            case coQ10 = "Coenzima Q10"
            case myoInositol = "Mio-inositol"
            case vitaminD = "Vitamina D"
            case omega3 = "Omega-3"
            case NAC = "N-Acetilcisteína"
            
            var dosage: String {
                switch self {
                case .folicAcid: return "5 mg/día (3 meses pre-concepción)"
                case .coQ10: return "600 mg/día (baja reserva ovárica)"
                case .myoInositol: return "4 g/día (SOP + RI)"
                case .vitaminD: return "2000-4000 UI/día (deficiencia)"
                case .omega3: return "1-2 g/día (DHA + EPA)"
                case .NAC: return "1.2 g/día (SOP, antioxidante)"
                }
            }
            
            var evidenceLevel: String {
                switch self {
                case .folicAcid: return "A - Evidencia fuerte"
                case .coQ10: return "B - Evidencia moderada"
                case .myoInositol: return "A - Evidencia fuerte (SOP)"
                case .vitaminD: return "B - Evidencia moderada"
                case .omega3: return "C - Evidencia limitada"
                case .NAC: return "B - Evidencia moderada"
                }
            }
        }
        
        enum MaleSupplements: String, CaseIterable {
            case coQ10 = "Coenzima Q10"
            case vitaminE = "Vitamina E"
            case zinc = "Zinc"
            case selenium = "Selenio"
            case carnitine = "L-Carnitina"
            case vitaminC = "Vitamina C"
            
            var dosage: String {
                switch self {
                case .coQ10: return "200 mg/día (3 meses)"
                case .vitaminE: return "400 UI/día"
                case .zinc: return "15 mg/día"
                case .selenium: return "200 μg/día"
                case .carnitine: return "2 g/día"
                case .vitaminC: return "1 g/día"
                }
            }
            
            var indication: String {
                switch self {
                case .coQ10: return "Antioxidante. Mejora motilidad"
                case .vitaminE: return "Antioxidante. Protección DNA"
                case .zinc: return "Esencial espermatogénesis"
                case .selenium: return "Antioxidante. Morfología"
                case .carnitine: return "Metabolismo energético espermático"
                case .vitaminC: return "Antioxidante general"
                }
            }
        }
    }
    
    // MARK: - Tratamientos Hormonales
    
    enum HormonalTreatments: String, CaseIterable {
        case levothyroxine = "Levotiroxina"
        case cabergoline = "Cabergolina"
        case bromocriptine = "Bromocriptina"
        case progesterone = "Progesterona"
        case estradiol = "Estradiol"
        
        var indication: String {
            switch self {
            case .levothyroxine:
                return "Hipotiroidismo. TSH objetivo <2.5 mIU/L"
            case .cabergoline:
                return "Hiperprolactinemia. Primera línea"
            case .bromocriptine:
                return "Hiperprolactinemia. Alternativa económica"
            case .progesterone:
                return "Fase lútea corta. Soporte post-FIV"
            case .estradiol:
                return "Preparación endometrial. THS"
            }
        }
        
        var dosageRange: String {
            switch self {
            case .levothyroxine: return "25-100 μg/día"
            case .cabergoline: return "0.25-1.0 mg 2x/semana"
            case .bromocriptine: return "2.5-7.5 mg/día"
            case .progesterone: return "200-600 mg/día vaginal"
            case .estradiol: return "2-6 mg/día oral"
            }
        }
    }
}

// MARK: - ⚔️ TRATAMIENTOS QUIRÚRGICOS

struct SurgicalTreatments {
    
    // MARK: - Cirugía Histeroscópica
    
    enum HysteroscopicSurgery: String, CaseIterable {
        case polypectomy = "Polipectomía"
        case myomectomy = "Miomectomía Submucosa"
        case septumResection = "Resección Septum"
        case synechiolysis = "Sinequiolisis"
        case endometrialAblation = "Ablación Endometrial"
        
        var indication: String {
            switch self {
            case .polypectomy:
                return "Pólipos endometriales >5mm"
            case .myomectomy:
                return "Miomas submucosos tipos 0, 1, 2"
            case .septumResection:
                return "Septum uterino >1cm"
            case .synechiolysis:
                return "Adherencias intrauterinas (Asherman)"
            case .endometrialAblation:
                return "Menorragia. Contraindicado en fertilidad"
            }
        }
        
        var fertilityImprovement: Double {
            switch self {
            case .polypectomy: return 1.15        // +15% mejora
            case .myomectomy: return 1.25         // +25% mejora
            case .septumResection: return 1.30    // +30% mejora
            case .synechiolysis: return 1.20      // +20% mejora
            case .endometrialAblation: return 0.05 // -95% fertilidad
            }
        }
        
        var complicationRate: Double {
            switch self {
            case .polypectomy: return 0.02        // 2% complicaciones
            case .myomectomy: return 0.05         // 5% complicaciones
            case .septumResection: return 0.03    // 3% complicaciones
            case .synechiolysis: return 0.08      // 8% complicaciones
            case .endometrialAblation: return 0.10 // 10% complicaciones
            }
        }
    }
    
    // MARK: - Cirugía Laparoscópica
    
    enum LaparoscopicSurgery: String, CaseIterable {
        case ovariectomy = "Ooforectomía"
        case cystectomy = "Cistectomía Ovárica"
        case myomectomy = "Miomectomía Laparoscópica"
        case endometriosisResection = "Resección Endometriosis"
        case adhesiolysis = "Adhesiolisis"
        case tubalSurgery = "Cirugía Tubárica"
        
        var indication: String {
            switch self {
            case .ovariectomy:
                return "Ovario no funcionante. Endometriomas >6cm"
            case .cystectomy:
                return "Endometriomas 3-6cm. Preservar tejido ovárico"
            case .myomectomy:
                return "Miomas intramurales >4cm. Síntomas"
            case .endometriosisResection:
                return "Endometriosis severa. Dolor pélvico"
            case .adhesiolysis:
                return "Adherencias pélvicas extensas"
            case .tubalSurgery:
                return "Hidrosálpinx. Reparación tubárica"
            }
        }
        
        var fertilityImpact: String {
            switch self {
            case .ovariectomy:
                return "Reduce reserva ovárica -20%"
            case .cystectomy:
                return "Reduce reserva ovárica -10%"
            case .myomectomy:
                return "Mejora fertilidad +15-30%"
            case .endometriosisResection:
                return "Mejora fertilidad +10-20%"
            case .adhesiolysis:
                return "Mejora fertilidad +15-25%"
            case .tubalSurgery:
                return "Variable según severidad"
            }
        }
    }
    
    // MARK: - Timing Quirúrgico
    
    struct SurgicalTiming {
        
        enum Priority: String, CaseIterable {
            case immediate = "Inmediata"
            case planned = "Programada"
            case optional = "Opcional"
            
            var timeframe: String {
                switch self {
                case .immediate: return "1-4 semanas"
                case .planned: return "2-6 meses"
                case .optional: return "6-12 meses"
                }
            }
        }
        
        static func determinePriority(pathology: String, age: Double, fertilityDesire: Bool) -> Priority {
            if age >= 38 && fertilityDesire {
                return .immediate  // Urgencia reproductiva
            }
            
            switch pathology.lowercased() {
            case "mioma submucoso", "septum uterino":
                return .immediate
            case "endometrioma >4cm", "hidrosálpinx":
                return .planned
            case "mioma intramural <4cm":
                return .optional
            default:
                return .planned
            }
        }
    }
}

// MARK: - 🎯 ALGORITMOS DE DECISIÓN TERAPÉUTICA

struct TreatmentDecisionAlgorithms {
    
    /// Algoritmo de decisión para SOP
    static func PCOSAlgorithm(profile: FertilityProfile) -> [String] {
        var treatments: [String] = []
        
        // Base: Metformina + Mio-inositol
        treatments.append("Metformina 1500mg/día + Mio-inositol 4g/día")
        
        // Inducción ovulación
        if let cycleLength = profile.cycleLength, cycleLength > 35 {
            treatments.append("Letrozol 2.5-5mg días 3-7 (inducción ovulación)")
        }
        
        // Control peso
        if profile.bmi > 30 {
            treatments.append("Pérdida peso >10% (dieta + ejercicio estructurado)")
        }
        
        // Técnicas reproductivas
        if profile.age >= 35 {
            treatments.append("FIV con protocolo antagonista (menor riesgo SHO)")
        } else {
            treatments.append("IIU hasta 3 ciclos, luego FIV")
        }
        
        return treatments
    }
    
    /// Algoritmo de decisión para Endometriosis
    static func EndometriosisAlgorithm(stage: Int, age: Double) -> [String] {
        var treatments: [String] = []
        
        switch stage {
        case 1, 2: // Mínima-Leve
            treatments.append("Seguimiento expectante 6-12 meses")
            if age >= 35 {
                treatments.append("Inducción ovulación con letrozol")
            }
            
        case 3: // Moderada
            treatments.append("Laparoscopia diagnóstica/terapéutica")
            treatments.append("Si cirugía no exitosa: FIV inmediata")
            
        case 4: // Severa
            treatments.append("FIV inmediata (primera línea)")
            treatments.append("Cirugía solo si endometriomas >4cm o dolor severo")
            
        default:
            treatments.append("Evaluación individualizada")
        }
        
        return treatments
    }
    
    /// Algoritmo de decisión para Factor Masculino
    static func MaleFactorAlgorithm(severity: MaleFactorPathology.Severity) -> [String] {
        var treatments: [String] = []
        
        switch severity {
        case .normal:
            treatments.append("Factor masculino normal - No tratamiento específico")
            
        case .mild:
            treatments.append("Optimización lifestyle (ejercicio, dieta, no tabaco)")
            treatments.append("Suplementos: CoQ10 200mg + Vitamina E 400UI + Zinc 15mg")
            treatments.append("IIU hasta 3 ciclos")
            
        case .moderate:
            treatments.append("Evaluación urológica")
            treatments.append("Suplementos antioxidantes por 3 meses")
            treatments.append("FIV/ICSI recomendado")
            
        case .severe:
            treatments.append("FIV/ICSI recomendado")
            treatments.append("Estudio genético (cariotipo + microdeleciones Y)")
            treatments.append("Evaluación urológica especializada")
            
        case .critical:
            treatments.append("ICSI obligatorio - REM <1M post-capacitación")
            treatments.append("Estudio genético completo urgente")
            treatments.append("Evaluación urológica especializada inmediata")
            
        case .azoospermia:
            treatments.append("Biopsia testicular URGENTE")
            treatments.append("Considerar espermatozoides de donante")
            treatments.append("Asesoramiento genético")
        }
        
        return treatments
    }
    
    /// Algoritmo edad-dependiente
    static func AgeBasedAlgorithm(age: Double, amh: Double?) -> [String] {
        var treatments: [String] = []
        
        switch age {
        case ..<30:
            treatments.append("Ventana reproductiva óptima")
            treatments.append("Tratamientos expectantes hasta 12 meses")
            
        case 30..<35:
            treatments.append("Buena reserva reproductiva")
            treatments.append("Tratamientos expectantes hasta 6-9 meses")
            
        case 35..<38:
            treatments.append("Fertilidad en descenso")
            treatments.append("Evaluación completa inmediata")
            treatments.append("Tratamientos activos después 6 meses")
            
        case 38..<40:
            treatments.append("Urgencia reproductiva moderada")
            treatments.append("Evaluación y tratamiento inmediato")
            treatments.append("Considerar PGT-A si FIV")
            
        case 40..<42:
            treatments.append("Urgencia reproductiva alta")
            treatments.append("FIV inmediata con PGT-A")
            treatments.append("Acumulación de óvulos recomendada")
            
        default: // ≥42
            treatments.append("Urgencia reproductiva crítica")
            treatments.append("Evaluación para ovodonación")
            treatments.append("Considerar gestación subrogada si indicado")
        }
        
        // Modificar según AMH
        if let amhValue = amh {
            if amhValue < 0.5 {
                treatments.append("CRÍTICO: AMH <0.5 - Considerar ovodonación")
            } else if amhValue < 1.0 {
                treatments.append("Reserva baja: Protocolo alta respuesta + acumulación")
            }
        }
        
        return treatments
    }
}

// MARK: - 🎯 RECOMENDACIONES CLÍNICAS POR EDAD MATERNA

/// Recomendaciones actualizadas según ESHRE 2023, ASRM 2023, NICE 2024
/// Referencias principales:
/// - ESHRE Guideline Female Fertility (2023), PMID: 37018592
/// - NICE Fertility Problems Assessment (2024), PMID: 36746012
/// - ASRM Committee Opinion Fertility Evaluation (2023), DOI: 10.1016/j.fertnstert.2023.03.004
struct AgeBasedClinicalRecommendations {
    
    // MARK: - Niveles de Complejidad Terapéutica
    
    enum TreatmentComplexity: String, CaseIterable {
        case lowComplexity = "Baja Complejidad"      // IIU + estimulación leve/moderada
        case highComplexity = "Alta Complejidad"    // FIV/ICSI +/- PGT-A
        case oocyteDonation = "Ovodonación"         // Donación ovocitaria
        
        var description: String {
            switch self {
            case .lowComplexity:
                return "Estimulación ovárica + relaciones dirigidas o IIU"
            case .highComplexity:
                return "FIV convencional o ICSI +/- PGT-A"
            case .oocyteDonation:
                return "Donación ovocitaria como primera línea"
            }
        }
    }
    
    // MARK: - Recomendaciones por Grupo de Edad
    
    enum AgeGroup: String, CaseIterable {
        case under35 = "<35 años"
        case age35to37 = "35-37 años"
        case age38to40 = "38-40 años"
        case age41to42 = "41-42 años"
        case over43 = "≥43 años"
        
        /// Determina grupo de edad
        static func categorize(age: Double) -> AgeGroup {
            switch age {
            case ..<35: return .under35
            case 35..<38: return .age35to37
            case 38..<41: return .age38to40
            case 41..<43: return .age41to42
            default: return .over43
            }
        }
    }
    
    // MARK: - Recomendaciones de Baja Complejidad (IIU)
    
    struct LowComplexityRecommendations {
        
        /// Recomendaciones IIU según edad
        static func getIUIRecommendation(age: Double, amh: Double?, cfa: Int?) -> IUIRecommendation {
            let ageGroup = AgeGroup.categorize(age: age)
            
            switch ageGroup {
            case .under35:
                return IUIRecommendation(
                    isRecommended: true,
                    maxCycles: 4,
                    successRate: 0.175, // 17.5% promedio (15-20%)
                    conditions: [
                        "Buena reserva ovárica",
                        "Ciclos regulares",
                        "Permeabilidad tubárica confirmada",
                        "Ausencia de factor masculino grave"
                    ],
                    stimulationType: "Estimulación ovárica leve/moderada",
                    reference: "ESHRE Guideline Female Fertility (2023), PMID: 37018592"
                )
                
            case .age35to37:
                return IUIRecommendation(
                    isRecommended: true,
                    maxCycles: 3,
                    successRate: 0.125, // 12.5% promedio (10-15%)
                    conditions: [
                        "Buena reserva ovárica",
                        "Permeabilidad tubárica",
                        "Sin factor masculino significativo",
                        "Pronóstico individualizado"
                    ],
                    stimulationType: "Estimulación ovárica moderada preferida",
                    reference: "NICE Fertility Problems Assessment (2024), PMID: 36746012"
                )
                
            case .age38to40:
                let hasGoodReserve = (amh ?? 0) > 1.2 && (cfa ?? 0) > 7
                return IUIRecommendation(
                    isRecommended: hasGoodReserve,
                    maxCycles: hasGoodReserve ? 2 : 0,
                    successRate: 0.075, // 7.5% promedio (5-10%)
                    conditions: [
                        "AMH >1.2 ng/mL",
                        "CFA >7 folículos",
                        "Ausencia total de factores adicionales",
                        "Asesoramiento adecuado del pronóstico limitado"
                    ],
                    stimulationType: "Estimulación controlada",
                    reference: "ASRM Committee Opinion Fertility Evaluation (2023), DOI: 10.1016/j.fertnstert.2023.03.004"
                )
                
            case .age41to42, .over43:
                return IUIRecommendation(
                    isRecommended: false,
                    maxCycles: 0,
                    successRate: 0.03, // <3% (muy baja)
                    conditions: [
                        "No recomendado salvo excepciones",
                        "Condiciones ideales requeridas",
                        "Asesoramiento obligatorio"
                    ],
                    stimulationType: "No aplicable",
                    reference: "ESHRE Guideline Advanced Female Age (2024), DOI: 10.1093/hropen/hoad015"
                )
            }
        }
    }
    
    // MARK: - Recomendaciones de Alta Complejidad (FIV/ICSI)
    
    struct HighComplexityRecommendations {
        
        /// Recomendaciones FIV/ICSI según edad
        static func getIVFRecommendation(age: Double, amh: Double?) -> IVFRecommendation {
            let ageGroup = AgeGroup.categorize(age: age)
            
            switch ageGroup {
            case .under35:
                return IVFRecommendation(
                    technique: .conventionalIVF,
                    pgtRecommended: false,
                    successRate: 0.425, // 42.5% promedio (40-45%) - ACTUALIZADO 2024
                    liveBirthRate: 0.425,
                    indications: [
                        "Obstrucción tubárica bilateral",
                        "Endometriosis avanzada",
                        "Factor masculino severo",
                        "Falla previa de IIU"
                    ],
                    strategy: "FIV convencional primera línea, ICSI solo si factor masculino severo",
                    reference: "SART Data Analysis 2024 PMID: 36251589, ESHRE Registry 2024 DOI: 10.1093/hropen/hoad015"
                )
                
            case .age35to37:
                return IVFRecommendation(
                    technique: .conventionalOrICSI,
                    pgtRecommended: false, // Solo tras fallos previos
                    successRate: 0.325, // 32.5% promedio (30-35%)
                    liveBirthRate: 0.325,
                    indications: [
                        "Indicaciones similares a <35 años",
                        "Baja reserva ovárica moderada (AMH 0.8-1.2 ng/mL, CFA 5-7)"
                    ],
                    strategy: "FIV/ICSI según indicación; considerar PGT-A tras fallos previos",
                    reference: "ESHRE Recommendations for Ovarian Stimulation (2024), DOI: 10.1093/hropen/hoad015"
                )
                
            case .age38to40:
                return IVFRecommendation(
                    technique: .ICSI,
                    pgtRecommended: true,
                    successRate: 0.225, // 22.5% promedio (20-25%)
                    liveBirthRate: 0.225,
                    indications: [
                        "Indicación de elección (tasas bajas IIU/natural)",
                        "Disminución calidad ovocitaria",
                        "Factor masculino o fallos previos"
                    ],
                    strategy: "ICSI preferido; PGT-A recomendado para reducir abortos",
                    reference: "ASRM Genetic Evaluation Opinion (2023), DOI: 10.1016/j.fertnstert.2023.02.003"
                )
                
            case .age41to42:
                let hasLowReserve = (amh ?? 1.0) < 0.5
                return IVFRecommendation(
                    technique: .ICSIwithPGT,
                    pgtRecommended: true,
                    successRate: hasLowReserve ? 0.55 : 0.125, // 55% ovodonación vs 12.5% propios
                    liveBirthRate: hasLowReserve ? 0.55 : 0.125,
                    indications: [
                        "Indicación absoluta (baja probabilidad espontánea/IIU)",
                        "Considerar ovodonación si AMH <0.5 ng/mL, CFA <5, fallos repetidos"
                    ],
                    strategy: hasLowReserve ? 
                        "Ovodonación recomendada (50-60% éxito)" : 
                        "FIV-ICSI + PGT-A con ovocitos propios (10-15% éxito)",
                    reference: "NICE Fertility Guidelines (2024), PMID: 36746012"
                )
                
            case .over43:
                return IVFRecommendation(
                    technique: .oocyteDonation,
                    pgtRecommended: false, // No necesario con óvulos jóvenes
                    successRate: 0.55, // 55% promedio (50-60%)
                    liveBirthRate: 0.55,
                    indications: [
                        "Baja probabilidad con ovocitos propios (<8%)",
                        "Recomendación fuerte de ovodonación"
                    ],
                    strategy: "Ovodonación como primera línea para optimizar tasas de éxito",
                    reference: "ASRM Age-related Fertility Decline Opinion (2024), DOI: 10.1016/j.fertnstert.2024.01.010"
                )
            }
        }
    }
    
    // MARK: - Estructuras de Datos
    
    struct IUIRecommendation {
        let isRecommended: Bool
        let maxCycles: Int
        let successRate: Double        // Tasa por ciclo
        let conditions: [String]
        let stimulationType: String
        let reference: String
        
        var recommendation: String {
            if isRecommended {
                return "✅ Hasta \(maxCycles) ciclos de IIU (\(Int(successRate * 100))% por ciclo)"
            } else {
                return "❌ No recomendado (probabilidad <\(Int(successRate * 100))%)"
            }
        }
    }
    
    struct IVFRecommendation {
        let technique: IVFTechnique
        let pgtRecommended: Bool
        let successRate: Double        // Tasa por ciclo
        let liveBirthRate: Double      // Tasa nacido vivo
        let indications: [String]
        let strategy: String
        let reference: String
        
        enum IVFTechnique: String {
            case conventionalIVF = "FIV Convencional"
            case conventionalOrICSI = "FIV o ICSI"
            case ICSI = "ICSI"
            case ICSIwithPGT = "ICSI + PGT-A"
            case oocyteDonation = "Ovodonación"
        }
        
        var recommendation: String {
            let pgtText = pgtRecommended ? " + PGT-A" : ""
            return "✅ \(technique.rawValue)\(pgtText) (\(Int(liveBirthRate * 100))% nacido vivo)"
        }
    }
    
    // MARK: - Tabla Resumen Simplificada
    
    static func getSimplifiedRecommendation(age: Double, amh: Double? = nil, cfa: Int? = nil) -> (iui: String, ivf: String) {
        let ageGroup = AgeGroup.categorize(age: age)
        
        switch ageGroup {
        case .under35:
            return (
                iui: "✅ Hasta 3-4 ciclos",
                ivf: "✅ Indicaciones específicas"
            )
            
        case .age35to37:
            return (
                iui: "✅ Hasta 2-3 ciclos",
                ivf: "✅ FIV/ICSI +/- PGT-A según contexto"
            )
            
        case .age38to40:
            let hasGoodReserve = (amh ?? 0) > 1.2 && (cfa ?? 0) > 7
            return (
                iui: hasGoodReserve ? "⚠️ Máximo 1-2 intentos en condiciones ideales" : "❌ No recomendado",
                ivf: "✅ FIV/ICSI + PGT-A recomendado"
            )
            
        case .age41to42:
            return (
                iui: "❌ No recomendado",
                ivf: "✅ FIV-ICSI + PGT-A o donación ovocitaria"
            )
            
        case .over43:
            return (
                iui: "❌ No recomendado",
                ivf: "✅ Ovodonación como primera recomendación"
            )
        }
    }
    
    // MARK: - Algoritmo de Decisión Integrado
    
    /// Genera recomendación completa basada en edad y reserva ovárica
    static func generateComprehensiveRecommendation(
        age: Double,
        amh: Double?,
        cfa: Int?,
        hasOtherFactors: Bool = false
    ) -> ComprehensiveAgeRecommendation {
        
        let ageGroup = AgeGroup.categorize(age: age)
        let iuiRec = LowComplexityRecommendations.getIUIRecommendation(age: age, amh: amh, cfa: cfa)
        let ivfRec = HighComplexityRecommendations.getIVFRecommendation(age: age, amh: amh)
        
        // Modificar recomendaciones si hay otros factores
        var finalIUIRecommended = iuiRec.isRecommended
        if hasOtherFactors && age >= 35 {
            finalIUIRecommended = false // Acelerar a FIV si hay factores adicionales
        }
        
        return ComprehensiveAgeRecommendation(
            ageGroup: ageGroup,
            iuiRecommendation: iuiRec,
            ivfRecommendation: ivfRec,
            primaryRecommendation: finalIUIRecommended ? .lowComplexity : 
                                 (age >= 43 || (amh ?? 1.0) < 0.5) ? .oocyteDonation : .highComplexity,
            urgencyLevel: age >= 38 ? .high : age >= 35 ? .medium : .low,
            counselingPoints: generateCounselingPoints(age: age, amh: amh)
        )
    }
    
    /// Puntos clave para counseling según edad
    private static func generateCounselingPoints(age: Double, amh: Double?) -> [String] {
        var points: [String] = []
        
        if age >= 43 {
            points.append("Ventana reproductiva muy limitada con ovocitos propios")
            points.append("Ovodonación ofrece las mejores tasas de éxito (50-60%)")
            points.append("Riesgo obstétrico aumentado requiere seguimiento especializado")
        } else if age >= 40 {
            points.append("Declive acelerado de fertilidad después de los 40 años")
            points.append("PGT-A recomendado para reducir abortos espontáneos")
            points.append("Considerar acumulación de embriones si desea más de un hijo")
        } else if age >= 35 {
            points.append("Fertilidad disminuye más rápidamente después de los 35 años")
            points.append("Evaluación y tratamiento no deben retrasarse")
            points.append("Buenas perspectivas con tratamiento adecuado")
        } else {
            points.append("Ventana reproductiva óptima")
            points.append("Excelente pronóstico con tratamientos apropiados")
            points.append("Tiempo disponible para intentos múltiples si es necesario")
        }
        
        if let amhValue = amh, amhValue < 1.0 {
            points.append("Reserva ovárica disminuida requiere tratamiento urgente")
            points.append("Considerar preservación de fertilidad si no desea embarazo inmediato")
        }
        
        return points
    }
    
    struct ComprehensiveAgeRecommendation {
        let ageGroup: AgeGroup
        let iuiRecommendation: IUIRecommendation
        let ivfRecommendation: IVFRecommendation
        let primaryRecommendation: TreatmentComplexity
        let urgencyLevel: UrgencyLevel
        let counselingPoints: [String]
        
        enum UrgencyLevel: String {
            case low = "Baja"
            case medium = "Moderada"
            case high = "Alta"
            
            var timeframe: String {
                switch self {
                case .low: return "6-12 meses para evaluación"
                case .medium: return "3-6 meses para evaluación"
                case .high: return "Evaluación inmediata (1-2 meses)"
                }
            }
        }
    }
}
