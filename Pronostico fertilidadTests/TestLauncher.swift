//
//  TestLauncher.swift
//  Pronostico fertilidadTests
//
//  Created by Jorge Vasquez rodriguez on 11/08/2025.
//

@testable import Pronostico_fertilidad
import Foundation

// MARK: - 🚀 LANZADOR PRINCIPAL DE TESTS
public struct TestLauncher {
    
    /// Ejecuta todos los tests disponibles
    public static func runAllTests() {
        print("\n" + "=".repeating(60))
        print("🧪 SISTEMA DE TESTING - PRONÓSTICO FERTILIDAD")
        print("=".repeating(60))
        
        let startTime = Date()
        
        // Ejecutar tests unitarios
        print("\n📋 EJECUTANDO TESTS UNITARIOS...")
        TestRunner.runAllTests()
        
        // Ejecutar tests de integración
        print("\n📋 EJECUTANDO TESTS DE INTEGRACIÓN...")
        IntegrationTestRunner.runIntegrationTests()
        
        // Ejecutar tests de rendimiento
        print("\n📋 EJECUTANDO TESTS DE RENDIMIENTO...")
        PerformanceTestRunner.runPerformanceTests()
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        print("\n" + "=".repeating(60))
        print("🏁 EJECUCIÓN COMPLETADA")
        print("⏱️  Tiempo total: \(String(format: "%.2f", duration)) segundos")
        print("=".repeating(60))
    }
    
    /// Ejecuta solo tests unitarios
    public static func runUnitTests() {
        print("\n🧪 EJECUTANDO SOLO TESTS UNITARIOS...")
        TestRunner.runAllTests()
    }
    
    /// Ejecuta solo tests de integración
    public static func runIntegrationTests() {
        print("\n🔗 EJECUTANDO SOLO TESTS DE INTEGRACIÓN...")
        IntegrationTestRunner.runIntegrationTests()
    }
    
    /// Ejecuta solo tests de rendimiento
    public static func runPerformanceTests() {
        print("\n⚡ EJECUTANDO SOLO TESTS DE RENDIMIENTO...")
        PerformanceTestRunner.runPerformanceTests()
    }
}

// MARK: - ⚡ TESTS DE RENDIMIENTO
struct PerformanceTestRunner {
    
    static func runPerformanceTests() {
        print("\n⚡ INICIANDO TESTS DE RENDIMIENTO...")
        print("=====================================")
        
        var passedTests = 0
        var totalTests = 0
        
        // Test 1: Rendimiento del motor principal
        if testEnginePerformance() { passedTests += 1 }
        totalTests += 1
        
        // Test 2: Rendimiento del simulador
        if testSimulatorPerformance() { passedTests += 1 }
        totalTests += 1
        
        // Test 3: Rendimiento de cálculos
        if testCalculationsPerformance() { passedTests += 1 }
        totalTests += 1
        
        print("\n📊 RESUMEN DE TESTS DE RENDIMIENTO:")
        print("✅ Tests pasados: \(passedTests)")
        print("❌ Tests fallidos: \(totalTests - passedTests)")
        print("📈 Porcentaje de éxito: \(Int((Double(passedTests) / Double(totalTests)) * 100))%")
        print("=====================================")
    }
    
    // MARK: - ⚡ TEST 1: RENDIMIENTO DEL MOTOR
    private static func testEnginePerformance() -> Bool {
        print("\n⚡ TEST 1: RENDIMIENTO DEL MOTOR")
        print("---------------------------------")
        
        let engine = ImprovedFertilityEngine()
        let iterations = 100
        
        let startTime = Date()
        
        for i in 0..<iterations {
            let profile = FertilityProfile(
                age: Double(25 + (i % 20)),  // Edades variadas
                height: Double(160 + (i % 20)),
                weight: Double(55 + (i % 30))
            )
            
            // Establecer valores después de la inicialización
            profile.tshValue = 2.0 + Double(i % 10)
            profile.amhValue = 0.5 + Double(i % 5)
            
            let _ = engine.analyzeComprehensiveFertility(from: profile)
        }
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        let avgTime = duration / Double(iterations)
        
        print("📊 Rendimiento del motor:")
        print("   • Iteraciones: \(iterations)")
        print("   • Tiempo total: \(String(format: "%.3f", duration))s")
        print("   • Tiempo promedio: \(String(format: "%.3f", avgTime * 1000))ms")
        
        // Criterio de rendimiento: menos de 10ms por análisis
        let passed = avgTime < 0.01
        
        if passed {
            print("✅ Test rendimiento del motor: PASÓ")
        } else {
            print("❌ Test rendimiento del motor: FALLÓ - muy lento")
        }
        
        return passed
    }
    
