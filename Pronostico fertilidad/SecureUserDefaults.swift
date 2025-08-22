//
//  SecureUserDefaults.swift
//  Pronostico fertilidad
//
//  Gestor seguro de UserDefaults con encriptación para datos médicos
//

import Foundation

// MARK: - 🔒 SECURE USER DEFAULTS
class SecureUserDefaults: ObservableObject {
    static let shared = SecureUserDefaults()
    
    private let defaults = UserDefaults.standard
    private let securityManager = SecurityManager.shared
    
    // Claves para datos médicos sensibles
    private enum MedicalDataKeys {
        static let userID = "secure_appleUserID"
        static let userEmail = "secure_userEmail"
        static let userFullName = "secure_userFullName"
        static let medicalHistory = "secure_medicalHistory"
        static let fertilityProfile = "secure_fertilityProfile"
        static let treatmentHistory = "secure_treatmentHistory"
        static let lastCalculation = "secure_lastCalculation"
    }
    
    // Claves para datos no sensibles
    private enum NonSensitiveKeys {
        static let appLanguage = "AppLanguage"
        static let selectedFontFamily = "selectedFontFamily"
        static let themePreference = "themePreference"
        static let notificationsEnabled = "notificationsEnabled"
    }
    
    private init() {}
    
    // MARK: - 🔐 DATOS MÉDICOS ENCRIPTADOS
    
    // Usuario Apple ID
    var secureAppleUserID: String? {
        get {
            guard let encryptedValue = defaults.string(forKey: MedicalDataKeys.userID) else { return nil }
            return securityManager.decryptString(encryptedValue)
        }
        set {
            if let value = newValue {
                // Manejar string vacío
                if value.isEmpty {
                    defaults.set("", forKey: MedicalDataKeys.userID)
                } else if let encryptedValue = securityManager.encryptString(value) {
                    defaults.set(encryptedValue, forKey: MedicalDataKeys.userID)
                } else {
                    print("⚠️ Error encriptando Apple User ID")
                    // Fallback: almacenar sin encriptar (no recomendado para producción)
                    defaults.set(value, forKey: MedicalDataKeys.userID)
                }
            } else {
                defaults.removeObject(forKey: MedicalDataKeys.userID)
            }
            defaults.synchronize()
        }
    }
    
    // Email del usuario
    var secureUserEmail: String? {
        get {
            guard let encryptedValue = defaults.string(forKey: MedicalDataKeys.userEmail) else { return nil }
            return securityManager.decryptString(encryptedValue)
        }
        set {
            if let value = newValue {
                if let encryptedValue = securityManager.encryptString(value) {
                    defaults.set(encryptedValue, forKey: MedicalDataKeys.userEmail)
                }
            } else {
                defaults.removeObject(forKey: MedicalDataKeys.userEmail)
            }
            defaults.synchronize()
        }
    }
    
    // Nombre completo del usuario
    var secureUserFullName: String? {
        get {
            guard let encryptedValue = defaults.string(forKey: MedicalDataKeys.userFullName) else { return nil }
            return securityManager.decryptString(encryptedValue)
        }
        set {
            if let value = newValue {
                if let encryptedValue = securityManager.encryptString(value) {
                    defaults.set(encryptedValue, forKey: MedicalDataKeys.userFullName)
                }
            } else {
                defaults.removeObject(forKey: MedicalDataKeys.userFullName)
            }
            defaults.synchronize()
        }
    }
    
    // Historial médico
    var secureMedicalHistory: [String]? {
        get {
            guard let encryptedData = defaults.data(forKey: MedicalDataKeys.medicalHistory) else { return nil }
            guard let decryptedData = securityManager.decryptData(encryptedData) else { return nil }
            return try? JSONDecoder().decode([String].self, from: decryptedData)
        }
        set {
            if let value = newValue {
                if let jsonData = try? JSONEncoder().encode(value),
                   let encryptedData = securityManager.encryptData(jsonData) {
                    defaults.set(encryptedData, forKey: MedicalDataKeys.medicalHistory)
                }
            } else {
                defaults.removeObject(forKey: MedicalDataKeys.medicalHistory)
            }
            defaults.synchronize()
        }
    }
    
    // Perfil de fertilidad
    var secureFertilityProfile: Data? {
        get {
            guard let encryptedData = defaults.data(forKey: MedicalDataKeys.fertilityProfile) else { return nil }
            return securityManager.decryptData(encryptedData)
        }
        set {
            if let value = newValue {
                if let encryptedData = securityManager.encryptData(value) {
                    defaults.set(encryptedData, forKey: MedicalDataKeys.fertilityProfile)
                }
            } else {
                defaults.removeObject(forKey: MedicalDataKeys.fertilityProfile)
            }
            defaults.synchronize()
        }
    }
    
    // Historial de tratamientos
    var secureTreatmentHistory: Data? {
        get {
            guard let encryptedData = defaults.data(forKey: MedicalDataKeys.treatmentHistory) else { return nil }
            return securityManager.decryptData(encryptedData)
        }
        set {
            if let value = newValue {
                if let encryptedData = securityManager.encryptData(value) {
                    defaults.set(encryptedData, forKey: MedicalDataKeys.treatmentHistory)
                }
            } else {
                defaults.removeObject(forKey: MedicalDataKeys.treatmentHistory)
            }
            defaults.synchronize()
        }
    }
    
