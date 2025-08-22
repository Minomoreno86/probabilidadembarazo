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
        // Sistema de testing iniciado
        
        let startTime = Date()
        
        // Ejecutar tests unitarios
        // Ejecutando tests unitarios
        TestRunner.runAllTests()
        
        // Ejecutar tests de integración
        // Ejecutando tests de integración
        IntegrationTestRunner.runIntegrationTests()
        
        // Ejecutar tests de rendimiento
        // Ejecutando tests de rendimiento
        PerformanceTestRunner.runPerformanceTests()
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        // Ejecución completada
    }
    
    /// Ejecuta solo tests unitarios
    public static func runUnitTests() {
        // Ejecutando solo tests unitarios
        TestRunner.runAllTests()
    }
    
    /// Ejecuta solo tests de integración
    public static func runIntegrationTests() {
        // Ejecutando solo tests de integración
        IntegrationTestRunner.runIntegrationTests()
    }
    
    /// Ejecuta solo tests de rendimiento
    public static func runPerformanceTests() {
        // Ejecutando solo tests de rendimiento
        PerformanceTestRunner.runPerformanceTests()
    }
}

// MARK: - ⚡ TESTS DE RENDIMIENTO
struct PerformanceTestRunner {
    
    static func runPerformanceTests() {
        // Iniciando tests de rendimiento
        
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
        
        // Resumen de tests de rendimiento completado
    }
    
    // MARK: - ⚡ TEST 1: RENDIMIENTO DEL MOTOR
    private static func testEnginePerformance() -> Bool {
        // Test 1: Rendimiento del motor
        
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
        
        // Rendimiento del motor medido
        
        // Criterio de rendimiento: menos de 10ms por análisis
        let passed = avgTime < 0.01
        
        // Resultado del test evaluado
        
        return passed
    }
    
    // MARK: - ⚡ TEST 2: RENDIMIENTO DEL SIMULADOR
    private static func testSimulatorPerformance() -> Bool {
        // Test 2: Rendimiento del simulador
        
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
        
        // Rendimiento del simulador medido
        
        // Criterio de rendimiento: menos de 20ms por simulación completa
        let passed = avgTime < 0.02
        
        // Resultado del test evaluado
        
        return passed
    }
    
    // MARK: - ⚡ TEST 3: RENDIMIENTO DE CÁLCULOS
    private static func testCalculationsPerformance() -> Bool {
        // Test 3: Rendimiento de cálculos
        
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
        
        // Rendimiento de cálculos medido
        
        // Criterio de rendimiento: menos de 1μs por cálculo
        let passed = avgTime < 0.000001
        
        // Resultado del test evaluado
        
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
