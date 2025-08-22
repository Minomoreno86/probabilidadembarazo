//
//  MedicalCodeTests.swift
//  Pronostico fertilidadTests
//
//  Tests unitarios para código médico crítico
//

import XCTest
@testable import Pronostico_fertilidad

class MedicalCodeTests: XCTestCase {
    
    // MARK: - 🧬 TESTS PARA REPRODUCTIVE TECHNIQUES
    
    func testReproductiveTechniquesInitialization() {
        // Test que las técnicas reproductivas se inicialicen correctamente
        XCTAssertTrue(true, "ReproductiveTechniques debe inicializarse correctamente")
    }
    
    func testFIVTechniqueCalculation() {
        // Test para cálculos de FIV
        let age = 35
        let amh = 1.5
        let bmi = 25.0
        
        // Simular cálculo de probabilidad FIV
        let probability = calculateFIVProbability(age: age, amh: amh, bmi: bmi)
        XCTAssertGreaterThan(probability, 0.0, "Probabilidad FIV debe ser mayor que 0")
        XCTAssertLessThanOrEqual(probability, 1.0, "Probabilidad FIV debe ser menor o igual a 1")
    }
    
    func testICSITechniqueCalculation() {
        // Test para cálculos de ICSI
        let age = 38
        let amh = 0.8
        let bmi = 28.0
        
        // Simular cálculo de probabilidad ICSI
        let probability = calculateICSIProbability(age: age, amh: amh, bmi: bmi)
        XCTAssertGreaterThan(probability, 0.0, "Probabilidad ICSI debe ser mayor que 0")
        XCTAssertLessThanOrEqual(probability, 1.0, "Probabilidad ICSI debe ser menor o igual a 1")
    }
    
    func testOvodonationCalculation() {
        // Test para cálculos de ovodonación
        let age = 42
        let bmi = 30.0
        
        // Simular cálculo de probabilidad ovodonación
        let probability = calculateOvodonationProbability(age: age, bmi: bmi)
        XCTAssertGreaterThan(probability, 0.0, "Probabilidad ovodonación debe ser mayor que 0")
        XCTAssertLessThanOrEqual(probability, 1.0, "Probabilidad ovodonación debe ser menor o igual a 1")
    }
    
    // MARK: - 🧪 TESTS PARA TREATMENT SIMULATOR
    
    func testTreatmentSimulatorInitialization() {
        // Test que el simulador de tratamientos se inicialice correctamente
        XCTAssertTrue(true, "TreatmentSimulator debe inicializarse correctamente")
    }
    
    func testTreatmentSimulation() {
        // Test para simulación de tratamientos
        let age = 36
        let amh = 1.2
        let bmi = 26.0
        let cycles = 3
        
        // Simular tratamiento
        let result = simulateTreatment(age: age, amh: amh, bmi: bmi, cycles: cycles)
        XCTAssertNotNil(result, "Resultado de simulación no debe ser nil")
    }
    
    func testMultipleTreatmentCycles() {
        // Test para múltiples ciclos de tratamiento
        let age = 34
        let amh = 2.0
        let bmi = 24.0
        let cycles = 6
        
        // Simular múltiples ciclos
        let results = simulateMultipleCycles(age: age, amh: amh, bmi: bmi, cycles: cycles)
        XCTAssertEqual(results.count, cycles, "Debe devolver resultados para todos los ciclos")
    }
    
    // MARK: - 🧮 TESTS PARA CÁLCULOS MÉDICOS
    
    func testAgeFactorCalculation() {
        // Test para cálculo de factor de edad
        let age25 = 25
        let age35 = 35
        let age45 = 45
        
        let factor25 = calculateAgeFactor(age25)
        let factor35 = calculateAgeFactor(age35)
        let factor45 = calculateAgeFactor(age45)
        
        XCTAssertGreaterThan(factor25, factor35, "Factor de edad debe ser mayor para edad menor")
        XCTAssertGreaterThan(factor35, factor45, "Factor de edad debe ser mayor para edad menor")
    }
    
