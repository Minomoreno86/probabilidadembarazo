//
//  SecurityManager.swift
//  Pronostico fertilidad
//
//  Gestor de seguridad y encriptación para datos médicos
//

import Foundation
import CryptoKit
import Security
import LocalAuthentication

// MARK: - 🔒 SECURITY MANAGER
class SecurityManager: ObservableObject {
    static let shared = SecurityManager()
    
    // Clave de encriptación derivada del dispositivo
    private var encryptionKey: SymmetricKey?
    
    // Estado de generación de claves
    private var needsKeyGeneration = false
    
    // Configuración de seguridad
    private let keychainService = "com.pronostico.fertilidad.security"
    private let keychainAccount = "encryption_key"
    
    private init() {
        setupEncryption()
    }
    
    // MARK: - 🔑 CONFIGURACIÓN DE ENCRIPTACIÓN
    private func setupEncryption() {
        // Si se necesita regenerar la clave, hacerlo
        if needsKeyGeneration {
            encryptionKey = generateNewEncryptionKey()
            if let key = encryptionKey {
                storeKeyInKeychain(key)
                needsKeyGeneration = false
            }
            return
        }
        
        // Intentar recuperar clave existente del keychain
        if let existingKey = retrieveKeyFromKeychain() {
            encryptionKey = existingKey
        } else {
            // Generar nueva clave y almacenarla en keychain
            encryptionKey = generateNewEncryptionKey()
            if let key = encryptionKey {
                storeKeyInKeychain(key)
            }
        }
    }
    
    // MARK: - 🔐 GENERACIÓN DE CLAVES
    private func generateNewEncryptionKey() -> SymmetricKey {
        return SymmetricKey(size: .bits256)
    }
    
