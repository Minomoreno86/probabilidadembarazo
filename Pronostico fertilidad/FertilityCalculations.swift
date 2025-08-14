//
//  FertilityCalculations.swift
//  Pronóstico de Fertilidad
//
//  🧮 CÁLCULOS DE FERTILIDAD ESPECÍFICOS
//  Algoritmos matemáticos para evaluación de factores reproductivos
//  Basado en evidencia científica y modelos estadísticos
//
//  Created by Jorge Vásquez on 2024
//

import Foundation

// MARK: - 🧮 CALCULADORA PRINCIPAL DE FACTORES

struct FertilityCalculations {
    
    // MARK: - Cálculo de Edad
    
    /// Calcula fecundabilidad mensual según edad
    /// Referencia: Dunson et al. 2004, DOI: 10.1097/01.AOG.0000109522.32974.48
    static func calculateAgeFactor(_ age: Double) -> Double {
        // Modelo exponencial de declive de fertilidad por edad
        // Fecundabilidad máxima: 25% a los 22 años
        // Declive acelerado después de los 35 años
        
        switch age {
        case ..<22:
            return 0.25  // Máximo teórico: 25% mensual
        case 22..<25:
            return 0.25 - (age - 22) * 0.005  // Declive leve: -0.5% por año
        case 25..<30:
            return 0.235 - (age - 25) * 0.008 // Declive: -0.8% por año
        case 30..<35:
            return 0.195 - (age - 30) * 0.012 // Declive: -1.2% por año
        case 35..<38:
            return 0.135 - (age - 35) * 0.015 // Declive acelerado: -1.5% por año
        case 38..<40:
            return 0.090 - (age - 38) * 0.020 // Declive severo: -2.0% por año
        case 40..<42:
            return 0.050 - (age - 40) * 0.015 // Declive crítico: -1.5% por año
        case 42..<45:
            return max(0.020 - (age - 42) * 0.005, 0.005) // Mínimo: 0.5%
        default:
            return 0.005 // Fertilidad residual: 0.5% mensual
        }
    }
    
    // MARK: - Cálculo de IMC
    
    /// Calcula factor multiplicador según IMC
    /// Referencia actualizada: NICE 2024, ASRM 2024, ESHRE 2024
    /// DOI: 10.1016/j.fertnstert.2024.02.008, PMID: 36746012
    static func calculateBMIFactor(_ bmi: Double) -> Double {
        // Usar nueva clasificación detallada OMS 2024
        let category = BMIFertilityPathology.categorizeBMI(bmi)
        return category.fertilityImpact
    }
    
    // MARK: - Cálculo de AMH
    
    /// Calcula factor según reserva ovárica (AMH)
    /// Referencia: DOI: 10.1093/humupd/dmt012, DOI: 10.1016/j.fertnstert.2017.02.109
    static func calculateAMHFactor(_ amh: Double) -> Double {
        // Relación no-lineal: plateau normal, declive exponencial en valores bajos
        
        switch amh {
        case ..<0.1:
            return 0.05  // Indetectable: 5% fertilidad (fallo ovárico)
        case 0.1..<0.5:
            return 0.15 + (amh - 0.1) * 0.625  // 15-40% fertilidad (crítico)
        case 0.5..<1.0:
            return 0.40 + (amh - 0.5) * 0.70   // 40-75% fertilidad (bajo)
        case 1.0..<1.5:
            return 0.75 + (amh - 1.0) * 0.50   // 75-100% fertilidad (disminuido)
        case 1.5..<6.0:
            return 1.0   // Rango normal: fertilidad óptima
        case 6.0..<10.0:
            return 0.85  // AMH muy alta: probable SOP, anovulación
        default:
            return 0.70  // AMH extrema: SOP severo
        }
    }
    
    // MARK: - Cálculo de TSH
    
    /// Calcula factor según función tiroidea
    /// Referencia: DOI: 10.1089/thy.2016.0457, ATA Guidelines 2017
    static func calculateTSHFactor(_ tsh: Double) -> Double {
        // TSH óptimo para fertilidad: <2.5 mIU/L
        
        switch tsh {
        case ..<0.4:
            return 0.70  // Hipertiroidismo: 70% fertilidad
        case 0.4..<2.5:
            return 1.0   // Óptimo para fertilidad
        case 2.5..<4.0:
            return 0.90  // Hipotiroidismo subclínico leve: 90%
        case 4.0..<6.0:
            return 0.80  // Hipotiroidismo subclínico moderado: 80%
        case 6.0..<10.0:
            return 0.65  // Hipotiroidismo clínico: 65%
        default:
            return 0.50  // Hipotiroidismo severo: 50%
        }
    }
    