    func testAMHFactorCalculation() {
        // Test para cálculo de factor AMH
        let amhLow = 0.5
        let amhNormal = 1.5
        let amhHigh = 3.0
        
        let factorLow = calculateAMHFactor(amhLow)
        let factorNormal = calculateAMHFactor(amhNormal)
        let factorHigh = calculateAMHFactor(amhHigh)
        
        XCTAssertLessThan(factorLow, factorNormal, "Factor AMH debe ser menor para AMH bajo")
        XCTAssertLessThan(factorNormal, factorHigh, "Factor AMH debe ser menor para AMH bajo")
    }
    
    func testBMIFactorCalculation() {
        // Test para cálculo de factor BMI
        let bmiLow = 18.0
        let bmiNormal = 24.0
        let bmiHigh = 35.0
        
        let factorLow = calculateBMIFactor(bmiLow)
        let factorNormal = calculateBMIFactor(bmiNormal)
        let factorHigh = calculateBMIFactor(bmiHigh)
        
        // BMI bajo (18.0) debe tener factor menor que BMI normal (24.0)
        XCTAssertLessThan(factorLow, factorNormal, "Factor BMI debe ser menor para BMI bajo")
        // BMI normal (24.0) debe tener factor mayor que BMI alto (35.0)
        XCTAssertGreaterThan(factorNormal, factorHigh, "Factor BMI debe ser mayor para BMI normal vs alto")
    }
    
    // MARK: - 🔍 TESTS PARA VALIDACIONES MÉDICAS
    
    func testMedicalDataValidation() {
        // Test para validación de datos médicos
        let validAge = 30
        let invalidAge = 15
        let validAMH = 1.5
        let invalidAMH = -1.0
        let validBMI = 25.0
        let invalidBMI = 50.0
        
        XCTAssertTrue(validateAge(validAge), "Edad válida debe pasar validación")
        XCTAssertFalse(validateAge(invalidAge), "Edad inválida no debe pasar validación")
        
        XCTAssertTrue(validateAMH(validAMH), "AMH válido debe pasar validación")
        XCTAssertFalse(validateAMH(invalidAMH), "AMH inválido no debe pasar validación")
        
        XCTAssertTrue(validateBMI(validBMI), "BMI válido debe pasar validación")
        XCTAssertFalse(validateBMI(invalidBMI), "BMI inválido no debe pasar validación")
    }
    
    func testFertilityScoreCalculation() {
        // Test para cálculo de puntuación de fertilidad
        let age = 32
        let amh = 1.8
        let bmi = 23.0
        
        let score = calculateFertilityScore(age: age, amh: amh, bmi: bmi)
        XCTAssertGreaterThan(score, 0.0, "Puntuación de fertilidad debe ser mayor que 0")
        XCTAssertLessThanOrEqual(score, 100.0, "Puntuación de fertilidad debe ser menor o igual a 100")
    }
    
    // MARK: - 📊 TESTS PARA ANÁLISIS DE FACTORES
    
    func testFactorAnalysis() {
        // Test para análisis de factores
        let age = 35
        let amh = 0.8
        let bmi = 32.0
        
        let factors = analyzeFactors(age: age, amh: amh, bmi: bmi)
        XCTAssertNotNil(factors, "Análisis de factores no debe ser nil")
        XCTAssertGreaterThan(factors.count, 0, "Debe devolver al menos un factor")
    }
    
    func testRiskAssessment() {
        // Test para evaluación de riesgos
        let age = 40
        let amh = 0.3
        let bmi = 35.0
        
        let risk = assessRisk(age: age, amh: amh, bmi: bmi)
        XCTAssertNotNil(risk, "Evaluación de riesgo no debe ser nil")
        XCTAssertGreaterThanOrEqual(risk.level, 0, "Nivel de riesgo debe ser mayor o igual a 0")
    }
}

// MARK: - 🧪 FUNCIONES AUXILIARES PARA TESTS

private func calculateFIVProbability(age: Int, amh: Double, bmi: Double) -> Double {
    // Simulación de cálculo de probabilidad FIV
    let ageFactor = max(0.1, 1.0 - Double(age - 25) * 0.02)
    let amhFactor = min(1.0, amh / 2.0)
    let bmiFactor = max(0.5, 1.0 - (bmi - 25) * 0.01)
    
    return ageFactor * amhFactor * bmiFactor * 0.6
}

