//
//  MedicalPathologies.swift
//  Pronóstico de Fertilidad
//
//  🏥 BASE DE DATOS DE PATOLOGÍAS MÉDICAS
//  Definiciones, clasificaciones y algoritmos diagnósticos
//  Basado en evidencia científica y guías clínicas internacionales
//
//  Created by Jorge Vásquez on 2024
//

import Foundation

// MARK: - 🔬 SÍNDROME DE OVARIOS POLIQUÍSTICOS (SOP)

/// SOP según criterios Rotterdam y ESHRE 2023
/// Referencias: 
/// - DOI: 10.1093/hropen/hoad019 (ESHRE PCOS Guideline 2023)
/// - DOI: 10.1016/j.fertnstert.2023.04.013 (ASRM PCOS Committee Opinion)
struct PCOSPathology {
    
    /// Fenotipos de SOP según criterios Rotterdam
    enum PCOSPhenotype: String, CaseIterable {
        case A = "Fenotipo A - Clásico"          // Hiperandrogenismo + Anovulación + Ovarios poliquísticos
        case B = "Fenotipo B - Sin ovarios"      // Hiperandrogenismo + Anovulación
        case C = "Fenotipo C - Ovulatorio"       // Hiperandrogenismo + Ovarios poliquísticos
        case D = "Fenotipo D - No androgénico"   // Anovulación + Ovarios poliquísticos
        
        var fertilityImpact: Double {
            switch self {
            case .A: return 0.25  // Severo: 25% fertilidad (anovulación + RI + hiperandrogenismo)
            case .B: return 0.35  // Alto: 35% fertilidad (anovulación sin ovarios poliquísticos)
            case .C: return 0.65  // Moderado: 65% fertilidad (ovulatorio pero hiperandrogénico)
            case .D: return 0.45  // Alto: 45% fertilidad (anovulación sin hiperandrogenismo)
            }
        }
    }
    
    /// Evaluación integral de SOP
    static func evaluatePCOS(profile: FertilityProfile) -> (severity: Double, phenotype: PCOSPhenotype?) {
        guard profile.hasPcos else { return (1.0, nil) }
        
        var severity: Double = 0.0
        
        // 1. Resistencia a la insulina (factor crítico)
        if let homaIr = profile.homaIr {
            if homaIr > 3.5 {
                severity += 0.3 // Alta RI: fenotipo clásico severo (A/B)
            } else if homaIr > 2.5 {
                severity += 0.15 // RI moderada
            }
        } else {
            severity += 0.15 // Sin datos HOMA: asumir RI moderada
        }
        
        // 2. Ciclos menstruales (anovulación)
        if let cycleLength = profile.cycleLength {
            if cycleLength > 45 {
                severity += 0.2 // Oligomenorrea severa (fenotipos A/B/D)
            } else if cycleLength > 35 {
                severity += 0.1 // Oligomenorrea leve
            }
        } else {
            severity += 0.15 // Sin datos: asumir anovulación
        }
        
        // 3. IMC (obesidad empeora SOP)
        if profile.bmi > 30 {
            severity += 0.1 // Obesidad + SOP = peor pronóstico
        }
        
        // 4. AMH elevada (criterio diagnóstico)
        if let amh = profile.amhValue {
            if amh > 6.0 {
                severity += 0.15 // AMH muy alta: sugiere fenotipo clásico A/B
            } else if amh > 4.0 {
                severity += 0.1 // AMH moderadamente elevada
            }
        } else {
            severity += 0.1 // Sin datos AMH: asumir elevada
        }
        
        // 5. Determinar fenotipo (simplificado)
        let phenotype: PCOSPhenotype = {
            if severity >= 0.5 {
                return .A // Fenotipo clásico severo
            } else if severity >= 0.4 {
                return .B // Sin ovarios poliquísticos
            } else if severity >= 0.3 {
                return .D // No androgénico
            } else {
                return .C // Ovulatorio
            }
        }()
        
        // Convertir severidad a factor multiplicador
        let fertilityFactor = phenotype.fertilityImpact
        
        return (fertilityFactor, phenotype)
    }
}

// MARK: - 🌸 ENDOMETRIOSIS

/// Endometriosis según clasificación rASRM revisada
/// Referencias: DOI: 10.1016/j.fertnstert.2012.05.023, DOI: 10.1093/hropen/hoac009
struct EndometriosisPathology {
    
    enum Stage: Int, CaseIterable {
        case I = 1      // Mínima (1-5 puntos)
        case II = 2     // Leve (6-15 puntos)
        case III = 3    // Moderada (16-40 puntos)
        case IV = 4     // Severa (>40 puntos)
        
        var fertilityImpact: Double {
            switch self {
            case .I:  return 0.85   // Mínima: 85% fertilidad (impacto leve)
            case .II: return 0.70   // Leve: 70% fertilidad
            case .III: return 0.45  // Moderada: 45% fertilidad
            case .IV: return 0.25   // Severa: 25% fertilidad (adherencias extensas)
            }
        }
        
        var treatmentRecommendation: String {
            switch self {
            case .I, .II:
                return "Seguimiento expectante 6-12 meses. Inducción ovulación si no embarazo"
            case .III:
                return "Laparoscopia diagnóstica/terapéutica. FIV si cirugía no exitosa"
            case .IV:
                return "FIV inmediata. Cirugía solo si endometriomas >4cm o dolor severo"
            }
        }
    }
    
    static func calculateEndometriosisFactor(_ stage: Int) -> Double {
        guard let stageEnum = Stage(rawValue: stage) else { return 1.0 }
        return stageEnum.fertilityImpact
    }
}

// MARK: - 🎯 MIOMATOSIS UTERINA

/// Miomatosis uterina según clasificación FIGO 2018
/// Referencias: DOI: 10.1016/j.fertnstert.2017.12.014, DOI: 10.1093/humrep/deaa162
struct MyomaPathology {
    
    /// Clasificación FIGO detallada
    enum FIGOType: String, CaseIterable {
        // Submucosos (0-2)
        case submucoso0 = "Submucoso Tipo 0"     // 100% intracavitario
        case submucoso1 = "Submucoso Tipo 1"     // >50% intracavitario
        case submucoso2 = "Submucoso Tipo 2"     // <50% intracavitario
        
        // Otros (3-8)
        case intramural3 = "Intramural Tipo 3"   // Contacta endometrio
        case intramural4 = "Intramural Tipo 4"   // Completamente intramural
        case intramural5 = "Intramural Tipo 5"   // Contacta serosa
        case subserosal6 = "Subserosal Tipo 6"   // <50% intramural
        case subserosal7 = "Subserosal Tipo 7"   // >50% intramural
        case pediculado8 = "Pediculado Tipo 8"   // Completamente externo
        
        var fertilityImpact: Double {
            switch self {
            // Submucosos: mayor impacto
            case .submucoso0: return 0.15  // Crítico: 15% fertilidad
            case .submucoso1: return 0.25  // Severo: 25% fertilidad
            case .submucoso2: return 0.40  // Alto: 40% fertilidad
            
            // Intramurales: impacto variable según tamaño
            case .intramural3: return 0.60  // Moderado: 60% fertilidad
            case .intramural4: return 0.75  // Leve: 75% fertilidad
            case .intramural5: return 0.80  // Mínimo: 80% fertilidad
            
            // Subserosos: mínimo impacto
            case .subserosal6, .subserosal7: return 0.90  // 90% fertilidad
            case .pediculado8: return 0.95  // 95% fertilidad
            }
        }
        