    // MARK: - ⚡ TEST 2: RENDIMIENTO DEL SIMULADOR
    private static func testSimulatorPerformance() -> Bool {
        print("\n⚡ TEST 2: RENDIMIENTO DEL SIMULADOR")
        print("-------------------------------------")
        
        let simulator = TreatmentSimulator()
        let iterations = 50
        
        let startTime = Date()
        
        for i in 0..<iterations {
            let profile = FertilityProfile(
                age: Double(25 + (i % 20)),
                height: 165.0,
                weight: 65.0
            )
            
            // Establecer valores después de la inicialización
            profile.tshValue = 5.0 + Double(i % 10)
            profile.amhValue = 0.5 + Double(i % 5)
            
            let _ = simulator.determineOptimalTreatment(profile: profile)
            let _ = simulator.simulateModifiableFactors(profile: profile)
            let _ = simulator.simulateFactorCorrection(profile: profile)
        }
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        let avgTime = duration / Double(iterations)
        
        print("📊 Rendimiento del simulador:")
        print("   • Iteraciones: \(iterations)")
        print("   • Tiempo total: \(String(format: "%.3f", duration))s")
        print("   • Tiempo promedio: \(String(format: "%.3f", avgTime * 1000))ms")
        
        // Criterio de rendimiento: menos de 20ms por simulación completa
        let passed = avgTime < 0.02
        
        if passed {
            print("✅ Test rendimiento del simulador: PASÓ")
        } else {
            print("❌ Test rendimiento del simulador: FALLÓ - muy lento")
        }
        
        return passed
    }
    
    // MARK: - ⚡ TEST 3: RENDIMIENTO DE CÁLCULOS
    private static func testCalculationsPerformance() -> Bool {
        print("\n⚡ TEST 3: RENDIMIENTO DE CÁLCULOS")
        print("-----------------------------------")
        
        let iterations = 1000
        
        let startTime = Date()
        
        for i in 0..<iterations {
            let age = Double(18 + (i % 28))  // Edades 18-45
            let bmi = 18.0 + Double(i % 25)  // IMC 18-43
            let tsh = 0.1 + Double(i % 20)  // TSH 0.1-20.0
            
            let _ = FertilityCalculations.calculateAgeFactor(age)
            let _ = FertilityCalculations.calculateBMIFactor(bmi)
            let _ = FertilityCalculations.calculateTSHFactor(tsh)
        }
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        let avgTime = duration / Double(iterations)
        
        print("📊 Rendimiento de cálculos:")
        print("   • Iteraciones: \(iterations)")
        print("   • Tiempo total: \(String(format: "%.3f", duration))s")
        print("   • Tiempo promedio: \(String(format: "%.6f", avgTime * 1000000))μs")
        
        // Criterio de rendimiento: menos de 1μs por cálculo
        let passed = avgTime < 0.000001
        
        if passed {
            print("✅ Test rendimiento de cálculos: PASÓ")
        } else {
            print("❌ Test rendimiento de cálculos: FALLÓ - muy lento")
        }
        
        return passed
    }
}

// MARK: - 🔧 EXTENSIONES DE UTILIDAD
extension String {
    func repeating(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }
}

// MARK: - 📱 INTEGRACIÓN CON LA APLICACIÓN
// Para ejecutar tests desde la aplicación principal, agregar en ContentView:
// Button("🧪 Ejecutar Tests") {
//     TestLauncher.runAllTests()
// }
