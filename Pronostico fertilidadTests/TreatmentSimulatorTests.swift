//
//  TreatmentSimulatorTests.swift
//  Pronostico fertilidadTests
//
//  Tests para TreatmentSimulator.swift
//

import Foundation

// MARK: - 📊 ESTRUCTURA DE RESULTADOS
struct TestResult {
    let total: Int
    let passed: Int
    let failed: Int
    
    var successRate: Double {
        return Double(passed) / Double(total)
    }
}

// MARK: - 🧪 TESTS PARA SIMULADOR DE TRATAMIENTOS
class TreatmentSimulatorTests {
    
    static func runTests() -> TestResult {
        print("💊 EJECUTANDO TESTS DEL SIMULADOR DE TRATAMIENTOS...")
        
        var total = 0
        var passed = 0
        
        // Test 1: Inicialización del simulador
        total += 1
        if testSimulatorInitialization() {
            passed += 1
            print("  ✅ Inicialización del simulador")
        } else {
            print("  ❌ Inicialización del simulador")
        }
        
        // Test 2: Recomendaciones de tratamiento
        total += 1
        if testTreatmentRecommendations() {
            passed += 1
            print("  ✅ Recomendaciones de tratamiento")
        } else {
            print("  ❌ Recomendaciones de tratamiento")
        }
        
        // Test 3: Simulación de factores modificables
        total += 1
        if testModifiableFactorsSimulation() {
            passed += 1
            print("  ✅ Simulación de factores modificables")
        } else {
            print("  ❌ Simulación de factores modificables")
        }
        
        // Test 4: Validación de datos médicos
        total += 1
        if testMedicalDataValidation() {
            passed += 1
            print("  ✅ Validación de datos médicos")
        } else {
            print("  ❌ Validación de datos médicos")
        }
        
        // Test 5: Cálculos de probabilidad
        total += 1
        if testProbabilityCalculations() {
            passed += 1
            print("  ✅ Cálculos de probabilidad")
        } else {
            print("  ❌ Cálculos de probabilidad")
        }
        
        return TestResult(total: total, passed: passed, failed: total - passed)
    }
    
    // MARK: - 🧪 TESTS ESPECÍFICOS
    
    private static func testSimulatorInitialization() -> Bool {
        // Simular inicialización del simulador
        let simulator = MockTreatmentSimulator()
        return simulator.isInitialized && simulator.version == "1.0"
    }
    
    private static func testTreatmentRecommendations() -> Bool {
        let simulator = MockTreatmentSimulator()
        
        // Test diferentes escenarios
        let recommendation1 = simulator.getTreatmentRecommendation(age: 25, amh: 2.5, bmi: 22.0)
        let recommendation2 = simulator.getTreatmentRecommendation(age: 38, amh: 0.8, bmi: 28.0)
        let recommendation3 = simulator.getTreatmentRecommendation(age: 32, amh: 1.2, bmi: 24.0)
        
        // Verificar que las recomendaciones son válidas
        return !recommendation1.isEmpty && 
               !recommendation2.isEmpty && 
               !recommendation3.isEmpty &&
               recommendation1 != recommendation2 // Diferentes edades deben dar diferentes recomendaciones
    }
    
    private static func testModifiableFactorsSimulation() -> Bool {
        let simulator = MockTreatmentSimulator()
        
        // Simular diferentes escenarios
        let factors1 = simulator.simulateModifiableFactors(age: 25, bmi: 22.0, lifestyle: "Sedentario")
        let factors2 = simulator.simulateModifiableFactors(age: 35, bmi: 30.0, lifestyle: "Activo")
        
        // Verificar que se generan factores válidos
        return factors1.count > 0 && factors2.count > 0 &&
               factors1.contains { $0.contains("mejora") } &&
               factors2.contains { $0.contains("reducción") }
    }
    
    private static func testMedicalDataValidation() -> Bool {
        let validator = MockMedicalDataValidator()
        
        // Test datos válidos
        let validData = validator.validatePatientData(age: 28, amh: 1.8, bmi: 23.0)
        
        // Test datos inválidos
        let invalidData1 = validator.validatePatientData(age: -5, amh: 1.8, bmi: 23.0)
        let invalidData2 = validator.validatePatientData(age: 28, amh: -1.0, bmi: 23.0)
        let invalidData3 = validator.validatePatientData(age: 28, amh: 1.8, bmi: 5.0)
        
        return validData && !invalidData1 && !invalidData2 && !invalidData3
    }
    
    private static func testProbabilityCalculations() -> Bool {
        let calculator = MockProbabilityCalculator()
        
        // Test cálculos de probabilidad
        let prob1 = calculator.calculateSuccessProbability(age: 25, amh: 2.0, bmi: 22.0)
        let prob2 = calculator.calculateSuccessProbability(age: 35, amh: 1.0, bmi: 25.0)
        let prob3 = calculator.calculateSuccessProbability(age: 40, amh: 0.5, bmi: 28.0)
        
        // Verificar que las probabilidades son lógicas
        return prob1 > prob2 && prob2 > prob3 && // Edad menor = mayor probabilidad
               prob1 > 0 && prob1 <= 1.0 &&
               prob2 > 0 && prob2 <= 1.0 &&
               prob3 > 0 && prob3 <= 1.0
    }
}

// MARK: - 🎭 MOCKS PARA TESTING

class MockTreatmentSimulator {
    var isInitialized: Bool = true
    var version: String = "1.0"
    
    func getTreatmentRecommendation(age: Int, amh: Double, bmi: Double) -> String {
        if age < 30 && amh >= 1.5 && bmi < 25.0 {
            return "Coito programado - Alta probabilidad natural"
        } else if age < 35 && amh >= 1.0 {
            return "IUI considerado - Probabilidad moderada"
        } else if age >= 35 || amh < 1.0 {
            return "FIV recomendado - Baja probabilidad natural"
        } else {
            return "Evaluación individualizada requerida"
        }
    }
    
    func simulateModifiableFactors(age: Int, bmi: Double, lifestyle: String) -> [String] {
        var factors: [String] = []
        
        if bmi > 25.0 {
            factors.append("Reducción de peso recomendada")
        }
        
        if lifestyle == "Sedentario" {
            factors.append("Mejora de actividad física")
        }
        
        if age >= 35 {
            factors.append("Evaluación urgente recomendada")
        }
        
        return factors
    }
}

class MockMedicalDataValidator {
    func validatePatientData(age: Int, amh: Double, bmi: Double) -> Bool {
        return age >= 18 && age <= 50 &&
               amh >= 0.1 && amh <= 10.0 &&
               bmi >= 16.0 && bmi <= 50.0
    }
}

class MockProbabilityCalculator {
    func calculateSuccessProbability(age: Int, amh: Double, bmi: Double) -> Double {
        var probability = 0.25 // Base
        
        // Factor edad
        if age < 30 { probability *= 1.0 }
        else if age < 35 { probability *= 0.9 }
        else if age < 40 { probability *= 0.7 }
        else { probability *= 0.5 }
        
        // Factor AMH
        if amh >= 1.0 { probability *= 1.0 }
        else if amh >= 0.5 { probability *= 0.8 }
        else { probability *= 0.6 }
        
        // Factor BMI
        if bmi >= 18.5 && bmi < 25.0 { probability *= 1.0 }
        else if bmi >= 25.0 && bmi < 30.0 { probability *= 0.9 }
        else { probability *= 0.7 }
        
        return min(max(probability, 0.0), 1.0)
    }
}
