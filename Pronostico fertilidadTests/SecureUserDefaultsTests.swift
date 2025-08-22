//
//  SecureUserDefaultsTests.swift
//  Pronostico fertilidadTests
//
//  Tests unitarios para SecureUserDefaults
//

import XCTest
@testable import Pronostico_fertilidad

final class SecureUserDefaultsTests: XCTestCase {
    
    var secureDefaults: SecureUserDefaults!
    
    override func setUpWithError() throws {
        secureDefaults = SecureUserDefaults.shared
        // Limpiar datos de prueba antes de cada test
        secureDefaults.clearAllData()
    }
    
    override func tearDownWithError() throws {
        // Limpiar datos después de cada test
        secureDefaults.clearAllData()
    }
    
    // MARK: - 🔐 TESTS DE DATOS MÉDICOS ENCRIPTADOS
    
    func testSecureAppleUserIDStorage() throws {
        // Test de almacenamiento seguro del Apple User ID
        let testUserID = "user_123456789_secure"
        
        // Almacenar
        secureDefaults.secureAppleUserID = testUserID
        
        // Recuperar
        let retrievedUserID = secureDefaults.secureAppleUserID
        XCTAssertEqual(retrievedUserID, testUserID, "El Apple User ID debe recuperarse correctamente")
        
        // Verificar que está encriptado en UserDefaults
        let rawValue = UserDefaults.standard.string(forKey: "secure_appleUserID")
        XCTAssertNotNil(rawValue, "Debe existir un valor en UserDefaults")
        XCTAssertNotEqual(rawValue, testUserID, "El valor en UserDefaults debe estar encriptado")
    }
    
    func testSecureUserEmailStorage() throws {
        // Test de almacenamiento seguro del email
        let testEmail = "doctor.medico@hospital.com"
        
        // Almacenar
        secureDefaults.secureUserEmail = testEmail
        
        // Recuperar
        let retrievedEmail = secureDefaults.secureUserEmail
        XCTAssertEqual(retrievedEmail, testEmail, "El email debe recuperarse correctamente")
        
        // Verificar encriptación
        let rawValue = UserDefaults.standard.string(forKey: "secure_userEmail")
        XCTAssertNotEqual(rawValue, testEmail, "El email en UserDefaults debe estar encriptado")
    }
    
    func testSecureUserFullNameStorage() throws {
        // Test de almacenamiento seguro del nombre completo
        let testName = "Dr. María Elena Rodríguez de la Cruz"
        
        // Almacenar
        secureDefaults.secureUserFullName = testName
        
        // Recuperar
        let retrievedName = secureDefaults.secureUserFullName
        XCTAssertEqual(retrievedName, testName, "El nombre completo debe recuperarse correctamente")
        
        // Verificar encriptación
        let rawValue = UserDefaults.standard.string(forKey: "secure_userFullName")
        XCTAssertNotEqual(rawValue, testName, "El nombre en UserDefaults debe estar encriptado")
    }
    
    func testSecureMedicalHistoryStorage() throws {
        // Test de almacenamiento seguro del historial médico
        let testHistory = [
            "Consulta inicial - Problemas de fertilidad",
            "Análisis de sangre - AMH: 2.1 ng/mL",
            "Ecografía - Folículos antrales: 8",
            "Tratamiento - 3 ciclos de IUI"
        ]
        
        // Almacenar
        secureDefaults.secureMedicalHistory = testHistory
        
        // Recuperar
        let retrievedHistory = secureDefaults.secureMedicalHistory
        XCTAssertNotNil(retrievedHistory, "El historial médico debe recuperarse correctamente")
        XCTAssertEqual(retrievedHistory, testHistory, "El historial médico debe ser idéntico al original")
        
        // Verificar encriptación
        let rawData = UserDefaults.standard.data(forKey: "secure_medicalHistory")
        XCTAssertNotNil(rawData, "Debe existir data encriptada en UserDefaults")
    }
    
    func testSecureFertilityProfileStorage() throws {
        // Test de almacenamiento seguro del perfil de fertilidad
        let testProfileData = "Perfil de fertilidad del paciente".data(using: .utf8)!
        
        // Almacenar
        secureDefaults.secureFertilityProfile = testProfileData
        
        // Recuperar
        let retrievedProfile = secureDefaults.secureFertilityProfile
        XCTAssertNotNil(retrievedProfile, "El perfil de fertilidad debe recuperarse correctamente")
        XCTAssertEqual(retrievedProfile, testProfileData, "El perfil debe ser idéntico al original")
    }
    