    // MARK: - Cálculo de Prolactina
    
    /// Calcula factor según prolactina
    /// Referencia: DOI: 10.1210/clinem/dgac389, Endocrine Society Guidelines
    static func calculateProlactinFactor(_ prolactin: Double) -> Double {
        // Prolactina normal: <25 ng/mL
        
        switch prolactin {
        case ..<25:
            return 1.0   // Normal: sin impacto
        case 25..<50:
            return 0.85  // Hiperprolactinemia leve: 85%
        case 50..<100:
            return 0.60  // Hiperprolactinemia moderada: 60%
        case 100..<200:
            return 0.35  // Hiperprolactinemia severa: 35%
        default:
            return 0.15  // Prolactinoma: 15% (anovulación severa)
        }
    }
    
    // MARK: - Cálculo de HOMA-IR
    
    /// Calcula factor según resistencia insulínica
    /// Referencia: DOI: 10.3390/jcm10112440, DOI: 10.1210/clinem/dgac389
    static func calculateHOMAFactor(_ homa: Double) -> Double {
        // HOMA-IR normal: <2.5
        
        switch homa {
        case ..<2.5:
            return 1.0   // Normal: sin impacto
        case 2.5..<3.5:
            return 0.90  // RI leve: 90%
        case 3.5..<5.0:
            return 0.75  // RI moderada: 75%
        case 5.0..<7.0:
            return 0.60  // RI severa: 60%
        default:
            return 0.45  // RI crítica: 45% (diabetes tipo 2)
        }
    }
    
    // MARK: - Cálculo de Ciclo Menstrual
    
    /// Calcula factor según duración del ciclo
    /// Referencia actualizada: ACOG 2024, ESHRE 2024, NICE 2024
    /// PMID: 36367491, DOI: 10.1093/hropen/hoad022
    static func calculateCycleFactor(_ duration: Int) -> Double {
        // Usar nueva clasificación detallada de patrones menstruales
        let pattern = MenstrualCyclePathology.CyclePattern.categorize(cycleLength: Double(duration))
        return pattern.fertilityImpact
    }
    
    // MARK: - Cálculo de Duración de Infertilidad
    
    /// Calcula factor según tiempo intentando concebir
    /// Referencia: DOI: 10.1093/humrep/deab045, Cochrane Reviews
    static func calculateInfertilityDurationFactor(_ duration: Double) -> Double {
        // Declive progresivo de fertilidad con tiempo
        
        switch duration {
        case ..<1:
            return 1.0   // <1 año: sin impacto
        case 1..<2:
            return 0.90  // 1-2 años: 90%
        case 2..<3:
            return 0.80  // 2-3 años: 80%
        case 3..<5:
            return 0.65  // 3-5 años: 65%
        case 5..<8:
            return 0.45  // 5-8 años: 45%
        default:
            return 0.25  // >8 años: 25% (infertilidad prolongada)
        }
    }
    
    // MARK: - Cálculo de Cirugías Pélvicas
    
    /// Calcula factor según antecedentes quirúrgicos
    /// Referencia: DOI: 10.1016/j.ejogrb.2020.01.012, Cochrane Reviews
    static func calculatePelvicSurgeryFactor(_ profile: FertilityProfile) -> Double {
        guard profile.hasPelvicSurgery else { return 1.0 }
        
        let numberOfSurgeries = profile.numberOfPelvicSurgeries
        
        // Impacto acumulativo de cirugías (adherencias)
        switch numberOfSurgeries {
        case 1:
            return 0.90  // Una cirugía: 90% (impacto leve)
        case 2:
            return 0.80  // Dos cirugías: 80%
        case 3:
            return 0.65  // Tres cirugías: 65%
        default:
            return 0.50  // >3 cirugías: 50% (adherencias extensas)
        }
    }
}

// MARK: - 🔢 CÁLCULOS INTEGRADOS

extension FertilityCalculations {
    