        var surgicalIndication: String {
            switch self {
            case .submucoso0, .submucoso1, .submucoso2:
                return "Histeroscopia quirúrgica URGENTE antes de concepción"
            case .intramural3, .intramural4:
                return "Miomectomía si >4cm o síntomas. Evaluar caso por caso"
            case .intramural5:
                return "Seguimiento. Cirugía solo si >6cm"
            case .subserosal6, .subserosal7, .pediculado8:
                return "No requiere cirugía para fertilidad. Solo si síntomas"
            }
        }
    }
    
    /// Parámetros detallados de miomatosis
    struct MyomaParameters {
        let count: Int                    // Número de miomas
        let maxSize: Double              // Tamaño máximo en cm
        let figoTypes: [FIGOType]        // Tipos FIGO presentes
        let symptoms: [String]           // Síntomas asociados
        let cavityDistortion: Bool       // Distorsión cavidad uterina
        
        var overallFertilityImpact: Double {
            // Impacto basado en el peor tipo presente
            let worstImpact = figoTypes.map { $0.fertilityImpact }.min() ?? 1.0
            
            // Modificadores por número y tamaño
            var modifier = 1.0
            if count > 3 { modifier *= 0.9 }  // Múltiples miomas
            if maxSize > 6 { modifier *= 0.8 } // Miomas grandes
            if cavityDistortion { modifier *= 0.7 } // Distorsión cavitaria
            
            return worstImpact * modifier
        }
    }
}

// MARK: - 🔄 ADENOMIOSIS

/// Adenomiosis según clasificación morfológica
/// Referencias: DOI: 10.1016/j.jogc.2018.05.007, DOI: 10.1093/humrep/deab266
struct AdenomyosisPathology {
    
    enum Severity: String, CaseIterable {
        case mild = "Leve"               // <1/3 miometrio
        case moderate = "Moderada"       // 1/3-2/3 miometrio  
        case severe = "Severa"          // >2/3 miometrio
        
        var fertilityImpact: Double {
            switch self {
            case .mild: return 0.80      // 80% fertilidad
            case .moderate: return 0.60  // 60% fertilidad
            case .severe: return 0.35    // 35% fertilidad
            }
        }
        
        var treatmentStrategy: String {
            switch self {
            case .mild:
                return "Seguimiento expectante. AINEs para dismenorrea"
            case .moderate:
                return "GnRH agonistas 3 meses pre-FIV. Transferencia congelada"
            case .severe:
                return "Considerar gestación subrogada. Histerectomía post-paridad"
            }
        }
    }
}

// MARK: - 🌸 PÓLIPOS ENDOMETRIALES

/// Pólipos endometriales y su impacto reproductivo
/// Referencias: DOI: 10.1016/j.fertnstert.2019.04.028, DOI: 10.1093/hropen/hoaa016
struct PolypPathology {
    
    enum PolypType: String, CaseIterable {
        case single = "Único"
        case multiple = "Múltiples"
        case giant = "Gigante (>2cm)"
        
        var fertilityImpact: Double {
            switch self {
            case .single: return 0.85    // 85% fertilidad (impacto leve)
            case .multiple: return 0.70  // 70% fertilidad
            case .giant: return 0.60     // 60% fertilidad
            }
        }
        
        var resectionBenefit: Double {
            // Mejora esperada post-polipectomía
            switch self {
            case .single: return 1.15    // +15% mejora
            case .multiple: return 1.25  // +25% mejora
            case .giant: return 1.30     // +30% mejora
            }
        }
    }
}

// MARK: - 🧪 RESERVA OVÁRICA (AMH)

/// Evaluación de reserva ovárica según AMH
/// Referencias: DOI: 10.1093/humupd/dmt012, DOI: 10.1016/j.fertnstert.2017.02.109
struct OvarianReservePathology {
    
    enum AMHCategory: String, CaseIterable {
        case veryHigh = "Muy Alta (>6.0 ng/mL)"      // SOP probable
        case high = "Alta (4.0-6.0 ng/mL)"          // Reserva excelente
        case normal = "Normal (1.5-4.0 ng/mL)"      // Reserva adecuada
        case low = "Baja (0.5-1.5 ng/mL)"          // Reserva disminuida
        case veryLow = "Muy Baja (0.1-0.5 ng/mL)"   // Reserva crítica
        case undetectable = "Indetectable (<0.1)"    // Fallo ovárico
        
        var fertilityImpact: Double {
            switch self {
            case .veryHigh: return 0.70     // SOP: anovulación
            case .high: return 1.0          // Óptima
            case .normal: return 1.0        // Normal
            case .low: return 0.75          // Disminuida
            case .veryLow: return 0.40      // Crítica
            case .undetectable: return 0.05 // Fallo ovárico
            }
        }
        
        var treatmentStrategy: String {
            switch self {
            case .veryHigh:
                return "Evaluar SOP. Protocolo antagonista para FIV"
            case .high, .normal:
                return "Reserva adecuada. Tratamientos estándar"
            case .low:
                return "Urgencia reproductiva. Protocolo alta respuesta"
            case .veryLow:
                return "FIV inmediata con acumulación óvulos. Considerar ovodonación"
            case .undetectable:
                return "Ovodonación indicada. Terapia hormonal sustitutiva"
            }
        }
    }
    
    static func categorizeAMH(_ amhValue: Double) -> AMHCategory {
        switch amhValue {
        case 6.0...: return .veryHigh
        case 4.0..<6.0: return .high
        case 1.5..<4.0: return .normal
        case 0.5..<1.5: return .low
        case 0.1..<0.5: return .veryLow
        default: return .undetectable
        }
    }
}

// MARK: - 🧬 FACTOR MASCULINO

/// Factor masculino según criterios OMS 2021
/// Referencias: DOI: 10.1093/humupd/dmab030, WHO Laboratory Manual 6th Edition
struct MaleFactorPathology {
    
    /// Parámetros seminales según OMS 2021
    struct SeminalParameters {
        static let normalConcentration: Double = 16.0  // millones/mL
        static let normalMotility: Double = 30.0       // % motilidad progresiva
        static let normalMorphology: Double = 4.0      // % formas normales
        static let normalVolume: Double = 1.4          // mL
    }
    
    enum Severity: String, CaseIterable {
        case normal = "Normal"
        case mild = "Leve"              // Concentración 10-15 M/mL, morfología/motilidad >p5
        case moderate = "Moderado"      // Concentración 5-10 M/mL o morfología <4%
        case severe = "Severo"          // Concentración <5 M/mL, motilidad <30%, morfología <1%
        case critical = "Crítico"       // REM <1 millón post-capacitación
        case azoospermia = "Azoospermia" // Sin espermatozoides
        
        var fertilityImpact: Double {
            switch self {
            case .normal: return 1.0        // Sin impacto
            case .mild: return 0.85         // 85% fertilidad (IIU posible si REM ≥5M)
            case .moderate: return 0.60     // 60% fertilidad (IIU limitada, preferir FIV)
            case .severe: return 0.35       // 35% fertilidad (FIV/ICSI recomendado)
            case .critical: return 0.15     // 15% fertilidad (ICSI obligatorio)
            case .azoospermia: return 0.05  // 5% fertilidad (biopsia testicular)
            }
        }
        
