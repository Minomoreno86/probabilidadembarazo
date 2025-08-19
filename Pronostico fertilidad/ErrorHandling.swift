//
//  ErrorHandling.swift
//  Pronostico fertilidad
//
//  Sistema de manejo de errores médicos específicos para fertilidad
//  Implementa tipos de errores especializados y protocolos de manejo
//
//  Created by Jorge Vásquez on 2024
//

import Foundation

// MARK: - 🚨 TIPOS DE ERRORES MÉDICOS

/// Errores específicos para cálculos médicos de fertilidad
enum MedicalCalculationError: LocalizedError {
    case invalidAgeRange(age: Double, min: Double, max: Double)
    case invalidAMHRange(amh: Double, min: Double, max: Double)
    case invalidTSHRange(tsh: Double, min: Double, max: Double)
    case invalidBMIRange(bmi: Double, min: Double, max: Double)
    case inconsistentData(description: String)
    case calculationOverflow(operation: String)
    case insufficientData(missingFactors: [String])
    case validationFailed(reason: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidAgeRange(let age, let min, let max):
            return "Edad inválida: \(age). Debe estar entre \(min) y \(max) años."
        case .invalidAMHRange(let amh, let min, let max):
            return "AMH inválido: \(amh). Debe estar entre \(min) y \(max) ng/mL."
        case .invalidTSHRange(let tsh, let min, let max):
            return "TSH inválido: \(tsh). Debe estar entre \(min) y \(max) mIU/L."
        case .invalidBMIRange(let bmi, let min, let max):
            return "IMC inválido: \(bmi). Debe estar entre \(min) y \(max)."
        case .inconsistentData(let description):
            return "Datos inconsistentes: \(description)"
        case .calculationOverflow(let operation):
            return "Error de cálculo: \(operation) excedió límites seguros."
        case .insufficientData(let missingFactors):
            return "Datos insuficientes. Faltan: \(missingFactors.joined(separator: ", "))"
        case .validationFailed(let reason):
            return "Validación fallida: \(reason)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidAgeRange:
            return "Verifique que la edad esté en el rango válido (18-50 años)."
        case .invalidAMHRange:
            return "Verifique que el AMH esté en el rango válido (0.1-10.0 ng/mL)."
        case .invalidTSHRange:
            return "Verifique que el TSH esté en el rango válido (0.1-20.0 mIU/L)."
        case .invalidBMIRange:
            return "Verifique que el IMC esté en el rango válido (15.0-60.0)."
        case .inconsistentData:
            return "Revise la consistencia de los datos médicos ingresados."
        case .calculationOverflow:
            return "Los valores ingresados pueden estar fuera de rangos seguros."
        case .insufficientData:
            return "Complete todos los datos requeridos para el cálculo."
        case .validationFailed:
            return "Corrija los datos según las validaciones médicas."
        }
    }
}

/// Errores de validación de datos médicos
enum MedicalValidationError: LocalizedError {
    case ageAMHInconsistency(age: Double, amh: Double)
    case ageFertilityMismatch(age: Double, fertilityScore: Double)
    case multiplePathologiesConflict(pathologies: [String])
    case treatmentContraindication(treatment: String, reason: String)
    
    var errorDescription: String? {
        switch self {
        case .ageAMHInconsistency(let age, let amh):
            return "Inconsistencia edad-AMH: Edad \(age) años con AMH \(amh) ng/mL"
        case .ageFertilityMismatch(let age, let fertilityScore):
            return "Puntuación de fertilidad \(fertilityScore) no corresponde a edad \(age)"
        case .multiplePathologiesConflict(let pathologies):
            return "Conflicto entre patologías: \(pathologies.joined(separator: ", "))"
        case .treatmentContraindication(let treatment, let reason):
            return "Contraindicación para \(treatment): \(reason)"
        }
    }
}

/// Errores de persistencia de datos
enum DataPersistenceError: LocalizedError {
    case saveFailed(reason: String)
    case loadFailed(reason: String)
    case deleteFailed(reason: String)
    case encryptionFailed(reason: String)
    case decryptionFailed(reason: String)
    
    var errorDescription: String? {
        switch self {
        case .saveFailed(let reason):
            return "Error al guardar datos: \(reason)"
        case .loadFailed(let reason):
            return "Error al cargar datos: \(reason)"
        case .deleteFailed(let reason):
            return "Error al eliminar datos: \(reason)"
        case .encryptionFailed(let reason):
            return "Error al encriptar datos: \(reason)"
        case .decryptionFailed(let reason):
            return "Error al desencriptar datos: \(reason)"
        }
    }
}

// MARK: - 🔧 PROTOCOLO DE MANEJO DE ERRORES MÉDICOS

/// Protocolo para manejo consistente de errores médicos
protocol MedicalErrorHandling {
    /// Maneja errores de cálculo médico
    func handleCalculationError(_ error: MedicalCalculationError) -> String
    
    /// Maneja errores de validación médica
    func handleValidationError(_ error: MedicalValidationError) -> String
    