    /// Convierte perfil a factores médicos cuantificados
    static func convertProfileToMedicalFactors(_ profile: FertilityProfile) -> MedicalFactors {
        var factors = MedicalFactors()
        
        // 🔍 DEBUG: Verificar valores de entrada del perfil
        // Debug logs removed for production
        
        // Factor edad (fecundabilidad mensual directa)
        factors.age = calculateAgeFactor(profile.age)
        
        // Factor IMC
        factors.bmi = calculateBMIFactor(profile.bmi)
        
        // Factores hormonales
        if let amh = profile.amhValue {
            factors.amh = calculateAMHFactor(amh)
        }
        
        if let tsh = profile.tshValue {
            factors.tsh = calculateTSHFactor(tsh)
        }
        
        if let prolactin = profile.prolactinValue {
            factors.prolactin = calculateProlactinFactor(prolactin)
        }
        
        if let homa = profile.homaIr {
            factors.homaIR = calculateHOMAFactor(homa)
        }
        
        // Factores ginecológicos
        if profile.hasPcos {
            let (pcosImpact, _) = PCOSPathology.evaluatePCOS(profile: profile)
            factors.pcos = pcosImpact
        }
        
        if profile.endometriosisStage > 0 {
            factors.endometriosis = EndometriosisPathology.calculateEndometriosisFactor(profile.endometriosisStage)
        }
        
        // Miomas con tamaño específico
        if profile.myomaType != .none {
            factors.myoma = calculateMyomaSizeFactor(profile.myomaType, profile.myomaSize)
        }
        
        // Paridad previa
        factors.parity = calculateParityFactor(profile.previousPregnancies)
        
        // Factor masculino (incluyendo nuevas variables)
        if profile.spermConcentration != nil || profile.spermProgressiveMotility != nil || profile.spermNormalMorphology != nil {
            let (_, baseMaleImpact) = MaleFactorPathology.evaluateMaleFactor(profile: profile)
            
            // Aplicar modificadores masculinos adicionales
            let dnaFragmentationFactor = calculateDNAFragmentationFactor(profile.spermDNAFragmentation)
            let varicoceleFactor = calculateVaricoceleFactor(profile.hasVaricocele)
            let seminalCultureFactor = calculateSeminalCultureFactor(profile.seminalCulturePositive)
            
            factors.male = baseMaleImpact * dnaFragmentationFactor * varicoceleFactor * seminalCultureFactor
        }
        
        // Factor tubárico
        switch profile.hsgResult {
        case .normal:
            factors.hsg = 1.0
        case .unilateral:
            factors.hsg = 0.50
        case .bilateral:
            factors.hsg = 0.01
        }
        
        // Oclusión tubárica bilateral
        if profile.hasOtb {
            factors.otb = 0.01
        }
        
        // Cirugías pélvicas previas
        if profile.hasPelvicSurgery {
            factors.pelvicSurgery = calculatePelvicSurgeryFactor(profile)
        }
        
        // Factores patológicos ginecológicos
        factors.endometriosis = calculateEndometriosisFactor(profile.endometriosisStage)
        factors.myoma = calculateMyomaFactor(profile.myomaType, profile.myomaSize)
        factors.adenomyosis = calculateAdenomyosisFactor(profile.adenomyosisType)
        factors.polyp = calculatePolypFactor(profile.polypType)
        
        // Factores temporales
        if let duration = profile.infertilityDuration {
            factors.infertilityDuration = calculateInfertilityDurationFactor(duration)
        }
        
        if let cycleLength = profile.cycleLength {
            factors.cycle = calculateCycleFactor(Int(cycleLength))
        }
        
        return factors
    }
    
    /// Calcula probabilidad final integrada
    static func calculateFinalProbability(factors: MedicalFactors, interactions: NonLinearInteractions) -> Double {
        
        // 🔍 DEBUG: Verificar factores antes del cálculo
        // Debug factors removed for production
        
        // 1. Fecundabilidad base por edad
        var adjustedFertility = factors.age
        
        // 2. Aplicar factores multiplicadores
        adjustedFertility *= factors.bmi
        adjustedFertility *= factors.cycle
        adjustedFertility *= factors.infertilityDuration
        adjustedFertility *= factors.amh
        adjustedFertility *= factors.tsh
        adjustedFertility *= factors.prolactin
        adjustedFertility *= factors.homaIR
        adjustedFertility *= factors.parity  // Nueva variable: paridad previa
        adjustedFertility *= factors.pcos
        adjustedFertility *= factors.endometriosis
        adjustedFertility *= factors.myoma
        adjustedFertility *= factors.polyp
        adjustedFertility *= factors.adenomyosis
        adjustedFertility *= factors.hsg
        adjustedFertility *= factors.otb
        adjustedFertility *= factors.pelvicSurgery
        adjustedFertility *= factors.male
        
        // 3. Aplicar interacciones no lineales (reducciones adicionales)
        adjustedFertility *= (1.0 - interactions.ageAmhSynergy)
        adjustedFertility *= (1.0 - interactions.scopInsulinResistance)
        adjustedFertility *= (1.0 - interactions.endometriosisMale)
        adjustedFertility *= (1.0 - interactions.ageCriticalFailure)
        adjustedFertility *= (1.0 - interactions.scopObesitySevere)
        adjustedFertility *= (1.0 - interactions.adenomyosisAge)
        adjustedFertility *= (1.0 - interactions.multipleSurgeries)
        adjustedFertility *= (1.0 - interactions.reserveCritical)
        
        // 4. Límites de seguridad
        let finalProbability = max(0.005, min(0.25, adjustedFertility)) // Entre 0.5% y 25%
        
        // 🔍 DEBUG: Verificar resultado final
        // Debug results removed for production
        
        return finalProbability
    }
    
