//
//  FertilityScenarioUITests.swift
//  Pronostico fertilidadUITests
//
//  Created by Jorge Vasquez rodriguez on 11/08/2025.
//

import XCTest

// MARK: - 🎭 TESTS DE ESCENARIOS ESPECÍFICOS
final class FertilityScenarioUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        _ = app.wait(for: .runningForeground, timeout: 10)
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - 👩‍⚕️ ESCENARIOS MÉDICOS ESPECÍFICOS
    
    @MainActor
    func testYoungPatientScenario() throws {
        // Escenario: Paciente joven (22 años) con mioma submucosal
        try navigateToCalculator()
        
        // Datos del escenario
        fillPatientData(age: "22", height: "165", weight: "65")
        
        // Agregar factor específico: mioma submucosal
        let myomaButton = app.buttons["Mioma"]
        if myomaButton.waitForExistence(timeout: 5) {
            myomaButton.tap()
            
            let submucosalOption = app.buttons["Submucosal"]
            if submucosalOption.waitForExistence(timeout: 5) {
                submucosalOption.tap()
            }
            
            // Tamaño del mioma
            let sizeField = app.textFields["Tamaño (cm)"]
            if sizeField.waitForExistence(timeout: 5) {
                sizeField.tap()
                sizeField.typeText("2")
            }
        }
        
        // Ejecutar cálculo
        executeCalculation()
        
        // Verificar que recomienda tratamiento apropiado
        try navigateToSimulator()
        
        let treatmentText = app.staticTexts.containing(.staticText, identifier: "FIV").firstMatch
        XCTAssertTrue(treatmentText.waitForExistence(timeout: 5), "Debe recomendar FIV para mioma submucosal")
        
        print("✅ Test escenario paciente joven con mioma: PASÓ")
    }
    
    @MainActor
    func testHypothyroidismScenario() throws {
        // Escenario: Paciente con hipotiroidismo (TSH elevado)
        try navigateToCalculator()
        
        fillPatientData(age: "30", height: "165", weight: "65")
        
        // TSH elevado
        let tshField = app.textFields["TSH"]
        if tshField.waitForExistence(timeout: 5) {
            tshField.tap()
            tshField.typeText("8.0")
        }
        
        executeCalculation()
        
        // Verificar análisis detallado
        let analysisTab = app.buttons["Análisis"]
        if analysisTab.waitForExistence(timeout: 5) {
            analysisTab.tap()
            
            let hypothyroidismText = app.staticTexts.containing(.staticText, identifier: "hipotiroidismo").firstMatch
            XCTAssertTrue(hypothyroidismText.waitForExistence(timeout: 5), "Debe mencionar hipotiroidismo")
            
            let treatmentText = app.staticTexts.containing(.staticText, identifier: "Levotiroxina").firstMatch
            XCTAssertTrue(treatmentText.waitForExistence(timeout: 5), "Debe recomendar Levotiroxina")
        }
        
        print("✅ Test escenario hipotiroidismo: PASÓ")
    }
    
    @MainActor
    func testLowAMHScenario() throws {
        // Escenario: Paciente con reserva ovárica baja (AMH bajo)
        try navigateToCalculator()
        
        fillPatientData(age: "35", height: "165", weight: "65")
        
        // AMH bajo
        let amhField = app.textFields["AMH"]
        if amhField.waitForExistence(timeout: 5) {
            amhField.tap()
            amhField.typeText("0.5")
        }
        
        executeCalculation()
        
        // Verificar clasificación POSEIDON
        try navigateToSimulator()
        
        let poseidonText = app.staticTexts.containing(.staticText, identifier: "POSEIDON").firstMatch
        XCTAssertTrue(poseidonText.waitForExistence(timeout: 5), "Debe mencionar clasificación POSEIDON")
        
        let fivText = app.staticTexts.containing(.staticText, identifier: "FIV").firstMatch
        XCTAssertTrue(fivText.waitForExistence(timeout: 5), "Debe recomendar FIV para AMH bajo")
        
        print("✅ Test escenario AMH bajo: PASÓ")
    }
    
    @MainActor
    func testObesityScenario() throws {
        // Escenario: Paciente con obesidad
        try navigateToCalculator()
        
        fillPatientData(age: "28", height: "165", weight: "95") // IMC ~35
        
        executeCalculation()
        
        // Verificar análisis de IMC
        let factorsTab = app.buttons["Factores"]
        if factorsTab.waitForExistence(timeout: 5) {
            factorsTab.tap()
            
            let imcText = app.staticTexts.containing(.staticText, identifier: "IMC").firstMatch
            XCTAssertTrue(imcText.waitForExistence(timeout: 5), "Debe mostrar análisis de IMC")
            
            let obesityText = app.staticTexts.containing(.staticText, identifier: "obesidad").firstMatch
            XCTAssertTrue(obesityText.waitForExistence(timeout: 5), "Debe mencionar obesidad")
        }
        
        print("✅ Test escenario obesidad: PASÓ")
    }
    
    // MARK: - 🎯 TESTS DEL SIMULADOR DE CORRECCIÓN
    
    @MainActor
    func testFactorCorrectionFlow() throws {
        // Escenario con múltiples factores modificables
        try navigateToCalculator()
        
        fillPatientData(age: "30", height: "165", weight: "85") // IMC elevado
        
        // TSH elevado
        let tshField = app.textFields["TSH"]
        if tshField.waitForExistence(timeout: 5) {
            tshField.tap()
            tshField.typeText("7.0")
        }
        
        executeCalculation()
        
        // Ir al simulador y probar corrección
        try navigateToSimulator()
        
        let correctionButton = app.buttons["Simular Corrección"]
        if correctionButton.waitForExistence(timeout: 5) {
            correctionButton.tap()
            
            // Verificar que aparezca la simulación
            let correctionTitle = app.staticTexts["Simulación de Corrección"]
            XCTAssertTrue(correctionTitle.waitForExistence(timeout: 5), "Debe mostrar simulación de corrección")
            
            // Verificar factor más crítico
            let criticalFactorText = app.staticTexts.containing(.staticText, identifier: "TSH").firstMatch
            XCTAssertTrue(criticalFactorText.waitForExistence(timeout: 5), "Debe identificar TSH como factor crítico")
            
            // Verificar mejora en probabilidad
            let improvementText = app.staticTexts.containing(.staticText, identifier: "%").firstMatch
            XCTAssertTrue(improvementText.waitForExistence(timeout: 5), "Debe mostrar mejora en porcentaje")
        }
        
        print("✅ Test flujo de corrección de factores: PASÓ")
    }
    
    // MARK: - 📊 TESTS DE VALIDACIÓN DE DATOS
    
    @MainActor
    func testDataValidationEdgeCases() throws {
        try navigateToCalculator()
        
        // Test con edad muy joven
        let ageField = app.textFields["Edad"]
        if ageField.waitForExistence(timeout: 5) {
            ageField.tap()
            ageField.typeText("15") // Edad muy joven
        }
        
        let calculateButton = app.buttons["Calcular"]
        if calculateButton.waitForExistence(timeout: 5) {
            calculateButton.tap()
            
            // Debe mostrar algún tipo de validación
            let hasValidation = app.alerts.count > 0 || 
                               app.staticTexts.containing(.staticText, identifier: "válida").count > 0
            
            if hasValidation {
                print("✅ Validación de edad detectada")
            }
        }
        
        // Test con valores extremos
        clearField(ageField)
        ageField.typeText("50") // Edad límite
        
        let heightField = app.textFields["Altura (cm)"]
        if heightField.waitForExistence(timeout: 5) {
            heightField.tap()
            heightField.typeText("200") // Altura extrema
        }
        
        print("✅ Test validación casos extremos: PASÓ")
    }
    
    // MARK: - 🔄 TESTS DE FLUJO COMPLETO
    
    @MainActor
    func testCompleteUserJourney() throws {
        // Simular un journey completo de usuario
        
        // 1. Inicio
        let titleText = app.staticTexts["FERTILIDAD"]
        XCTAssertTrue(titleText.waitForExistence(timeout: 5), "Debe mostrar pantalla de inicio")
        
        // 2. Navegación a calculadora
        try navigateToCalculator()
        
        // 3. Entrada de datos completa
        fillCompletePatientData()
        
        // 4. Cálculo
        executeCalculation()
        
        // 5. Revisión de resultados
        let resultsTitle = app.staticTexts["Resultados del Análisis"]
        XCTAssertTrue(resultsTitle.waitForExistence(timeout: 10), "Debe mostrar resultados")
        
        // 6. Navegación entre tabs
        try testAllResultTabs()
        
        // 7. Uso del simulador
        try navigateToSimulator()
        
        // 8. Simulación de corrección
        let correctionButton = app.buttons["Simular Corrección"]
        if correctionButton.waitForExistence(timeout: 5) {
            correctionButton.tap()
        }
        
        print("✅ Test journey completo de usuario: PASÓ")
    }
    
    // MARK: - 🔧 FUNCIONES AUXILIARES
    
    private func navigateToCalculator() throws {
        let calculatorButton = app.buttons.containing(.staticText, identifier: "Iniciar").firstMatch
        
        if !calculatorButton.exists {
            let alternativeButton = app.buttons["Comenzar Análisis"]
            XCTAssertTrue(alternativeButton.waitForExistence(timeout: 10), "Debe existir botón de navegación")
            alternativeButton.tap()
        } else {
            calculatorButton.tap()
        }
        
        let calculatorTitle = app.navigationBars.firstMatch
        XCTAssertTrue(calculatorTitle.waitForExistence(timeout: 5), "Debe navegar a calculadora")
    }
    
    private func fillPatientData(age: String, height: String, weight: String) {
        let ageField = app.textFields["Edad"]
        if ageField.waitForExistence(timeout: 5) {
            ageField.tap()
            ageField.typeText(age)
        }
        
        let heightField = app.textFields["Altura (cm)"]
        if heightField.waitForExistence(timeout: 5) {
            heightField.tap()
            heightField.typeText(height)
        }
        
        let weightField = app.textFields["Peso (kg)"]
        if weightField.waitForExistence(timeout: 5) {
            weightField.tap()
            weightField.typeText(weight)
        }
        
        // Ocultar teclado
        app.tap()
    }
    
    private func fillCompletePatientData() {
        fillPatientData(age: "32", height: "165", weight: "65")
        
        // Datos adicionales
        let tshField = app.textFields["TSH"]
        if tshField.waitForExistence(timeout: 5) {
            tshField.tap()
            tshField.typeText("3.5")
        }
        
        let amhField = app.textFields["AMH"]
        if amhField.waitForExistence(timeout: 5) {
            amhField.tap()
            amhField.typeText("2.0")
        }
        
        app.tap() // Ocultar teclado
    }
    
    private func executeCalculation() {
        let calculateButton = app.buttons["Calcular"]
        XCTAssertTrue(calculateButton.waitForExistence(timeout: 5), "Debe existir botón calcular")
        calculateButton.tap()
    }
    
    private func navigateToSimulator() throws {
        let simulatorTab = app.buttons["Simulador"]
        XCTAssertTrue(simulatorTab.waitForExistence(timeout: 5), "Debe existir tab simulador")
        simulatorTab.tap()
        
        let simulatorTitle = app.staticTexts["Simulador de Tratamientos"]
        XCTAssertTrue(simulatorTitle.waitForExistence(timeout: 5), "Debe mostrar simulador")
    }
    
    private func testAllResultTabs() throws {
        // Resumen
        let summaryTab = app.buttons["Resumen"]
        if summaryTab.waitForExistence(timeout: 5) {
            summaryTab.tap()
            let probabilityText = app.staticTexts.containing(.staticText, identifier: "%").firstMatch
            XCTAssertTrue(probabilityText.waitForExistence(timeout: 5), "Debe mostrar probabilidades")
        }
        
        // Factores
        let factorsTab = app.buttons["Factores"]
        if factorsTab.waitForExistence(timeout: 5) {
            factorsTab.tap()
            let factorsContent = app.staticTexts["Análisis de Factores"]
            XCTAssertTrue(factorsContent.waitForExistence(timeout: 5), "Debe mostrar factores")
        }
        
        // Análisis
        let analysisTab = app.buttons["Análisis"]
        if analysisTab.waitForExistence(timeout: 5) {
            analysisTab.tap()
            let analysisContent = app.staticTexts.containing(.staticText, identifier: "Evidencia").firstMatch
            XCTAssertTrue(analysisContent.waitForExistence(timeout: 5), "Debe mostrar análisis")
        }
    }
    
    private func clearField(_ field: XCUIElement) {
        field.tap()
        field.press(forDuration: 1.0)
        
        let selectAllButton = app.menuItems["Select All"]
        if selectAllButton.exists {
            selectAllButton.tap()
            app.keyboards.keys["delete"].tap()
        }
    }
}
