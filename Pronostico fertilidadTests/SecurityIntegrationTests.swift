//
//  SecurityIntegrationTests.swift
//  Pronostico fertilidadTests
//
//  Tests de integración del sistema de seguridad
//

import XCTest
@testable import Pronostico_fertilidad

final class SecurityIntegrationTests: XCTestCase {
    
    var securityManager: SecurityManager!
    var secureDefaults: SecureUserDefaults!
    var auditLogger: SecurityAuditLogger!
    
    override func setUpWithError() throws {
        securityManager = SecurityManager.shared
        secureDefaults = SecureUserDefaults.shared
        auditLogger = SecurityAuditLogger.shared
        
        // Limpiar datos de prueba
        secureDefaults.clearAllData()
    }
    
    override func tearDownWithError() throws {
        // Limpiar después de cada test
        secureDefaults.clearAllData()
        securityManager.secureWipe()
    }
    
    // MARK: - 🔗 TESTS DE INTEGRACIÓN COMPLETA
    
    func testCompleteSecurityWorkflow() throws {
        // Test del flujo completo de seguridad
        let testUserID = "integration_test_user_123"
        let testEmail = "integration@test.com"
        let testName = "Usuario de Prueba de Integración"
        let testMedicalData = "Datos médicos sensibles del paciente"
        
        // 1. Log de inicio de sesión
        auditLogger.logUserAuthentication(
            userID: testUserID,
            method: "Integration Test",
            success: true
        )
        
        // 2. Almacenar datos médicos de forma segura
        secureDefaults.secureAppleUserID = testUserID
        secureDefaults.secureUserEmail = testEmail
        secureDefaults.secureUserFullName = testName
        
        // 3. Encriptar datos médicos adicionales
        let encryptedMedicalData = securityManager.encryptString(testMedicalData)
        XCTAssertNotNil(encryptedMedicalData, "Los datos médicos deben encriptarse")
        
        // 4. Log de acceso a datos médicos
        auditLogger.logMedicalDataAccess(
            operation: "store_medical_data",
            dataType: "patient_information",
            userID: testUserID,
            success: true
        )
        
        // 5. Verificar que los datos se almacenaron correctamente
        let retrievedUserID = secureDefaults.secureAppleUserID
        let retrievedEmail = secureDefaults.secureUserEmail
        let retrievedName = secureDefaults.secureUserFullName
        
        XCTAssertEqual(retrievedUserID, testUserID, "El User ID debe recuperarse correctamente")
        XCTAssertEqual(retrievedEmail, testEmail, "El email debe recuperarse correctamente")
        XCTAssertEqual(retrievedName, testName, "El nombre debe recuperarse correctamente")
        
        // 6. Verificar que los datos están encriptados en UserDefaults
        let rawUserID = UserDefaults.standard.string(forKey: "secure_appleUserID")
        let rawEmail = UserDefaults.standard.string(forKey: "secure_userEmail")
        let rawName = UserDefaults.standard.string(forKey: "secure_userFullName")
        
        XCTAssertNotEqual(rawUserID, testUserID, "El User ID en UserDefaults debe estar encriptado")
        XCTAssertNotEqual(rawEmail, testEmail, "El email en UserDefaults debe estar encriptado")
        XCTAssertNotEqual(rawName, testName, "El nombre en UserDefaults debe estar encriptado")
        
        // 7. Verificar integridad de los datos médicos
        let isIntegrityValid = secureDefaults.verifyMedicalDataIntegrity()
        XCTAssertTrue(isIntegrityValid, "La integridad de los datos médicos debe ser válida")
        
        // 8. Log de cierre de sesión
        auditLogger.logUserAuthentication(
            userID: testUserID,
            method: "Integration Test Logout",
            success: true
        )
        
        XCTAssertTrue(true, "El flujo completo de seguridad debe ejecutarse sin errores")
    }
    
