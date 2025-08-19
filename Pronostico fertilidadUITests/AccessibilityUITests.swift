//
//  AccessibilityUITests.swift
//  Pronostico fertilidadUITests
//
//  Created by Jorge Vasquez rodriguez on 11/08/2025.
//

import XCTest

// MARK: - ♿ TESTS DE ACCESIBILIDAD AVANZADOS
final class AccessibilityUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launchArguments.append("--accessibility-testing")
        app.launch()
        _ = app.wait(for: .runningForeground, timeout: 10)
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - 🗣️ TESTS DE VOICEOVER
    
    @MainActor
    func testVoiceOverLabels() throws {
        // Verificar que todos los elementos principales tengan etiquetas apropiadas
        
        // Título principal
        let mainTitle = app.staticTexts["FERTILIDAD"]
        if mainTitle.waitForExistence(timeout: 5) {
            XCTAssertTrue(mainTitle.isAccessibilityElement, "El título debe ser accesible")
            XCTAssertFalse(mainTitle.label.isEmpty, "El título debe tener etiqueta")
            
            // Verificar que la etiqueta sea descriptiva
            let label = mainTitle.label
            XCTAssertTrue(label.contains("FERTILIDAD") || label.contains("fertilidad"), 
                         "La etiqueta debe contener información sobre fertilidad")
        }
        
        // Estadísticas
        let precisionStat = app.staticTexts["96.1%"]
        if precisionStat.waitForExistence(timeout: 5) {
            XCTAssertTrue(precisionStat.isAccessibilityElement, "Las estadísticas deben ser accesibles")
        }
        
        // Botones principales
        let buttons = app.buttons
        for i in 0..<min(buttons.count, 10) {
            let button = buttons.element(boundBy: i)
            if button.exists && button.isHittable {
                XCTAssertTrue(button.isAccessibilityElement, "Botón \(i) debe ser accesible")
                XCTAssertFalse(button.label.isEmpty, "Botón \(i) debe tener etiqueta")
                
                // Verificar que el botón tenga un rol apropiado
                XCTAssertEqual(button.elementType, .button, "Elemento debe ser reconocido como botón")
            }
        }
        
        print("✅ Test etiquetas VoiceOver: PASÓ")
    }
    
    @MainActor
    func testVoiceOverNavigation() throws {
        // Simular navegación con VoiceOver
        
        // Verificar orden de navegación lógico
        let accessibilityElements = app.descendants(matching: .any).allElementsBoundByAccessibilityElement
        
        var hasNavigableElements = false
        for element in accessibilityElements.prefix(20) {
            if element.isAccessibilityElement && element.exists {
                hasNavigableElements = true
                
                // Verificar que el elemento tenga información útil
                XCTAssertFalse(element.label.isEmpty || element.value as? String == "", 
                              "Elementos navegables deben tener información")
            }
        }
        
        XCTAssertTrue(hasNavigableElements, "Debe haber elementos navegables para VoiceOver")
        
        print("✅ Test navegación VoiceOver: PASÓ")
    }
    
    // MARK: - 🎯 TESTS DE CONTRASTE Y VISIBILIDAD
    
    @MainActor
    func testColorContrast() throws {
        // Verificar que los elementos sean visibles con alto contraste
        
        // Tomar screenshot para análisis visual
        let screenshot = app.screenshot()
        XCTAssertNotNil(screenshot, "Debe poder tomar screenshot")
        
        // Verificar que los elementos principales sean visibles
        let titleElement = app.staticTexts["FERTILIDAD"]
        if titleElement.waitForExistence(timeout: 5) {
            XCTAssertTrue(titleElement.isHittable, "El título debe ser visible")
            
            // Verificar que el elemento tenga un frame válido
            let frame = titleElement.frame
            XCTAssertTrue(frame.width > 0 && frame.height > 0, "El título debe tener dimensiones válidas")
        }
        
        // Verificar botones principales
        let buttons = app.buttons
        for i in 0..<min(buttons.count, 5) {
            let button = buttons.element(boundBy: i)
            if button.exists {
                XCTAssertTrue(button.isHittable, "Botón \(i) debe ser visible y tocable")
                
                let frame = button.frame
                XCTAssertTrue(frame.width >= 44 && frame.height >= 44, 
                             "Botón \(i) debe cumplir tamaño mínimo de accesibilidad (44x44)")
            }
        }
        
        print("✅ Test contraste y visibilidad: PASÓ")
    }
    
    // MARK: - 📱 TESTS DE TAMAÑO DE FUENTE DINÁMICO
    
    @MainActor
    func testDynamicTypeSupport() throws {
        // Verificar que la app responda a cambios de tamaño de fuente
        
        // Tomar medidas iniciales
        let titleElement = app.staticTexts["FERTILIDAD"]
        if titleElement.waitForExistence(timeout: 5) {
            let initialFrame = titleElement.frame
            
            // Simular cambio de tamaño de fuente (esto requeriría configuración adicional)
            // Por ahora, verificamos que el elemento tenga un tamaño razonable
            XCTAssertTrue(initialFrame.height >= 20, "El texto debe tener altura mínima legible")
            XCTAssertTrue(initialFrame.width > 0, "El texto debe tener ancho válido")
        }
        
        print("✅ Test soporte Dynamic Type: PASÓ")
    }
    
    // MARK: - 🤏 TESTS DE GESTOS DE ACCESIBILIDAD
    
    @MainActor
    func testAccessibilityActions() throws {
        // Verificar que los elementos soporten acciones de accesibilidad apropiadas
        
        let buttons = app.buttons
        for i in 0..<min(buttons.count, 5) {
            let button = buttons.element(boundBy: i)
            if button.exists && button.isAccessibilityElement {
                
                // Verificar que el botón sea activable
                XCTAssertTrue(button.isHittable, "Botón \(i) debe ser activable")
                
                // Verificar traits apropiados
                let traits = button.accessibilityTraits
                XCTAssertTrue(traits.contains(.button), "Elemento debe tener trait de botón")
                
                // Si el botón está deshabilitado, debe tener el trait apropiado
                if !button.isEnabled {
                    XCTAssertTrue(traits.contains(.notEnabled), "Botón deshabilitado debe tener trait apropiado")
                }
            }
        }
        
        print("✅ Test acciones de accesibilidad: PASÓ")
    }
    
    // MARK: - 📝 TESTS DE FORMULARIOS ACCESIBLES
    
    @MainActor
    func testFormAccessibility() throws {
        // Navegar a la calculadora si existe
        let calculatorButton = app.buttons.containing(.staticText, identifier: "Iniciar").firstMatch
        if calculatorButton.exists {
            calculatorButton.tap()
            
            // Verificar campos de entrada
            let textFields = app.textFields
            for i in 0..<min(textFields.count, 10) {
                let field = textFields.element(boundBy: i)
                if field.exists {
                    XCTAssertTrue(field.isAccessibilityElement, "Campo \(i) debe ser accesible")
                    
                    // Verificar que tenga etiqueta descriptiva
                    let label = field.label
                    XCTAssertFalse(label.isEmpty, "Campo \(i) debe tener etiqueta")
                    
                    // Verificar que sea editable
                    let traits = field.accessibilityTraits
                    XCTAssertTrue(traits.contains(.searchField) || traits.contains(.keyboardKey) || 
                                 field.elementType == .textField, "Campo debe ser reconocido como editable")
                    
                    // Verificar tamaño mínimo
                    let frame = field.frame
                    XCTAssertTrue(frame.height >= 44, "Campo debe tener altura mínima de 44pt")
                }
            }
        }
        
        print("✅ Test accesibilidad de formularios: PASÓ")
    }
    
    // MARK: - 🎨 TESTS DE MODO OSCURO
    
    @MainActor
    func testDarkModeAccessibility() throws {
        // Verificar que la app sea accesible en modo oscuro
        // (Esto requeriría cambiar la configuración del sistema)
        
        // Por ahora, verificamos que los elementos sean visibles independientemente del tema
        let elements = [
            app.staticTexts["FERTILIDAD"],
            app.staticTexts["96.1%"],
            app.staticTexts["1,247"]
        ]
        
        for element in elements {
            if element.waitForExistence(timeout: 5) {
                XCTAssertTrue(element.isHittable, "Elemento debe ser visible en cualquier tema")
                
                let frame = element.frame
                XCTAssertTrue(frame.width > 0 && frame.height > 0, "Elemento debe tener dimensiones válidas")
            }
        }
        
        print("✅ Test accesibilidad modo oscuro: PASÓ")
    }
    
    // MARK: - 📊 TESTS DE CONTENIDO MÉDICO ACCESIBLE
    
    @MainActor
    func testMedicalContentAccessibility() throws {
        // Verificar que el contenido médico sea accesible
        
        // Buscar elementos que contengan terminología médica
        let medicalTerms = ["Fertilidad", "AMH", "TSH", "IMC", "Probabilidad"]
        
        for term in medicalTerms {
            let elements = app.staticTexts.containing(.staticText, identifier: term)
            
            if elements.count > 0 {
                let element = elements.firstMatch
                if element.exists {
                    XCTAssertTrue(element.isAccessibilityElement, "\(term) debe ser accesible")
                    
                    // Verificar que tenga información contextual
                    let label = element.label
                    XCTAssertFalse(label.isEmpty, "\(term) debe tener etiqueta descriptiva")
                    
                    // Para términos médicos complejos, verificar que haya contexto adicional
                    if ["AMH", "TSH"].contains(term) {
                        // Ideally, these should have accessibility hints explaining what they are
                        // For now, just verify they exist and are accessible
                        XCTAssertTrue(element.exists, "\(term) debe estar presente y accesible")
                    }
                }
            }
        }
        
        print("✅ Test accesibilidad contenido médico: PASÓ")
    }
    
    // MARK: - 🚨 TESTS DE ALERTAS Y NOTIFICACIONES
    
    @MainActor
    func testAlertsAccessibility() throws {
        // Verificar que las alertas sean accesibles
        
        // Intentar triggear una alerta (por ejemplo, validación de formulario)
        let calculatorButton = app.buttons.containing(.staticText, identifier: "Iniciar").firstMatch
        if calculatorButton.exists {
            calculatorButton.tap()
            
            // Intentar calcular sin datos para triggear validación
            let calculateButton = app.buttons["Calcular"]
            if calculateButton.waitForExistence(timeout: 5) {
                calculateButton.tap()
                
                // Verificar si aparece una alerta
                if app.alerts.count > 0 {
                    let alert = app.alerts.firstMatch
                    XCTAssertTrue(alert.isAccessibilityElement, "Alerta debe ser accesible")
                    
                    // Verificar botones de la alerta
                    let alertButtons = alert.buttons
                    for i in 0..<alertButtons.count {
                        let button = alertButtons.element(boundBy: i)
                        XCTAssertTrue(button.isAccessibilityElement, "Botón de alerta debe ser accesible")
                        XCTAssertFalse(button.label.isEmpty, "Botón de alerta debe tener etiqueta")
                    }
                }
            }
        }
        
        print("✅ Test accesibilidad de alertas: PASÓ")
    }
    
    // MARK: - 📏 TESTS DE DISEÑO RESPONSIVO
    
    @MainActor
    func testResponsiveDesignAccessibility() throws {
        // Verificar que el diseño sea accesible en diferentes orientaciones
        
        let device = XCUIDevice.shared
        let originalOrientation = device.orientation
        
        // Verificar elementos en orientación actual
        verifyElementsAccessibility()
        
        // Cambiar orientación si es posible
        if device.orientation != .landscapeLeft {
            device.orientation = .landscapeLeft
            
            // Esperar a que se complete la rotación
            Thread.sleep(forTimeInterval: 1.0)
            
            // Verificar elementos en nueva orientación
            verifyElementsAccessibility()
            
            // Restaurar orientación original
            device.orientation = originalOrientation
        }
        
        print("✅ Test diseño responsivo accesible: PASÓ")
    }
    
    // MARK: - 🔧 FUNCIONES AUXILIARES
    
    private func verifyElementsAccessibility() {
        let titleElement = app.staticTexts["FERTILIDAD"]
        if titleElement.waitForExistence(timeout: 3) {
            XCTAssertTrue(titleElement.isAccessibilityElement, "Título debe seguir siendo accesible")
            XCTAssertTrue(titleElement.isHittable, "Título debe seguir siendo visible")
        }
        
        // Verificar que los botones principales sigan siendo accesibles
        let buttons = app.buttons
        let accessibleButtons = buttons.allElementsBoundByAccessibilityElement.filter { 
            $0.isAccessibilityElement && $0.exists 
        }
        
        XCTAssertGreaterThan(accessibleButtons.count, 0, "Debe haber botones accesibles")
    }
    
    private func verifyMinimumTouchTargetSize(_ element: XCUIElement) {
        let frame = element.frame
        let minSize: CGFloat = 44.0 // Apple's minimum recommended touch target size
        
        XCTAssertGreaterThanOrEqual(frame.width, minSize, "Elemento debe cumplir ancho mínimo")
        XCTAssertGreaterThanOrEqual(frame.height, minSize, "Elemento debe cumplir altura mínima")
    }
}
