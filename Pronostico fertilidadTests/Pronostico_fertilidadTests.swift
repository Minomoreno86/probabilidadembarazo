//
//  Pronostico_fertilidadTests.swift
//  Pronostico fertilidadTests
//
//  Created by Jorge Vasquez rodriguez on 11/08/2025.
//

@testable import Pronostico_fertilidad
import Foundation

// MARK: - 🧪 SISTEMA DE TESTING SIMPLIFICADO
struct TestRunner {
    
    static func runAllTests() {
        print("\n🚀 INICIANDO EJECUCIÓN DE TESTS...")
        print("=====================================")
        
        var passedTests = 0
        var totalTests = 0
        
        // Test 1: Cálculos matemáticos básicos
        if testFertilityCalculations() { passedTests += 1 }
        totalTests += 1
        
        // Test 2: Simulador de tratamientos
        if testTreatmentSimulator() { passedTests += 1 }
        totalTests += 1
        
        // Test 3: Motor principal
        if testImprovedFertilityEngine() { passedTests += 1 }
        totalTests += 1
        
        // Test 4: Análisis detallado
        if testDetailedAnalysis() { passedTests += 1 }
        totalTests += 1
        
        // Test 5: Factores modificables
        if testModifiableFactors() { passedTests += 1 }
        totalTests += 1
        
        print("\n📊 RESUMEN DE TESTS:")
        print("✅ Tests pasados: \(passedTests)")
        print("❌ Tests fallidos: \(totalTests - passedTests)")
        print("📈 Porcentaje de éxito: \(Int((Double(passedTests) / Double(totalTests)) * 100))%")
        print("=====================================")
    }
    
    // MARK: - 🧪 TEST 1: CÁLCULOS MATEMÁTICOS
    private static func testFertilityCalculations() -> Bool {
        print("\n🧪 TEST 1: CÁLCULOS MATEMÁTICOS")
        print("---------------------------------")
        
        var allPassed = true
        
        // Test factor edad
        let factor18 = FertilityCalculations.calculateAgeFactor(age: 18)
        let factor30 = FertilityCalculations.calculateAgeFactor(age: 30)
        let factor35 = FertilityCalculations.calculateAgeFactor(age: 35)
        let factor40 = FertilityCalculations.calculateAgeFactor(age: 40)
        
        print("Edad 18: \(factor18) (esperado: ≥0.20)")
        print("Edad 30: \(factor30) (esperado: ≥0.15)")
        print("Edad 35: \(factor35) (esperado: 0.10-0.15)")
        print("Edad 40: \(factor40) (esperado: <0.10)")
        
        // Validaciones
        if factor18 < 0.20 {
            print("❌ Edad 18: Falló - valor muy bajo")
            allPassed = false
        }
        
        if factor30 < 0.15 {
            print("❌ Edad 30: Falló - valor muy bajo")
            allPassed = false
        }
        
        if factor35 < 0.10 || factor35 >= 0.15 {
            print("❌ Edad 35: Falló - fuera del rango esperado")
            allPassed = false
        }
        
        if factor40 >= 0.10 {
            print("❌ Edad 40: Falló - valor muy alto")
            allPassed = false
        }
        
        // Test factor IMC
        let bmiNormal = FertilityCalculations.calculateBMIFactor(bmi: 22.0)
        let bmiOverweight = FertilityCalculations.calculateBMIFactor(bmi: 28.0)
        
        print("IMC 22.0: \(bmiNormal) (esperado: 1.0)")
        print("IMC 28.0: \(bmiOverweight) (esperado: <1.0)")
        
        if bmiNormal != 1.0 {
            print("❌ IMC normal: Falló")
            allPassed = false
        }
        
        if bmiOverweight >= 1.0 {
            print("❌ IMC sobrepeso: Falló")
            allPassed = false
        }
        
        if allPassed {
            print("✅ Test cálculos matemáticos: PASÓ")
        } else {
            print("❌ Test cálculos matemáticos: FALLÓ")
        }
        
        return allPassed
    }
    
    // MARK: - 🧪 TEST 2: SIMULADOR DE TRATAMIENTOS
    private static func testTreatmentSimulator() -> Bool {
        print("\n🧪 TEST 2: SIMULADOR DE TRATAMIENTOS")
        print("-------------------------------------")
        
        var allPassed = true
        let simulator = TreatmentSimulator()
        
        // Test clasificación POSEIDON
        let profile1 = FertilityProfile()
        profile1.age = 25
        profile1.amhValue = 3.0
        
        let rec1 = simulator.determineOptimalTreatment(profile: profile1)
        print("POSEIDON Group 1 (25 años, AMH 3.0): \(rec1.plan)")
        
        if rec1.plan != .coito && rec1.plan != .iui {
            print("❌ POSEIDON Group 1: Falló - debería ser Coito o IUI")
            allPassed = false
        }
        
        // Test factores modificables
        let profile2 = FertilityProfile()
        profile2.age = 30
        profile2.tshValue = 8.0
        profile2.bmi = 32.0
        
        let modifiableFactors = simulator.simulateModifiableFactors(profile: profile2)
        print("Factores modificables encontrados: \(modifiableFactors.count)")
        
        if modifiableFactors.count < 2 {
            print("❌ Factores modificables: Falló - muy pocos factores")
            allPassed = false
        }
        
        // Test simulación de corrección
        let correction = simulator.simulateFactorCorrection(profile: profile2)
        if correction == nil {
            print("❌ Simulación corrección: Falló - no se pudo simular")
            allPassed = false
        } else {
            print("✅ Simulación corrección: PASÓ")
        }
        
        if allPassed {
            print("✅ Test simulador tratamientos: PASÓ")
        } else {
            print("❌ Test simulador tratamientos: FALLÓ")
        }
        
        return allPassed
    }
    