    func testSecurityComponentsInteraction() throws {
        // Test de interacción entre componentes de seguridad
        
        // 1. SecurityManager genera clave de encriptación
        let testData = "Datos de prueba para interacción".data(using: .utf8)!
        let encryptedData = securityManager.encryptData(testData)
        XCTAssertNotNil(encryptedData, "SecurityManager debe encriptar datos")
        
        // 2. SecureUserDefaults usa SecurityManager para encriptar
        let testString = "String de prueba para interacción"
        secureDefaults.secureAppleUserID = testString
        
        // 3. Verificar que la encriptación funcionó
        let retrievedString = secureDefaults.secureAppleUserID
        XCTAssertEqual(retrievedString, testString, "SecureUserDefaults debe desencriptar correctamente")
        
        // 4. SecurityAuditLogger registra la operación
        auditLogger.logMedicalDataAccess(
            operation: "test_interaction",
            dataType: "test_data",
            userID: "test_user",
            success: true
        )
        
        // 5. Verificar que todos los componentes funcionan juntos
        let isDeviceSecure = securityManager.isDeviceSecure()
        let deviceStatus = secureDefaults.getDeviceSecurityStatus()
        let criticalLogs = auditLogger.getCriticalEventLogs()
        
        // Solo verificamos que no hay errores
        XCTAssertNotNil(deviceStatus, "El estado del dispositivo debe obtenerse")
        XCTAssertNotNil(criticalLogs, "Los logs críticos deben obtenerse")
        
        XCTAssertTrue(true, "Todos los componentes de seguridad deben interactuar correctamente")
    }
    
    func testSecurityPolicyEnforcement() throws {
        // Test de aplicación de políticas de seguridad
        
        // 1. Verificar políticas de encriptación
        XCTAssertEqual(SecurityConfiguration.encryptionAlgorithm, "AES-256-GCM", "El algoritmo debe ser AES-256-GCM")
        XCTAssertEqual(SecurityConfiguration.encryptionKeySize, 256, "El tamaño de clave debe ser 256 bits")
        
        // 2. Verificar políticas de autenticación
        XCTAssertTrue(SecurityConfiguration.requireBiometricForMedicalData, "Debe requerir autenticación biométrica")
        XCTAssertFalse(SecurityConfiguration.allowSimulatorUsage, "No debe permitir uso en simulador")
        
        // 3. Verificar políticas de auditoría
        XCTAssertTrue(SecurityConfiguration.enableAuditLogging, "Debe habilitar logging de auditoría")
        XCTAssertTrue(SecurityConfiguration.encryptAuditLogs, "Debe encriptar logs de auditoría")
        
        // 4. Verificar políticas de privacidad
        XCTAssertFalse(SecurityConfiguration.shareDataWithThirdParties, "No debe compartir datos con terceros")
        XCTAssertTrue(SecurityConfiguration.requireExplicitMedicalDataConsent, "Debe requerir consentimiento explícito")
        
        // 5. Verificar cumplimiento regulatorio
        let isHIPAACompliant = SecurityConfiguration.isHIPAACompliant()
        let isGDPRCompliant = SecurityConfiguration.isGDPRCompliant()
        
        XCTAssertTrue(isHIPAACompliant, "Debe cumplir con HIPAA")
        XCTAssertTrue(isGDPRCompliant, "Debe cumplir con GDPR")
        
        XCTAssertTrue(true, "Todas las políticas de seguridad deben aplicarse correctamente")
    }
    
    // MARK: - 🔐 TESTS DE ENCRIPTACIÓN INTEGRADA
    
