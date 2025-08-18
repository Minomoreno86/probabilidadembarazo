//
//  Pronostico_fertilidadTests.swift
//  Pronostico fertilidadTests
//
//  Created by Jorge Vasquez rodriguez on 11/08/2025.
//

import Testing
@testable import Pronostico_fertilidad
import Foundation

struct Pronostico_fertilidadTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

    @Test func testAnalysis_Age30_TSH7() async throws {
        // Perfil con 30 años y TSH = 7.0
        let profile = FertilityProfile(
            age: 30,
            height: 165,
            weight: 65,
            tshValue: 7.0
        )
        let engine = ImprovedFertilityEngine()
        let result = engine.analyzeComprehensiveFertility(from: profile)
        let analysis = result.detailedAnalysis
        
        // Imprimir para inspección visual en logs de test
        print("\n===== ANÁLISIS CON EDAD 30 Y TSH 7.0 =====")
        print(analysis)
        print("==========================================\n")
        
        // Validaciones
        #expect(analysis.contains("TSH 7.0"))
        #expect(analysis.contains("hipotiroidismo"))
        #expect(analysis.contains("corrección"))
        #expect(analysis.contains("Evidencia Científica"))
    }

    @Test func testAnalysis_Age30_HOMA4() async throws {
        // Perfil con 30 años y HOMA-IR = 4.0
        let profile = FertilityProfile(
            age: 30,
            height: 165,
            weight: 65,
            insulinValue: 20.0,
            glucoseValue: 100.0
        )
        // HOMA-IR = (20 * 100) / 405 = 4.94
        let engine = ImprovedFertilityEngine()
        let result = engine.analyzeComprehensiveFertility(from: profile)
        let analysis = result.detailedAnalysis
        
        // Imprimir para inspección visual en logs de test
        print("\n===== ANÁLISIS CON EDAD 30 Y HOMA-IR 4.94 =====")
        print(analysis)
        print("===============================================\n")
        
        // Validaciones
        #expect(analysis.contains("HOMA-IR"))
        #expect(analysis.contains("resistencia a la insulina"))
        #expect(analysis.contains("corrección"))
        #expect(analysis.contains("metformina"))
        #expect(analysis.contains("Evidencia Científica"))
    }

    @Test func testAnalysis_Age30_AMH05() async throws {
        // Perfil con 30 años y AMH = 0.5
        let profile = FertilityProfile(
            age: 30,
            height: 165,
            weight: 65,
            amhValue: 0.5
        )
        let engine = ImprovedFertilityEngine()
        let result = engine.analyzeComprehensiveFertility(from: profile)
        let analysis = result.detailedAnalysis
        
        // Imprimir para inspección visual en logs de test
        print("\n===== ANÁLISIS CON EDAD 30 Y AMH 0.5 =====")
        print(analysis)
        print("==========================================\n")
        
        // Validaciones
        #expect(analysis.contains("AMH"))
        #expect(analysis.contains("reserva ovárica"))
        #expect(analysis.contains("baja"))
        #expect(analysis.contains("evaluación"))
        #expect(analysis.contains("Evidencia Científica"))
    }

    @Test func testAnalysis_Age30_BMI38() async throws {
        // Perfil con 30 años y IMC = 38 (obesidad tipo 2)
        let profile = FertilityProfile(
            age: 30,
            height: 165,
            weight: 103.5  // IMC = 103.5 / (1.65²) = 38.0
        )
        let engine = ImprovedFertilityEngine()
        let result = engine.analyzeComprehensiveFertility(from: profile)
        let analysis = result.detailedAnalysis
        
        // Imprimir para inspección visual en logs de test
        print("\n===== ANÁLISIS CON EDAD 30 Y IMC 38.0 =====")
        print(analysis)
        print("==========================================\n")
        
        // Validaciones
        #expect(analysis.contains("IMC"))
        #expect(analysis.contains("obesidad tipo 2"))
        #expect(analysis.contains("corrección"))
        #expect(analysis.contains("crítica"))
        #expect(analysis.contains("Evidencia Científica"))
    }

    @Test func testAnalysis_Age30_Cycle60() async throws {
        // Perfil con 30 años y ciclo de 60 días (oligomenorrea severa)
        let profile = FertilityProfile(
            age: 30,
            height: 165,
            weight: 65,
            cycleLength: 60
        )
        let engine = ImprovedFertilityEngine()
        let result = engine.analyzeComprehensiveFertility(from: profile)
        let analysis = result.detailedAnalysis
        
        // Imprimir para inspección visual en logs de test
        print("\n===== ANÁLISIS CON EDAD 30 Y CICLO 60 DÍAS =====")
        print(analysis)
        print("===============================================\n")
        
        // Validaciones
        #expect(analysis.contains("Duración del Ciclo"))
        #expect(analysis.contains("oligomenorrea severa"))
        #expect(analysis.contains("corrección"))
        #expect(analysis.contains("crítica"))
        #expect(analysis.contains("Evidencia Científica"))
    }

    // MARK: - 🧪 TEST SIMULADOR FACTORES MODIFICABLES
    
    func testTreatmentSimulator_ModifiableFactors() throws {
        // Crear perfil con datos específicos del usuario
        let profile = FertilityProfile()
        profile.age = 22.0
        profile.amhValue = 0.5  // No modificable
        profile.tshValue = 7.0  // Modificable
        profile.myomaType = .intramural
        profile.myomaSize = 4.0  // Modificable
        profile.bmi = 22.0  // Normal
        
        let simulator = TreatmentSimulator()
        
        // 1. Verificar recomendación de tratamiento
        let recommendation = simulator.determineOptimalTreatment(profile: profile)
        
        // Debería recomendar FIV por POSEIDON Group 4 (joven con baja reserva)
        XCTAssertEqual(recommendation.plan, .fiv, "Debería recomendar FIV para POSEIDON Group 4")
        XCTAssertTrue(recommendation.rationale.contains("POSEIDON Group 4"), "Debería incluir clasificación POSEIDON")
        
        // 2. Verificar factores modificables
        let modifiableFactors = simulator.simulateModifiableFactors(profile: profile)
        
        // Debería encontrar 2 factores modificables: TSH y Mioma
        XCTAssertEqual(modifiableFactors.count, 2, "Debería encontrar 2 factores modificables")
        
        // Verificar TSH
        let tshFactor = modifiableFactors.first { $0.factor.contains("TSH") }
        XCTAssertNotNil(tshFactor, "Debería incluir factor TSH")
        XCTAssertTrue(tshFactor?.recommendation.contains("Levotiroxina") ?? false, "Debería recomendar Levotiroxina")
        
        // Verificar Mioma
        let myomaFactor = modifiableFactors.first { $0.factor.contains("Mioma") }
        XCTAssertNotNil(myomaFactor, "Debería incluir factor Mioma")
        XCTAssertTrue(myomaFactor?.recommendation.contains("Laparoscopia") ?? false, "Debería recomendar cirugía")
        
        // 3. Verificar que AMH no aparece como modificable
        let amhFactor = modifiableFactors.first { $0.factor.contains("AMH") || $0.factor.contains("Reserva") }
        XCTAssertNil(amhFactor, "AMH no debería aparecer como factor modificable")
        
        print("✅ Test simulador factores modificables: PASÓ")
        print("📊 Factores modificables encontrados: \(modifiableFactors.count)")
        print("🎯 Recomendación: \(recommendation.plan)")
        print("📝 Razonamiento: \(recommendation.rationale.joined(separator: ", "))")
    }
}
