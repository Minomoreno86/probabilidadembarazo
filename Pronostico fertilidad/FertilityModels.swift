//
//  FertilityModels.swift
//  Pronostico fertilidad
//
//  Created by Jorge Vasquez rodriguez on 11/08/2025.
//

import Foundation
import SwiftData

// MARK: - Enums para tipos de datos médicos

enum MyomaType: String, CaseIterable, Codable {
    case none = "none"
    case submucosal = "submucosal"
    case intramural = "intramural"
    case subserosal = "subserosal"
    
    var displayName: String {
        switch self {
        case .none: return "Ninguno"
        case .submucosal: return "Submucoso"
        case .intramural: return "Intramural"
        case .subserosal: return "Subseroso"
        }
    }
}

enum AdenomyosisType: String, CaseIterable, Codable {
    case none = "none"
    case focal = "focal"
    case diffuse = "diffuse"
    
    var displayName: String {
        switch self {
        case .none: return "Ninguna"
        case .focal: return "Focal"
        case .diffuse: return "Difusa"
        }
    }
}

enum PolypType: String, CaseIterable, Codable {
    case none = "none"
    case single = "single"
    case multiple = "multiple"
    
    var displayName: String {
        switch self {
        case .none: return "Ninguno"
        case .single: return "Único"
        case .multiple: return "Múltiples"
        }
    }
}

enum HsgResult: String, CaseIterable, Codable {
    case normal = "normal"
    case unilateral = "unilateral"
    case bilateral = "bilateral"
    
    var displayName: String {
        switch self {
        case .normal: return "Normal"
        case .unilateral: return "Obstrucción Unilateral"
        case .bilateral: return "Obstrucción Bilateral"
        }
    }
}

enum OtbMethod: String, CaseIterable, Codable {
    case none = "none"
    case clips = "clips"
    case coagulation = "coagulation"
    case salpingectomy = "salpingectomy"
    
    var displayName: String {
        switch self {
        case .none: return "Ninguno"
        case .clips: return "Clips"
        case .coagulation: return "Coagulación"
        case .salpingectomy: return "Salpingectomía"
        }
    }
}

// MARK: - Modelo principal de datos de fertilidad

@Model
final class FertilityProfile {
    // Información demográfica
    var age: Double
    var height: Double // en cm
    var weight: Double // en kg
    var bmi: Double
    
    // Historia ginecológica
    var cycleLength: Double?
    var infertilityDuration: Double?
    var previousPregnancies: Int // Paridad previa (nullípara vs multípara)
    var hasPcos: Bool
    var endometriosisStage: Int
    var myomaType: MyomaType
    var myomaSize: Double? // Tamaño del mioma más grande (en cm)
    var adenomyosisType: AdenomyosisType
    var polypType: PolypType
    var hsgResult: HsgResult
    var hasPelvicSurgery: Bool
    var numberOfPelvicSurgeries: Int
    var hasOtb: Bool
    var otbMethod: OtbMethod
    
    // Pruebas de laboratorio
    var tpoAbPositive: Bool
    var insulinValue: Double?
    var glucoseValue: Double?
    var homaIr: Double?
    var amhValue: Double?
    var tshValue: Double?
    var prolactinValue: Double?
    
    // Factor masculino
    var spermConcentration: Double?
    var spermProgressiveMotility: Double?
    var spermNormalMorphology: Double?
    var semenVolume: Double?
    var spermDNAFragmentation: Double? // % fragmentación DNA (opcional)
    var hasVaricocele: Bool // Historia de varicocele
    var seminalCulturePositive: Bool // Cultivo seminal positivo (opcional)
    
    // Metadatos
    var createdAt: Date
    var updatedAt: Date
    var isCompleted: Bool
    
    init(
        age: Double = 30,
        height: Double = 165,
        weight: Double = 65,
        cycleLength: Double? = nil,
        infertilityDuration: Double? = nil,
        previousPregnancies: Int = 0,
        hasPcos: Bool = false,
        endometriosisStage: Int = 0,
        myomaType: MyomaType = .none,
        myomaSize: Double? = nil,
        adenomyosisType: AdenomyosisType = .none,
        polypType: PolypType = .none,
        hsgResult: HsgResult = .normal,
        hasPelvicSurgery: Bool = false,
        numberOfPelvicSurgeries: Int = 0,
        hasOtb: Bool = false,
        otbMethod: OtbMethod = .none,
        tpoAbPositive: Bool = false,
        insulinValue: Double? = nil,
        glucoseValue: Double? = nil,
        amhValue: Double? = nil,
        tshValue: Double? = nil,
        prolactinValue: Double? = nil,
        spermConcentration: Double? = nil,
        spermProgressiveMotility: Double? = nil,
        spermNormalMorphology: Double? = nil,
        semenVolume: Double? = nil,
        spermDNAFragmentation: Double? = nil,
        hasVaricocele: Bool = false,
        seminalCulturePositive: Bool = false
    ) {
        self.age = age
        self.height = height
        self.weight = weight
        self.bmi = weight / ((height / 100) * (height / 100))
        self.cycleLength = cycleLength
        self.infertilityDuration = infertilityDuration
        self.previousPregnancies = previousPregnancies
        self.hasPcos = hasPcos
        self.endometriosisStage = endometriosisStage
        self.myomaType = myomaType
        self.myomaSize = myomaSize
        self.adenomyosisType = adenomyosisType
        self.polypType = polypType
        self.hsgResult = hsgResult
        self.hasPelvicSurgery = hasPelvicSurgery
        self.numberOfPelvicSurgeries = numberOfPelvicSurgeries
        self.hasOtb = hasOtb
        self.otbMethod = otbMethod
        self.tpoAbPositive = tpoAbPositive
        self.insulinValue = insulinValue
        self.glucoseValue = glucoseValue
        self.amhValue = amhValue
        self.tshValue = tshValue
        self.prolactinValue = prolactinValue
        self.spermConcentration = spermConcentration
        self.spermProgressiveMotility = spermProgressiveMotility
        self.spermNormalMorphology = spermNormalMorphology
        self.semenVolume = semenVolume
        self.spermDNAFragmentation = spermDNAFragmentation
        self.hasVaricocele = hasVaricocele
        self.seminalCulturePositive = seminalCulturePositive
        
        // Calcular HOMA-IR si hay datos disponibles
        // Fórmula correcta: (Insulina μU/mL × Glucosa mg/dL) / 405
        if let insulin = insulinValue, let glucose = glucoseValue {
            self.homaIr = (insulin * glucose) / 405
        } else {
            self.homaIr = nil
        }
        
        self.createdAt = Date()
        self.updatedAt = Date()
        self.isCompleted = false
    }
    