    /// Maneja errores de persistencia
    func handlePersistenceError(_ error: DataPersistenceError) -> String
    
    /// Registra errores para análisis posterior
    func logError(_ error: Error, context: String)
}

// MARK: - 📊 IMPLEMENTACIÓN DEL MANEJADOR DE ERRORES

/// Implementación del manejador de errores médicos
class MedicalErrorHandler: MedicalErrorHandling {
    
    // MARK: - Singleton
    static let shared = MedicalErrorHandler()
    private init() {}
    
    // MARK: - Manejo de Errores de Cálculo
    func handleCalculationError(_ error: MedicalCalculationError) -> String {
        // Log del error para análisis
        logError(error, context: "MedicalCalculation")
        
        // Retornar mensaje de error apropiado
        return error.errorDescription ?? "Error de cálculo médico desconocido"
    }
    
    // MARK: - Manejo de Errores de Validación
    func handleValidationError(_ error: MedicalValidationError) -> String {
        logError(error, context: "MedicalValidation")
        
        return error.errorDescription ?? "Error de validación médica desconocido"
    }
    
    // MARK: - Manejo de Errores de Persistencia
    func handlePersistenceError(_ error: DataPersistenceError) -> String {
        logError(error, context: "DataPersistence")
        
        return error.errorDescription ?? "Error de persistencia desconocido"
    }
    
    // MARK: - Logging de Errores
    func logError(_ error: Error, context: String) {
        let timestamp = Date()
        let errorInfo = """
        [\(timestamp)] ERROR in \(context):
        Type: \(type(of: error))
        Description: \(error.localizedDescription)
        Recovery: \((error as? LocalizedError)?.recoverySuggestion ?? "No disponible")
        """
        
        // En producción, esto iría a un sistema de logging
        print("🔴 MEDICAL ERROR: \(errorInfo)")
        
        // TODO: Implementar logging a archivo o servicio externo
        // TODO: Implementar analytics de errores
    }
}

// MARK: - 🎯 EXTENSIONES ÚTILES

extension Result {
    /// Convierte un Result en un valor opcional con manejo de errores
    func handleError<T>(_ handler: MedicalErrorHandling = MedicalErrorHandler.shared) -> T? where Success == T {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            if let medicalError = error as? MedicalCalculationError {
                _ = handler.handleCalculationError(medicalError)
            } else if let validationError = error as? MedicalValidationError {
                _ = handler.handleValidationError(validationError)
            } else if let persistenceError = error as? DataPersistenceError {
                _ = handler.handlePersistenceError(persistenceError)
            } else {
                handler.logError(error, context: "Unknown")
            }
            return nil
        }
    }
}

// MARK: - 📋 VALIDADORES DE RANGOS MÉDICOS

/// Validadores de rangos para datos médicos
struct MedicalRangeValidators {
    
    /// Valida rango de edad para fertilidad
    static func validateAge(_ age: Double) -> Result<Double, MedicalCalculationError> {
        let minAge: Double = 18.0
        let maxAge: Double = 50.0
        
        guard age >= minAge && age <= maxAge else {
            return .failure(.invalidAgeRange(age: age, min: minAge, max: maxAge))
        }
        
        return .success(age)
    }
    
    /// Valida rango de AMH
    static func validateAMH(_ amh: Double) -> Result<Double, MedicalCalculationError> {
        let minAMH: Double = 0.1
        let maxAMH: Double = 10.0
        
        guard amh >= minAMH && amh <= maxAMH else {
            return .failure(.invalidAMHRange(amh: amh, min: minAMH, max: maxAMH))
        }
        
        return .success(amh)
    }
    
    /// Valida rango de TSH
    static func validateTSH(_ tsh: Double) -> Result<Double, MedicalCalculationError> {
        let minTSH: Double = 0.1
        let maxTSH: Double = 20.0
        
        guard tsh >= minTSH && tsh <= maxTSH else {
            return .failure(.invalidTSHRange(tsh: tsh, min: minTSH, max: maxTSH))
        }
        
        return .success(tsh)
    }
    
    /// Valida rango de IMC
    static func validateBMI(_ bmi: Double) -> Result<Double, MedicalCalculationError> {
        let minBMI: Double = 15.0
        let maxBMI: Double = 60.0
        
        guard bmi >= minBMI && bmi <= maxBMI else {
            return .failure(.invalidBMIRange(bmi: bmi, min: minBMI, max: maxBMI))
        }
        
        return .success(bmi)
    }
    
    /// Valida consistencia entre edad y AMH
    static func validateAgeAMHConsistency(age: Double, amh: Double) -> Result<Void, MedicalValidationError> {
        // Reglas de consistencia basadas en evidencia médica
        if age > 40 && amh > 3.0 {
            return .failure(.ageAMHInconsistency(age: age, amh: amh))
        }
        
        if age < 25 && amh < 0.5 {
            return .failure(.ageAMHInconsistency(age: age, amh: amh))
        }
        
        return .success(())
    }
}
