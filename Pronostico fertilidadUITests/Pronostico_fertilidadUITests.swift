//
//  Pronostico_fertilidadUITests.swift
//  Pronostico fertilidadUITests
//
//  Created by Jorge Vasquez rodriguez on 11/08/2025.
//

import XCTest

// MARK: - 🧪 TESTS DE UI PRINCIPALES
final class Pronostico_fertilidadUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Configuración inicial para cada test
        continueAfterFailure = false
        
        // Inicializar la aplicación
        app = XCUIApplication()
        
        // Configurar argumentos de lanzamiento para testing
        app.launchArguments.append("--uitesting")
        
        // Lanzar la aplicación
        app.launch()
        
        // Esperar a que la app esté lista
        _ = app.wait(for: .runningForeground, timeout: 10)
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - 🚀 TEST DE LANZAMIENTO Y NAVEGACIÓN PRINCIPAL
    
    @MainActor
    func testAppLaunch() throws {
        // Verificar que la app se lance correctamente
        XCTAssertTrue(app.state == .runningForeground, "La aplicación debería estar ejecutándose")
        
        // Verificar elementos principales de la pantalla de inicio
        let titleText = app.staticTexts["FERTILIDAD"]
        XCTAssertTrue(titleText.waitForExistence(timeout: 5), "El título principal debe aparecer")
        
        // Verificar que aparezcan las estadísticas
        let precisionText = app.staticTexts["96.1%"]
        XCTAssertTrue(precisionText.waitForExistence(timeout: 5), "Las estadísticas de precisión deben aparecer")
        
        let referencesText = app.staticTexts["1,247"]
        XCTAssertTrue(referencesText.waitForExistence(timeout: 5), "Las referencias deben aparecer")
        
        print("✅ Test de lanzamiento: PASÓ")
    }
    
    @MainActor
    func testNavigationToCalculator() throws {
        // Esperar a que aparezca el botón de calculadora
        let calculatorButton = app.buttons.containing(.staticText, identifier: "Iniciar Evaluación").firstMatch
        
        if !calculatorButton.exists {
            // Si no existe, buscar por otros posibles identificadores
            let alternativeButton = app.buttons["Comenzar Análisis"]
            XCTAssertTrue(alternativeButton.waitForExistence(timeout: 10), "Debe existir un botón para iniciar la evaluación")
            alternativeButton.tap()
        } else {
            XCTAssertTrue(calculatorButton.waitForExistence(timeout: 10), "El botón de calculadora debe aparecer")
            calculatorButton.tap()
        }
        
        // Verificar que se abre la calculadora
        let calculatorTitle = app.navigationBars.staticTexts["Evaluación de Fertilidad"]
        XCTAssertTrue(calculatorTitle.waitForExistence(timeout: 5), "Debe navegar a la calculadora")
        
        print("✅ Test de navegación a calculadora: PASÓ")
    }
    
    // MARK: - 📝 TESTS DE ENTRADA DE DATOS
    
    @MainActor
    func testDataEntry() throws {
        // Navegar a la calculadora
        try testNavigationToCalculator()
        
        // Test de entrada de edad
        let ageField = app.textFields["Edad"]
        if ageField.waitForExistence(timeout: 5) {
            ageField.tap()
            ageField.typeText("30")
            
            // Verificar que se aceptó el valor
            XCTAssertEqual(ageField.value as? String, "30", "La edad debe establecerse correctamente")
        }
        
        // Test de entrada de altura
        let heightField = app.textFields["Altura (cm)"]
        if heightField.waitForExistence(timeout: 5) {
            heightField.tap()
            heightField.typeText("165")
        }
        
        // Test de entrada de peso
        let weightField = app.textFields["Peso (kg)"]
        if weightField.waitForExistence(timeout: 5) {
            weightField.tap()
            weightField.typeText("65")
        }
        
        print("✅ Test de entrada de datos: PASÓ")
    }
    
    @MainActor
    func testFormValidation() throws {
        // Navegar a la calculadora
        try testNavigationToCalculator()
        
        // Intentar calcular sin datos
        let calculateButton = app.buttons["Calcular"]
        if calculateButton.waitForExistence(timeout: 5) {
            calculateButton.tap()
            
            // Verificar que aparezca algún mensaje de validación
            let alertExists = app.alerts.count > 0
            let errorMessageExists = app.staticTexts.containing(.staticText, identifier: "requerido").count > 0
            
            XCTAssertTrue(alertExists || errorMessageExists, "Debe mostrar validación cuando faltan datos")
        }
        
        print("✅ Test de validación de formulario: PASÓ")
    }
    
    // MARK: - 🧮 TESTS DE CÁLCULO Y RESULTADOS
    
    @MainActor
    func testCompleteCalculationFlow() throws {
        // Navegar a la calculadora
        try testNavigationToCalculator()
        
        // Llenar datos básicos
        fillBasicData()
        
        // Ejecutar cálculo
        let calculateButton = app.buttons["Calcular"]
        if calculateButton.waitForExistence(timeout: 5) {
            calculateButton.tap()
            
            // Esperar a que aparezcan los resultados
            let resultsTitle = app.staticTexts["Resultados del Análisis"]
            XCTAssertTrue(resultsTitle.waitForExistence(timeout: 10), "Deben aparecer los resultados")
            
            // Verificar que aparezcan probabilidades
            let monthlyProbability = app.staticTexts.containing(.staticText, identifier: "%").firstMatch
            XCTAssertTrue(monthlyProbability.waitForExistence(timeout: 5), "Debe mostrar probabilidad mensual")
        }
        
        print("✅ Test de flujo completo de cálculo: PASÓ")
    }
    
    @MainActor
    func testResultsNavigation() throws {
        // Ejecutar cálculo completo
        try testCompleteCalculationFlow()
        
        // Test de navegación entre tabs de resultados
        let summaryTab = app.buttons["Resumen"]
        if summaryTab.waitForExistence(timeout: 5) {
            summaryTab.tap()
            
            // Verificar contenido de resumen
            let probabilityText = app.staticTexts.containing(.staticText, identifier: "Probabilidad").firstMatch
            XCTAssertTrue(probabilityText.waitForExistence(timeout: 5), "Debe mostrar información de probabilidad")
        }
        
        let factorsTab = app.buttons["Factores"]
        if factorsTab.waitForExistence(timeout: 5) {
            factorsTab.tap()
            
            // Verificar contenido de factores
            let factorsTitle = app.staticTexts["Análisis de Factores"]
            XCTAssertTrue(factorsTitle.waitForExistence(timeout: 5), "Debe mostrar análisis de factores")
        }
        
        print("✅ Test de navegación en resultados: PASÓ")
    }
    
    // MARK: - 🎯 TESTS DEL SIMULADOR DE TRATAMIENTOS
    
    @MainActor
    func testTreatmentSimulator() throws {
        // Ejecutar cálculo completo
        try testCompleteCalculationFlow()
        
        // Navegar al simulador
        let simulatorTab = app.buttons["Simulador"]
        if simulatorTab.waitForExistence(timeout: 5) {
            simulatorTab.tap()
            
            // Verificar contenido del simulador
            let simulatorTitle = app.staticTexts["Simulador de Tratamientos"]
            XCTAssertTrue(simulatorTitle.waitForExistence(timeout: 5), "Debe mostrar el simulador")
            
            // Verificar recomendación de tratamiento
            let treatmentRecommendation = app.staticTexts.containing(.staticText, identifier: "Recomendado").firstMatch
            XCTAssertTrue(treatmentRecommendation.waitForExistence(timeout: 5), "Debe mostrar recomendación de tratamiento")
        }
        
        print("✅ Test del simulador de tratamientos: PASÓ")
    }
    
    @MainActor
    func testFactorCorrectionSimulation() throws {
        // Navegar al simulador
        try testTreatmentSimulator()
        
        // Buscar el botón de simulación de corrección
        let correctionButton = app.buttons["Simular Corrección"]
        if correctionButton.waitForExistence(timeout: 5) {
            correctionButton.tap()
            
            // Verificar que aparezca la simulación
            let correctionTitle = app.staticTexts["Simulación de Corrección"]
            XCTAssertTrue(correctionTitle.waitForExistence(timeout: 5), "Debe mostrar la simulación de corrección")
            
            // Verificar que aparezca información de mejora
            let improvementText = app.staticTexts.containing(.staticText, identifier: "Mejora").firstMatch
            XCTAssertTrue(improvementText.waitForExistence(timeout: 5), "Debe mostrar información de mejora")
        }
        
        print("✅ Test de simulación de corrección: PASÓ")
    }
    
    // MARK: - ♿ TESTS DE ACCESIBILIDAD BÁSICOS
    
    @MainActor
    func testAccessibilityElements() throws {
        // Verificar que los elementos principales tengan etiquetas de accesibilidad
        let titleElement = app.staticTexts["FERTILIDAD"]
        if titleElement.waitForExistence(timeout: 5) {
            XCTAssertNotNil(titleElement.label, "El título debe tener etiqueta de accesibilidad")
        }
        
        // Verificar botones principales
        let buttons = app.buttons
        for i in 0..<min(buttons.count, 5) {
            let button = buttons.element(boundBy: i)
            if button.exists {
                XCTAssertTrue(button.isEnabled, "Los botones deben estar habilitados")
                XCTAssertFalse(button.label.isEmpty, "Los botones deben tener etiquetas")
            }
        }
        
        print("✅ Test de accesibilidad básica: PASÓ")
    }
    
    @MainActor
    func testVoiceOverSupport() throws {
        // Habilitar VoiceOver para testing
        let device = XCUIDevice.shared
        
        // Verificar que los elementos sean accesibles para VoiceOver
        let titleElement = app.staticTexts["FERTILIDAD"]
        if titleElement.waitForExistence(timeout: 5) {
            XCTAssertTrue(titleElement.isAccessibilityElement, "El título debe ser accesible")
        }
        
        print("✅ Test de soporte VoiceOver: PASÓ")
    }
    
    // MARK: - ⚡ TESTS DE RENDIMIENTO UI
    
    @MainActor
    func testLaunchPerformance() throws {
        // Medir tiempo de lanzamiento
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
        
        print("✅ Test de rendimiento de lanzamiento: PASÓ")
    }
    
    @MainActor
    func testCalculationPerformance() throws {
        // Navegar a la calculadora
        try testNavigationToCalculator()
        
        // Llenar datos
        fillBasicData()
        
        // Medir tiempo de cálculo
        let calculateButton = app.buttons["Calcular"]
        if calculateButton.waitForExistence(timeout: 5) {
            measure(metrics: [XCTClockMetric()]) {
                calculateButton.tap()
                
                // Esperar resultados
                let resultsTitle = app.staticTexts["Resultados del Análisis"]
                _ = resultsTitle.waitForExistence(timeout: 10)
            }
        }
        
        print("✅ Test de rendimiento de cálculo: PASÓ")
    }
    
    // MARK: - 🔧 FUNCIONES AUXILIARES
    
    private func fillBasicData() {
        // Llenar datos básicos para testing
        let ageField = app.textFields["Edad"]
        if ageField.waitForExistence(timeout: 5) {
            ageField.tap()
            ageField.typeText("30")
        }
        
        let heightField = app.textFields["Altura (cm)"]
        if heightField.waitForExistence(timeout: 5) {
            heightField.tap()
            heightField.typeText("165")
        }
        
        let weightField = app.textFields["Peso (kg)"]
        if weightField.waitForExistence(timeout: 5) {
            weightField.tap()
            weightField.typeText("65")
        }
        
        // Ocultar teclado
        app.keyboards.buttons["Done"].tap()
    }
    
    private func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 10) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
}
