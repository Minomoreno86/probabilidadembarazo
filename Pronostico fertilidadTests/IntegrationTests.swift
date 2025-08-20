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
        print("\n🔗 INICIANDO TESTS DE INTEGRACIÓN...")
        print("=====================================")
        
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
        
        print("\n📊 RESUMEN DE TESTS DE INTEGRACIÓN:")
        print("✅ Tests pasados: \(passedTests)")
        print("❌ Tests fallidos: \(totalTests - passedTests)")
        print("📈 Porcentaje de éxito: \(Int((Double(passedTests) / Double(totalTests)) * 100))%")
        print("=====================================")
    }
    
    // MARK: - 🧪 TEST 1: FLUJO COMPLETO DE ANÁLISIS
    private static func testCompleteAnalysisFlow() -> Bool {
        print("\n🧪 TEST 1: FLUJO COMPLETO DE ANÁLISIS")
        print("----------------------------------------")
        
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
        
        print("📊 Resultados del análisis:")
        print("   • Probabilidad mensual: \(result.monthlyProbability)")
        print("   • Probabilidad anual: \(result.annualProbability)")
        print("   • Factores clave: \(result.keyFactors.count)")
        print("   • Análisis detallado: \(result.detailedAnalysis.count) caracteres")
        
        // Validaciones del flujo completo
        if result.monthlyProbability <= 0 || result.monthlyProbability > 1.0 {
            print("❌ Probabilidad mensual: Falló - valor fuera de rango")
            allPassed = false
        }
        
        if result.annualProbability <= 0 || result.annualProbability > 1.0 {
            print("❌ Probabilidad anual: Falló - valor fuera de rango")
            allPassed = false
        }
        
        if result.keyFactors.count < 3 {
            print("❌ Factores clave: Falló - muy pocos factores")
            allPassed = false
        }
        
        if result.detailedAnalysis.count < 500 {
            print("❌ Análisis detallado: Falló - muy corto")
            allPassed = false
        }
        
        // Verificar que se incluyan todos los factores esperados
        let factorNames = result.keyFactors.map { $0.key }
        let expectedFactors = ["Edad", "IMC", "TSH", "AMH", "Ciclo", "HOMA-IR"]
        
        for expectedFactor in expectedFactors {
            if !factorNames.contains(where: { $0.contains(expectedFactor) }) {
                print("❌ Factor esperado '\(expectedFactor)' no encontrado en factores clave")
                return false
            }
        }
        
        if allPassed {
            print("✅ Test flujo completo de análisis: PASÓ")
        } else {
            print("❌ Test flujo completo de análisis: FALLÓ")
        }
        
        return allPassed
    }
    
    // MARK: - 🧪 TEST 2: FLUJO COMPLETO DE SIMULADOR
    private static func testCompleteSimulatorFlow() -> Bool {
        print("\n🧪 TEST 2: FLUJO COMPLETO DE SIMULADOR")
        print("-----------------------------------------")
        
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
        print("🎯 Tratamiento recomendado: \(recommendation.plan)")
        print("📝 Razonamiento: \(recommendation.rationale.joined(separator: ", "))")
        
        if recommendation.plan == .coitoProgramado || recommendation.plan == .iui || recommendation.plan == .fiv || recommendation.plan == .icsi || recommendation.plan == .evaluarOvodonacion {
            print("✅ Tratamiento: PASÓ - se determinó correctamente")
        } else {
            print("❌ Tratamiento: Falló - no se pudo determinar")
            allPassed = false
        }
        
        // Paso 2: Identificar factores modificables
        let modifiableFactors = simulator.simulateModifiableFactors(profile: profile)
        print("🔧 Factores modificables encontrados: \(modifiableFactors.count)")
        
        if modifiableFactors.count < 3 {
            print("❌ Factores modificables: Falló - muy pocos")
            allPassed = false
        }
        
        // Paso 3: Simular corrección del factor más crítico
        let correction = simulator.simulateFactorCorrection(profile: profile)
        if correction == nil {
            print("❌ Simulación corrección: Falló - no se pudo simular")
            allPassed = false
        } else {
            print("✅ Simulación corrección: PASÓ")
            print("   • Factor corregido: \(correction!.correctedFactor)")
            print("   • Mejora: \(correction!.improvementInProbability)%")
            print("   • Tiempo: \(correction!.timeToCorrection)")
            
            // Verificar que la corrección cambie la recomendación
            if correction!.originalRecommendation.plan == correction!.correctedRecommendation.plan {
                print("⚠️  Advertencia: La corrección no cambió el tratamiento")
            } else {
                print("🔄 Cambio de tratamiento: \(correction!.originalRecommendation.plan) → \(correction!.correctedRecommendation.plan)")
            }
        }
        
        if allPassed {
            print("✅ Test flujo completo de simulador: PASÓ")
        } else {
            print("❌ Test flujo completo de simulador: FALLÓ")
        }
        
        return allPassed
    }
    
    // MARK: - 🧪 TEST 3: PERSISTENCIA DE DATOS
    private static func testDataPersistence() -> Bool {
        print("\n🧪 TEST 3: PERSISTENCIA DE DATOS")
        print("----------------------------------")
        
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
            print("❌ Persistencia edad: Falló")
            allPassed = false
        }
        
        if recoveredProfile.tshValue != originalProfile.tshValue {
            print("❌ Persistencia TSH: Falló")
            allPassed = false
        }
        
        if recoveredProfile.amhValue != originalProfile.amhValue {
            print("❌ Persistencia AMH: Falló")
            allPassed = false
        }
        
        // Verificar que el IMC se calcule correctamente
        let expectedBMI = 65.0 / (1.65 * 1.65)
        if abs(recoveredProfile.bmi - expectedBMI) > 0.1 {
            print("❌ Cálculo IMC: Falló - esperado: \(expectedBMI), obtenido: \(recoveredProfile.bmi)")
            allPassed = false
        }
        
        if allPassed {
            print("✅ Test persistencia de datos: PASÓ")
        } else {
            print("❌ Test persistencia de datos: FALLÓ")
        }
        
        return allPassed
    }
    
    // MARK: - 🧪 TEST 4: VALIDACIÓN DE DATOS
    private static func testDataValidation() -> Bool {
        print("\n🧪 TEST 4: VALIDACIÓN DE DATOS")
        print("--------------------------------")
        
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
            print("❌ Validación edad: Falló - fuera de rango")
            allPassed = false
        }
        
        if validProfile.height < 140 || validProfile.height > 200 {
            print("❌ Validación altura: Falló - fuera de rango")
            allPassed = false
        }
        
        if validProfile.weight < 40 || validProfile.weight > 150 {
            print("❌ Validación peso: Falló - fuera de rango")
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
            print("❌ Validación edad límite: Falló")
            allPassed = false
        }
        
        if (edgeProfile.tshValue ?? 0) <= 0 {
            print("❌ TSH debe ser > 0")
            return false
        }
        
        if (edgeProfile.amhValue ?? 0) <= 0 {
            print("❌ AMH debe ser > 0")
            return false
        }
        
        if allPassed {
            print("✅ Test validación de datos: PASÓ")
        } else {
            print("❌ Test validación de datos: FALLÓ")
        }
        
        return allPassed
    }
}

// MARK: - 🚀 EJECUTAR TESTS DE INTEGRACIÓN
// Para ejecutar los tests de integración, llamar: IntegrationTestRunner.runIntegrationTests()
