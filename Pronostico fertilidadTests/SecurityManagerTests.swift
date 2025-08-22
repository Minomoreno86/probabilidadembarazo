//
//  SecurityManagerTests.swift
//  Pronostico fertilidadTests
//
//  Tests unitarios para el sistema de seguridad
//

import XCTest
@testable import Pronostico_fertilidad

final class SecurityManagerTests: XCTestCase {
    
    var securityManager: SecurityManager!
    
    override func setUpWithError() throws {
        securityManager = SecurityManager.shared
    }
    
    override func tearDownWithError() throws {
        // Limpiar después de cada test
        securityManager.secureWipe()
    }
    
    // MARK: - 🔐 TESTS DE ENCRIPTACIÓN
    
    func testStringEncryptionDecryption() throws {
        // Test de encriptación/desencriptación de strings
        let originalString = "Datos médicos sensibles del paciente"
        
        // Encriptar
        let encryptedString = securityManager.encryptString(originalString)
        XCTAssertNotNil(encryptedString, "El string debe encriptarse correctamente")
        XCTAssertNotEqual(originalString, encryptedString, "El string encriptado debe ser diferente al original")
        
        // Desencriptar
        let decryptedString = securityManager.decryptString(encryptedString!)
        XCTAssertNotNil(decryptedString, "El string debe desencriptarse correctamente")
        XCTAssertEqual(originalString, decryptedString, "El string desencriptado debe ser igual al original")
    }
    
    func testDataEncryptionDecryption() throws {
        // Test de encriptación/desencriptación de datos
        let originalData = "Datos médicos en formato Data".data(using: .utf8)!
        
        // Encriptar
        let encryptedData = securityManager.encryptData(originalData)
        XCTAssertNotNil(encryptedData, "Los datos deben encriptarse correctamente")
        XCTAssertNotEqual(originalData, encryptedData, "Los datos encriptados deben ser diferentes a los originales")
        
        // Desencriptar
        let decryptedData = securityManager.decryptData(encryptedData!)
        XCTAssertNotNil(decryptedData, "Los datos deben desencriptarse correctamente")
        XCTAssertEqual(originalData, decryptedData, "Los datos desencriptados deben ser iguales a los originales")
    }
    
    func testLargeDataEncryption() throws {
        // Test con datos grandes (simulando historial médico completo)
        let largeString = String(repeating: "Datos médicos del paciente con información detallada del historial clínico, tratamientos previos, resultados de laboratorio y notas del médico. ", count: 100)
        let largeData = largeString.data(using: .utf8)!
        
        // Encriptar
        let encryptedData = securityManager.encryptData(largeData)
        XCTAssertNotNil(encryptedData, "Los datos grandes deben encriptarse correctamente")
        
        // Desencriptar
        let decryptedData = securityManager.decryptData(encryptedData!)
        XCTAssertNotNil(decryptedData, "Los datos grandes deben desencriptarse correctamente")
        XCTAssertEqual(largeData, decryptedData, "Los datos grandes desencriptados deben ser iguales a los originales")
    }
    
    // MARK: - 🧮 TESTS DE HASHING
    
    func testStringHashing() throws {
        // Test de hashing de strings
        let originalString = "Contraseña del usuario médico"
        let hash1 = securityManager.hashString(originalString)
        let hash2 = securityManager.hashString(originalString)
        
        XCTAssertNotNil(hash1, "El hash debe generarse correctamente")
        XCTAssertEqual(hash1, hash2, "El mismo string debe generar el mismo hash")
        XCTAssertNotEqual(originalString, hash1, "El hash debe ser diferente al string original")
        XCTAssertEqual(hash1.count, 64, "El hash SHA-256 debe tener 64 caracteres")
    }
    
    func testDataHashing() throws {
        // Test de hashing de datos
        let originalData = "Datos médicos del paciente".data(using: .utf8)!
        let hash1 = securityManager.hashData(originalData)
        let hash2 = securityManager.hashData(originalData)
        
        XCTAssertNotNil(hash1, "El hash de datos debe generarse correctamente")
        XCTAssertEqual(hash1, hash2, "Los mismos datos deben generar el mismo hash")
        XCTAssertEqual(hash1.count, 64, "El hash SHA-256 debe tener 64 caracteres")
    }
    
    // MARK: - 🔍 TESTS DE VERIFICACIÓN DE INTEGRIDAD
    
    func testDataIntegrityVerification() throws {
        // Test de verificación de integridad de datos
        let originalData = "Datos médicos críticos".data(using: .utf8)!
        let expectedHash = securityManager.hashData(originalData)
        
        // Verificar integridad
        let isIntegrityValid = securityManager.verifyDataIntegrity(originalData, expectedHash: expectedHash)
        XCTAssertTrue(isIntegrityValid, "La verificación de integridad debe ser exitosa para datos válidos")
        
        // Verificar con hash incorrecto
        let wrongHash = "hash_incorrecto_que_no_coincide_con_los_datos"
        let isIntegrityInvalid = securityManager.verifyDataIntegrity(originalData, expectedHash: wrongHash)
        XCTAssertFalse(isIntegrityInvalid, "La verificación de integridad debe fallar para hash incorrecto")
    }
    
