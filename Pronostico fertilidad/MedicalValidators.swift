//
//  MedicalValidators.swift
//  Pronostico fertilidad
//
//  Sistema de validaciones médicas para cálculos de fertilidad
//  Integra con ErrorHandling.swift y FertilityCalculations.swift
//
//  Created by Jorge Vásquez on 2024
//

import Foundation

// MARK: - 🏥 VALIDADORES MÉDICOS INTEGRADOS

/// Servicio de validaciones médicas para cálculos de fertilidad
struct MedicalValidators {
    
    // MARK: - Singleton
    static let shared = MedicalValidators()
    private init() {}
    
    // MARK: - Validaciones de Factores Principales
    
    /// Valida y calcula factor de edad con manejo de errores
    static func validateAndCalculateAgeFactor(_ age: Double) -> Result<Double, MedicalCalculationError> {
        // Validar rango de edad
        let validationResult = MedicalRangeValidators.validateAge(age)
        guard case .success(let validatedAge) = validationResult else {
            return validationResult
        }
        
        // Calcular factor usando función existente
        let factor = FertilityCalculations.calculateAgeFactor(validatedAge)
        
        // Validar resultado del cálculo
        guard factor >= 0.005 && factor <= 0.25 else {
            return .failure(.calculationOverflow(operation: "calculateAgeFactor"))
        }
        
        return .success(factor)
    }
    
    /// Valida y calcula factor de AMH con manejo de errores
    static func validateAndCalculateAMHFactor(_ amh: Double) -> Result<Double, MedicalCalculationError> {
        // Validar rango de AMH
        let validationResult = MedicalRangeValidators.validateAMH(amh)
        guard case .success(let validatedAMH) = validationResult else {
            return validationResult
        }
        
        // Calcular factor usando función existente
        let factor = FertilityCalculations.calculateAMHFactor(validatedAMH)
        
        // Validar resultado del cálculo
        guard factor >= 0.05 && factor <= 1.0 else {
            return .failure(.calculationOverflow(operation: "calculateAMHFactor"))
        }
        
        return .success(factor)
    }
    
    /// Valida y calcula factor de TSH con manejo de errores
    static func validateAndCalculateTSHFactor(_ tsh: Double) -> Result<Double, MedicalCalculationError> {
        // Validar rango de TSH
        let validationResult = MedicalRangeValidators.validateTSH(tsh)
        guard case .success(let validatedTSH) = validationResult else {
            return validationResult
        }
        
        // Calcular factor usando función existente
        let factor = FertilityCalculations.calculateTSHFactor(validatedTSH)
        
        // Validar resultado del cálculo
        guard factor >= 0.1 && factor <= 1.0 else {
            return .failure(.calculationOverflow(operation: "calculateTSHFactor"))
        }
        
        return .success(factor)
    }
    
    /// Valida y calcula factor de IMC con manejo de errores
    static func validateAndCalculateBMIFactor(_ bmi: Double) -> Result<Double, MedicalCalculationError> {
        // Validar rango de IMC
        let validationResult = MedicalRangeValidators.validateBMI(bmi)
        guard case .success(let validatedBMI) = validationResult else {
            return validationResult
        }
        
        // Calcular factor usando función existente
        let factor = FertilityCalculations.calculateBMIFactor(validatedBMI)
        
        // Validar resultado del cálculo
        guard factor >= 0.1 && factor <= 1.0 else {
            return .failure(.calculationOverflow(operation: "calculateBMIFactor"))
        }
        
        return .success(factor)
    }
    
    // MARK: - Validaciones de Consistencia Médica
    
    /// Valida consistencia entre edad y AMH
    static func validateAgeAMHConsistency(age: Double, amh: Double) -> Result<Void, MedicalValidationError> {
        return MedicalRangeValidators.validateAgeAMHConsistency(age: age, amh: amh)
    }
    
    /// Valida consistencia de datos de fertilidad
    static func validateFertilityDataConsistency(
        age: Double,
        amh: Double,
        tsh: Double,
        bmi: Double
    ) -> Result<Void, MedicalValidationError> {
        
        // Validar edad-AMH
        let ageAMHResult = validateAgeAMHConsistency(age: age, amh: amh)
        guard case .success = ageAMHResult else {
            return ageAMHResult
        }
        
        // Validar que los factores no sean contradictorios
        let ageFactor = FertilityCalculations.calculateAgeFactor(age)
        let amhFactor = FertilityCalculations.calculateAMHFactor(amh)
        
        // Si edad indica fertilidad muy baja pero AMH es normal, puede ser inconsistente
        if ageFactor < 0.05 && amhFactor > 0.8 {
            return .failure(.ageFertilityMismatch(age: age, fertilityScore: ageFactor))
        }
        
        return .success(())
    }
    