    // MARK: - 🧪 TEST 3: MOTOR PRINCIPAL
    private static func testImprovedFertilityEngine() -> Bool {
        print("\n🧪 TEST 3: MOTOR PRINCIPAL")
        print("----------------------------")
        
        var allPassed = true
        let engine = ImprovedFertilityEngine()
        
        let profile = FertilityProfile(
            age: 30,
            height: 165,
            weight: 65,
            tshValue: 7.0,
            amhValue: 1.2,
            cycleLength: 35
        )
        
        let result = engine.analyzeComprehensiveFertility(from: profile)
        
        print("Probabilidad mensual: \(result.monthlyProbability)")
        print("Probabilidad anual: \(result.annualProbability)")
        print("Factores clave: \(result.keyFactors.count)")
        
        // Validaciones
        if result.monthlyProbability <= 0 {
            print("❌ Probabilidad mensual: Falló - valor inválido")
            allPassed = false
        }
        
        if result.annualProbability <= 0 {
            print("❌ Probabilidad anual: Falló - valor inválido")
            allPassed = false
        }
        
        if result.keyFactors.isEmpty {
            print("❌ Factores clave: Falló - no hay factores")
            allPassed = false
        }
        
        if allPassed {
            print("✅ Test motor principal: PASÓ")
        } else {
            print("❌ Test motor principal: FALLÓ")
        }
        
        return allPassed
    }
    
    // MARK: - 🧪 TEST 4: ANÁLISIS DETALLADO
    private static func testDetailedAnalysis() -> Bool {
        print("\n🧪 TEST 4: ANÁLISIS DETALLADO")
        print("-------------------------------")
        
        var allPassed = true
        let engine = ImprovedFertilityEngine()
        
        // Test con TSH elevado
        let profile = FertilityProfile(
            age: 30,
            height: 165,
            weight: 65,
            tshValue: 7.0
        )
        
        let result = engine.analyzeComprehensiveFertility(from: profile)
        let analysis = result.detailedAnalysis
        
        print("Análisis generado: \(analysis.prefix(200))...")
        
        // Validaciones
        if !analysis.contains("TSH 7.0") {
            print("❌ Análisis TSH: Falló - no menciona valor TSH")
            allPassed = false
        }
        
        if !analysis.contains("hipotiroidismo") {
            print("❌ Análisis TSH: Falló - no menciona hipotiroidismo")
            allPassed = false
        }
        
        if !analysis.contains("Evidencia Científica") {
            print("❌ Análisis: Falló - no incluye evidencia científica")
            allPassed = false
        }
        
        if allPassed {
            print("✅ Test análisis detallado: PASÓ")
        } else {
            print("❌ Test análisis detallado: FALLÓ")
        }
        
        return allPassed
    }
    
    // MARK: - 🧪 TEST 5: FACTORES MODIFICABLES
    private static func testModifiableFactors() -> Bool {
        print("\n🧪 TEST 5: FACTORES MODIFICABLES")
        print("---------------------------------")
        
        var allPassed = true
        let simulator = TreatmentSimulator()
        
        let profile = FertilityProfile()
        profile.age = 22.0
        profile.amhValue = 0.5  // No modificable
        profile.tshValue = 7.0  // Modificable
        profile.myomaType = .intramural
        profile.myomaSize = 4.0  // Modificable
        profile.bmi = 22.0  // Normal
        
        // Verificar recomendación
        let recommendation = simulator.determineOptimalTreatment(profile: profile)
        print("Recomendación: \(recommendation.plan)")
        
        if recommendation.plan != .fiv {
            print("❌ Recomendación: Falló - debería ser FIV para POSEIDON Group 4")
            allPassed = false
        }
        
        // Verificar factores modificables
        let modifiableFactors = simulator.simulateModifiableFactors(profile: profile)
        print("Factores modificables: \(modifiableFactors.count)")
        
        if modifiableFactors.count != 2 {
            print("❌ Factores modificables: Falló - debería encontrar 2")
            allPassed = false
        }
        
        // Verificar que AMH no aparece como modificable
        let amhFactor = modifiableFactors.first { $0.factor.contains("AMH") || $0.factor.contains("Reserva") }
        if amhFactor != nil {
            print("❌ AMH modificable: Falló - AMH no debería ser modificable")
            allPassed = false
        }
        
        if allPassed {
            print("✅ Test factores modificables: PASÓ")
        } else {
            print("❌ Test factores modificables: FALLÓ")
        }
        
        return allPassed
    }
}

// MARK: - 🚀 EJECUTAR TESTS
// Para ejecutar los tests, llamar: TestRunner.runAllTests()