    // Último cálculo realizado
    var secureLastCalculation: Data? {
        get {
            guard let encryptedData = defaults.data(forKey: MedicalDataKeys.lastCalculation) else { return nil }
            return securityManager.decryptData(encryptedData)
        }
        set {
            if let value = newValue {
                if let encryptedData = securityManager.encryptData(value) {
                    defaults.set(encryptedData, forKey: MedicalDataKeys.lastCalculation)
                }
            } else {
                defaults.removeObject(forKey: MedicalDataKeys.lastCalculation)
            }
            defaults.synchronize()
        }
    }
    
    // MARK: - 📱 DATOS NO SENSIBLES (SIN ENCRIPTAR)
    
    // Idioma de la aplicación
    var appLanguage: String? {
        get { defaults.string(forKey: NonSensitiveKeys.appLanguage) }
        set {
            defaults.set(newValue, forKey: NonSensitiveKeys.appLanguage)
            defaults.synchronize()
        }
    }
    
    // Familia de fuente seleccionada
    var selectedFontFamily: String? {
        get { defaults.string(forKey: NonSensitiveKeys.selectedFontFamily) }
        set {
            defaults.set(newValue, forKey: NonSensitiveKeys.selectedFontFamily)
            defaults.synchronize()
        }
    }
    
    // Preferencia de tema
    var themePreference: String? {
        get { defaults.string(forKey: NonSensitiveKeys.themePreference) }
        set {
            defaults.set(newValue, forKey: NonSensitiveKeys.themePreference)
            defaults.synchronize()
        }
    }
    
    // Notificaciones habilitadas
    var notificationsEnabled: Bool {
        get { defaults.bool(forKey: NonSensitiveKeys.notificationsEnabled) }
        set {
            defaults.set(newValue, forKey: NonSensitiveKeys.notificationsEnabled)
            defaults.synchronize()
        }
    }
    
    // MARK: - 🧹 LIMPIEZA SEGURA
    
    // Limpiar solo datos médicos
    func clearMedicalData() {
        defaults.removeObject(forKey: MedicalDataKeys.userID)
        defaults.removeObject(forKey: MedicalDataKeys.userEmail)
        defaults.removeObject(forKey: MedicalDataKeys.userFullName)
        defaults.removeObject(forKey: MedicalDataKeys.medicalHistory)
        defaults.removeObject(forKey: MedicalDataKeys.fertilityProfile)
        defaults.removeObject(forKey: MedicalDataKeys.treatmentHistory)
        defaults.removeObject(forKey: MedicalDataKeys.lastCalculation)
        defaults.synchronize()
    }
    
    // Limpiar todos los datos
    func clearAllData() {
        clearMedicalData()
        defaults.removeObject(forKey: NonSensitiveKeys.appLanguage)
        defaults.removeObject(forKey: NonSensitiveKeys.selectedFontFamily)
        defaults.removeObject(forKey: NonSensitiveKeys.themePreference)
        defaults.removeObject(forKey: NonSensitiveKeys.notificationsEnabled)
        defaults.synchronize()
    }
    
    // MARK: - 🔍 VERIFICACIÓN DE INTEGRIDAD
    
    // Verificar si los datos médicos están corruptos
    func verifyMedicalDataIntegrity() -> Bool {
        let keys = [
            MedicalDataKeys.userID,
            MedicalDataKeys.userEmail,
            MedicalDataKeys.userFullName,
            MedicalDataKeys.medicalHistory,
            MedicalDataKeys.fertilityProfile,
            MedicalDataKeys.treatmentHistory,
            MedicalDataKeys.lastCalculation
        ]
        
        for key in keys {
            if let value = defaults.object(forKey: key) {
                if let stringValue = value as? String {
                    // Verificar que se puede desencriptar
                    if securityManager.decryptString(stringValue) == nil {
                        print("⚠️ Datos corruptos detectados en: \(key)")
                        return false
                    }
                } else if let dataValue = value as? Data {
                    // Verificar que se puede desencriptar
                    if securityManager.decryptData(dataValue) == nil {
                        print("⚠️ Datos corruptos detectados en: \(key)")
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    // MARK: - 📊 MIGRACIÓN DE DATOS EXISTENTES
    
    // Migrar datos existentes de UserDefaults a versión encriptada
    func migrateExistingData() {
        // Migrar Apple User ID
        if let existingUserID = defaults.string(forKey: "appleUserID") {
            secureAppleUserID = existingUserID
            defaults.removeObject(forKey: "appleUserID")
        }
        
        // Migrar email del usuario
        if let existingEmail = defaults.string(forKey: "userEmail") {
            secureUserEmail = existingEmail
            defaults.removeObject(forKey: "userEmail")
        }
        
        // Migrar nombre del usuario
        if let existingName = defaults.string(forKey: "userFullName") {
            secureUserFullName = existingName
            defaults.removeObject(forKey: "userFullName")
        }
        
        defaults.synchronize()
        print("✅ Migración de datos completada")
    }
    
    // MARK: - 🔐 VERIFICACIÓN DE SEGURIDAD
    
    // Verificar si el dispositivo es seguro para datos médicos
    func isDeviceSecureForMedicalData() -> Bool {
        return securityManager.isDeviceSecure()
    }
    
    // Obtener estado de seguridad del dispositivo
    func getDeviceSecurityStatus() -> String {
        if securityManager.isDeviceSecure() {
            return "🔒 Dispositivo seguro para datos médicos"
        } else {
            return "⚠️ Dispositivo no seguro para datos médicos"
        }
    }
}