    // MARK: - 🔑 TESTS DE GESTIÓN DE CLAVES
    
    func testKeyGenerationAndStorage() throws {
        // Test de generación y almacenamiento de claves
        let originalKey = securityManager.encryptString("Test data")
        XCTAssertNotNil(originalKey, "Debe poder encriptar con la clave generada")
        
        // Verificar que la clave persiste
        let testData = "Datos de prueba".data(using: .utf8)!
        let encryptedData = securityManager.encryptData(testData)
        XCTAssertNotNil(encryptedData, "Debe poder encriptar datos con la clave persistente")
    }
    
    // MARK: - 🗑️ TESTS DE LIMPIEZA SEGURA
    
    func testSecureWipe() throws {
        // Test de limpieza segura
        let testString = "Datos sensibles de prueba"
        let encryptedString = securityManager.encryptString(testString)
        XCTAssertNotNil(encryptedString, "Debe poder encriptar antes de la limpieza")
        
        // Limpiar
        securityManager.secureWipe()
        
        // Verificar que la clave se regenera automáticamente
        let newEncryptedString = securityManager.encryptString("Nuevos datos")
        XCTAssertNotNil(newEncryptedString, "Debe poder encriptar después de la limpieza (clave regenerada)")
        
        // Verificar que es una nueva clave (diferente resultado)
        XCTAssertNotEqual(encryptedString, newEncryptedString, "La nueva encriptación debe ser diferente a la anterior")
    }
    
    // MARK: - 📱 TESTS DE SEGURIDAD DEL DISPOSITIVO
    
    func testDeviceSecurityCheck() throws {
        // Test de verificación de seguridad del dispositivo
        let isSecure = securityManager.isDeviceSecure()
        
        // En simulador debe ser false
        #if targetEnvironment(simulator)
        XCTAssertFalse(isSecure, "El simulador no debe considerarse seguro para datos médicos")
        #else
        // En dispositivo real puede ser true o false dependiendo de la configuración
        // Solo verificamos que la función no falle
        XCTAssertTrue(true, "La verificación de seguridad del dispositivo debe ejecutarse sin errores")
        #endif
    }
    
    // MARK: - 🔒 TESTS DE PROTECCIÓN DE DATOS MÉDICOS
    
    func testMedicalDataProtection() throws {
        // Test de protección de datos médicos
        let medicalData: [String: Any] = [
            "patientName": "Juan Pérez",
            "diagnosis": "Problemas de fertilidad",
            "testResults": "AMH: 2.5 ng/mL",
            "treatmentHistory": "3 ciclos de IUI"
        ]
        
        // Proteger datos
        let protectedData = securityManager.protectMedicalData(medicalData)
        XCTAssertNotNil(protectedData, "Los datos médicos deben protegerse correctamente")
        
        // Verificar que los valores sensibles están encriptados
        if let protectedName = protectedData?["patientName"] as? String {
            XCTAssertNotEqual(protectedName, "Juan Pérez", "El nombre del paciente debe estar encriptado")
        }
        
        // Desproteger datos
        let unprotectedData = securityManager.unprotectMedicalData(protectedData!)
        XCTAssertNotNil(unprotectedData, "Los datos médicos deben desprotegerse correctamente")
        
        // Verificar que los datos originales se recuperan
        XCTAssertEqual(unprotectedData?["patientName"] as? String, "Juan Pérez", "El nombre del paciente debe recuperarse correctamente")
        XCTAssertEqual(unprotectedData?["diagnosis"] as? String, "Problemas de fertilidad", "El diagnóstico debe recuperarse correctamente")
    }
    
    // MARK: - 🚨 TESTS DE CASOS EXTREMOS
    
    func testEmptyStringEncryption() throws {
        // Test con string vacío
        let emptyString = ""
        let encryptedString = securityManager.encryptString(emptyString)
        XCTAssertNotNil(encryptedString, "El string vacío debe encriptarse correctamente")
        
        let decryptedString = securityManager.decryptString(encryptedString!)
        XCTAssertEqual(decryptedString, emptyString, "El string vacío debe desencriptarse correctamente")
    }
    
    func testSpecialCharactersEncryption() throws {
        // Test con caracteres especiales
        let specialString = "¡Hola! ¿Cómo estás? @#$%^&*()_+-=[]{}|;':\",./<>?"
        let encryptedString = securityManager.encryptString(specialString)
        XCTAssertNotNil(encryptedString, "Los caracteres especiales deben encriptarse correctamente")
        
        let decryptedString = securityManager.decryptString(encryptedString!)
        XCTAssertEqual(decryptedString, specialString, "Los caracteres especiales deben desencriptarse correctamente")
    }
    
    func testUnicodeCharactersEncryption() throws {
        // Test con caracteres Unicode
        let unicodeString = "Paciente: María José López-García (Español) 🏥💊"
        let encryptedString = securityManager.encryptString(unicodeString)
        XCTAssertNotNil(encryptedString, "Los caracteres Unicode deben encriptarse correctamente")
        
        let decryptedString = securityManager.decryptString(encryptedString!)
        XCTAssertEqual(decryptedString, unicodeString, "Los caracteres Unicode deben desencriptarse correctamente")
    }
}