    // MARK: - Cálculo de Factores Ginecológicos
    
    /// Calcula factor según endometriosis
    static func calculateEndometriosisFactor(_ stage: Int) -> Double {
        switch stage {
        case 0: return 1.0     // Sin endometriosis
        case 1: return 0.85    // Mínima: 85% fertilidad
        case 2: return 0.70    // Leve: 70% fertilidad  
        case 3: return 0.50    // Moderada: 50% fertilidad
        case 4: return 0.30    // Severa: 30% fertilidad
        default: return 1.0
        }
    }
    
    /// Calcula factor según miomas
    static func calculateMyomaFactor(_ type: MyomaType, _ size: Double?) -> Double {
        switch type {
        case .none: return 1.0
        case .submucosal:
            // Submucosos son críticos incluso pequeños
            if let size = size, size >= 1.0 {
                return 0.30  // ≥1cm submucoso: 30% fertilidad
            } else {
                return 0.50  // <1cm submucoso: 50% fertilidad
            }
        case .intramural:
            if let size = size, size >= 4.0 {
                return 0.75  // ≥4cm intramural: 75% fertilidad
            } else {
                return 0.90  // <4cm intramural: 90% fertilidad
            }
        case .subserosal: return 0.95  // Subseroso: 95% fertilidad
        }
    }
    
    /// Calcula factor según adenomiosis
    static func calculateAdenomyosisFactor(_ type: AdenomyosisType) -> Double {
        switch type {
        case .none: return 1.0     // Sin adenomiosis
        case .focal: return 0.75   // Focal: 75% fertilidad
        case .diffuse: return 0.55 // Difusa: 55% fertilidad
        }
    }
    
    /// Calcula factor según pólipos
    static func calculatePolypFactor(_ type: PolypType) -> Double {
        switch type {
        case .none: return 1.0       // Sin pólipos
        case .single: return 0.75    // Único: 75% fertilidad
        case .multiple: return 0.55  // Múltiples: 55% fertilidad
        }
    }
}

// MARK: - 📊 CATEGORIZACIÓN DE FERTILIDAD

extension FertilityCalculations {
    
    enum FertilityCategory: String, CaseIterable {
        case excellent = "Excelente"    // ≥20% mensual
        case good = "Buena"            // 15-19% mensual
        case moderate = "Moderada"     // 10-14% mensual
        case low = "Baja"             // 5-9% mensual
        case veryLow = "Muy Baja"     // 2-4% mensual
        case critical = "Crítica"     // <2% mensual
        
        var description: String {
            switch self {
            case .excellent:
                return "Fertilidad excelente. Coito programado con monitoreo."
            case .good:
                return "Buena fertilidad. Inducción de ovulación recomendada."
            case .moderate:
                return "Fertilidad moderada. IUI con estimulación controlada."
            case .low:
                return "Fertilidad baja. FIV/ICSI indicada."
            case .veryLow:
                return "Fertilidad muy baja. FIV/ICSI con PGT-A."
            case .critical:
                return "Fertilidad crítica. Técnicas reproductivas avanzadas."
            }
        }
        
        var color: String {
            switch self {
            case .excellent: return "green"
            case .good: return "blue"
            case .moderate: return "orange"
            case .low: return "red"
            case .veryLow: return "purple"
            case .critical: return "black"
            }
        }
    }
    
    /// Determina categoría de fertilidad según probabilidad mensual
    static func determineFertilityCategory(_ probability: Double) -> FertilityCategory {
        switch probability {
        case 0.20...1.0: return .excellent    // ≥20% mensual
        case 0.15..<0.20: return .good        // 15-19% mensual
        case 0.10..<0.15: return .moderate    // 10-14% mensual
        case 0.05..<0.10: return .low         // 5-9% mensual
        case 0.02..<0.05: return .veryLow     // 2-4% mensual
        default: return .critical             // <2% mensual
        }
    }
    
    /// Calcula probabilidad anual a partir de mensual
    static func calculateAnnualProbability(_ monthlyProbability: Double) -> Double {
        return 1.0 - pow(1.0 - monthlyProbability, 12.0)
    }
    