    // MARK: - Validaciones de Datos Disponibles
    
    /// Analiza qué datos están disponibles y calcula nivel de confianza
    /// Diseñado para calculadora que funciona con datos parciales
    static func validateAvailableData(
        age: Double?,
        amh: Double?,
        tsh: Double?,
        bmi: Double?
    ) -> (availableFactors: [String], missingFactors: [String], confidenceLevel: Double, suggestions: [String]) {
        
        var available: [String] = []
        var missing: [String] = []
        var suggestions: [String] = []
        
        // Analizar cada factor
        if age != nil { 
            available.append("Edad") 
        } else { 
            missing.append("Edad")
            suggestions.append("La edad es fundamental para el cálculo de fertilidad")
        }
        
        if amh != nil { 
            available.append("AMH") 
        } else { 
            missing.append("AMH")
            suggestions.append("El AMH es crucial para evaluar la reserva ovárica")
        }
        
        if tsh != nil { 
            available.append("TSH") 
        } else { 
            missing.append("TSH")
            suggestions.append("El TSH ayuda a evaluar la función tiroidea")
        }
        
        if bmi != nil { 
            available.append("IMC") 
        } else { 
            missing.append("IMC")
            suggestions.append("El IMC es importante para evaluar el peso corporal")
        }
        
        // Calcular nivel de confianza basado en datos disponibles
        let totalFactors = 4.0
        let confidenceLevel = Double(available.count) / totalFactors
        
        // Ajustar confianza según importancia de factores
        let adjustedConfidence = adjustConfidenceByFactorImportance(
            available: available,
            baseConfidence: confidenceLevel
        )
        
        return (available, missing, adjustedConfidence, suggestions)
    }
    
    /// Ajusta el nivel de confianza según la importancia de los factores disponibles
    private static func adjustConfidenceByFactorImportance(
        available: [String],
        baseConfidence: Double
    ) -> Double {
        
        var adjustedConfidence = baseConfidence
        
        // Factores críticos (si están disponibles, aumentan confianza)
        let criticalFactors = ["Edad", "AMH"]
        let criticalFactorBonus = 0.1
        
        for factor in criticalFactors {
            if available.contains(factor) {
                adjustedConfidence += criticalFactorBonus
            }
        }
        
        // Factores secundarios (si están disponibles, aumentan confianza moderadamente)
        let secondaryFactors = ["TSH", "IMC"]
        let secondaryFactorBonus = 0.05
        
        for factor in secondaryFactors {
            if available.contains(factor) {
                adjustedConfidence += secondaryFactorBonus
            }
        }
        
        // Limitar a máximo 1.0
        return min(1.0, adjustedConfidence)
    }
    
    /// Valida que al menos los datos mínimos estén presentes para un cálculo básico
    static func validateMinimumDataForCalculation(
        age: Double?,
        amh: Double?,
        tsh: Double?,
        bmi: Double?
    ) -> Result<Void, MedicalCalculationError> {
        
        // Mínimo requerido: Edad (es el factor más fundamental)
        guard age != nil else {
            return .failure(.insufficientData(missingFactors: ["Edad (mínimo requerido)"]))
        }
        
        // Si solo tiene edad, es aceptable pero con baja confianza
        if age != nil && amh == nil && tsh == nil && bmi == nil {
            // Permitir cálculo pero con advertencia
            return .success(())
        }
        
        return .success(())
    }
    
    // MARK: - Validaciones de Rango Clínico
    
    /// Valida que los valores estén en rangos clínicamente relevantes
    static func validateClinicalRanges(
        age: Double,
        amh: Double,
        tsh: Double,
        bmi: Double
    ) -> Result<Void, MedicalCalculationError> {
        
        // Validar cada factor individualmente
        let ageResult = MedicalRangeValidators.validateAge(age)
        let amhResult = MedicalRangeValidators.validateAMH(amh)
        let tshResult = MedicalRangeValidators.validateTSH(tsh)
        let bmiResult = MedicalRangeValidators.validateBMI(bmi)
        
        // Si algún factor falla, retornar el primer error
        if case .failure(let error) = ageResult { return .failure(error) }
        if case .failure(let error) = amhResult { return .failure(error) }
        if case .failure(let error) = tshResult { return .failure(error) }
        if case .failure(let error) = bmiResult { return .failure(error) }
        
        return .success(())
    }
    
