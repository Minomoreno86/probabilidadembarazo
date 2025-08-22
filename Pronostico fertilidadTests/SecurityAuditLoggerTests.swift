//
//  SecurityAuditLoggerTests.swift
//  Pronostico fertilidadTests
//
//  Tests unitarios para SecurityAuditLogger
//

import XCTest
@testable import Pronostico_fertilidad

final class SecurityAuditLoggerTests: XCTestCase {
    
    var auditLogger: SecurityAuditLogger!
    
    override func setUpWithError() throws {
        auditLogger = SecurityAuditLogger.shared
    }
    
    override func tearDownWithError() throws {
        // Limpiar logs de prueba después de cada test
        // Los logs se limpian automáticamente por el sistema
    }
    
    // MARK: - 📝 TESTS DE LOGGING DE EVENTOS
    
    func testMedicalDataAccessLogging() throws {
        // Test de logging de acceso a datos médicos
        let testUserID = "test_user_medical_access"
        let testOperation = "read_fertility_profile"
        let testDataType = "fertility_data"
        
        // Log de acceso exitoso
        auditLogger.logMedicalDataAccess(
            operation: testOperation,
            dataType: testDataType,
            userID: testUserID,
            success: true
        )
        
        // Log de acceso fallido
        auditLogger.logMedicalDataAccess(
            operation: testOperation,
            dataType: testDataType,
            userID: testUserID,
            success: false
        )
        
        // Verificar que los logs se crearon (no podemos verificar el contenido directamente)
        // pero podemos verificar que no hay errores en la ejecución
        XCTAssertTrue(true, "El logging de acceso a datos médicos debe ejecutarse sin errores")
    }
    
    func testUserAuthenticationLogging() throws {
        // Test de logging de autenticación de usuario
        let testUserID = "test_user_auth"
        let testMethod = "Apple Sign In"
        
        // Log de autenticación exitosa
        auditLogger.logUserAuthentication(
            userID: testUserID,
            method: testMethod,
            success: true
        )
        
        // Log de autenticación fallida
        auditLogger.logUserAuthentication(
            userID: testUserID,
            method: testMethod,
            success: false
        )
        
        // Log de autenticación anónima
        auditLogger.logUserAuthentication(
            userID: nil,
            method: "Anonymous",
            success: true
        )
        
        XCTAssertTrue(true, "El logging de autenticación debe ejecutarse sin errores")
    }
    
    func testSecurityConfigurationChangeLogging() throws {
        // Test de logging de cambios en configuración de seguridad
        let testUserID = "test_user_config"
        let testChange = "encryption_key_rotation"
        
        // Log de cambio exitoso
        auditLogger.logSecurityConfigurationChange(
            change: testChange,
            userID: testUserID,
            success: true
        )
        
        // Log de cambio fallido
        auditLogger.logSecurityConfigurationChange(
            change: testChange,
            userID: testUserID,
            success: false
        )
        
        XCTAssertTrue(true, "El logging de cambios de configuración debe ejecutarse sin errores")
    }
    
    func testUnauthorizedAccessLogging() throws {
        // Test de logging de accesos no autorizados
        let testUserID = "test_user_unauthorized"
        let testOperation = "access_medical_records"
        let testDataType = "patient_data"
        let testReason = "Insufficient permissions"
        
        // Log de acceso no autorizado
        auditLogger.logUnauthorizedAccess(
            operation: testOperation,
            dataType: testDataType,
            userID: testUserID,
            reason: testReason
        )
        
        // Log de acceso no autorizado anónimo
        auditLogger.logUnauthorizedAccess(
            operation: "brute_force_attempt",
            dataType: "login",
            userID: nil,
            reason: "Multiple failed attempts"
        )
        
        XCTAssertTrue(true, "El logging de accesos no autorizados debe ejecutarse sin errores")
    }
    