    private func storeKeyInKeychain(_ key: SymmetricKey) {
        let keyData = key.withUnsafeBytes { Data($0) }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecValueData as String: keyData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("⚠️ Error almacenando clave en keychain: \(status)")
        }
    }
    
    private func retrieveKeyFromKeychain() -> SymmetricKey? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let keyData = result as? Data else {
            return nil
        }
        
        return SymmetricKey(data: keyData)
    }
    
    // MARK: - 🔒 ENCRIPTACIÓN DE DATOS
    func encryptData(_ data: Data) -> Data? {
        // Asegurar que tenemos una clave de encriptación
        if encryptionKey == nil {
            setupEncryption()
        }
        
        guard let key = encryptionKey else {
            print("❌ Clave de encriptación no disponible")
            return nil
        }
        
        // Manejar datos vacíos
        if data.isEmpty {
            return Data()
        }
        
        // Verificar tamaño máximo (1GB para evitar problemas de memoria)
        let maxSize = 1024 * 1024 * 1024 // 1GB
        if data.count > maxSize {
            print("⚠️ Datos demasiado grandes para encriptar: \(data.count) bytes")
            return nil
        }
        
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined
        } catch {
            print("❌ Error encriptando datos: \(error)")
            return nil
        }
    }
    
    func decryptData(_ encryptedData: Data) -> Data? {
        // Asegurar que tenemos una clave de encriptación
        if encryptionKey == nil {
            setupEncryption()
        }
        
        guard let key = encryptionKey else {
            print("❌ Clave de encriptación no disponible")
            return nil
        }
        
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
            return try AES.GCM.open(sealedBox, using: key)
        } catch {
            print("❌ Error desencriptando datos: \(error)")
            return nil
        }
    }
    
    // MARK: - 🔐 ENCRIPTACIÓN DE STRINGS
    func encryptString(_ string: String) -> String? {
        // Asegurar que tenemos una clave de encriptación
        if encryptionKey == nil {
            setupEncryption()
        }
        
        // Manejar string vacío
        if string.isEmpty {
            return encryptEmptyString()
        }
        
        guard let data = string.data(using: .utf8) else { 
            print("❌ Error convirtiendo string a data: \(string)")
            return nil 
        }
        guard let encryptedData = encryptData(data) else { return nil }
        return encryptedData.base64EncodedString()
    }
    
    func decryptString(_ encryptedString: String) -> String? {
        // Asegurar que tenemos una clave de encriptación
        if encryptionKey == nil {
            setupEncryption()
        }
        
        // Manejar string vacío encriptado
        if encryptedString.isEmpty {
            return ""
        }
        
        guard let encryptedData = Data(base64Encoded: encryptedString) else { 
            print("❌ Error convirtiendo string encriptado a data: \(encryptedString)")
            return nil 
        }
        guard let decryptedData = decryptData(encryptedData) else { return nil }
        return String(data: decryptedData, encoding: .utf8)
    }
    
    // MARK: - 🔐 MANEJO DE STRING VACÍO
    private func encryptEmptyString() -> String? {
        let emptyData = Data()
        guard let encryptedData = encryptData(emptyData) else { return nil }
        return encryptedData.base64EncodedString()
    }
    
    // MARK: - 🧮 HASHING SEGURO
    func hashData(_ data: Data) -> String {
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func hashString(_ string: String) -> String {
        // Manejar string vacío
        if string.isEmpty {
            return hashData(Data())
        }
        
        guard let data = string.data(using: .utf8) else { 
            print("⚠️ Error convirtiendo string a data para hash: \(string)")
            // Fallback: usar string vacío
            return hashData(Data())
        }
        return hashData(data)
    }
    
    // MARK: - 🔍 VERIFICACIÓN DE INTEGRIDAD
    func verifyDataIntegrity(_ data: Data, expectedHash: String) -> Bool {
        let actualHash = hashData(data)
        return actualHash == expectedHash
    }
    
    // MARK: - 🗑️ LIMPIEZA SEGURA
    func secureWipe() {
        // Limpiar clave de encriptación
        encryptionKey = nil
        
        // Eliminar clave del keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount
        ]
        SecItemDelete(query as CFDictionary)
        
        // Limpiar UserDefaults de forma segura
        clearUserDefaultsSecurely()
        
        // NO regenerar clave automáticamente para tests
        // needsKeyGeneration = true
    }
    
    private func clearUserDefaultsSecurely() {
        let defaults = UserDefaults.standard
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
    }
    
    // MARK: - 📱 VERIFICACIÓN DE SEGURIDAD DEL DISPOSITIVO
    func isDeviceSecure() -> Bool {
        #if targetEnvironment(simulator)
        return false // Simulador no es seguro para datos médicos
        #else
        // Verificar si el dispositivo tiene protección biométrica
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        }
        
        // Verificar si tiene código de acceso
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            return true
        }
        
        return false
        #endif
    }
    
    // MARK: - 🔒 PROTECCIÓN DE DATOS MÉDICOS
    func protectMedicalData(_ data: [String: Any]) -> [String: Any]? {
        var protectedData: [String: Any] = [:]
        
        for (key, value) in data {
            if let stringValue = value as? String {
                if let encryptedValue = encryptString(stringValue) {
                    protectedData[key] = encryptedValue
                } else {
                    print("⚠️ No se pudo encriptar valor para clave: \(key)")
                    return nil
                }
            } else if let dataValue = value as? Data {
                if let encryptedValue = encryptData(dataValue) {
                    protectedData[key] = encryptedValue.base64EncodedString()
                } else {
                    print("⚠️ No se pudo encriptar datos para clave: \(key)")
                    return nil
                }
            } else {
                // Para tipos no sensibles, mantener como están
                protectedData[key] = value
            }
        }
        
        return protectedData
    }
    
    func unprotectMedicalData(_ protectedData: [String: Any]) -> [String: Any]? {
        var unprotectedData: [String: Any] = [:]
        
        for (key, value) in protectedData {
            if let encryptedString = value as? String {
                if let decryptedValue = decryptString(encryptedString) {
                    unprotectedData[key] = decryptedValue
                } else {
                    print("⚠️ No se pudo desencriptar valor para clave: \(key)")
                    return nil
                }
            } else {
                // Mantener valores no encriptados
                unprotectedData[key] = value
            }
        }
        
        return unprotectedData
    }
}

// MARK: - 🔐 EXTENSIONES DE SEGURIDAD
extension String {
    var encrypted: String? {
        return SecurityManager.shared.encryptString(self)
    }
    
    var decrypted: String? {
        return SecurityManager.shared.decryptString(self)
    }
    
    var hashed: String {
        return SecurityManager.shared.hashString(self)
    }
}

extension Data {
    var encrypted: Data? {
        return SecurityManager.shared.encryptData(self)
    }
    
    var decrypted: Data? {
        return SecurityManager.shared.decryptData(self)
    }
    
    var hashed: String {
        return SecurityManager.shared.hashData(self)
    }
}