    // MARK: - Validaciones de Seguridad
    
    /// Valida que los cálculos no excedan límites seguros
    static func validateCalculationSafety(
        ageFactor: Double,
        amhFactor: Double,
        tshFactor: Double,
        bmiFactor: Double
    ) -> Result<Void, MedicalCalculationError> {
        
        let factors = [ageFactor, amhFactor, tshFactor, bmiFactor]
        
        // Verificar que ningún factor sea extremo
        for (index, factor) in factors.enumerated() {
            if factor < 0.001 || factor > 1.0 {
                let factorNames = ["Edad", "AMH", "TSH", "IMC"]
                return .failure(.calculationOverflow(operation: "Factor \(factorNames[index])"))
            }
        }
        
        // Verificar que el producto total no sea extremo
        let totalFactor = factors.reduce(1.0, *)
        if totalFactor < 0.0001 || totalFactor > 1.0 {
            return .failure(.calculationOverflow(operation: "Producto total de factores"))
        }
        
        return .success(())
    }
}

// MARK: - 🔧 EXTENSIONES PARA INTEGRACIÓN

extension FertilityCalculations {
    
    /// Versión validada de calculateAgeFactor
    static func calculateAgeFactorValidated(_ age: Double) -> Result<Double, MedicalCalculationError> {
        return MedicalValidators.validateAndCalculateAgeFactor(age)
    }
    
    /// Versión validada de calculateAMHFactor
    static func calculateAMHFactorValidated(_ amh: Double) -> Result<Double, MedicalCalculationError> {
        return MedicalValidators.validateAndCalculateAMHFactor(amh)
    }
    
    /// Versión validada de calculateTSHFactor
    static func calculateTSHFactorValidated(_ tsh: Double) -> Result<Double, MedicalCalculationError> {
        return MedicalValidators.validateAndCalculateTSHFactor(tsh)
    }
    
    /// Versión validada de calculateBMIFactor
    static func calculateBMIFactorValidated(_ bmi: Double) -> Result<Double, MedicalCalculationError> {
        return MedicalValidators.validateAndCalculateBMIFactor(bmi)
    }
}

// MARK: - 📊 LOGGING DE VALIDACIONES

extension MedicalValidators {
    
    /// Registra validación exitosa
    static func logSuccessfulValidation(_ factor: String, value: Double) {
        let message = "✅ Validación exitosa: \(factor) = \(value)"
        print("🏥 MEDICAL VALIDATION: \(message)")
    }
    
    /// Registra validación fallida
    static func logFailedValidation(_ factor: String, value: Double, error: String) {
        let message = "❌ Validación fallida: \(factor) = \(value) - \(error)"
        print("🏥 MEDICAL VALIDATION: \(message)")
    }
    
    /// Registra cálculo exitoso
    static func logSuccessfulCalculation(_ factor: String, input: Double, output: Double) {
        let message = "✅ Cálculo exitoso: \(factor)(\(input)) = \(output)"
        print("🧮 MEDICAL CALCULATION: \(message)")
    }
    
    /// Registra cálculo fallido
    static func logFailedCalculation(_ factor: String, input: Double, error: String) {
        let message = "❌ Cálculo fallido: \(factor)(\(input)) - \(error)"
        print("🧮 MEDICAL CALCULATION: \(message)")
    }
    
    /// Genera mensaje de confianza para mostrar al usuario
    static func generateConfidenceMessage(
        confidenceLevel: Double,
        availableFactors: [String],
        missingFactors: [String]
    ) -> (title: String, message: String, color: String) {
        
        switch confidenceLevel {
        case 0.8...1.0:
            return (
                title: "Alta Confianza",
                message: "Cálculo basado en \(availableFactors.count) factores principales. Resultado muy confiable.",
                color: "green"
            )
        case 0.6..<0.8:
            return (
                title: "Confianza Moderada",
                message: "Cálculo basado en \(availableFactors.count) factores. Considera agregar: \(missingFactors.joined(separator: ", ")).",
                color: "orange"
            )
        case 0.4..<0.6:
            return (
                title: "Confianza Baja",
                message: "Cálculo limitado. Para mayor precisión, agrega: \(missingFactors.joined(separator: ", ")).",
                color: "red"
            )
        default:
            return (
                title: "Confianza Muy Baja",
                message: "Cálculo básico con edad únicamente. Agrega más datos para mejor precisión.",
                color: "red"
            )
        }
    }
}