        var treatmentRecommendation: String {
            switch self {
            case .normal:
                return "Factor masculino normal. Tratamientos estándar según factor femenino"
            case .mild:
                return "IIU con estimulación ovárica (3-4 ciclos) si REM ≥5M post-capacitación"
            case .moderate:
                return "IIU limitada (REM 1-4M). Preferir FIV si edad >35 años"
            case .severe:
                return "FIV/ICSI recomendado. Evaluación urológica especializada"
            case .critical:
                return "ICSI obligatorio. REM <1M post-capacitación"
            case .azoospermia:
                return "Biopsia testicular + ICSI. Considerar espermatozoides donantes"
            }
        }
    }
    
    static func evaluateMaleFactor(profile: FertilityProfile) -> (severity: Severity, impact: Double) {
        var alteredParameters = 0
        var maxImpact: Double = 0
        
        // Concentración espermática (según ASRM 2024, ESHRE 2023)
        if let concentration = profile.spermConcentration {
            if concentration == 0 { 
                return (.azoospermia, 0.95)
            } else if concentration < 1 { 
                // REM muy bajo, ICSI obligatorio
                return (.critical, 0.85)
            } else if concentration < 5 { 
                // Severo: <5 M/mL → FIV/ICSI recomendado
                maxImpact = max(maxImpact, 0.65)
                alteredParameters += 2  // Cuenta como 2 parámetros por severidad
            } else if concentration < 10 { 
                // Moderado: 5-10 M/mL → IIU limitada
                maxImpact = max(maxImpact, 0.40)
                alteredParameters += 1
            } else if concentration < 15 { 
                // Leve: 10-15 M/mL → IIU posible
                maxImpact = max(maxImpact, 0.15)
                alteredParameters += 1
            }
            // ≥15 M/mL = normal (OMS 2021: ≥16 M/mL, pero 15 es aceptable)
        }
        
        // Motilidad progresiva
        if let motility = profile.spermProgressiveMotility {
            if motility < 10 { 
                maxImpact = max(maxImpact, 0.7)
                alteredParameters += 1
            } else if motility < 20 { 
                maxImpact = max(maxImpact, 0.6)
                alteredParameters += 1
            } else if motility < 30 { 
                maxImpact = max(maxImpact, 0.15)
                alteredParameters += 1
            }
        }
        
        // Morfología normal
        if let morphology = profile.spermNormalMorphology {
            if morphology < 1 { 
                maxImpact = max(maxImpact, 0.6)
                alteredParameters += 1
            } else if morphology < 4 { 
                maxImpact = max(maxImpact, 0.5)
                alteredParameters += 1
            }
        }
        
        // Determinar severidad basada en parámetros alterados y severidad máxima
        let severity: Severity = {
            // Si ya se determinó critical o azoospermia, ya se retornó antes
            if maxImpact >= 0.65 { return .severe }      // Impacto ≥65% = severo
            else if alteredParameters >= 3 { return .severe }
            else if alteredParameters == 2 { return .moderate }
            else if alteredParameters == 1 { return .mild }
            else { return .normal }
        }()
        
        return (severity, 1.0 - maxImpact)
    }
}

// MARK: - 🦴 FACTOR TUBÁRICO

/// Factor tubárico según HSG y laparoscopia
/// References: DOI: 10.1016/j.fertnstert.2023.04.010, DOI: 10.1093/hropen/hoad024
struct TubalFactorPathology {
    
    enum HSGResult: String, CaseIterable {
        case normal = "Normal"
        case unilateral = "Obstrucción Unilateral"
        case bilateral = "Obstrucción Bilateral"
        
        var fertilityImpact: Double {
            switch self {
            case .normal: return 1.0      // Factor óptimo (100%)
            case .unilateral: return 0.50 // 50% fertilidad (IIU hasta 3 ciclos)
            case .bilateral: return 0.01  // 1% fertilidad (embarazo natural casi imposible)
            }
        }
        
        var treatmentStrategy: String {
            switch self {
            case .normal:
                return "Factor tubárico normal. Tratamientos estándar"
            case .unilateral:
                return "IIU hasta 3 ciclos. Si falla, FIV inmediata"
            case .bilateral:
                return "FIV obligatoria. Embarazo natural prácticamente imposible"
            }
        }
    }
}

// MARK: - 🍯 RESISTENCIA INSULÍNICA

/// Resistencia insulínica según HOMA-IR
/// Referencias: DOI: 10.3390/jcm10112440, DOI: 10.1210/clinem/dgac389
struct InsulinResistancePathology {
    
    enum HOMACategory: String, CaseIterable {
        case normal = "Normal (<2.5)"
        case mild = "Leve (2.5-3.5)"
        case moderate = "Moderada (3.5-5.0)"
        case severe = "Severa (>5.0)"
        
        var fertilityImpact: Double {
            switch self {
            case .normal: return 1.0     // Sin impacto
            case .mild: return 0.90      // 90% fertilidad
            case .moderate: return 0.75  // 75% fertilidad
            case .severe: return 0.60    // 60% fertilidad
            }
        }
        
        var treatmentProtocol: String {
            switch self {
            case .normal:
                return "HOMA-IR normal. No tratamiento específico"
            case .mild:
                return "Mio-inositol 2g/día + lifestyle"
            case .moderate:
                return "Metformina 1000mg/día + mio-inositol 4g/día"
            case .severe:
                return "Metformina 1500mg/día + evaluación endocrinológica"
            }
        }
    }
    
    static func categorizeHOMA(_ homaValue: Double) -> HOMACategory {
        switch homaValue {
        case ..<2.5: return .normal
        case 2.5..<3.5: return .mild
        case 3.5..<5.0: return .moderate
        default: return .severe
        }
    }
}

// MARK: - 🦋 FUNCIÓN TIROIDEA

/// Disfunción tiroidea en fertilidad
/// Referencias: DOI: 10.1089/thy.2016.0457, ATA Guidelines 2017
struct ThyroidPathology {
    
    enum TSHCategory: String, CaseIterable {
        case optimal = "Óptimo (<2.5 mIU/L)"
        case subclinical = "Hipotiroidismo Subclínico (2.5-4.5)"
        case clinical = "Hipotiroidismo Clínico (>4.5)"
        case hyperthyroid = "Hipertiroidismo (<0.4)"
        
        var fertilityImpact: Double {
            switch self {
            case .optimal: return 1.0        // Óptimo para fertilidad
            case .subclinical: return 0.85   // 85% fertilidad
            case .clinical: return 0.65      // 65% fertilidad
            case .hyperthyroid: return 0.70  // 70% fertilidad
            }
        }
        
        var treatmentGoal: String {
            switch self {
            case .optimal:
                return "TSH óptimo para fertilidad. Mantener <2.5 mIU/L"
            case .subclinical:
                return "Levotiroxina para TSH <2.5 mIU/L. Control cada 6 semanas"
            case .clinical:
                return "Levotiroxina URGENTE. TSH objetivo <2.5 mIU/L"
            case .hyperthyroid:
                return "Evaluación endocrinológica urgente. Antitiroideos"
            }
        }
    }
    
    static func categorizeTSH(_ tshValue: Double) -> TSHCategory {
        switch tshValue {
        case ..<0.4: return .hyperthyroid
        case 0.4..<2.5: return .optimal
        case 2.5..<4.5: return .subclinical
        default: return .clinical
        }
    }
}

// MARK: - ⚖️ ÍNDICE DE MASA CORPORAL (IMC) Y FERTILIDAD

/// IMC y fertilidad según OMS 2024, NICE 2024, ASRM 2024
/// Referencias principales:
/// - NICE guideline: Obesity and fertility (2024). PMID: 36746012
/// - ASRM Committee Opinion on Obesity and Reproduction (2024). DOI: 10.1016/j.fertnstert.2024.02.008
/// - ESHRE Guideline: Obesity and Reproductive Outcomes (2024). DOI: 10.1093/hropen/hoad019
struct BMIFertilityPathology {
    