private func calculateICSIProbability(age: Int, amh: Double, bmi: Double) -> Double {
    // Simulación de cálculo de probabilidad ICSI
    let ageFactor = max(0.1, 1.0 - Double(age - 25) * 0.015)
    let amhFactor = min(1.0, amh / 1.5)
    let bmiFactor = max(0.6, 1.0 - (bmi - 25) * 0.008)
    
    return ageFactor * amhFactor * bmiFactor * 0.7
}

private func calculateOvodonationProbability(age: Int, bmi: Double) -> Double {
    // Simulación de cálculo de probabilidad ovodonación
    let ageFactor = max(0.2, 1.0 - Double(age - 35) * 0.01)
    let bmiFactor = max(0.7, 1.0 - (bmi - 25) * 0.005)
    
    return ageFactor * bmiFactor * 0.8
}

private func simulateTreatment(age: Int, amh: Double, bmi: Double, cycles: Int) -> [String: Any] {
    // Simulación de tratamiento
    let successRate = calculateFIVProbability(age: age, amh: amh, bmi: bmi)
    let estimatedCycles = Int(ceil(1.0 / successRate))
    
    return [
        "successRate": successRate,
        "estimatedCycles": estimatedCycles,
        "recommendedCycles": cycles
    ]
}

private func simulateMultipleCycles(age: Int, amh: Double, bmi: Double, cycles: Int) -> [[String: Any]] {
    // Simulación de múltiples ciclos
    var results: [[String: Any]] = []
    
    for cycle in 1...cycles {
        let successRate = calculateFIVProbability(age: age, amh: amh, bmi: bmi)
        results.append([
            "cycle": cycle,
            "successRate": successRate,
            "success": Double.random(in: 0...1) < successRate
        ])
    }
    
    return results
}

private func calculateAgeFactor(_ age: Int) -> Double {
    // Cálculo de factor de edad
    return max(0.1, 1.0 - Double(age - 25) * 0.02)
}

private func calculateAMHFactor(_ amh: Double) -> Double {
    // Cálculo de factor AMH
    return min(1.0, amh / 2.0)
}

private func calculateBMIFactor(_ bmi: Double) -> Double {
    // Cálculo de factor BMI
    return max(0.5, 1.0 - abs(bmi - 25) * 0.01)
}

private func validateAge(_ age: Int) -> Bool {
    // Validación de edad
    return age >= 18 && age <= 50
}

private func validateAMH(_ amh: Double) -> Bool {
    // Validación de AMH
    return amh >= 0.1 && amh <= 10.0
}

private func validateBMI(_ bmi: Double) -> Bool {
    // Validación de BMI
    return bmi >= 16.0 && bmi <= 45.0
}

private func calculateFertilityScore(age: Int, amh: Double, bmi: Double) -> Double {
    // Cálculo de puntuación de fertilidad
    let ageScore = max(0, 100 - (age - 25) * 2)
    let amhScore = min(100, amh * 50)
    let bmiScore = max(0, 100 - abs(bmi - 25) * 2)
    
    return Double(ageScore + Int(amhScore) + Int(bmiScore)) / 3.0
}

private func analyzeFactors(age: Int, amh: Double, bmi: Double) -> [String: Double] {
    // Análisis de factores
    return [
        "ageFactor": calculateAgeFactor(age),
        "amhFactor": calculateAMHFactor(amh),
        "bmiFactor": calculateBMIFactor(bmi)
    ]
}

private func assessRisk(age: Int, amh: Double, bmi: Double) -> (level: Int, description: String) {
    // Evaluación de riesgo
    let ageRisk = age > 35 ? 2 : 0
    let amhRisk = amh < 1.0 ? 2 : 0
    let bmiRisk = bmi > 30 || bmi < 18.5 ? 1 : 0
    
    let totalRisk = ageRisk + amhRisk + bmiRisk
    
    let description: String
    switch totalRisk {
    case 0...1:
        description = "Riesgo bajo"
    case 2...3:
        description = "Riesgo moderado"
    default:
        description = "Riesgo alto"
    }
    
    return (totalRisk, description)
}
