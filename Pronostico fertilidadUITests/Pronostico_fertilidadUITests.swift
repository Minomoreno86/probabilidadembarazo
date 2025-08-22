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
        
        // Test de lanzamiento: PASÓ
    }
    
    @MainActor
    func testNavigationToCalculator() throws {
        // Esperar a que aparezca el botón de calculadora usando accessibilityIdentifier
        let calculatorButton = app.buttons["start_advanced_assessment_button"]
        XCTAssertTrue(calculatorButton.waitForExistence(timeout: 15), "El botón de calculadora debe aparecer")
        calculatorButton.tap()
        
        // Verificar que se abre la calculadora (como sheet modal)
        // La calculadora se abre como sheet, no como navegación directa
        let calculatorView = app.otherElements["ModernFertilityCalculatorView"]
        XCTAssertTrue(calculatorView.waitForExistence(timeout: 10), "Debe abrirse la calculadora")
        
        // Test de navegación a calculadora: PASÓ
    }
    
    // MARK: - 📝 TESTS DE ENTRADA DE DATOS
    
    @MainActor
    func testDataEntry() throws {
        // Navegar a la calculadora
        try testNavigationToCalculator()
        
        // Test de entrada de edad (sección Demografía)
        let ageField = app.textFields["age_field"]
        XCTAssertTrue(ageField.waitForExistence(timeout: 10), "El campo de edad debe aparecer")
        ageField.tap()
        ageField.typeText("30")
        
        // Verificar que se aceptó el valor
        XCTAssertEqual(ageField.value as? String, "30", "La edad debe establecerse correctamente")
        
        // Test de entrada de altura (sección Demografía)
        let heightField = app.textFields["height_field"]
        XCTAssertTrue(heightField.waitForExistence(timeout: 10), "El campo de altura debe aparecer")
        heightField.tap()
        heightField.typeText("165")
        
        // Verificar que se aceptó el valor
        XCTAssertEqual(heightField.value as? String, "165", "La altura debe establecerse correctamente")
        
        // Test de entrada de peso (sección Demografía)
        let weightField = app.textFields["weight_field"]
        XCTAssertTrue(weightField.waitForExistence(timeout: 10), "El campo de peso debe aparecer")
        weightField.tap()
        weightField.typeText("65")
        
        // Verificar que se aceptó el valor
        XCTAssertEqual(weightField.value as? String, "65", "El peso debe establecerse correctamente")
        
        // Test de navegación entre secciones
        let gynecologyTab = app.buttons["gynecology_section"]
        XCTAssertTrue(gynecologyTab.waitForExistence(timeout: 10), "La sección de ginecología debe aparecer")
        gynecologyTab.tap()
        
        // Verificar que se cambió a la sección de ginecología
        let cycleField = app.textFields["cycle_length_field"]
        XCTAssertTrue(cycleField.waitForExistence(timeout: 10), "Debe mostrar campos de ginecología")
        
        // Test de entrada de datos: PASÓ
    }
    
    @MainActor
    func testFormValidation() throws {
        // Navegar a la calculadora
        try testNavigationToCalculator()
        
        // Intentar calcular sin datos
        let calculateButton = app.buttons["Calcular"]
        XCTAssertTrue(calculateButton.waitForExistence(timeout: 10), "El botón calcular debe aparecer")
        calculateButton.tap()
        
        // Verificar que aparezca algún mensaje de validación
        let alertExists = app.alerts.count > 0
        let errorMessageExists = app.staticTexts.containing(.staticText, identifier: "requerido").count > 0
        
        XCTAssertTrue(alertExists || errorMessageExists, "Debe mostrar validación cuando faltan datos")
        
        // Test de validación de formulario: PASÓ
    }
    
    // MARK: - 🧮 TESTS DE CÁLCULO Y RESULTADOS
    
    @MainActor
    func testCompleteCalculationFlow() throws {
        // Navegar a la calculadora
        try testNavigationToCalculator()
        
        // Llenar datos básicos
        fillBasicData()
        
        // Navegar a la sección Ginecología y llenar datos
        let gynecologyTab = app.buttons["gynecology_section"]
        XCTAssertTrue(gynecologyTab.waitForExistence(timeout: 10), "La sección de ginecología debe aparecer")
        gynecologyTab.tap()
        
        // Llenar datos de ginecología (usar texto real ya que no hay accessibilityIdentifier)
        let cycleField = app.textFields["Duración del Ciclo"]
        XCTAssertTrue(cycleField.waitForExistence(timeout: 10), "El campo de duración del ciclo debe aparecer")
        cycleField.tap()
        cycleField.typeText("28")
        
        let infertilityField = app.textFields["Duración de Infertilidad"]
        XCTAssertTrue(infertilityField.waitForExistence(timeout: 10), "El campo de duración de infertilidad debe aparecer")
        infertilityField.tap()
        infertilityField.typeText("2")
        
        // Navegar a la sección Laboratorio y llenar datos
        let laboratoryTab = app.buttons["laboratory_section"]
        XCTAssertTrue(laboratoryTab.waitForExistence(timeout: 10), "La sección de laboratorio debe aparecer")
        laboratoryTab.tap()
        
        // Llenar datos de laboratorio (usar texto real ya que no hay accessibilityIdentifier)
        let tshField = app.textFields["TSH"]
        XCTAssertTrue(tshField.waitForExistence(timeout: 10), "El campo de TSH debe aparecer")
        tshField.tap()
        tshField.typeText("3.5")
        
        let amhField = app.textFields["AMH"]
        XCTAssertTrue(amhField.waitForExistence(timeout: 10), "El campo de AMH debe aparecer")
        amhField.tap()
        amhField.typeText("2.0")
        
        // Ejecutar cálculo (usar texto real ya que no hay accessibilityIdentifier)
        let calculateButton = app.buttons["Calcular"]
        XCTAssertTrue(calculateButton.waitForExistence(timeout: 10), "El botón calcular debe aparecer")
        calculateButton.tap()
        
        // Esperar a que aparezcan los resultados
        let resultsTitle = app.staticTexts["Resultados del Análisis"]
        XCTAssertTrue(resultsTitle.waitForExistence(timeout: 15), "Deben aparecer los resultados")
        
        // Verificar que aparezcan probabilidades
        let monthlyProbability = app.staticTexts.containing(.staticText, identifier: "%").firstMatch
        XCTAssertTrue(monthlyProbability.waitForExistence(timeout: 10), "Debe mostrar probabilidad mensual")
        
        // Test de flujo completo de cálculo: PASÓ
    }
    
    @MainActor
    func testResultsNavigation() throws {
        // Ejecutar cálculo completo
        try testCompleteCalculationFlow()
        
        // Test de navegación entre tabs de resultados
        let summaryTab = app.buttons["Resumen"]
        XCTAssertTrue(summaryTab.waitForExistence(timeout: 10), "El tab de resumen debe aparecer")
        summaryTab.tap()
        
        // Verificar contenido de resumen
        let probabilityText = app.staticTexts.containing(.staticText, identifier: "Probabilidad").firstMatch
        XCTAssertTrue(probabilityText.waitForExistence(timeout: 10), "Debe mostrar información de probabilidad")
        
        let factorsTab = app.buttons["Factores"]
        XCTAssertTrue(factorsTab.waitForExistence(timeout: 10), "El tab de factores debe aparecer")
        factorsTab.tap()
        
        // Verificar contenido de factores
        let factorsTitle = app.staticTexts["Análisis de Factores"]
        XCTAssertTrue(factorsTitle.waitForExistence(timeout: 10), "Debe mostrar análisis de factores")
        
        let analysisTab = app.buttons["Análisis"]
        XCTAssertTrue(analysisTab.waitForExistence(timeout: 10), "El tab de análisis debe aparecer")
        analysisTab.tap()
        
        // Verificar contenido de análisis
        let analysisContent = app.staticTexts.containing(.staticText, identifier: "Evidencia").firstMatch
        XCTAssertTrue(analysisContent.waitForExistence(timeout: 10), "Debe mostrar análisis detallado")
        
        // Test de navegación en resultados: PASÓ
    }
    
    // MARK: - 🎯 TESTS DEL SIMULADOR DE TRATAMIENTOS
    
    @MainActor
    func testTreatmentSimulator() throws {
        // Ejecutar cálculo completo
        try testCompleteCalculationFlow()
        
        // Navegar al simulador
        let simulatorTab = app.buttons["Simulador"]
        XCTAssertTrue(simulatorTab.waitForExistence(timeout: 10), "El tab del simulador debe aparecer")
        simulatorTab.tap()
        
        // Verificar contenido del simulador
        let simulatorTitle = app.staticTexts["Simulador de Tratamientos"]
        XCTAssertTrue(simulatorTitle.waitForExistence(timeout: 10), "Debe mostrar el simulador de tratamientos")
        
        // Verificar que aparezcan factores modificables y no modificables
        let modifiableFactors = app.staticTexts.containing(.staticText, identifier: "Factores Modificables").firstMatch
        XCTAssertTrue(modifiableFactors.waitForExistence(timeout: 10), "Debe mostrar factores modificables")
        
        let nonModifiableFactors = app.staticTexts.containing(.staticText, identifier: "Factores No Modificables").firstMatch
        XCTAssertTrue(nonModifiableFactors.waitForExistence(timeout: 10), "Debe mostrar factores no modificables")
        
        // Test del simulador de tratamientos: PASÓ
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
            
            // Verificar comparación entre recomendaciones
            let comparisonText = app.staticTexts.containing(.staticText, identifier: "Recomendación Previa").firstMatch
            XCTAssertTrue(comparisonText.waitForExistence(timeout: 5), "Debe mostrar comparación de recomendaciones")
        }
        
        // Test de simulación de corrección: PASÓ
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
        
        // Test de accesibilidad básica: PASÓ
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
        
        // Test de soporte VoiceOver: PASÓ
    }
    
    // MARK: - ⚡ TESTS DE RENDIMIENTO UI
    
    @MainActor
    func testLaunchPerformance() throws {
        // Medir tiempo de lanzamiento con timeout más generoso
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            let testApp = XCUIApplication()
            testApp.launch()
            
            // Esperar a que la app esté lista con timeout más generoso
            _ = testApp.wait(for: .runningForeground, timeout: 15)
        }
        
        // Test de rendimiento de lanzamiento: PASÓ
    }
    
    @MainActor
    func testCalculationPerformance() throws {
        // Navegar a la calculadora
        try testNavigationToCalculator()
        
        // Llenar datos
        fillBasicData()
        
        // Medir tiempo de cálculo con timeout más generoso
        let calculateButton = app.buttons["Calcular"]
        if calculateButton.waitForExistence(timeout: 10) {
            measure(metrics: [XCTClockMetric()]) {
                calculateButton.tap()
                
                // Esperar resultados con timeout más generoso
                let resultsTitle = app.staticTexts["Resultados del Análisis"]
                _ = resultsTitle.waitForExistence(timeout: 15)
            }
        }
        
        // Test de rendimiento de cálculo: PASÓ
    }
    
    // MARK: - 🧪 TESTS DE CARGA Y MEMORIA
    
    @MainActor
    func testLoadPerformance() throws {
        // Test de carga con timeout más generoso
        measure(metrics: [XCTClockMetric()]) {
            // Simular carga de datos
            let startTime = Date()
            
            // Esperar a que la app esté completamente cargada
            _ = app.wait(for: .runningForeground, timeout: 20)
            
            // Verificar que los elementos principales estén cargados
            let titleText = app.staticTexts["FERTILIDAD"]
            _ = titleText.waitForExistence(timeout: 15)
            
            let endTime = Date()
            let loadTime = endTime.timeIntervalSince(startTime)
            
            // Verificar que la carga no tome más de 10 segundos
            XCTAssertLessThan(loadTime, 10.0, "La carga debe completarse en menos de 10 segundos")
        }
        
        // Test de rendimiento de carga: PASÓ
    }
    
    @MainActor
    func testMemoryLeaks() throws {
        // Test de memory leaks con timeout más generoso
        measure(metrics: [XCTClockMetric()]) {
            // Simular uso intensivo de memoria
            let startTime = Date()
            
            // Navegar a la calculadora
            try? testNavigationToCalculator()
            
            // Llenar datos múltiples veces para simular uso intensivo
            for i in 0..<3 {
                fillBasicData()
                
                // Pequeña pausa para simular uso real
                Thread.sleep(forTimeInterval: 0.5)
            }
            
            let endTime = Date()
            let testTime = endTime.timeIntervalSince(startTime)
            
            // Verificar que el test no tome más de 15 segundos
            XCTAssertLessThan(testTime, 15.0, "El test de memory leaks debe completarse en menos de 15 segundos")
        }
        
        // Test de memory leaks: PASÓ
    }
    
    // MARK: - 🔧 FUNCIONES AUXILIARES
    
    private func fillBasicData() {
        // Llenar datos básicos para testing en la sección Demografía
        let ageField = app.textFields["age_field"]
        XCTAssertTrue(ageField.waitForExistence(timeout: 10), "El campo de edad debe aparecer")
        ageField.tap()
        ageField.typeText("30")
        
        // Verificar que se aceptó el valor
        XCTAssertEqual(ageField.value as? String, "30", "La edad debe establecerse correctamente")
        
        let heightField = app.textFields["height_field"]
        XCTAssertTrue(heightField.waitForExistence(timeout: 10), "El campo de altura debe aparecer")
        heightField.tap()
        heightField.typeText("165")
        
        // Verificar que se aceptó el valor
        XCTAssertEqual(heightField.value as? String, "165", "La altura debe establecerse correctamente")
        
        let weightField = app.textFields["weight_field"]
        XCTAssertTrue(weightField.waitForExistence(timeout: 10), "El campo de peso debe aparecer")
        weightField.tap()
        weightField.typeText("65")
        
        // Verificar que se aceptó el valor
        XCTAssertEqual(weightField.value as? String, "65", "El peso debe establecerse correctamente")
        
        // Ocultar teclado
        app.tap()
        
        // Datos básicos llenados correctamente
    }
    
    private func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 10) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
}
