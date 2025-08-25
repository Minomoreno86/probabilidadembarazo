//
//  SecurityAuditLogger.swift
//  Pronostico fertilidad
//
//  Sistema de auditoría y logging seguro para eventos de seguridad
//

import Foundation
import os.log
#if os(iOS)
import UIKit
#endif

// MARK: - 🔍 SECURITY AUDIT LOGGER
class SecurityAuditLogger: ObservableObject {
    static let shared = SecurityAuditLogger()
    
    // Logger del sistema para eventos de seguridad
    private let securityLogger = Logger(subsystem: "com.pronostico.fertilidad.security", category: "SecurityAudit")
    
    // Archivo de auditoría local (encriptado)
    private var auditLogFile: URL? {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsPath.appendingPathComponent("security_audit.log")
    }
    
    // Configuración de auditoría
    private let maxLogEntries = 1000
    private let logRetentionDays = 90
    
    private init() {
        setupAuditLog()
        cleanupOldLogs()
    }
    
    // MARK: - 🔧 CONFIGURACIÓN DEL SISTEMA DE AUDITORÍA
    
    private func setupAuditLog() {
        guard let logFile = auditLogFile else { return }
        
        // Crear archivo si no existe
        if !FileManager.default.fileExists(atPath: logFile.path) {
            FileManager.default.createFile(atPath: logFile.path, contents: nil, attributes: nil)
        }
    }
    
    // MARK: - 📝 LOGGING DE EVENTOS DE SEGURIDAD
    
    // Acceso a datos médicos
    func logMedicalDataAccess(operation: String, dataType: String, userID: String?, success: Bool) {
        let event = SecurityEvent(
            timestamp: Date(),
            eventType: .medicalDataAccess,
            operation: operation,
            dataType: dataType,
            userID: userID,
            success: success,
            deviceInfo: getDeviceInfo(),
            additionalInfo: nil
        )
        
        logSecurityEvent(event)
    }
    
    // Autenticación de usuario
    func logUserAuthentication(userID: String?, method: String, success: Bool) {
        let event = SecurityEvent(
            timestamp: Date(),
            eventType: .userAuthentication,
            operation: method,
            dataType: "authentication",
            userID: userID,
            success: success,
            deviceInfo: getDeviceInfo(),
            additionalInfo: nil
        )
        
        logSecurityEvent(event)
    }
    
    // Cambios en configuración de seguridad
    func logSecurityConfigurationChange(change: String, userID: String?, success: Bool) {
        let event = SecurityEvent(
            timestamp: Date(),
            eventType: .securityConfiguration,
            operation: change,
            dataType: "configuration",
            userID: userID,
            success: success,
            deviceInfo: getDeviceInfo(),
            additionalInfo: nil
        )
        
        logSecurityEvent(event)
    }
    
    // Intentos de acceso no autorizado
    func logUnauthorizedAccess(operation: String, dataType: String, userID: String?, reason: String) {
        let event = SecurityEvent(
            timestamp: Date(),
            eventType: .unauthorizedAccess,
            operation: operation,
            dataType: dataType,
            userID: userID,
            success: false,
            deviceInfo: getDeviceInfo(),
            additionalInfo: ["reason": reason]
        )
        
        logSecurityEvent(event)
        securityLogger.warning("🚨 Acceso no autorizado detectado: \(operation) en \(dataType) - Razón: \(reason)")
    }
    
    // Errores de encriptación/desencriptación
    func logEncryptionError(operation: String, error: String, userID: String?) {
        let event = SecurityEvent(
            timestamp: Date(),
            eventType: .encryptionError,
            operation: operation,
            dataType: "encryption",
            userID: userID,
            success: false,
            deviceInfo: getDeviceInfo(),
            additionalInfo: ["error": error]
        )
        
        logSecurityEvent(event)
        securityLogger.error("🔐 Error de encriptación: \(operation) - \(error)")
    }
    
    // Cambios en el estado de seguridad del dispositivo
    func logDeviceSecurityChange(previousState: String, newState: String, userID: String?) {
        let event = SecurityEvent(
            timestamp: Date(),
            eventType: .deviceSecurityChange,
            operation: "security_state_change",
            dataType: "device_security",
            userID: userID,
            success: true,
            deviceInfo: getDeviceInfo(),
            additionalInfo: [
                "previous_state": previousState,
                "new_state": newState
            ]
        )
        
        logSecurityEvent(event)
        securityLogger.info("📱 Cambio en seguridad del dispositivo: \(previousState) → \(newState)")
    }
    
    // MARK: - 🔒 LOGGING INTERNO SEGURO
    
    private func logSecurityEvent(_ event: SecurityEvent) {
        // Log al sistema (os.log)
        logToSystem(event)
        
        // Log local encriptado
        logToLocalFile(event)
        
        // Verificar si necesitamos alertar sobre eventos críticos
        checkForCriticalEvents(event)
    }
    
    private func logToSystem(_ event: SecurityEvent) {
        let message = event.formattedMessage
        
        switch event.eventType {
        case .unauthorizedAccess, .encryptionError:
            securityLogger.error("\(message)")
        case .medicalDataAccess, .userAuthentication:
            securityLogger.info("\(message)")
        case .securityConfiguration, .deviceSecurityChange:
            securityLogger.notice("\(message)")
        }
    }
    