    // MARK: - 📱 TESTS DE DATOS NO SENSIBLES
    
    func testNonSensitiveDataStorage() throws {
        // Test de almacenamiento de datos no sensibles (sin encriptar)
        let testLanguage = "es"
        let testFont = "Helvetica"
        let testTheme = "dark"
        
        // Almacenar
        secureDefaults.appLanguage = testLanguage
        secureDefaults.selectedFontFamily = testFont
        secureDefaults.themePreference = testTheme
        
        // Recuperar
        let retrievedLanguage = secureDefaults.appLanguage
        let retrievedFont = secureDefaults.selectedFontFamily
        let retrievedTheme = secureDefaults.themePreference
        
        XCTAssertEqual(retrievedLanguage, testLanguage, "El idioma debe almacenarse sin encriptar")
        XCTAssertEqual(retrievedFont, testFont, "La fuente debe almacenarse sin encriptar")
        XCTAssertEqual(retrievedTheme, testTheme, "El tema debe almacenarse sin encriptar")
        
        // Verificar que no están encriptados en UserDefaults
        let rawLanguage = UserDefaults.standard.string(forKey: "AppLanguage")
        let rawFont = UserDefaults.standard.string(forKey: "selectedFontFamily")
        let rawTheme = UserDefaults.standard.string(forKey: "themePreference")
        
        XCTAssertEqual(rawLanguage, testLanguage, "El idioma en UserDefaults no debe estar encriptado")
        XCTAssertEqual(rawFont, testFont, "La fuente en UserDefaults no debe estar encriptada")
        XCTAssertEqual(rawTheme, testTheme, "El tema en UserDefaults no debe estar encriptado")
    }
    
    func testNotificationsEnabledStorage() throws {
        // Test de almacenamiento de preferencias de notificaciones
        let testNotificationsEnabled = true
        
        // Almacenar
        secureDefaults.notificationsEnabled = testNotificationsEnabled
        
        // Recuperar
        let retrievedNotifications = secureDefaults.notificationsEnabled
        XCTAssertEqual(retrievedNotifications, testNotificationsEnabled, "Las notificaciones deben almacenarse correctamente")
        
        // Cambiar valor
        secureDefaults.notificationsEnabled = false
        let newNotificationsValue = secureDefaults.notificationsEnabled
        XCTAssertFalse(newNotificationsValue, "El valor de notificaciones debe cambiar correctamente")
    }
    
    // MARK: - 🧹 TESTS DE LIMPIEZA
    
    func testClearMedicalData() throws {
        // Test de limpieza solo de datos médicos
        let testUserID = "test_user_123"
        let testEmail = "test@example.com"
        let testLanguage = "en"
        
        // Almacenar datos médicos y no médicos
        secureDefaults.secureAppleUserID = testUserID
        secureDefaults.secureUserEmail = testEmail
        secureDefaults.appLanguage = testLanguage
        
        // Limpiar solo datos médicos
        secureDefaults.clearMedicalData()
        
        // Verificar que los datos médicos se limpiaron
        XCTAssertNil(secureDefaults.secureAppleUserID, "El Apple User ID debe limpiarse")
        XCTAssertNil(secureDefaults.secureUserEmail, "El email debe limpiarse")
        
        // Verificar que los datos no médicos permanecen
        XCTAssertEqual(secureDefaults.appLanguage, testLanguage, "El idioma debe permanecer")
    }
    
    func testClearAllData() throws {
        // Test de limpieza de todos los datos
        let testUserID = "test_user_456"
        let testEmail = "test2@example.com"
        let testLanguage = "fr"
        let testFont = "Arial"
        
        // Almacenar datos
        secureDefaults.secureAppleUserID = testUserID
        secureDefaults.secureUserEmail = testEmail
        secureDefaults.appLanguage = testLanguage
        secureDefaults.selectedFontFamily = testFont
        
        // Limpiar todos los datos
        secureDefaults.clearAllData()
        
        // Verificar que todos los datos se limpiaron
        XCTAssertNil(secureDefaults.secureAppleUserID, "El Apple User ID debe limpiarse")
        XCTAssertNil(secureDefaults.secureUserEmail, "El email debe limpiarse")
        XCTAssertNil(secureDefaults.appLanguage, "El idioma debe limpiarse")
        XCTAssertNil(secureDefaults.selectedFontFamily, "La fuente debe limpiarse")
    }
    