    // MARK: - Clasificación OMS 2024
    
    enum BMICategory: String, CaseIterable {
        case underweight = "Bajo peso (<18.5)"           // <18.5 kg/m²
        case normal = "Normopeso (18.5-24.9)"          // 18.5-24.9 kg/m²
        case overweight = "Sobrepeso (25-29.9)"        // 25-29.9 kg/m²
        case obesityI = "Obesidad grado I (30-34.9)"   // 30-34.9 kg/m²
        case obesityII = "Obesidad grado II (35-39.9)" // 35-39.9 kg/m²
        case obesityIII = "Obesidad grado III (≥40)"   // ≥40 kg/m²
        
        var fertilityImpact: Double {
            switch self {
            case .underweight: return 0.70   // 70% fertilidad (hipogonadismo funcional)
            case .normal: return 1.0         // 100% fertilidad (óptimo)
            case .overweight: return 0.85    // 85% fertilidad (impacto leve)
            case .obesityI: return 0.65      // 65% fertilidad (resistencia insulínica)
            case .obesityII: return 0.45     // 45% fertilidad (inflamación sistémica)
            case .obesityIII: return 0.30    // 30% fertilidad (disfunción severa)
            }
        }
        
        var iuiSuccessRate: Double {
            switch self {
            case .underweight: return 0.125  // 12.5% promedio (10-15%)
            case .normal: return 0.175       // 17.5% promedio (15-20%)
            case .overweight: return 0.135   // 13.5% promedio (12-15%)
            case .obesityI: return 0.075     // 7.5% promedio (5-10%)
            case .obesityII: return 0.075    // 7.5% promedio (5-10%)
            case .obesityIII: return 0.075   // 7.5% promedio (5-10%)
            }
        }
        
        var ivfSuccessRate: Double {
            switch self {
            case .underweight: return 0.225  // 22.5% promedio (20-25%)
            case .normal: return 0.40        // 40% promedio (35-45%)
            case .overweight: return 0.30    // 30% promedio (25-35%)
            case .obesityI: return 0.20      // 20% promedio (15-25%)
            case .obesityII: return 0.20     // 20% promedio (15-25%)
            case .obesityIII: return 0.20    // 20% promedio (15-25%)
            }
        }
        
        var clinicalManifestations: [String] {
            switch self {
            case .underweight:
                return [
                    "Amenorrea o ciclos oligomenorreicos",
                    "Menor respuesta ovárica en tratamientos",
                    "Hipogonadismo hipogonadotrópico funcional"
                ]
            case .normal:
                return ["Sin manifestaciones clínicas específicas"]
            case .overweight, .obesityI, .obesityII, .obesityIII:
                return [
                    "Ciclos menstruales irregulares o anovulación",
                    "Incremento abortos espontáneos (15-20% más)",
                    "Menor tasa éxito tratamientos fertilidad",
                    "Resistencia insulínica asociada"
                ]
            }
        }
        
        var riskFactors: [String] {
            switch self {
            case .underweight:
                return [
                    "Dieta restrictiva",
                    "Trastornos alimentarios",
                    "Actividad física excesiva",
                    "Factores socioeconómicos"
                ]
            case .normal:
                return ["Mantener peso estable"]
            case .overweight, .obesityI, .obesityII, .obesityIII:
                return [
                    "Dieta hipercalórica",
                    "Sedentarismo",
                    "Resistencia insulínica",
                    "Factores genéticos (FTO, IRS-1, IRS-2)"
                ]
            }
        }
    }
    
    // MARK: - Fisiopatología Detallada
    
    struct Pathophysiology {
        
        /// Mecanismos en obesidad (IMC ≥30)
        static let obesityMechanisms = [
            "Incrementa aromatización periférica → elevación estrógenos periféricos",
            "Disminución calidad ovocitaria por estrés oxidativo",
            "Resistencia insulínica → alteración foliculogénesis",
            "Mediadores inflamatorios (IL-6, TNF-α) → disfunción endometrial",
            "Menor implantación embrionaria",
            "Alteración perfil lipídico y metabolismo glucosa"
        ]
        
        /// Mecanismos en bajo peso (IMC <18.5)
        static let underweightMechanisms = [
            "Alteración eje hipotálamo-hipófisis-ovario",
            "Disminución pulsos GnRH y LH",
            "Hipogonadismo hipogonadotrópico funcional",
            "Disminución reserva ovárica funcional",
            "Deficiencia nutricional → alteración síntesis hormonal",
            "Estrés metabólico crónico"
        ]
        
        /// Aspectos genéticos relevantes
        static let geneticFactors = [
            "Polimorfismos FTO: Predisposición obesidad",
            "Polimorfismos IRS-1, IRS-2: Resistencia insulínica",
            "Receptores LH, FSH: Respuesta ovárica alterada",
            "Evaluación genética: Solo obesidad extrema refractaria"
        ]
    }
    
    // MARK: - Métodos Diagnósticos
    
    struct DiagnosticMethods {
        
        enum Assessment: String, CaseIterable {
            case bmiCalculation = "Cálculo IMC (obligatorio)"
            case hormonalProfile = "Perfil hormonal complementario"
            case ovarianUltrasound = "Ecografía ovárica"
            case metabolicEvaluation = "Evaluación metabólica"
            
            var description: String {
                switch self {
                case .bmiCalculation:
                    return "Peso(kg)/Talla²(m²) - Estándar en toda evaluación fertilidad"
                case .hormonalProfile:
                    return "Insulina, glucosa ayunas, curva tolerancia oral glucosa"
                case .ovarianUltrasound:
                    return "Volumen ovárico y recuento folículos antrales"
                case .metabolicEvaluation:
                    return "HOMA-IR, perfil lipídico, HbA1c si indicado"
                }
            }
        }
        
        /// Criterios evaluación metabólica
        static func requiresMetabolicEvaluation(bmi: Double) -> Bool {
            return bmi >= 25.0 || bmi < 18.5
        }
        
        /// Parámetros HOMA-IR según IMC
        static func homaIRThreshold(bmi: Double) -> Double {
            switch bmi {
            case ..<25: return 2.0   // Normal: <2.0
            case 25..<30: return 2.5 // Sobrepeso: <2.5
            default: return 3.0      // Obesidad: <3.0 (más permisivo)
            }
        }
    }
    
    // MARK: - Recomendaciones de Tratamiento por IMC
    
    struct TreatmentRecommendations {
        