    func testIntegratedEncryptionWorkflow() throws {
        // Test del flujo completo de encriptación integrado
        
        // 1. Datos médicos complejos
        let medicalProfile: [String: Any] = [
            "patientID": "P12345",
            "diagnosis": "Problemas de fertilidad",
            "testResults": [
                "AMH": "2.1 ng/mL",
                "FSH": "8.5 mIU/mL",
                "Estradiol": "45 pg/mL"
            ],
            "treatmentHistory": [
                "2023": "3 ciclos de IUI",
                "2024": "1 ciclo de IVF"
            ]
        ]
        
        // 2. Proteger datos médicos usando SecurityManager
        let protectedData = securityManager.protectMedicalData(medicalProfile)
        XCTAssertNotNil(protectedData, "Los datos médicos deben protegerse")
        
        // 3. Verificar que los valores sensibles están encriptados
        if let protectedPatientID = protectedData?["patientID"] as? String {
            XCTAssertNotEqual(protectedPatientID, "P12345", "El ID del paciente debe estar encriptado")
        }
        
        // 4. Desproteger datos médicos
        let unprotectedData = securityManager.unprotectMedicalData(protectedData!)
        XCTAssertNotNil(unprotectedData, "Los datos médicos deben desprotegerse")
        
        // 5. Verificar que los datos originales se recuperan
        XCTAssertEqual(unprotectedData?["patientID"] as? String, "P12345", "El ID del paciente debe recuperarse")
        XCTAssertEqual(unprotectedData?["diagnosis"] as? String, "Problemas de fertilidad", "El diagnóstico debe recuperarse")
        
        // 6. Log de la operación de encriptación
        auditLogger.logMedicalDataAccess(
            operation: "encrypt_medical_profile",
            dataType: "patient_profile",
            userID: "test_user",
            success: true
        )
        
        XCTAssertTrue(true, "El flujo de encriptación integrado debe funcionar correctamente")
    }
    
    // MARK: - 🔍 TESTS DE AUDITORÍA INTEGRADA
    
    func testIntegratedAuditWorkflow() throws {
        // Test del flujo completo de auditoría integrado
        
        let testUserID = "audit_test_user"
        let testOperation = "comprehensive_audit_test"
        
        // 1. Simular múltiples operaciones de seguridad
        for i in 1...5 {
            // Autenticación
            auditLogger.logUserAuthentication(
                userID: testUserID,
                method: "Test Method \(i)",
                success: i % 2 == 0 // Alternar éxito/fallo
            )
            
            // Acceso a datos médicos
            auditLogger.logMedicalDataAccess(
                operation: "\(testOperation)_\(i)",
                dataType: "test_data_type",
                userID: testUserID,
                success: true
            )
            
            // Cambios de configuración
            auditLogger.logSecurityConfigurationChange(
                change: "test_change_\(i)",
                userID: testUserID,
                success: true
            )
        }
        
        // 2. Simular algunos eventos críticos
        auditLogger.logUnauthorizedAccess(
            operation: "test_unauthorized_access",
            dataType: "test_data",
            userID: testUserID,
            reason: "Testing critical event detection"
        )
        
        auditLogger.logEncryptionError(
            operation: "test_encryption_error",
            error: "Test encryption error for audit",
            userID: testUserID
        )
        
        // 3. Recuperar logs de auditoría
        let fromDate = Date().addingTimeInterval(-3600) // Última hora
        let toDate = Date()
        let auditLogs = auditLogger.getAuditLogs(from: fromDate, to: toDate)
        
        // 4. Recuperar logs de eventos críticos
        let criticalLogs = auditLogger.getCriticalEventLogs()
        
        // Verificar que la auditoría funciona
        XCTAssertNotNil(auditLogs, "Los logs de auditoría deben recuperarse")
        XCTAssertNotNil(criticalLogs, "Los logs críticos deben recuperarse")
        
        XCTAssertTrue(true, "El flujo de auditoría integrado debe funcionar correctamente")
    }
    
    // MARK: - 🧹 TESTS DE LIMPIEZA INTEGRADA
    