    // MARK: - 🔍 TESTS DE VERIFICACIÓN DE INTEGRIDAD
    
    func testMedicalDataIntegrityVerification() throws {
        // Test de verificación de integridad de datos médicos
        let testUserID = "integrity_test_user"
        secureDefaults.secureAppleUserID = testUserID
        
        // Verificar integridad
        let isIntegrityValid = secureDefaults.verifyMedicalDataIntegrity()
        XCTAssertTrue(isIntegrityValid, "La integridad de los datos médicos debe ser válida")
        
        // Corromper datos (simular)
        UserDefaults.standard.set("corrupted_data", forKey: "secure_appleUserID")
        
        // Verificar que se detecta la corrupción
        let isCorruptedIntegrityValid = secureDefaults.verifyMedicalDataIntegrity()
        XCTAssertFalse(isCorruptedIntegrityValid, "Debe detectar datos médicos corruptos")
    }
    
    // MARK: - 📊 TESTS DE MIGRACIÓN
    
    func testDataMigration() throws {
        // Test de migración de datos existentes
        let oldUserID = "old_user_123"
        let oldEmail = "old@example.com"
        let oldName = "Old User Name"
        
        // Simular datos antiguos en UserDefaults
        UserDefaults.standard.set(oldUserID, forKey: "appleUserID")
        UserDefaults.standard.set(oldEmail, forKey: "userEmail")
        UserDefaults.standard.set(oldName, forKey: "userFullName")
        
        // Ejecutar migración
        secureDefaults.migrateExistingData()
        
        // Verificar que los datos se migraron correctamente
        let migratedUserID = secureDefaults.secureAppleUserID
        let migratedEmail = secureDefaults.secureUserEmail
        let migratedName = secureDefaults.secureUserFullName
        
        XCTAssertEqual(migratedUserID, oldUserID, "El User ID debe migrarse correctamente")
        XCTAssertEqual(migratedEmail, oldEmail, "El email debe migrarse correctamente")
        XCTAssertEqual(migratedName, oldName, "El nombre debe migrarse correctamente")
        
        // Verificar que los datos antiguos se eliminaron
        XCTAssertNil(UserDefaults.standard.string(forKey: "appleUserID"), "Los datos antiguos deben eliminarse")
        XCTAssertNil(UserDefaults.standard.string(forKey: "userEmail"), "Los datos antiguos deben eliminarse")
        XCTAssertNil(UserDefaults.standard.string(forKey: "userFullName"), "Los datos antiguos deben eliminarse")
    }
    
    // MARK: - 🔒 TESTS DE SEGURIDAD DEL DISPOSITIVO
    
    func testDeviceSecurityStatus() throws {
        // Test de verificación del estado de seguridad del dispositivo
        let securityStatus = secureDefaults.getDeviceSecurityStatus()
        XCTAssertFalse(securityStatus.isEmpty, "El estado de seguridad no debe estar vacío")
        
        // Verificar que contiene información relevante
        XCTAssertTrue(securityStatus.contains("Dispositivo"), "El estado debe contener información del dispositivo")
    }
    
    // MARK: - 🚨 TESTS DE CASOS EXTREMOS
    
    func testNilValueHandling() throws {
        // Test de manejo de valores nil
        secureDefaults.secureAppleUserID = nil
        secureDefaults.secureUserEmail = nil
        
        // Verificar que se manejan correctamente
        XCTAssertNil(secureDefaults.secureAppleUserID, "Los valores nil deben manejarse correctamente")
        XCTAssertNil(secureDefaults.secureUserEmail, "Los valores nil deben manejarse correctamente")
    }
    
    func testEmptyStringHandling() throws {
        // Test de manejo de strings vacíos
        let emptyString = ""
        secureDefaults.secureAppleUserID = emptyString
        
        // Verificar que se maneja correctamente
        let retrievedEmpty = secureDefaults.secureAppleUserID
        XCTAssertEqual(retrievedEmpty, emptyString, "Los strings vacíos deben manejarse correctamente")
    }
    
    func testSpecialCharactersHandling() throws {
        // Test de manejo de caracteres especiales
        let specialString = "Usuario@123#Médico$%^&*()"
        secureDefaults.secureUserFullName = specialString
        
        // Verificar que se maneja correctamente
        let retrievedSpecial = secureDefaults.secureUserFullName
        XCTAssertEqual(retrievedSpecial, specialString, "Los caracteres especiales deben manejarse correctamente")
    }
}