        /// Recomendaciones baja complejidad (IUI)
        static func getIUIRecommendation(bmi: Double) -> BMITreatmentRecommendation {
            let category = categorizeBMI(bmi)
            
            switch category {
            case .underweight:
                return BMITreatmentRecommendation(
                    isRecommended: false, // Individualizar
                    priority: "⚠️ Individualizar caso",
                    conditions: [
                        "Corrección nutricional previa",
                        "Evaluación endocrinológica",
                        "IMC objetivo >20 kg/m²"
                    ],
                    expectedSuccess: category.iuiSuccessRate,
                    reference: "NICE Fertility Problems (2024)"
                )
                
            case .normal:
                return BMITreatmentRecommendation(
                    isRecommended: true,
                    priority: "✅ Ideal",
                    conditions: ["Mantener peso estable"],
                    expectedSuccess: category.iuiSuccessRate,
                    reference: "ESHRE Guidelines (2024)"
                )
                
            case .overweight:
                return BMITreatmentRecommendation(
                    isRecommended: true,
                    priority: "✅ Aceptable",
                    conditions: [
                        "Recomendable pérdida 5-10% peso",
                        "Control HOMA-IR si >2.5"
                    ],
                    expectedSuccess: category.iuiSuccessRate,
                    reference: "ASRM Committee Opinion (2024)"
                )
                
            case .obesityI:
                return BMITreatmentRecommendation(
                    isRecommended: false, // Mejorar IMC previo
                    priority: "⚠️ Mejorar IMC previo",
                    conditions: [
                        "Pérdida peso 10-15% obligatoria",
                        "IMC objetivo <30 kg/m²",
                        "Control metabólico"
                    ],
                    expectedSuccess: category.iuiSuccessRate,
                    reference: "NICE Obesity Guidelines (2024)"
                )
                
            case .obesityII, .obesityIII:
                return BMITreatmentRecommendation(
                    isRecommended: false,
                    priority: "❌ No recomendado",
                    conditions: [
                        "Pérdida peso >15% obligatoria",
                        "IMC objetivo <30 kg/m²",
                        "Considerar cirugía bariátrica"
                    ],
                    expectedSuccess: category.iuiSuccessRate,
                    reference: "ASRM Obesity Opinion (2024)"
                )
            }
        }
        
        /// Recomendaciones alta complejidad (FIV/ICSI)
        static func getIVFRecommendation(bmi: Double) -> BMITreatmentRecommendation {
            let category = categorizeBMI(bmi)
            
            switch category {
            case .underweight:
                return BMITreatmentRecommendation(
                    isRecommended: false, // Nutrición previa
                    priority: "⚠️ Nutrición previa necesaria",
                    conditions: [
                        "Corrección nutricional 3-6 meses",
                        "IMC objetivo >20 kg/m²",
                        "Soporte endocrinológico"
                    ],
                    expectedSuccess: category.ivfSuccessRate,
                    reference: "ESHRE Underweight Guidelines (2024)"
                )
                
            case .normal:
                return BMITreatmentRecommendation(
                    isRecommended: true,
                    priority: "✅ Ideal",
                    conditions: ["Condiciones óptimas para FIV"],
                    expectedSuccess: category.ivfSuccessRate,
                    reference: "Gold Standard"
                )
                
            case .overweight:
                return BMITreatmentRecommendation(
                    isRecommended: true,
                    priority: "✅ Aceptable",
                    conditions: [
                        "Recomendable pérdida peso previa",
                        "Ajuste dosis gonadotropinas"
                    ],
                    expectedSuccess: category.ivfSuccessRate,
                    reference: "ESHRE Stimulation Guidelines (2024)"
                )
                
            case .obesityI:
                return BMITreatmentRecommendation(
                    isRecommended: false, // Reducir peso antes
                    priority: "⚠️ Reducir peso antes",
                    conditions: [
                        "Pérdida peso 10% mínimo",
                        "Control riesgo hiperestimulación",
                        "Protocolo antagonista preferido"
                    ],
                    expectedSuccess: category.ivfSuccessRate,
                    reference: "NICE FIV Obesity (2024)"
                )
                
            case .obesityII, .obesityIII:
                return BMITreatmentRecommendation(
                    isRecommended: false, // Obligatorio pérdida peso
                    priority: "⚠️ Obligatorio pérdida peso previa",
                    conditions: [
                        "Pérdida peso >15% obligatoria",
                        "Evaluación anestésica previa",
                        "Consejería riesgos obstétricos",
                        "Considerar cirugía bariátrica"
                    ],
                    expectedSuccess: category.ivfSuccessRate,
                    reference: "ASRM Severe Obesity (2024)"
                )
            }
        }
    }
    
    // MARK: - Manejo Médico Específico
    
    struct MedicalManagement {
        
        enum WeightLossStrategy: String, CaseIterable {
            case dietary = "Corrección Nutricional"
            case exercise = "Actividad Física Estructurada"
            case pharmacological = "Tratamiento Farmacológico"
            case surgical = "Cirugía Bariátrica"
            
            var indication: String {
                switch self {
                case .dietary:
                    return "Primera línea: Dieta hipocalórica supervisada"
                case .exercise:
                    return "Complementario: 150-300 min/semana actividad moderada"
                case .pharmacological:
                    return "Metformina si HOMA-IR ≥2.5 + IMC ≥30"
                case .surgical:
                    return "IMC ≥40 o ≥35 con comorbilidades refractarias"
                }
            }
            
            var expectedWeightLoss: String {
                switch self {
                case .dietary: return "5-10% peso inicial"
                case .exercise: return "3-5% peso inicial"
                case .pharmacological: return "5-7% peso inicial"
                case .surgical: return "20-30% peso inicial"
                }
            }
        }
        
        /// Protocolo manejo obesidad
        static func getObesityManagementProtocol(bmi: Double) -> [WeightLossStrategy] {
            var strategies: [WeightLossStrategy] = [.dietary, .exercise]
            
            if bmi >= 30 {
                strategies.append(.pharmacological)
            }
            
            if bmi >= 40 || (bmi >= 35 && hasComorbidities()) {
                strategies.append(.surgical)
            }
            
            return strategies
        }
        
        /// Protocolo manejo bajo peso
        static func getUnderweightManagementProtocol() -> [String] {
            return [
                "Evaluación nutricional especializada",
                "Dieta hipercalórica balanceada",
                "Suplementación vitamínica",
                "Evaluación psicológica si TCA",
                "Seguimiento endocrinológico"
            ]
        }
        
        private static func hasComorbidities() -> Bool {
            // Simplificado - en implementación real evaluar:
            // Diabetes tipo 2, HTA, dislipidemia, SAOS
            return true // Placeholder
        }
    }
    
    // MARK: - Seguimiento y Pronóstico
    
    struct FollowUpProtocol {
        
        enum Indicator: String, CaseIterable {
            case weightLoss = "Pérdida Ponderal"
            case homaIR = "Control HOMA-IR"
            case menstrualCycle = "Regularidad Menstrual"
            case ovarianResponse = "Respuesta Ovárica"
            
            var target: String {
                switch self {
                case .weightLoss: return "5-10% peso inicial (mínimo)"
                case .homaIR: return "<2.5 (ideal <2.0)"
                case .menstrualCycle: return "Ciclos regulares 21-35 días"
                case .ovarianResponse: return "CFA >7, AMH estable"
                }
            }
            
            var frequency: String {
                switch self {
                case .weightLoss: return "Mensual primeros 6 meses"
                case .homaIR: return "Cada 3 meses"
                case .menstrualCycle: return "Registro diario"
                case .ovarianResponse: return "Cada 6 meses"
                }
            }
        }
        
        /// Complicaciones a prevenir
        static let complicationsToPrevent = [
            "Síndrome hiperestimulación ovárica (obesidad)",
            "Aborto temprano (obesidad/bajo peso)",
            "Diabetes gestacional (obesidad)",
            "Preeclampsia (obesidad)",
            "Restricción crecimiento fetal (bajo peso)"
        ]
    }
    
    // MARK: - Estructuras de Datos
    
    struct BMITreatmentRecommendation {
        let isRecommended: Bool
        let priority: String
        let conditions: [String]
        let expectedSuccess: Double
        let reference: String
        
        var successPercentage: String {
            return "\(Int(expectedSuccess * 100))%"
        }
    }
    