    // Función para actualizar BMI cuando cambien altura o peso
    func updateBMI() {
        self.bmi = weight / ((height / 100) * (height / 100))
        self.updatedAt = Date()
    }
    
    // Función para actualizar HOMA-IR cuando cambien insulina o glucosa
    func updateHomaIR() {
        // Fórmula correcta: (Insulina μU/mL × Glucosa mg/dL) / 405
        if let insulin = insulinValue, let glucose = glucoseValue {
            self.homaIr = (insulin * glucose) / 405
        } else {
            self.homaIr = nil
        }
        self.updatedAt = Date()
    }
    
    // Función para calcular el porcentaje de completitud
    func completionPercentage() -> Double {
        let totalFields = 28 // Número total de campos importantes (eliminadas 2 variables innecesarias)
        var completedFields = 0
        
        // Campos básicos siempre completados
        completedFields += 3 // age, height, weight
        
        // Campos opcionales
        if cycleLength != nil { completedFields += 1 }
        if infertilityDuration != nil { completedFields += 1 }
        if previousPregnancies > 0 { completedFields += 1 } // Nueva variable
        if hasPcos { completedFields += 1 }
        if endometriosisStage > 0 { completedFields += 1 }
        if myomaType != .none { completedFields += 1 }
        if myomaSize != nil { completedFields += 1 } // Nueva variable
        if adenomyosisType != .none { completedFields += 1 }
        if polypType != .none { completedFields += 1 }
        if hsgResult != .normal { completedFields += 1 }
        if hasPelvicSurgery { completedFields += 1 }
        if hasOtb { completedFields += 1 }
        if tpoAbPositive { completedFields += 1 }
        if insulinValue != nil { completedFields += 1 }
        if glucoseValue != nil { completedFields += 1 }
        if amhValue != nil { completedFields += 1 }
        if tshValue != nil { completedFields += 1 }
        if prolactinValue != nil { completedFields += 1 }
        if spermConcentration != nil { completedFields += 1 }
        if spermProgressiveMotility != nil { completedFields += 1 }
        if spermNormalMorphology != nil { completedFields += 1 }
        if semenVolume != nil { completedFields += 1 }
        if spermDNAFragmentation != nil { completedFields += 1 } // Nueva variable
        if hasVaricocele { completedFields += 1 } // Nueva variable
        if seminalCulturePositive { completedFields += 1 } // Nueva variable
        
        return Double(completedFields) / Double(totalFields) * 100
    }
    
    // Interpretación clínica del BMI
    func bmiCategory() -> (category: String, color: String, description: String) {
        if bmi < 18.5 {
            return ("Bajo peso", "orange", "Puede afectar fertilidad")
        } else if bmi < 25 {
            return ("Peso saludable", "green", "Óptimo para fertilidad")
        } else if bmi < 30 {
            return ("Sobrepeso", "orange", "Puede reducir fertilidad")
        } else {
            return ("Obesidad", "red", "Reduce significativamente fertilidad")
        }
    }
    
    // Interpretación clínica del HOMA-IR
    func homaCategory() -> (category: String, color: String, description: String)? {
        guard let homa = homaIr else { return nil }
        
        if homa < 1.0 {
            return ("Sensibilidad normal", "green", "Metabolismo de insulina óptimo")
        } else if homa < 2.5 {
            return ("Resistencia leve", "orange", "Posible resistencia a insulina")
        } else {
            return ("Resistencia significativa", "red", "Resistencia a insulina establecida")
        }
    }
}

// MARK: - Modelo para resultados de cálculo

@Model
final class FertilityCalculationResult {
    var profileId: String
    var pregnancyProbability: Double
    var monthlyProbability: Double
    var category: String
    var explanation: String
    var factors: [String: Double] // Factores que afectan la probabilidad
    var recommendations: [String]
    var calculatedAt: Date
    var calculationVersion: String
    
    init(
        profileId: String,
        pregnancyProbability: Double,
        monthlyProbability: Double,
        category: String,
        explanation: String,
        factors: [String: Double] = [:],
        recommendations: [String] = [],
        calculationVersion: String = "1.0"
    ) {
        self.profileId = profileId
        self.pregnancyProbability = pregnancyProbability
        self.monthlyProbability = monthlyProbability
        self.category = category
        self.explanation = explanation
        self.factors = factors
        self.recommendations = recommendations
        self.calculatedAt = Date()
        self.calculationVersion = calculationVersion
    }
}
