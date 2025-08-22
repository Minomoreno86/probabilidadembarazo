//
//  SecurityConfigurationTests.swift
//  Pronostico fertilidadTests
//
//  Tests unitarios para SecurityConfiguration
//

import XCTest
@testable import Pronostico_fertilidad

final class SecurityConfigurationTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Setup para cada test
    }
    
    override func tearDownWithError() throws {
        // Cleanup después de cada test
    }
    
    // MARK: - 🔐 TESTS DE POLÍTICAS DE AUTENTICACIÓN
    
    func testAuthenticationPolicies() throws {
        // Test de políticas de autenticación
        XCTAssertEqual(SecurityConfiguration.sessionTimeout, 1800, "El timeout de sesión debe ser 30 minutos")
        XCTAssertEqual(SecurityConfiguration.maxFailedAuthAttempts, 5, "El máximo de intentos fallidos debe ser 5")
        XCTAssertEqual(SecurityConfiguration.lockoutDuration, 900, "La duración de bloqueo debe ser 15 minutos")
        
        // Verificar que los valores son razonables para aplicaciones médicas
        XCTAssertLessThan(SecurityConfiguration.sessionTimeout, 3600, "El timeout de sesión debe ser menor a 1 hora para seguridad médica")
        XCTAssertLessThan(SecurityConfiguration.maxFailedAuthAttempts, 10, "El máximo de intentos debe ser menor a 10 para seguridad médica")
    }
    
    // MARK: - 🔒 TESTS DE POLÍTICAS DE DATOS MÉDICOS
    
    func testMedicalDataPolicies() throws {
        // Test de políticas de datos médicos
        XCTAssertEqual(SecurityConfiguration.medicalDataProtectionLevel, .complete, "El nivel de protección debe ser completo")
        XCTAssertEqual(SecurityConfiguration.medicalDataRetentionDays, 2555, "La retención debe ser 7 años")
        XCTAssertTrue(SecurityConfiguration.requireBiometricForMedicalData, "Debe requerir autenticación biométrica")
        
        // Verificar que cumple con estándares médicos
        XCTAssertGreaterThan(SecurityConfiguration.medicalDataRetentionDays, 1800, "La retención debe ser al menos 5 años")
    }
    
    // MARK: - 🔐 TESTS DE POLÍTICAS DE ENCRIPTACIÓN
    
    func testEncryptionPolicies() throws {
        // Test de políticas de encriptación
        XCTAssertEqual(SecurityConfiguration.encryptionAlgorithm, "AES-256-GCM", "El algoritmo debe ser AES-256-GCM")
        XCTAssertEqual(SecurityConfiguration.encryptionKeySize, 256, "El tamaño de clave debe ser 256 bits")
        XCTAssertTrue(SecurityConfiguration.autoRotateEncryptionKeys, "Debe rotar claves automáticamente")
        XCTAssertEqual(SecurityConfiguration.keyRotationIntervalDays, 90, "La rotación debe ser cada 90 días")
        
        // Verificar que cumple con estándares de seguridad
        XCTAssertGreaterThanOrEqual(SecurityConfiguration.encryptionKeySize, 256, "El tamaño de clave debe ser al menos 256 bits")
        XCTAssertLessThanOrEqual(SecurityConfiguration.keyRotationIntervalDays, 365, "La rotación debe ser al menos anual")
    }
    
    // MARK: - 📱 TESTS DE POLÍTICAS DEL DISPOSITIVO
    
    func testDevicePolicies() throws {
        // Test de políticas del dispositivo
        XCTAssertFalse(SecurityConfiguration.allowSimulatorUsage, "No debe permitir uso en simulador")
        XCTAssertTrue(SecurityConfiguration.requireDevicePasscode, "Debe requerir código de acceso")
        XCTAssertTrue(SecurityConfiguration.requireBiometricAuthentication, "Debe requerir autenticación biométrica")
        XCTAssertFalse(SecurityConfiguration.allowJailbrokenDevice, "No debe permitir dispositivos jailbreak")
        
        // Verificar que las políticas son estrictas para datos médicos
        XCTAssertFalse(SecurityConfiguration.allowSimulatorUsage, "El simulador no debe permitirse para datos médicos")
        XCTAssertTrue(SecurityConfiguration.requireDevicePasscode, "Debe requerir código de acceso para datos médicos")
    }
    
    // MARK: - 🔍 TESTS DE POLÍTICAS DE AUDITORÍA
    
    func testAuditPolicies() throws {
        // Test de políticas de auditoría
        XCTAssertTrue(SecurityConfiguration.enableAuditLogging, "Debe habilitar logging de auditoría")
        XCTAssertEqual(SecurityConfiguration.auditLogLevel, .detailed, "El nivel debe ser detallado")
        XCTAssertEqual(SecurityConfiguration.auditLogRetentionDays, 90, "La retención debe ser 90 días")
        XCTAssertTrue(SecurityConfiguration.encryptAuditLogs, "Debe encriptar logs de auditoría")
        
        // Verificar que cumple con regulaciones médicas
        XCTAssertTrue(SecurityConfiguration.enableAuditLogging, "El logging de auditoría es obligatorio para aplicaciones médicas")
        XCTAssertGreaterThanOrEqual(SecurityConfiguration.auditLogRetentionDays, 30, "La retención debe ser al menos 30 días")
    }
    
    // MARK: - 🌐 TESTS DE POLÍTICAS DE RED
    
    func testNetworkPolicies() throws {
        // Test de políticas de red
        XCTAssertFalse(SecurityConfiguration.allowInsecureConnections, "No debe permitir conexiones HTTP")
        XCTAssertTrue(SecurityConfiguration.requireValidSSLCertificates, "Debe requerir certificados SSL válidos")
        XCTAssertFalse(SecurityConfiguration.allowSelfSignedCertificates, "No debe permitir certificados autofirmados")
        
        // Verificar que cumple con estándares de seguridad de red
        XCTAssertFalse(SecurityConfiguration.allowInsecureConnections, "Las conexiones inseguras no son permitidas para datos médicos")
        XCTAssertTrue(SecurityConfiguration.requireValidSSLCertificates, "Los certificados SSL válidos son obligatorios")
    }
    
    // MARK: - 📊 TESTS DE POLÍTICAS DE PRIVACIDAD
    
    func testPrivacyPolicies() throws {
        // Test de políticas de privacidad
        XCTAssertFalse(SecurityConfiguration.collectUsageAnalytics, "No debe recopilar analytics de uso")
        XCTAssertFalse(SecurityConfiguration.shareDataWithThirdParties, "No debe compartir datos con terceros")
        XCTAssertFalse(SecurityConfiguration.allowUserTracking, "No debe permitir tracking de usuario")
        XCTAssertTrue(SecurityConfiguration.requireExplicitMedicalDataConsent, "Debe requerir consentimiento explícito")
        
        // Verificar que cumple con GDPR y regulaciones de privacidad
        XCTAssertFalse(SecurityConfiguration.shareDataWithThirdParties, "No compartir con terceros es requerido por GDPR")
        XCTAssertTrue(SecurityConfiguration.requireExplicitMedicalDataConsent, "El consentimiento explícito es requerido por GDPR")
    }
    
    // MARK: - 🚨 TESTS DE POLÍTICAS DE INCIDENTES
    
    func testIncidentPolicies() throws {
        // Test de políticas de incidentes
        XCTAssertTrue(SecurityConfiguration.autoNotifySecurityIncidents, "Debe notificar incidentes automáticamente")
        XCTAssertEqual(SecurityConfiguration.criticalIncidentThreshold, 3, "El umbral de incidentes críticos debe ser 3")
        XCTAssertEqual(SecurityConfiguration.criticalIncidentResponseTimeMinutes, 15, "El tiempo de respuesta debe ser 15 minutos")
        
        // Verificar que las políticas son apropiadas para aplicaciones médicas
        XCTAssertTrue(SecurityConfiguration.autoNotifySecurityIncidents, "La notificación automática es crítica para aplicaciones médicas")
        XCTAssertLessThanOrEqual(SecurityConfiguration.criticalIncidentResponseTimeMinutes, 30, "El tiempo de respuesta debe ser rápido")
    }
    
    // MARK: - 🔧 TESTS DE POLÍTICAS DE DESARROLLO
    
    func testDevelopmentPolicies() throws {
        // Test de políticas de desarrollo
        XCTAssertFalse(SecurityConfiguration.enableDebugModeInProduction, "No debe habilitar modo debug en producción")
        XCTAssertFalse(SecurityConfiguration.showSensitiveInfoInLogs, "No debe mostrar información sensible en logs")
        XCTAssertFalse(SecurityConfiguration.allowDeveloperConsoleAccess, "No debe permitir acceso a consola de desarrollo")
        XCTAssertFalse(SecurityConfiguration.enableHotReloadInProduction, "No debe habilitar hot reload en producción")
        
        // Verificar que las políticas son estrictas para producción
        XCTAssertFalse(SecurityConfiguration.enableDebugModeInProduction, "El modo debug no debe estar habilitado en producción")
        XCTAssertFalse(SecurityConfiguration.showSensitiveInfoInLogs, "La información sensible no debe aparecer en logs")
    }
    
    // MARK: - 🏷️ TESTS DE ENUMERACIONES
    
    func testDataProtectionLevelEnum() throws {
        // Test de enumeración DataProtectionLevel
        let levels = DataProtectionLevel.allCases
        XCTAssertEqual(levels.count, 4, "Debe haber 4 niveles de protección")
        
        // Verificar descripciones
        XCTAssertEqual(DataProtectionLevel.none.description, "Sin protección")
        XCTAssertEqual(DataProtectionLevel.complete.description, "Protección completa")
        XCTAssertEqual(DataProtectionLevel.completeUnlessOpen.description, "Protección completa a menos que esté abierta")
        XCTAssertEqual(DataProtectionLevel.completeUntilFirstUserAuthentication.description, "Protección completa hasta primera autenticación")
    }
    
    func testAuditLogLevelEnum() throws {
        // Test de enumeración AuditLogLevel
        let levels = AuditLogLevel.allCases
        XCTAssertEqual(levels.count, 4, "Debe haber 4 niveles de logging")
        
        // Verificar descripciones
        XCTAssertEqual(AuditLogLevel.minimal.description, "Mínimo - Solo eventos críticos")
        XCTAssertEqual(AuditLogLevel.basic.description, "Básico - Eventos importantes")
        XCTAssertEqual(AuditLogLevel.detailed.description, "Detallado - Todos los eventos")
        XCTAssertEqual(AuditLogLevel.verbose.description, "Verboso - Información completa")
    }
    
    // MARK: - 🔐 TESTS DE VALIDACIÓN DE CONFIGURACIÓN
    
    func testConfigurationValidation() throws {
        // Test de validación de configuración
        let issues = SecurityConfiguration.validateConfiguration()
        
        // Verificar que la validación funciona
        XCTAssertNotNil(issues, "La validación debe retornar una lista de problemas")
        
        // Verificar que no hay problemas críticos
        let criticalIssues = issues.filter { $0.severity == .critical }
        XCTAssertEqual(criticalIssues.count, 0, "No debe haber problemas críticos en la configuración")
        
        // Verificar que la configuración es segura (puede no haber problemas)
        XCTAssertGreaterThanOrEqual(issues.count, 0, "La configuración puede ser perfecta o tener problemas menores")
        
        // Verificar que si hay problemas, no son críticos
        for issue in issues {
            XCTAssertNotEqual(issue.severity, .critical, "No debe haber problemas críticos")
        }
    }
    
    func testHIPAACompliance() throws {
        // Test de cumplimiento HIPAA
        let isHIPAACompliant = SecurityConfiguration.isHIPAACompliant()
        
        // Verificar que cumple con HIPAA
        XCTAssertTrue(isHIPAACompliant, "La configuración debe cumplir con HIPAA")
        
        // Verificar que no hay problemas críticos
        let issues = SecurityConfiguration.validateConfiguration()
        let criticalIssues = issues.filter { $0.severity == .critical }
        XCTAssertEqual(criticalIssues.count, 0, "No debe haber problemas críticos para cumplir con HIPAA")
    }
    
    func testGDPRCompliance() throws {
        // Test de cumplimiento GDPR
        let isGDPRCompliant = SecurityConfiguration.isGDPRCompliant()
        
        // Verificar que cumple con GDPR
        XCTAssertTrue(isGDPRCompliant, "La configuración debe cumplir con GDPR")
        
        // Verificar políticas específicas de GDPR
        XCTAssertTrue(SecurityConfiguration.requireExplicitMedicalDataConsent, "El consentimiento explícito es requerido por GDPR")
        XCTAssertFalse(SecurityConfiguration.shareDataWithThirdParties, "No compartir con terceros es requerido por GDPR")
        XCTAssertFalse(SecurityConfiguration.allowUserTracking, "No permitir tracking es requerido por GDPR")
    }
    
    // MARK: - 📋 TESTS DE MODELO DE PROBLEMA DE VALIDACIÓN
    
    func testSecurityValidationIssue() throws {
        // Test del modelo SecurityValidationIssue
        let issue = SecurityValidationIssue(
            severity: .high,
            category: .encryption,
            message: "Test issue message",
            recommendation: "Test recommendation"
        )
        
        // Verificar propiedades
        XCTAssertEqual(issue.severity, .high, "La severidad debe ser alta")
        XCTAssertEqual(issue.category, .encryption, "La categoría debe ser encriptación")
        XCTAssertEqual(issue.message, "Test issue message", "El mensaje debe coincidir")
        XCTAssertEqual(issue.recommendation, "Test recommendation", "La recomendación debe coincidir")
        XCTAssertFalse(issue.isCritical, "No debe ser crítico")
    }
    
    func testSecurityIssueSeverityEnum() throws {
        // Test de enumeración SecurityIssueSeverity
        let severities = SecurityIssueSeverity.allCases
        XCTAssertEqual(severities.count, 4, "Debe haber 4 niveles de severidad")
        
        // Verificar que critical es crítico
        let criticalIssue = SecurityValidationIssue(
            severity: .critical,
            category: .authentication,
            message: "Critical issue",
            recommendation: "Fix immediately"
        )
        XCTAssertTrue(criticalIssue.isCritical, "Los problemas críticos deben marcarse como críticos")
    }
    
    func testSecurityIssueCategoryEnum() throws {
        // Test de enumeración SecurityIssueCategory
        let categories = SecurityIssueCategory.allCases
        XCTAssertEqual(categories.count, 7, "Debe haber 7 categorías")
        
        // Verificar descripciones
        XCTAssertEqual(SecurityIssueCategory.authentication.description, "Autenticación")
        XCTAssertEqual(SecurityIssueCategory.encryption.description, "Encriptación")
        XCTAssertEqual(SecurityIssueCategory.auditing.description, "Auditoría")
        XCTAssertEqual(SecurityIssueCategory.device.description, "Dispositivo")
        XCTAssertEqual(SecurityIssueCategory.network.description, "Red")
        XCTAssertEqual(SecurityIssueCategory.privacy.description, "Privacidad")
        XCTAssertEqual(SecurityIssueCategory.development.description, "Desarrollo")
    }
    
    // MARK: - 🚨 TESTS DE CASOS EXTREMOS
    
    func testEmptyConfigurationValidation() throws {
        // Test de validación con configuración mínima
        // Este test verifica que la validación funciona incluso con configuraciones básicas
        
        let issues = SecurityConfiguration.validateConfiguration()
        XCTAssertNotNil(issues, "La validación debe funcionar con cualquier configuración")
    }
    
    func testAllSeverityLevels() throws {
        // Test de todos los niveles de severidad
        let severities: [SecurityIssueSeverity] = [.low, .medium, .high, .critical]
        
        for severity in severities {
            let issue = SecurityValidationIssue(
                severity: severity,
                category: .authentication,
                message: "Test \(severity)",
                recommendation: "Fix \(severity)"
            )
            
            XCTAssertEqual(issue.severity, severity, "La severidad debe coincidir")
            XCTAssertNotNil(issue.severity, "Cada severidad debe ser válida")
        }
    }
    
    func testAllCategories() throws {
        // Test de todas las categorías
        let categories: [SecurityIssueCategory] = [
            .authentication, .encryption, .auditing, .device, .network, .privacy, .development
        ]
        
        for category in categories {
            let issue = SecurityValidationIssue(
                severity: .medium,
                category: category,
                message: "Test \(category)",
                recommendation: "Fix \(category)"
            )
            
            XCTAssertEqual(issue.category, category, "La categoría debe coincidir")
            XCTAssertFalse(issue.category.description.isEmpty, "Cada categoría debe tener una descripción")
        }
    }
}