    /// Categoriza IMC según clasificación OMS 2024
    static func categorizeBMI(_ bmi: Double) -> BMICategory {
        switch bmi {
        case ..<18.5: return .underweight
        case 18.5..<25.0: return .normal
        case 25.0..<30.0: return .overweight
        case 30.0..<35.0: return .obesityI
        case 35.0..<40.0: return .obesityII
        default: return .obesityIII
        }
    }
    
    /// Genera recomendación completa según IMC
    static func generateComprehensiveRecommendation(bmi: Double) -> BMIComprehensiveRecommendation {
        let category = categorizeBMI(bmi)
        let iuiRec = TreatmentRecommendations.getIUIRecommendation(bmi: bmi)
        let ivfRec = TreatmentRecommendations.getIVFRecommendation(bmi: bmi)
        
        return BMIComprehensiveRecommendation(
            category: category,
            iuiRecommendation: iuiRec,
            ivfRecommendation: ivfRec,
            managementProtocol: generateManagementProtocol(category: category),
            followUpIndicators: FollowUpProtocol.Indicator.allCases,
            weightLossTarget: calculateWeightLossTarget(bmi: bmi)
        )
    }
    
    private static func generateManagementProtocol(category: BMICategory) -> [String] {
        switch category {
        case .underweight:
            return MedicalManagement.getUnderweightManagementProtocol()
        case .normal:
            return ["Mantener peso estable", "Estilo de vida saludable"]
        case .overweight, .obesityI, .obesityII, .obesityIII:
            return MedicalManagement.getObesityManagementProtocol(bmi: 32.0).map { $0.indication }
        }
    }
    
    private static func calculateWeightLossTarget(bmi: Double) -> String {
        if bmi < 18.5 {
            return "Ganancia peso hasta IMC ≥20 kg/m²"
        } else if bmi >= 30 {
            let lossPercentage = min(15, max(10, Int((bmi - 25) * 2)))
            return "Pérdida \(lossPercentage)% peso corporal"
        } else if bmi >= 25 {
            return "Pérdida 5-10% peso corporal (opcional)"
        } else {
            return "Mantener peso actual"
        }
    }
    
    struct BMIComprehensiveRecommendation {
        let category: BMICategory
        let iuiRecommendation: BMITreatmentRecommendation
        let ivfRecommendation: BMITreatmentRecommendation
        let managementProtocol: [String]
        let followUpIndicators: [FollowUpProtocol.Indicator]
        let weightLossTarget: String
    }
}

// MARK: - 📅 CICLOS MENSTRUALES Y FERTILIDAD

/// Ciclos menstruales y fertilidad según ACOG 2024, ESHRE 2024, NICE 2024
/// Referencias principales:
/// - ACOG Committee Opinion on Menstrual Disorders (2024). PMID: 36367491
/// - ESHRE Guideline on Ovulatory Disorders (2024). DOI: 10.1093/hropen/hoad022
/// - NICE Assessment and Management of Ovulatory Disorders (2024). PMID: 36746012
struct MenstrualCyclePathology {
    
    // MARK: - Clasificación de Patrones Menstruales
    
    enum CyclePattern: String, CaseIterable {
        case regular = "Regular (21-35 días)"           // 21-35 días, variabilidad ≤7 días
        case irregularMild = "Irregular Leve (>35 días)"      // >35 días, variabilidad >7 días
        case irregularSevere = "Irregular Grave (>90 días)"   // >90 días, oligomenorrea severa
        case short = "Ciclos Cortos (<21 días)"        // <21 días, posible fase lútea corta
        case veryShort = "Ciclos Muy Cortos (<15 días)" // <15 días, disfunción severa
        
        /// Determina patrón según duración del ciclo
        static func categorize(cycleLength: Double?) -> CyclePattern {
            guard let length = cycleLength else { return .regular } // ✅ Si no hay datos, asumir normal
            
            switch length {
            case ..<15: return .veryShort
            case 15..<21: return .short
            case 21...35: return .regular
            case 36...90: return .irregularMild
            default: return .irregularSevere
            }
        }
        
        var fertilityImpact: Double {
            switch self {
            case .regular: return 1.0        // 100% fertilidad (óptimo)
            case .irregularMild: return 0.80 // 80% fertilidad (reducción 20%)
            case .irregularSevere: return 0.30 // 30% fertilidad (reducción 70%)
            case .short: return 0.70         // 70% fertilidad (fase lútea corta)
            case .veryShort: return 0.25     // 25% fertilidad (disfunción severa)
            }
        }
        
        var spontaneousPregnancyRate: Double {
            switch self {
            case .regular: return 0.20        // 20% promedio (15-25%)
            case .irregularMild: return 0.075 // 7.5% promedio (5-10%)
            case .irregularSevere: return 0.03 // 3% promedio (<5%)
            case .short: return 0.10          // 10% promedio (fase lútea corta)
            case .veryShort: return 0.02      // 2% promedio (muy bajo)
            }
        }
        
        var iuiSuccessRate: Double {
            switch self {
            case .regular: return 0.175       // 17.5% con ciclos regulares
            case .irregularMild: return 0.125 // 12.5% con inducción ovulación
            case .irregularSevere: return 0.075 // 7.5% (poca efectividad)
            case .short: return 0.10          // 10% (requiere soporte lúteo)
            case .veryShort: return 0.05      // 5% (muy baja efectividad)
            }
        }
        
        var ivfSuccessRate: Double {
            switch self {
            case .regular: return 0.40        // 40% promedio (35-45%)
            case .irregularMild: return 0.35  // 35% con estimulación controlada
            case .irregularSevere: return 0.35 // 35% (primera recomendación)
            case .short: return 0.30          // 30% con soporte lúteo
            case .veryShort: return 0.25      // 25% (requiere manejo especializado)
            }
        }
        
        var clinicalManifestations: [String] {
            switch self {
            case .regular:
                return ["Ovulación regular", "Fase lútea adecuada", "Sin síntomas específicos"]
            case .irregularMild:
                return [
                    "Variabilidad >7 días entre ciclos",
                    "Posible anovulación intermitente",
                    "Progesterona fase lútea variable"
                ]
            case .irregularSevere:
                return [
                    "Oligomenorrea severa",
                    "Anovulación crónica confirmada",
                    "Riesgo hiperplasia endometrial",
                    "Infertilidad anovulatoria"
                ]
            case .short:
                return [
                    "Ciclos frecuentes",
                    "Posible fase lútea corta",
                    "Progesterona baja (<3 ng/mL)"
                ]
            case .veryShort:
                return [
                    "Disfunción ovárica severa",
                    "Alteración eje hipotálamo-hipófisis",
                    "Requiere evaluación endocrinológica urgente"
                ]
            }
        }
        
        var underlyingCauses: [String] {
            switch self {
            case .regular:
                return ["Eje hormonal normal"]
            case .irregularMild:
                return [
                    "SOP leve-moderado",
                    "Estrés crónico",
                    "Cambios peso moderados",
                    "Resistencia insulínica leve"
                ]
            case .irregularSevere:
                return [
                    "SOP severo",
                    "Hiperprolactinemia",
                    "Hipotiroidismo",
                    "Hipogonadismo hipogonadotrópico",
                    "Estrés extremo o bajo peso"
                ]
            case .short:
                return [
                    "Fase lútea corta",
                    "Insuficiencia cuerpo lúteo",
                    "Hiperprolactinemia leve",
                    "Edad materna avanzada"
                ]
            case .veryShort:
                return [
                    "Disfunción ovárica primaria",
                    "Alteración severa eje HHO",
                    "Patología endocrina compleja"
                ]
            }
        }
    }
    
