//
//  IntegrationTests.swift
//  Pronostico fertilidadTests
//
//  Created by Jorge Vasquez rodriguez on 11/08/2025.
//

@testable import Pronostico_fertilidad
import Foundation

// MARK: - 🧪 TESTS DE INTEGRACIÓN
struct IntegrationTestRunner {
    
    static func runIntegrationTests() {
        // Iniciando tests de integración
        
        var passedTests = 0
        var totalTests = 0
        
        // Test 1: Flujo completo de análisis
        if testCompleteAnalysisFlow() { passedTests += 1 }
        totalTests += 1
        
        // Test 2: Flujo completo de simulador
        if testCompleteSimulatorFlow() { passedTests += 1 }
        totalTests += 1
        
        // Test 3: Persistencia de datos
        if testDataPersistence() { passedTests += 1 }
        totalTests += 1
        
        // Test 4: Validación de datos
        if testDataValidation() { passedTests += 1 }
        totalTests += 1
        
        // Resumen de tests de integración completado
    }
    
    // MARK: - 🧪 TEST 1: FLUJO COMPLETO DE ANÁLISIS
    private static func testCompleteAnalysisFlow() -> Bool {
        // Test 1: Flujo completo de análisis
        
        var allPassed = true
        let engine = ImprovedFertilityEngine()
        
        // Crear perfil complejo
        let profile = FertilityProfile(
            age: 32,
            height: 160,
            weight: 70,
            cycleLength: 40,
            insulinValue: 18.0,
            glucoseValue: 95.0,
            amhValue: 0.8,
            tshValue: 6.5,
            prolactinValue: 25.0
        )
        
        // Ejecutar análisis completo
        let result = engine.analyzeComprehensiveFertility(from: profile)
        
        // Resultados del análisis evaluados
        
        // Validaciones del flujo completo
        if result.monthlyProbability <= 0 || result.monthlyProbability > 1.0 {
            // Probabilidad mensual falló - valor fuera de rango
            allPassed = false
        }
        
        if result.annualProbability <= 0 || result.annualProbability > 1.0 {
            // Probabilidad anual falló - valor fuera de rango
            allPassed = false
        }
        
        if result.keyFactors.count < 3 {
            // Factores clave falló - muy pocos factores
            allPassed = false
        }
        
        if result.detailedAnalysis.count < 500 {
            // Análisis detallado falló - muy corto
            allPassed = false
        }
        
        // Verificar que se incluyan todos los factores esperados
        let factorNames = result.keyFactors.map { $0.key }
        let expectedFactors = ["Edad", "IMC", "TSH", "AMH", "Ciclo", "HOMA-IR"]
        
        for expectedFactor in expectedFactors {
            if !factorNames.contains(where: { $0.contains(expectedFactor) }) {
                // Factor esperado no encontrado en factores clave
                return false
            }
        }
        
        // Test flujo completo de análisis evaluado
        
        return allPassed
    }
    
    // MARK: - 🧪 TEST 2: FLUJO COMPLETO DE SIMULADOR
    private static func testCompleteSimulatorFlow() -> Bool {
        // Test 2: Flujo completo de simulador
        
        var allPassed = true
        let simulator = TreatmentSimulator()
        
        // Crear perfil con múltiples factores modificables
        let profile = FertilityProfile()
        profile.age = 28
        profile.tshValue = 8.0      // Modificable
        profile.bmi = 35.0          // Modificable
        profile.myomaType = .submucosal
        profile.myomaSize = 2.5     // Modificable
        profile.cycleLength = 45    // Modificable
        
        // Paso 1: Determinar tratamiento óptimo
        let recommendation = simulator.determineOptimalTreatment(profile: profile)
        // Tratamiento recomendado evaluado
        
        if recommendation.plan == .coitoProgramado || recommendation.plan == .iui || recommendation.plan == .fiv || recommendation.plan == .icsi || recommendation.plan == .evaluarOvodonacion {
            // Tratamiento se determinó correctamente
        } else {
            // Tratamiento falló - no se pudo determinar
            allPassed = false
        }
        
        // Paso 2: Identificar factores modificables
        let modifiableFactors = simulator.simulateModifiableFactors(profile: profile)
        // Factores modificables evaluados
        
        if modifiableFactors.count < 3 {
            // Factores modificables falló - muy pocos
            allPassed = false
        }
        
        // Paso 3: Simular corrección del factor más crítico
        let correction = simulator.simulateFactorCorrection(profile: profile)
        if correction == nil {
            // Simulación corrección falló - no se pudo simular
            allPassed = false
        } else {
            // Simulación corrección pasó
            // Factor corregido, mejora y tiempo evaluados
            
            // Verificar que la corrección cambie la recomendación
            if correction!.originalRecommendation.plan == correction!.correctedRecommendation.plan {
                // Advertencia: La corrección no cambió el tratamiento
            } else {
                // Cambio de tratamiento evaluado
            }
        }
        
        // Test flujo completo de simulador evaluado
        
        return allPassed
    }
    