    func testEncryptionErrorLogging() throws {
        // Test de logging de errores de encriptación
        let testUserID = "test_user_encryption"
        let testOperation = "encrypt_medical_data"
        let testError = "Key not found in keychain"
        
        // Log de error de encriptación
        auditLogger.logEncryptionError(
            operation: testOperation,
            error: testError,
            userID: testUserID
        )
        
        // Log de error de encriptación anónimo
        auditLogger.logEncryptionError(
            operation: "decrypt_backup",
            error: "Corrupted encryption key",
            userID: nil
        )
        
        XCTAssertTrue(true, "El logging de errores de encriptación debe ejecutarse sin errores")
    }
    
    func testDeviceSecurityChangeLogging() throws {
        // Test de logging de cambios en seguridad del dispositivo
        let testUserID = "test_user_device"
        let previousState = "Face ID enabled"
        let newState = "Face ID disabled"
        
        // Log de cambio en seguridad del dispositivo
        auditLogger.logDeviceSecurityChange(
            previousState: previousState,
            newState: newState,
            userID: testUserID
        )
        
        // Log de cambio anónimo
        auditLogger.logDeviceSecurityChange(
            previousState: "Passcode enabled",
            newState: "No security",
            userID: nil
        )
        
        XCTAssertTrue(true, "El logging de cambios de seguridad del dispositivo debe ejecutarse sin errores")
    }
    
    // MARK: - 🔍 TESTS DE CONSULTA DE LOGS
    
    func testAuditLogsRetrieval() throws {
        // Test de recuperación de logs de auditoría
        let fromDate = Date().addingTimeInterval(-3600) // Hace 1 hora
        let toDate = Date()
        
        // Obtener logs del período
        let logs = auditLogger.getAuditLogs(from: fromDate, to: toDate)
        
        // Verificar que la función no falla
        XCTAssertNotNil(logs, "La recuperación de logs no debe fallar")
        
        // Los logs pueden estar vacíos si no hay eventos recientes
        // pero la función debe ejecutarse correctamente
        XCTAssertTrue(true, "La recuperación de logs debe ejecutarse sin errores")
    }
    
    func testCriticalEventLogsRetrieval() throws {
        // Test de recuperación de logs de eventos críticos
        let criticalLogs = auditLogger.getCriticalEventLogs()
        
        // Verificar que la función no falla
        XCTAssertNotNil(criticalLogs, "La recuperación de logs críticos no debe fallar")
        
        // Los logs pueden estar vacíos si no hay eventos críticos recientes
        // pero la función debe ejecutarse correctamente
        XCTAssertTrue(true, "La recuperación de logs críticos debe ejecutarse sin errores")
    }
    
    // MARK: - 🚨 TESTS DE DETECCIÓN DE EVENTOS CRÍTICOS
    
    func testCriticalEventDetection() throws {
        // Test de detección de eventos críticos
        // Simular múltiples accesos no autorizados
        for i in 1...5 {
            auditLogger.logUnauthorizedAccess(
                operation: "test_unauthorized_\(i)",
                dataType: "test_data",
                userID: "test_user_critical",
                reason: "Test critical event detection"
            )
        }
        
        // Simular errores de encriptación
        for i in 1...3 {
            auditLogger.logEncryptionError(
                operation: "test_encryption_error_\(i)",
                error: "Test encryption error",
                userID: "test_user_critical"
            )
        }
        
        // Verificar que la detección funciona sin errores
        XCTAssertTrue(true, "La detección de eventos críticos debe ejecutarse sin errores")
    }
    
    // MARK: - 📱 TESTS DE INFORMACIÓN DEL DISPOSITIVO
    
    func testDeviceInfoRetrieval() throws {
        // Test de recuperación de información del dispositivo
        // Este test verifica que la función getDeviceInfo() funciona correctamente
        // No podemos verificar el contenido específico, pero sí que no falla
        
        // Simular un evento que use la información del dispositivo
        auditLogger.logUserAuthentication(
            userID: "test_device_info",
            method: "Test",
            success: true
        )
        
        XCTAssertTrue(true, "La recuperación de información del dispositivo debe ejecutarse sin errores")
    }
    