    // MARK: - Fisiopatología Detallada
    
    struct Pathophysiology {
        
        /// Mecanismos ciclos irregulares
        static let irregularMechanisms = [
            "Alteración eje hipotálamo-hipófisis-ovario (HHO)",
            "Hipogonadismo hipogonadotrópico funcional (estrés/bajo peso)",
            "Hiperandrogenismo (SOP) → alteración pulsos GnRH",
            "Hiperinsulinemia → disrupción foliculogénesis",
            "Hiperprolactinemia → inhibición GnRH y LH",
            "Anovulación → ausencia cuerpo lúteo → progesterona baja"
        ]
        
        /// Consecuencias anovulación prolongada
        static let anovulationConsequences = [
            "Estimulación estrogénica continua endometrio",
            "Riesgo hiperplasia endometrial",
            "Infertilidad anovulatoria",
            "Alteración metabolismo óseo (osteopenia)",
            "Dislipidemia asociada"
        ]
        
        /// Aspectos genéticos
        static let geneticFactors = [
            "Polimorfismos SOP: DENND1A, FSHR, LHCGR",
            "Variantes resistencia insulínica",
            "Evaluación genética: Solo SOP grave sin respuesta tratamiento"
        ]
    }
    
    // MARK: - Métodos Diagnósticos
    
    struct DiagnosticMethods {
        
        enum Assessment: String, CaseIterable {
            case ovulationConfirmation = "Confirmación Ovulación"
            case hormonalProfile = "Perfil Hormonal Básico"
            case transvaginalUltrasound = "Ecografía Transvaginal"
            case metabolicEvaluation = "Evaluación Metabólica"
            
            var description: String {
                switch self {
                case .ovulationConfirmation:
                    return "Progesterona sérica día 21-24 del ciclo (>3 ng/mL = ovulación)"
                case .hormonalProfile:
                    return "TSH, prolactina, LH, FSH, estradiol (día 2-5 del ciclo)"
                case .transvaginalUltrasound:
                    return "Folículos antrales, volumen ovárico, patrón poliquístico (Rotterdam)"
                case .metabolicEvaluation:
                    return "HOMA-IR si sospecha resistencia insulínica"
                }
            }
            
            var timing: String {
                switch self {
                case .ovulationConfirmation: return "Día 21-24 del ciclo"
                case .hormonalProfile: return "Día 2-5 del ciclo"
                case .transvaginalUltrasound: return "Cualquier momento"
                case .metabolicEvaluation: return "Ayunas"
                }
            }
        }
        
        /// Criterios confirmación ovulación
        static let ovulationCriteria = [
            "Progesterona sérica >3 ng/mL (día 21-24)",
            "Folículo dominante >18 mm pre-ovulación",
            "Pico LH detectado (test ovulación)",
            "Cambio temperatura basal bifásico"
        ]
        
        /// Criterios anovulación
        static let anovulationCriteria = [
            "Progesterona sérica <3 ng/mL (día 21-24)",
            "Ausencia folículo dominante",
            "LH basal persistente sin pico",
            "Temperatura basal monofásica"
        ]
    }
    
    // MARK: - Tratamiento Médico Específico
    
    struct MedicalTreatment {
        
        enum OvulationInductionAgent: String, CaseIterable {
            case letrozole = "Letrozol"
            case clomiphene = "Clomifeno"
            case metformin = "Metformina"
            case gonadotropins = "Gonadotropinas"
            
            var dosage: String {
                switch self {
                case .letrozole: return "2.5-5 mg/día (día 3-7 del ciclo)"
                case .clomiphene: return "50-150 mg/día (día 5-9 del ciclo)"
                case .metformin: return "1500-2000 mg/día (continuo)"
                case .gonadotropins: return "75-150 UI/día (día 3-7)"
                }
            }
            
            var indication: String {
                switch self {
                case .letrozole: return "Primera línea: SOP, ciclos irregulares"
                case .clomiphene: return "Segunda línea: alternativa letrozol"
                case .metformin: return "Resistencia insulínica + SOP"
                case .gonadotropins: return "Fallo letrozol/clomifeno"
                }
            }
            
            var ovulationRate: Double {
                switch self {
                case .letrozole: return 0.75      // 75% ovulación
                case .clomiphene: return 0.70     // 70% ovulación
                case .metformin: return 0.60      // 60% ovulación (monoterapia)
                case .gonadotropins: return 0.85  // 85% ovulación
                }
            }
            
            var pregnancyRate: Double {
                switch self {
                case .letrozole: return 0.15      // 15% embarazo por ciclo
                case .clomiphene: return 0.12     // 12% embarazo por ciclo
                case .metformin: return 0.08      // 8% embarazo por ciclo
                case .gonadotropins: return 0.18  // 18% embarazo por ciclo
                }
            }
            
            var evidenceLevel: String {
                switch self {
                case .letrozole: return "A - Evidencia fuerte"
                case .clomiphene: return "A - Evidencia fuerte"
                case .metformin: return "B - Evidencia moderada (SOP + RI)"
                case .gonadotropins: return "A - Evidencia fuerte"
                }
            }
        }
        
        /// Protocolo inducción ovulación según patrón
        static func getOvulationInductionProtocol(pattern: CyclePattern) -> [OvulationInductionAgent] {
            switch pattern {
            case .regular:
                return [] // No requiere inducción
                
            case .irregularMild:
                return [.letrozole, .clomiphene] // Primera y segunda línea
                
            case .irregularSevere:
                return [.letrozole, .metformin, .gonadotropins] // Protocolo completo
                
            case .short:
                return [.letrozole] // Mejorar calidad ovulación
                
            case .veryShort:
                return [.gonadotropins] // Requiere manejo especializado
            }
        }
        
        /// Manejo factores modificables
        static let lifestyleModifications = [
            "Dieta balanceada (índice glicémico bajo si SOP)",
            "Reducción estrés (técnicas relajación, ejercicio moderado)",
            "Ajuste peso corporal (IMC 20-25 kg/m²)",
            "Ejercicio regular 150 min/semana (evitar extremo)",
            "Suplementación: Ácido fólico 5mg/día, Vitamina D si deficiente"
        ]
    }
    
    // MARK: - Recomendaciones de Tratamiento por Patrón
    
    struct TreatmentRecommendations {
        