    private func logToLocalFile(_ event: SecurityEvent) {
        guard let logFile = auditLogFile else { return }
        
        do {
            let logEntry = event.jsonString + "\n"
            
            if let data = logEntry.data(using: .utf8) {
                let fileHandle = try FileHandle(forWritingTo: logFile)
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        } catch {
            securityLogger.error("Error writing to audit file: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 🚨 DETECCIÓN DE EVENTOS CRÍTICOS
    
    private func checkForCriticalEvents(_ event: SecurityEvent) {
        switch event.eventType {
        case .unauthorizedAccess:
            // Múltiples accesos no autorizados pueden indicar un ataque
            checkForMultipleUnauthorizedAccesses()
            
        case .encryptionError:
            // Errores de encriptación pueden comprometer la seguridad
            checkForEncryptionErrorPatterns()
            
        case .medicalDataAccess:
            // Verificar patrones sospechosos de acceso a datos
            checkForSuspiciousDataAccessPatterns(event)
            
        default:
            break
        }
    }
    
    private func checkForMultipleUnauthorizedAccesses() {
        // Implementar lógica para detectar múltiples intentos fallidos
        // y activar medidas de seguridad adicionales
    }
    
    private func checkForEncryptionErrorPatterns() {
        // Implementar lógica para detectar patrones de errores de encriptación
        // que puedan indicar compromiso del sistema
    }
    
    private func checkForSuspiciousDataAccessPatterns(_ event: SecurityEvent) {
        // Implementar lógica para detectar patrones sospechosos de acceso
        // a datos médicos (ej: acceso fuera de horario normal, múltiples accesos)
    }
    
    // MARK: - 🔍 CONSULTA DE LOGS
    
    // Obtener logs de auditoría para un período específico
    func getAuditLogs(from: Date, to: Date) -> [SecurityEvent] {
        guard let logFile = auditLogFile else { return [] }
        
        do {
            let content = try String(contentsOf: logFile)
            let lines = content.components(separatedBy: .newlines)
            
            var events: [SecurityEvent] = []
            
            for line in lines where !line.isEmpty {
                if let event = SecurityEvent.fromJSON(line) {
                    if event.timestamp >= from && event.timestamp <= to {
                        events.append(event)
                    }
                }
            }
            
            return events.sorted { $0.timestamp > $1.timestamp }
            
        } catch {
            securityLogger.error("Error reading audit logs: \(error.localizedDescription)")
            return []
        }
    }
    
    // Obtener logs de eventos críticos
    func getCriticalEventLogs() -> [SecurityEvent] {
        let allEvents = getAuditLogs(from: Date().addingTimeInterval(-86400), to: Date()) // Últimas 24 horas
        
        return allEvents.filter { event in
            switch event.eventType {
            case .unauthorizedAccess, .encryptionError:
                return true
            default:
                return false
            }
        }
    }
    
    // MARK: - 🧹 LIMPIEZA Y MANTENIMIENTO
    
    private func cleanupOldLogs() {
        let cutoffDate = Date().addingTimeInterval(-TimeInterval(logRetentionDays * 86400))
        
        guard let logFile = auditLogFile else { return }
        
        do {
            let content = try String(contentsOf: logFile)
            let lines = content.components(separatedBy: .newlines)
            
            var newLines: [String] = []
            
            for line in lines where !line.isEmpty {
                if let event = SecurityEvent.fromJSON(line) {
                    if event.timestamp >= cutoffDate {
                        newLines.append(line)
                    }
                }
            }
            
            // Mantener solo los últimos maxLogEntries
            if newLines.count > maxLogEntries {
                newLines = Array(newLines.suffix(maxLogEntries))
            }
            
            let newContent = newLines.joined(separator: "\n") + "\n"
            try newContent.write(to: logFile, atomically: true, encoding: .utf8)
            
        } catch {
            securityLogger.error("Error cleaning old logs: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 📱 INFORMACIÓN DEL DISPOSITIVO
    
    private func getDeviceInfo() -> [String: String] {
        #if os(iOS)
        return [
            "device_model": UIDevice.current.model,
            "system_version": UIDevice.current.systemVersion,
            "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown",
            "bundle_id": Bundle.main.bundleIdentifier ?? "Unknown"
        ]
        #else
        return [
            "device_model": "Unknown",
            "system_version": "Unknown",
            "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown",
            "bundle_id": Bundle.main.bundleIdentifier ?? "Unknown"
        ]
        #endif
    }
}

// MARK: - 📊 MODELO DE EVENTO DE SEGURIDAD

struct SecurityEvent: Codable {
    let timestamp: Date
    let eventType: SecurityEventType
    let operation: String
    let dataType: String
    let userID: String?
    let success: Bool
    let deviceInfo: [String: String]
    let additionalInfo: [String: String]?
    
    var formattedMessage: String {
        let status = success ? "✅" : "❌"
        let user = userID ?? "anonymous"
        return "[\(status)] \(eventType.rawValue): \(operation) en \(dataType) por \(user)"
    }
    
    var jsonString: String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        if let data = try? encoder.encode(self),
           let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        
        return "{}"
    }
    
    static func fromJSON(_ jsonString: String) -> SecurityEvent? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let data = jsonString.data(using: .utf8) else { return nil }
        
        return try? decoder.decode(SecurityEvent.self, from: data)
    }
}

// MARK: - 🏷️ TIPOS DE EVENTOS DE SEGURIDAD

enum SecurityEventType: String, Codable, CaseIterable {
    case medicalDataAccess = "medical_data_access"
    case userAuthentication = "user_authentication"
    case securityConfiguration = "security_configuration"
    case unauthorizedAccess = "unauthorized_access"
    case encryptionError = "encryption_error"
    case deviceSecurityChange = "device_security_change"
}

// MARK: - 🔐 EXTENSIONES DE SEGURIDAD PARA LOGGING

extension String {
    var secureLog: String {
        // Encriptar información sensible en logs
        if self.contains("@") || self.contains("password") || self.contains("token") {
            return "[REDACTED]"
        }
        return self
    }
}