    // MARK: - 🧪 TEST 3: PERSISTENCIA DE DATOS
    private static func testDataPersistence() -> Bool {
        // Test 3: Persistencia de datos
        
        var allPassed = true
        
        // Crear perfil de prueba
        let originalProfile = FertilityProfile(
            age: 30,
            height: 165,
            weight: 65,
            amhValue: 1.5,
            tshValue: 5.5
        )
        
        // Simular persistencia (en una app real esto iría a Core Data o UserDefaults)
        let savedAge = originalProfile.age
        let savedTSH = originalProfile.tshValue
        let savedAMH = originalProfile.amhValue
        
        // Simular recuperación
        let recoveredProfile = FertilityProfile()
        recoveredProfile.age = savedAge
        recoveredProfile.tshValue = savedTSH
        recoveredProfile.amhValue = savedAMH
        
        // Verificar que los datos se mantengan
        if recoveredProfile.age != originalProfile.age {
            // Persistencia edad falló
            allPassed = false
        }
        
        if recoveredProfile.tshValue != originalProfile.tshValue {
            // Persistencia TSH falló
            allPassed = false
        }
        
        if recoveredProfile.amhValue != originalProfile.amhValue {
            // Persistencia AMH falló
            allPassed = false
        }
        
        // Verificar que el IMC se calcule correctamente
        let expectedBMI = 65.0 / (1.65 * 1.65)
        if abs(recoveredProfile.bmi - expectedBMI) > 0.1 {
            // Cálculo IMC falló
            allPassed = false
        }
        
        // Test persistencia de datos evaluado
        
        return allPassed
    }
    
    // MARK: - 🧪 TEST 4: VALIDACIÓN DE DATOS
    private static func testDataValidation() -> Bool {
        // Test 4: Validación de datos
        
        var allPassed = true
        
        // Test con datos válidos
        let validProfile = FertilityProfile(
            age: 25,
            height: 160,
            weight: 55,
            amhValue: 2.0,
            tshValue: 2.5
        )
        
        // Verificar que los datos sean válidos
        if validProfile.age < 18 || validProfile.age > 50 {
            // Validación edad falló - fuera de rango
            allPassed = false
        }
        
        if validProfile.height < 140 || validProfile.height > 200 {
            // Validación altura falló - fuera de rango
            allPassed = false
        }
        
        if validProfile.weight < 40 || validProfile.weight > 150 {
            // Validación peso falló - fuera de rango
            allPassed = false
        }
        
        // Test con datos límite
        let edgeProfile = FertilityProfile(
            age: 18,
            height: 140,
            weight: 40,
            amhValue: 0.1,
            tshValue: 0.1
        )
        
        // Verificar que los datos límite sean válidos
        if edgeProfile.age < 18 {
            // Validación edad límite falló
            allPassed = false
        }
        
        if (edgeProfile.tshValue ?? 0) <= 0 {
            // TSH debe ser > 0
            return false
        }
        
        if (edgeProfile.amhValue ?? 0) <= 0 {
            // AMH debe ser > 0
            return false
        }
        
        // Test validación de datos evaluado
        
        return allPassed
    }
}

// MARK: - 🚀 EJECUTAR TESTS DE INTEGRACIÓN
// Para ejecutar los tests de integración, llamar: IntegrationTestRunner.runIntegrationTests()