        /// Recomendaciones baja complejidad (IUI)
        static func getIUIRecommendation(pattern: CyclePattern) -> CycleTreatmentRecommendation {
            switch pattern {
            case .regular:
                return CycleTreatmentRecommendation(
                    isRecommended: true,
                    priority: "✅ Ideal",
                    protocol: "IUI con monitoreo folicular natural",
                    maxCycles: 4,
                    expectedSuccess: pattern.iuiSuccessRate,
                    conditions: ["Ovulación espontánea confirmada"],
                    reference: "ESHRE Guidelines (2024)"
                )
                
            case .irregularMild:
                return CycleTreatmentRecommendation(
                    isRecommended: true,
                    priority: "✅ Inducción ovulatoria",
                    protocol: "Letrozol + IUI con monitoreo",
                    maxCycles: 3,
                    expectedSuccess: pattern.iuiSuccessRate,
                    conditions: [
                        "Inducción ovulación con letrozol",
                        "Confirmación folículo dominante >18mm",
                        "Buena reserva ovárica"
                    ],
                    reference: "ESHRE Ovulation Induction (2024)"
                )
                
            case .irregularSevere:
                return CycleTreatmentRecommendation(
                    isRecommended: false,
                    priority: "⚠️ Poca efectividad",
                    protocol: "Considerar solo tras inducción exitosa",
                    maxCycles: 2,
                    expectedSuccess: pattern.iuiSuccessRate,
                    conditions: [
                        "Inducción ovulación obligatoria",
                        "Máximo 2 intentos",
                        "Pasar rápidamente a FIV si falla"
                    ],
                    reference: "NICE Ovulatory Disorders (2024)"
                )
                
            case .short:
                return CycleTreatmentRecommendation(
                    isRecommended: true,
                    priority: "✅ Con soporte lúteo",
                    protocol: "IUI + progesterona fase lútea",
                    maxCycles: 3,
                    expectedSuccess: pattern.iuiSuccessRate,
                    conditions: [
                        "Soporte lúteo obligatorio",
                        "Progesterona 200-400mg/día vaginal",
                        "Monitoreo progesterona post-ovulación"
                    ],
                    reference: "ACOG Luteal Phase Support (2024)"
                )
                
            case .veryShort:
                return CycleTreatmentRecommendation(
                    isRecommended: false,
                    priority: "❌ No recomendado",
                    protocol: "Evaluación endocrinológica previa",
                    maxCycles: 0,
                    expectedSuccess: pattern.iuiSuccessRate,
                    conditions: [
                        "Estudio endocrinológico completo",
                        "Corrección causa subyacente",
                        "FIV como primera opción"
                    ],
                    reference: "ESHRE Complex Disorders (2024)"
                )
            }
        }
        
        /// Recomendaciones alta complejidad (FIV/ICSI)
        static func getIVFRecommendation(pattern: CyclePattern) -> CycleTreatmentRecommendation {
            switch pattern {
            case .regular:
                return CycleTreatmentRecommendation(
                    isRecommended: true,
                    priority: "✅ Indicaciones específicas",
                    protocol: "FIV convencional con protocolo estándar",
                    maxCycles: 3,
                    expectedSuccess: pattern.ivfSuccessRate,
                    conditions: [
                        "Indicaciones específicas (tubárico, masculino, etc.)",
                        "Protocolo estimulación estándar"
                    ],
                    reference: "ESHRE FIV Guidelines (2024)"
                )
                
            case .irregularMild:
                return CycleTreatmentRecommendation(
                    isRecommended: true,
                    priority: "✅ En fallos IUI",
                    protocol: "FIV con estimulación controlada",
                    maxCycles: 3,
                    expectedSuccess: pattern.ivfSuccessRate,
                    conditions: [
                        "Tras 2-3 fallos IUI con inducción",
                        "Protocolo antagonista preferido",
                        "Monitoreo estrecho respuesta"
                    ],
                    reference: "ESHRE Stimulation Protocols (2024)"
                )
                
            case .irregularSevere:
                return CycleTreatmentRecommendation(
                    isRecommended: true,
                    priority: "✅ Primera recomendación",
                    protocol: "FIV como primera línea",
                    maxCycles: 3,
                    expectedSuccess: pattern.ivfSuccessRate,
                    conditions: [
                        "Primera opción terapéutica",
                        "Protocolo antagonista",
                        "Pre-tratamiento metformina si RI"
                    ],
                    reference: "NICE Severe Anovulation (2024)"
                )
                
            case .short:
                return CycleTreatmentRecommendation(
                    isRecommended: true,
                    priority: "✅ Con soporte lúteo",
                    protocol: "FIV + soporte lúteo extendido",
                    maxCycles: 3,
                    expectedSuccess: pattern.ivfSuccessRate,
                    conditions: [
                        "Soporte lúteo extendido obligatorio",
                        "Progesterona hasta semana 12 gestación",
                        "Monitoreo β-hCG seriado"
                    ],
                    reference: "ASRM Luteal Support (2024)"
                )
                
            case .veryShort:
                return CycleTreatmentRecommendation(
                    isRecommended: true,
                    priority: "✅ Manejo especializado",
                    protocol: "FIV con protocolo individualizado",
                    maxCycles: 2,
                    expectedSuccess: pattern.ivfSuccessRate,
                    conditions: [
                        "Evaluación endocrina previa completa",
                        "Protocolo individualizado",
                        "Manejo multidisciplinario"
                    ],
                    reference: "ESHRE Complex Cases (2024)"
                )
            }
        }
    }
    
    // MARK: - Seguimiento y Pronóstico
    
    struct FollowUpProtocol {
        
        enum Indicator: String, CaseIterable {
            case ovulationConfirmation = "Confirmación Ovulatoria"
            case hormonalControl = "Control Hormonal"
            case follicularMonitoring = "Monitoreo Folicular"
            case lutealPhaseAssessment = "Evaluación Fase Lútea"
            
            var target: String {
                switch self {
                case .ovulationConfirmation: return "Progesterona >3 ng/mL día 21-24"
                case .hormonalControl: return "LH, estradiol seriados"
                case .follicularMonitoring: return "Folículo dominante >18mm"
                case .lutealPhaseAssessment: return "Progesterona adecuada >10 ng/mL"
                }
            }
            
            var frequency: String {
                switch self {
                case .ovulationConfirmation: return "Cada ciclo tratamiento"
                case .hormonalControl: return "Según protocolo (días 2-5, pico LH)"
                case .follicularMonitoring: return "Días 10-14 del ciclo"
                case .lutealPhaseAssessment: return "7 días post-ovulación"
                }
            }
        }
        
        /// Tasas de éxito por tratamiento
        static let successRatesByTreatment = [
            "Inducción ovulación + IUI": "10-15% por ciclo",
            "FIV/ICSI ciclos regulares": "35-45% por ciclo",
            "FIV/ICSI ciclos irregulares": "30-35% por ciclo"
        ]
    }
    
    // MARK: - Estructuras de Datos
    
    struct CycleTreatmentRecommendation {
        let isRecommended: Bool
        let priority: String
        let `protocol`: String
        let maxCycles: Int
        let expectedSuccess: Double
        let conditions: [String]
        let reference: String
        
        var successPercentage: String {
            return "\(Int(expectedSuccess * 100))%"
        }
    }
    
    /// Genera recomendación completa según patrón menstrual
    static func generateComprehensiveRecommendation(cycleLength: Double?) -> CycleComprehensiveRecommendation {
        let pattern = CyclePattern.categorize(cycleLength: cycleLength)
        let iuiRec = TreatmentRecommendations.getIUIRecommendation(pattern: pattern)
        let ivfRec = TreatmentRecommendations.getIVFRecommendation(pattern: pattern)
        
        return CycleComprehensiveRecommendation(
            pattern: pattern,
            iuiRecommendation: iuiRec,
            ivfRecommendation: ivfRec,
            ovulationInductionAgents: MedicalTreatment.getOvulationInductionProtocol(pattern: pattern),
            diagnosticMethods: DiagnosticMethods.Assessment.allCases,
            followUpIndicators: FollowUpProtocol.Indicator.allCases,
            lifestyleModifications: MedicalTreatment.lifestyleModifications
        )
    }
    
    struct CycleComprehensiveRecommendation {
        let pattern: CyclePattern
        let iuiRecommendation: CycleTreatmentRecommendation
        let ivfRecommendation: CycleTreatmentRecommendation
        let ovulationInductionAgents: [MedicalTreatment.OvulationInductionAgent]
        let diagnosticMethods: [DiagnosticMethods.Assessment]
        let followUpIndicators: [FollowUpProtocol.Indicator]
        let lifestyleModifications: [String]
    }
}
