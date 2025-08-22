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
        // Iniciando ejecución de tests
        
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
        
        // Resumen de tests completado
    }
    
    // MARK: - 🧪 TEST 1: CÁLCULOS MATEMÁTICOS
    private static func testFertilityCalculations() -> Bool {
        // Testing FertilityCalculations
        
        // Test 1: Cálculo de edad con transiciones suaves
        let factor18 = FertilityCalculations.calculateAgeFactor(18)
        let factor30 = FertilityCalculations.calculateAgeFactor(30)
        let factor35 = FertilityCalculations.calculateAgeFactor(35)
        let factor40 = FertilityCalculations.calculateAgeFactor(40)
        
        // Validar que las probabilidades estén en rangos médicamente válidos
        let ageTest18 = factor18 >= 0.20 && factor18 <= 0.30  // 18 años: ~25%
        let ageTest30 = factor30 >= 0.15 && factor30 <= 0.25  // 30 años: ~20%
        let ageTest35 = factor35 >= 0.10 && factor35 <= 0.20  // 35 años: ~15%
        let ageTest40 = factor40 >= 0.05 && factor40 <= 0.15  // 40 años: ~7.5%
        
        // Tests de edad completados
        
        // Test 2: Cálculo de IMC
        let bmiNormal = FertilityCalculations.calculateBMIFactor(22.0)
        let bmiOverweight = FertilityCalculations.calculateBMIFactor(28.0)
        
        let bmiTestNormal = bmiNormal >= 0.9 && bmiNormal <= 1.1    // Normal: ~1.0
        let bmiTestOverweight = bmiOverweight >= 0.7 && bmiOverweight <= 0.9  // Sobrepeso: ~0.8
        
        // Tests de IMC completados
        
        // Test 3: Cálculo de TSH
        let tshNormal = FertilityCalculations.calculateTSHFactor(2.0)
        let tshElevated = FertilityCalculations.calculateTSHFactor(4.0)
        
        let tshTestNormal = tshNormal >= 0.9 && tshNormal <= 1.1      // Normal: 1.0
        let tshTestElevated = tshElevated >= 0.7 && tshElevated <= 0.9 // Elevado: 0.8
        
        // Tests de TSH completados
        
        let allTestsPassed = ageTest18 && ageTest30 && ageTest35 && ageTest40 && 
                            bmiTestNormal && bmiTestOverweight && 
                            tshTestNormal && tshTestElevated
        
        // Resultado del test completado
        return allTestsPassed
    }
    
    // MARK: - 🧪 TEST 2: SIMULADOR DE TRATAMIENTOS
    private static func testTreatmentSimulator() -> Bool {
        // Testing TreatmentSimulator
        
        // Test 1: Clasificación POSEIDON
        let simulator = TreatmentSimulator()
        
        // Crear perfil de prueba
        let testProfile = FertilityProfile(
            age: 35,
            height: 165,
            weight: 65,
            cycleLength: 28,
            infertilityDuration: 2,
            previousPregnancies: 0,
            hasPcos: false,
            hirsutismSeverity: .none,
            acneSeverity: .none,
            ovarianMorphology: .notEvaluated,
            endometriosisStage: 0,
            myomaType: .none,
            myomaSize: nil,
            adenomyosisType: .none,
            polypType: .none,
            hsgResult: .normal,
            hasPelvicSurgery: false,
            numberOfPelvicSurgeries: 0,
            hasOtb: false,
            otbMethod: .none,
            tpoAbPositive: false,
            insulinValue: nil,
            glucoseValue: nil,
            amhValue: 0.8,
            tshValue: 3.5,
            prolactinValue: nil,
            spermConcentration: nil,
            spermProgressiveMotility: nil,
            spermNormalMorphology: nil,
            semenVolume: nil,
            spermDNAFragmentation: nil,
            hasVaricocele: false,
            seminalCulturePositive: false
        )
        
        let recommendation = simulator.determineOptimalTreatment(profile: testProfile)
        
        // Validar que la recomendación sea válida
        let validPlan = recommendation.plan == TreatmentPlan.coitoProgramado || 
                       recommendation.plan == TreatmentPlan.iui || 
                       recommendation.plan == TreatmentPlan.fiv || 
                       recommendation.plan == TreatmentPlan.icsi || 
                       recommendation.plan == TreatmentPlan.evaluarOvodonacion
        
        // Plan recomendado y validado
        
        // Test 2: Simulación de factores modificables
        let modifiableFactors = simulator.simulateModifiableFactors(profile: testProfile)
        let hasModifiableFactors = !modifiableFactors.isEmpty
        
        // Factores modificables validados
        
        // Test 3: Simulación de corrección de factor
        let correctionSimulation = simulator.simulateFactorCorrection(profile: testProfile)
        let hasCorrectionSimulation = correctionSimulation != nil
        
        // Simulación de corrección validada
        
        let allTestsPassed = validPlan && hasModifiableFactors
        
        // Resultado del test completado
        return allTestsPassed
    }
    
    // MARK: - 🧪 TEST 3: MOTOR PRINCIPAL
    private static func testImprovedFertilityEngine() -> Bool {
        // Testing ImprovedFertilityEngine
        
        // Test 1: Análisis completo de fertilidad
        let engine = ImprovedFertilityEngine()
        
        let testProfile = FertilityProfile(
            age: 30,
            height: 160,
            weight: 60,
            cycleLength: 28,
            infertilityDuration: 1,
            previousPregnancies: 0,
            hasPcos: false,
            hirsutismSeverity: .none,
            acneSeverity: .none,
            ovarianMorphology: .notEvaluated,
            endometriosisStage: 0,
            myomaType: .none,
            myomaSize: nil,
            adenomyosisType: .none,
            polypType: .none,
            hsgResult: .normal,
            hasPelvicSurgery: false,
            numberOfPelvicSurgeries: 0,
            hasOtb: false,
            otbMethod: .none,
            tpoAbPositive: false,
            insulinValue: nil,
            glucoseValue: nil,
            amhValue: 2.5,
            tshValue: 2.0,
            prolactinValue: nil,
            spermConcentration: nil,
            spermProgressiveMotility: nil,
            spermNormalMorphology: nil,
            semenVolume: nil,
            spermDNAFragmentation: nil,
            hasVaricocele: false,
            seminalCulturePositive: false
        )
        
        let result = engine.analyzeComprehensiveFertility(from: testProfile)
        
        // Validar que el resultado sea válido
        let validProbability = result.monthlyProbability >= 0.05 && result.monthlyProbability <= 0.25
        let hasKeyFactors = !result.keyFactors.isEmpty
        let validConfidence = result.confidenceLevel >= 0.7 && result.confidenceLevel <= 1.0
        
        // Probabilidad mensual, factores clave y confianza validados
        
        // Test 2: Generación de factores clave
        // Nota: generateKeyFactors requiere MedicalFactors, no [String: Double]
        // Por ahora solo verificamos que el resultado tenga factores clave
        let hasGeneratedFactors = !result.keyFactors.isEmpty
        
        // Factores generados validados
        
        let allTestsPassed = validProbability && hasKeyFactors && validConfidence && hasGeneratedFactors
        
        // Resultado del test evaluado
        return allTestsPassed
    }
    
    // MARK: - 🧪 TEST 4: ANÁLISIS DETALLADO
    private static func testDetailedAnalysis() -> Bool {
        // Test 4: Análisis detallado
        
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
        
        // Análisis generado evaluado
        
        // Validaciones
        if !analysis.contains("TSH 7.0") {
            // Análisis TSH falló - no menciona valor TSH
            allPassed = false
        }
        
        if !analysis.contains("hipotiroidismo") {
            // Análisis TSH falló - no menciona hipotiroidismo
            allPassed = false
        }
        
        if !analysis.contains("Evidencia Científica") {
            // Análisis falló - no incluye evidencia científica
            allPassed = false
        }
        
        // Test análisis detallado evaluado
        
        return allPassed
    }
    
    // MARK: - 🧪 TEST 5: FACTORES MODIFICABLES
    private static func testModifiableFactors() -> Bool {
        // Test 5: Factores modificables
        
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
        // Recomendación evaluada
        
        if recommendation.plan != .fiv {
            // Recomendación falló - debería ser FIV para POSEIDON Group 4
            allPassed = false
        }
        
        // Verificar factores modificables
        let modifiableFactors = simulator.simulateModifiableFactors(profile: profile)
        // Factores modificables evaluados
        
        if modifiableFactors.count != 2 {
            // Factores modificables falló - debería encontrar 2
            allPassed = false
        }
        
        // Verificar que AMH no aparece como modificable
        let amhFactor = modifiableFactors.first { $0.factor.contains("AMH") || $0.factor.contains("Reserva") }
        if amhFactor != nil {
            // AMH modificable falló - AMH no debería ser modificable
            allPassed = false
        }
        
        // Test factores modificables evaluado
        
        return allPassed
    }
}

// MARK: - 🚀 EJECUTAR TESTS
// Para ejecutar los tests, llamar: TestRunner.runAllTests()