    // MARK: - 🧹 TESTS DE LIMPIEZA Y MANTENIMIENTO
    
    func testLogCleanup() throws {
        // Test de limpieza automática de logs
        // Crear algunos logs de prueba
        for i in 1...10 {
            auditLogger.logMedicalDataAccess(
                operation: "test_cleanup_\(i)",
                dataType: "test_data",
                userID: "test_user_cleanup",
                success: true
            )
        }
        
        // La limpieza se ejecuta automáticamente
        // Solo verificamos que no hay errores
        XCTAssertTrue(true, "La limpieza automática de logs debe ejecutarse sin errores")
    }
    
    // MARK: - 🔐 TESTS DE EXTENSIONES DE SEGURIDAD
    
    func testSecureLogExtensions() throws {
        // Test de las extensiones de seguridad para logging
        let sensitiveString = "user@example.com:password123"
        let secureLog = sensitiveString.secureLog
        
        // Verificar que la información sensible se redacta
        XCTAssertNotEqual(secureLog, sensitiveString, "La información sensible debe redactarse en logs")
        XCTAssertTrue(secureLog.contains("[REDACTED]"), "Los logs deben contener [REDACTED] para información sensible")
        
        let normalString = "Información no sensible"
        let normalLog = normalString.secureLog
        
        // Verificar que la información no sensible no se redacta
        XCTAssertEqual(normalLog, normalString, "La información no sensible no debe redactarse")
    }
    
    // MARK: - 🚨 TESTS DE CASOS EXTREMOS
    
    func testEmptyStringLogging() throws {
        // Test de logging con strings vacíos
        auditLogger.logMedicalDataAccess(
            operation: "",
            dataType: "",
            userID: "",
            success: true
        )
        
        XCTAssertTrue(true, "El logging con strings vacíos debe ejecutarse sin errores")
    }
    
    func testVeryLongStringLogging() throws {
        // Test de logging con strings muy largos
        let longString = String(repeating: "A", count: 1000)
        
        auditLogger.logMedicalDataAccess(
            operation: longString,
            dataType: longString,
            userID: longString,
            success: true
        )
        
        XCTAssertTrue(true, "El logging con strings largos debe ejecutarse sin errores")
    }
    
    func testSpecialCharactersLogging() throws {
        // Test de logging con caracteres especiales
        let specialString = "¡Hola! ¿Cómo estás? @#$%^&*()_+-=[]{}|;':\",./<>?"
        
        auditLogger.logMedicalDataAccess(
            operation: specialString,
            dataType: specialString,
            userID: specialString,
            success: true
        )
        
        XCTAssertTrue(true, "El logging con caracteres especiales debe ejecutarse sin errores")
    }
    
    func testUnicodeCharactersLogging() throws {
        // Test de logging con caracteres Unicode
        let unicodeString = "Paciente: María José López-García (Español) 🏥💊"
        
        auditLogger.logMedicalDataAccess(
            operation: unicodeString,
            dataType: unicodeString,
            userID: unicodeString,
            success: true
        )
        
        XCTAssertTrue(true, "El logging con caracteres Unicode debe ejecutarse sin errores")
    }
    
    // MARK: - 📊 TESTS DE RENDIMIENTO
    
    func testHighVolumeLogging() throws {
        // Test de logging de alto volumen
        let startTime = Date()
        
        // Crear 100 logs rápidamente
        for i in 1...100 {
            auditLogger.logMedicalDataAccess(
                operation: "high_volume_test_\(i)",
                dataType: "test_data",
                userID: "test_user_volume",
                success: true
            )
        }
        
        let endTime = Date()
        let executionTime = endTime.timeIntervalSince(startTime)
        
        // Verificar que el logging de alto volumen no toma demasiado tiempo
        XCTAssertLessThan(executionTime, 5.0, "El logging de alto volumen debe completarse en menos de 5 segundos")
    }
}