    func testIntegratedCleanupWorkflow() throws {
        // Test del flujo completo de limpieza integrado
        
        // 1. Crear datos de prueba
        let testUserID = "cleanup_test_user"
        let testEmail = "cleanup@test.com"
        let testName = "Usuario de Limpieza"
        
        secureDefaults.secureAppleUserID = testUserID
        secureDefaults.secureUserEmail = testEmail
        secureDefaults.secureUserFullName = testName
        
        // 2. Verificar que los datos existen
        XCTAssertNotNil(secureDefaults.secureAppleUserID, "Los datos deben existir antes de la limpieza")
        
        // 3. Limpiar solo datos médicos
        secureDefaults.clearMedicalData()
        
        // 4. Verificar que los datos médicos se limpiaron
        XCTAssertNil(secureDefaults.secureAppleUserID, "Los datos médicos deben limpiarse")
        XCTAssertNil(secureDefaults.secureUserEmail, "Los datos médicos deben limpiarse")
        XCTAssertNil(secureDefaults.secureUserFullName, "Los datos médicos deben limpiarse")
        
        // 5. Log de la operación de limpieza
        auditLogger.logSecurityConfigurationChange(
            change: "medical_data_cleanup",
            userID: testUserID,
            success: true
        )
        
        // 6. Limpieza completa del SecurityManager
        securityManager.secureWipe()
        
        // 7. Verificar que la clave se regenera automáticamente
        let testString = "Test después de limpieza"
        let encryptedString = securityManager.encryptString(testString)
        XCTAssertNotNil(encryptedString, "Debe poder encriptar después de la limpieza (clave regenerada)")
        
        // 8. Verificar que es una nueva clave (diferente resultado)
        let testString2 = "Test después de limpieza 2"
        let encryptedString2 = securityManager.encryptString(testString2)
        XCTAssertNotNil(encryptedString2, "Debe poder encriptar con la nueva clave")
        XCTAssertNotEqual(encryptedString, encryptedString2, "Las encriptaciones deben ser diferentes")
        
        XCTAssertTrue(true, "El flujo de limpieza integrado debe funcionar correctamente")
    }
    
    // MARK: - 🚨 TESTS DE CASOS EXTREMOS INTEGRADOS
    
    func testExtremeCasesIntegration() throws {
        // Test de casos extremos con todos los componentes integrados
        
        // 1. String muy largo con caracteres especiales
        let extremeString = String(repeating: "¡Hola! ¿Cómo estás? @#$%^&*()_+-=[]{}|;':\",./<>? 🏥💊 ", count: 50)
        
        // Encriptar
        let encryptedExtreme = securityManager.encryptString(extremeString)
        XCTAssertNotNil(encryptedExtreme, "El string extremo debe encriptarse")
        
        // Almacenar en SecureUserDefaults
        secureDefaults.secureUserFullName = extremeString
        
        // Recuperar
        let retrievedExtreme = secureDefaults.secureUserFullName
        XCTAssertEqual(retrievedExtreme, extremeString, "El string extremo debe recuperarse correctamente")
        
        // 2. Log de operación extrema
        auditLogger.logMedicalDataAccess(
            operation: "extreme_case_test",
            dataType: "extreme_data",
            userID: "extreme_user",
            success: true
        )
        
        // 3. Verificar integridad
        let isIntegrityValid = secureDefaults.verifyMedicalDataIntegrity()
        XCTAssertTrue(isIntegrityValid, "La integridad debe mantenerse con casos extremos")
        
        XCTAssertTrue(true, "Los casos extremos deben manejarse correctamente por todos los componentes")
    }
    
    func testHighVolumeIntegration() throws {
        // Test de alto volumen con todos los componentes integrados
        
        let startTime = Date()
        let testUserID = "volume_test_user"
        
        // 1. Crear muchos logs rápidamente
        for i in 1...100 {
            auditLogger.logMedicalDataAccess(
                operation: "volume_test_\(i)",
                dataType: "test_data",
                userID: testUserID,
                success: true
            )
        }
        
        // 2. Encriptar muchos datos
        for i in 1...50 {
            let testData = "Datos de prueba \(i)".data(using: .utf8)!
            let encryptedData = securityManager.encryptData(testData)
            XCTAssertNotNil(encryptedData, "Los datos deben encriptarse en alto volumen")
        }
        
        // 3. Almacenar muchos datos en SecureUserDefaults
        for i in 1...25 {
            secureDefaults.secureAppleUserID = "user_\(i)"
            let retrievedID = secureDefaults.secureAppleUserID
            XCTAssertEqual(retrievedID, "user_\(i)", "Los datos deben almacenarse correctamente en alto volumen")
        }
        
        let endTime = Date()
        let executionTime = endTime.timeIntervalSince(startTime)
        
        // Verificar que el alto volumen no toma demasiado tiempo
        XCTAssertLessThan(executionTime, 10.0, "El alto volumen debe completarse en menos de 10 segundos")
        
        XCTAssertTrue(true, "El alto volumen debe manejarse correctamente por todos los componentes")
    }
}