    /// Calcula tiempo estimado para embarazo
    static func calculateTimeToPregnancy(_ monthlyProbability: Double) -> (months: Int, range: ClosedRange<Int>) {
        let averageMonths = Int(1.0 / monthlyProbability)
        let lowerBound = max(1, averageMonths - 3)
        let upperBound = averageMonths + 6
        
        return (averageMonths, lowerBound...upperBound)
    }
    
    // MARK: - Cálculo de Paridad Previa
    
    /// Calcula factor según embarazos previos
    /// Referencia: Hum Reprod Update 2024, ESHRE Guidelines 2024
    static func calculateParityFactor(_ previousPregnancies: Int) -> Double {
        // 🤱 PARIDAD REPRODUCTIVA - Basado en evidencia ASRM 2023, Dunson et al. 2002
        // Nulípara = baseline, Multípara = mejora por funcionalidad uterina probada
        
        switch previousPregnancies {
        case 0:
            return 1.0   // ✅ NULÍPARA: Baseline (sin penalización)
        case 1...:
            return 1.05  // ✅ MULTÍPARA: +5% mejora (funcionalidad probada)
        default:
            return 1.0   // Valor por defecto
        }
    }
    
    // MARK: - Cálculo de Tamaño de Miomas
    
    /// Calcula factor según tamaño de miomas
    /// Referencia: Fertil Steril 2024, ASRM Practice Guidelines 2024
    static func calculateMyomaSizeFactor(_ myomaType: MyomaType, _ myomaSize: Double?) -> Double {
        guard myomaType != .none, let size = myomaSize else { return 1.0 }
        
        switch myomaType {
        case .none:
            return 1.0
            
        case .submucosal:
            // Miomas submucosos: muy críticos para implantación
            if size >= 1.0 {
                return 0.30  // ≥1cm submucoso: 30% fertilidad (70% reducción) - CRÍTICO
            } else {
                return 0.70  // <1cm submucoso: 70% fertilidad (30% reducción)
            }
            
        case .intramural:
            // Miomas intramurales: impacto según tamaño
            if size >= 7.0 {
                return 0.60  // ≥7cm intramural: 60% fertilidad (40% reducción)
            } else if size >= 4.0 {
                return 0.75  // 4-7cm intramural: 75% fertilidad (25% reducción)
            } else {
                return 0.90  // <4cm intramural: 90% fertilidad (10% reducción)
            }
            
        case .subserosal:
            // Miomas subserosos: menor impacto
            if size >= 10.0 {
                return 0.85  // ≥10cm subseroso: 85% fertilidad (15% reducción)
            } else {
                return 0.95  // <10cm subseroso: 95% fertilidad (5% reducción)
            }
        }
    }
    
    // MARK: - Cálculo de Fragmentación DNA Espermática
    
    /// Calcula factor según fragmentación DNA espermática
    /// Referencia: Reprod Biomed Online 2024, ESHRE Guidelines 2024
    static func calculateDNAFragmentationFactor(_ dnaFragmentation: Double?) -> Double {
        guard let fragmentation = dnaFragmentation else { return 1.0 }
        
        // Valores de referencia según SCSA (Sperm Chromatin Structure Assay)
        switch fragmentation {
        case ..<15.0:
            return 1.0   // <15%: Normal, sin impacto
        case 15.0..<20.0:
            return 0.90  // 15-20%: Leve reducción (10%)
        case 20.0..<30.0:
            return 0.75  // 20-30%: Moderada reducción (25%)
        case 30.0..<50.0:
            return 0.60  // 30-50%: Severa reducción (40%)
        case 50.0...:
            return 0.40  // >50%: Crítica reducción (60%)
        default:
            return 1.0   // Valor por defecto
        }
    }
    
    // MARK: - Cálculo de Varicocele
    
    /// Calcula factor según historia de varicocele
    /// Referencia: J Urol 2024, Cochrane Reviews 2024
    static func calculateVaricoceleFactor(_ hasVaricocele: Bool) -> Double {
        if hasVaricocele {
            return 0.80  // Varicocele: 80% fertilidad (20% reducción)
        } else {
            return 1.0   // Sin varicocele: sin impacto
        }
    }
    
    // MARK: - Cálculo de Cultivo Seminal
    
    /// Calcula factor según cultivo seminal
    /// Referencia: Andrology 2024, WHO Guidelines 2021
    static func calculateSeminalCultureFactor(_ culturePositive: Bool) -> Double {
        if culturePositive {
            return 0.75  // Cultivo positivo: 75% fertilidad (25% reducción por infección)
        } else {
            return 1.0   // Cultivo negativo: sin impacto
        }
    }
}
