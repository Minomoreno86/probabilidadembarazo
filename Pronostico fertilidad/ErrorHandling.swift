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
            return String(format: NSLocalizedString("Edad invalida: %@. Debe estar entre %@ y %@ anios.", comment: ""), String(age), String(min), String(max))
        case .invalidAMHRange(let amh, let min, let max):
            return String(format: NSLocalizedString("AMH invalido: %@. Debe estar entre %@ y %@ ng/mL.", comment: ""), String(amh), String(min), String(max))
        case .invalidTSHRange(let tsh, let min, let max):
            return String(format: NSLocalizedString("TSH invalido: %@. Debe estar entre %@ y %@ mIU/L.", comment: ""), String(tsh), String(min), String(max))
        case .invalidBMIRange(let bmi, let min, let max):
            return String(format: NSLocalizedString("IMC invalido: %@. Debe estar entre %@ y %@.", comment: ""), String(bmi), String(min), String(max))
        case .inconsistentData(let description):
            return String(format: NSLocalizedString("Datos inconsistentes: %@", comment: ""), description)
        case .calculationOverflow(let operation):
            return String(format: NSLocalizedString("Error de calculo: %@ excedio limites seguros.", comment: ""), operation)
        case .insufficientData(let missingFactors):
            return String(format: NSLocalizedString("Datos insuficientes. Faltan: %@", comment: ""), missingFactors.joined(separator: ", "))
        case .validationFailed(let reason):
            return String(format: NSLocalizedString("Validacion fallida: %@", comment: ""), reason)
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidAgeRange:
            return NSLocalizedString("Verifique que la edad este en el rango valido (18-50 anios).", comment: "")
        case .invalidAMHRange:
            return NSLocalizedString("Verifique que el AMH este en el rango valido (0.1-10.0 ng/mL).", comment: "")
        case .invalidTSHRange:
            return NSLocalizedString("Verifique que el TSH este en el rango valido (0.1-20.0 mIU/L).", comment: "")
        case .invalidBMIRange:
            return NSLocalizedString("Verifique que el IMC este en el rango valido (15.0-60.0).", comment: "")
        case .inconsistentData:
            return NSLocalizedString("Revise la consistencia de los datos medicos ingresados.", comment: "")
        case .calculationOverflow:
            return NSLocalizedString("Los valores ingresados pueden estar fuera de rangos seguros.", comment: "")
        case .insufficientData:
            return NSLocalizedString("Complete todos los datos requeridos para el calculo.", comment: "")
        case .validationFailed:
            return NSLocalizedString("Corrija los datos segun las validaciones medicas.", comment: "")
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
            return String(format: NSLocalizedString("Inconsistencia edad-AMH: Edad %@ anios con AMH %@ ng/mL", comment: ""), String(age), String(amh))
        case .ageFertilityMismatch(let age, let fertilityScore):
            return String(format: NSLocalizedString("Puntuacion de fertilidad %@ no corresponde a edad %@", comment: ""), String(fertilityScore), String(age))
        case .multiplePathologiesConflict(let pathologies):
            return String(format: NSLocalizedString("Conflicto entre patologias: %@", comment: ""), pathologies.joined(separator: ", "))
        case .treatmentContraindication(let treatment, let reason):
            return String(format: NSLocalizedString("Contraindicacion para %@: %@", comment: ""), treatment, reason)
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
            return String(format: NSLocalizedString("Error al guardar datos: %@", comment: ""), reason)
        case .loadFailed(let reason):
            return String(format: NSLocalizedString("Error al cargar datos: %@", comment: ""), reason)
        case .deleteFailed(let reason):
            return String(format: NSLocalizedString("Error al eliminar datos: %@", comment: ""), reason)
        case .encryptionFailed(let reason):
            return String(format: NSLocalizedString("Error al encriptar datos: %@", comment: ""), reason)
        case .decryptionFailed(let reason):
            return String(format: NSLocalizedString("Error al desencriptar datos: %@", comment: ""), reason)
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
        return error.errorDescription ?? NSLocalizedString("Error de calculo medico desconocido", comment: "")
    }
    
    // MARK: - Manejo de Errores de Validación
    func handleValidationError(_ error: MedicalValidationError) -> String {
        logError(error, context: "MedicalValidation")
        
        return error.errorDescription ?? NSLocalizedString("Error de validacion medica desconocido", comment: "")
    }
    
    // MARK: - Manejo de Errores de Persistencia
    func handlePersistenceError(_ error: DataPersistenceError) -> String {
        logError(error, context: "DataPersistence")
        
        return error.errorDescription ?? NSLocalizedString("Error de persistencia desconocido", comment: "")
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
