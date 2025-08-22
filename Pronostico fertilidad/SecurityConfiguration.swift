//
//  SecurityConfiguration.swift
//  Pronostico fertilidad
//
//  Configuración de políticas de seguridad para la aplicación
//

import Foundation
import LocalAuthentication

// MARK: - 🔒 CONFIGURACIÓN DE SEGURIDAD
struct SecurityConfiguration {
    
    // MARK: - 🔐 POLÍTICAS DE AUTENTICACIÓN
    
    /// Tiempo máximo de inactividad antes de requerir re-autenticación (en segundos)
    static let sessionTimeout: TimeInterval = 1800 // 30 minutos
    
    /// Número máximo de intentos de autenticación fallidos antes de bloquear
    static let maxFailedAuthAttempts = 5
    
    /// Tiempo de bloqueo después de múltiples intentos fallidos (en segundos)
    static let lockoutDuration: TimeInterval = 900 // 15 minutos
    
    // MARK: - 🔒 POLÍTICAS DE DATOS MÉDICOS
    
    /// Nivel de protección requerido para datos médicos
    static let medicalDataProtectionLevel: DataProtectionLevel = .complete
    
    /// Tiempo máximo de retención de datos médicos (en días)
    static let medicalDataRetentionDays = 2555 // 7 años (requerimiento médico)
    
    /// ¿Requiere autenticación biométrica para acceder a datos médicos?
    static let requireBiometricForMedicalData = true
    
    // MARK: - 🔐 POLÍTICAS DE ENCRIPTACIÓN
    
    /// Algoritmo de encriptación para datos médicos
    static let encryptionAlgorithm = "AES-256-GCM"
    
    /// Tamaño de clave de encriptación (en bits)
    static let encryptionKeySize = 256
    
    /// ¿Rotar claves de encriptación automáticamente?
    static let autoRotateEncryptionKeys = true
    
    /// Frecuencia de rotación de claves (en días)
    static let keyRotationIntervalDays = 90
    
    // MARK: - 📱 POLÍTICAS DEL DISPOSITIVO
    
    /// ¿Permitir uso en simulador?
    static let allowSimulatorUsage = false
    
    /// ¿Requiere código de acceso del dispositivo?
    static let requireDevicePasscode = true
    
    /// ¿Requiere Face ID/Touch ID?
    static let requireBiometricAuthentication = true
    
    /// ¿Permitir jailbreak/root?
    static let allowJailbrokenDevice = false
    
    // MARK: - 🔍 POLÍTICAS DE AUDITORÍA
    
    /// ¿Habilitar logging de auditoría?
    static let enableAuditLogging = true
    
    /// Nivel de detalle del logging
    static let auditLogLevel: AuditLogLevel = .detailed
    
    /// Retención de logs de auditoría (en días)
    static let auditLogRetentionDays = 90
    
    /// ¿Encriptar logs de auditoría?
    static let encryptAuditLogs = true
    
    // MARK: - 🌐 POLÍTICAS DE RED
    
    /// ¿Permitir conexiones HTTP (no HTTPS)?
    static let allowInsecureConnections = false
    
    /// ¿Requiere certificados SSL válidos?
    static let requireValidSSLCertificates = true
    
    /// ¿Permitir certificados autofirmados?
    static let allowSelfSignedCertificates = false
    
    // MARK: - 📊 POLÍTICAS DE PRIVACIDAD
    
    /// ¿Recopilar analytics de uso?
    static let collectUsageAnalytics = false
    
    /// ¿Compartir datos con terceros?
    static let shareDataWithThirdParties = false
    
    /// ¿Permitir tracking de usuario?
    static let allowUserTracking = false
    
    /// ¿Requiere consentimiento explícito para datos médicos?
    static let requireExplicitMedicalDataConsent = true
    
    // MARK: - 🚨 POLÍTICAS DE INCIDENTES
    
    /// ¿Notificar automáticamente incidentes de seguridad?
    static let autoNotifySecurityIncidents = true
    
    /// Umbral para considerar un incidente como crítico
    static let criticalIncidentThreshold = 3
    
    /// Tiempo de respuesta máximo para incidentes críticos (en minutos)
    static let criticalIncidentResponseTimeMinutes = 15
    
    // MARK: - 🔧 POLÍTICAS DE DESARROLLO
    
    /// ¿Habilitar modo debug en producción?
    static let enableDebugModeInProduction = false
    
    /// ¿Mostrar información sensible en logs?
    static let showSensitiveInfoInLogs = false
    
    /// ¿Permitir acceso a consola de desarrollo?
    static let allowDeveloperConsoleAccess = false
    
    /// ¿Habilitar hot reload en producción?
    static let enableHotReloadInProduction = false
}

// MARK: - 🏷️ ENUMERACIONES DE CONFIGURACIÓN

enum DataProtectionLevel: String, CaseIterable {
    case none = "none"
    case complete = "complete"
    case completeUnlessOpen = "completeUnlessOpen"
    case completeUntilFirstUserAuthentication = "completeUntilFirstUserAuthentication"
    
    var description: String {
        switch self {
        case .none:
            return "Sin protección"
        case .complete:
            return "Protección completa"
        case .completeUnlessOpen:
            return "Protección completa a menos que esté abierta"
        case .completeUntilFirstUserAuthentication:
            return "Protección completa hasta primera autenticación"
        }
    }
}

enum AuditLogLevel: String, CaseIterable {
    case minimal = "minimal"
    case basic = "basic"
    case detailed = "detailed"
    case verbose = "verbose"
    
    var description: String {
        switch self {
        case .minimal:
            return "Mínimo - Solo eventos críticos"
        case .basic:
            return "Básico - Eventos importantes"
        case .detailed:
            return "Detallado - Todos los eventos"
        case .verbose:
            return "Verboso - Información completa"
        }
    }
}

// MARK: - 🔐 VALIDACIÓN DE CONFIGURACIÓN

extension SecurityConfiguration {
    
    /// Validar que la configuración cumple con estándares de seguridad médica
    static func validateConfiguration() -> [SecurityValidationIssue] {
        var issues: [SecurityValidationIssue] = []
        
        // Validar políticas de encriptación
        if encryptionKeySize < 256 {
            issues.append(.init(
                severity: .critical,
                category: .encryption,
                message: "Tamaño de clave insuficiente para datos médicos",
                recommendation: "Usar clave de al menos 256 bits"
            ))
        }
        
        // Validar políticas de autenticación
        if sessionTimeout > 3600 {
            issues.append(SecurityValidationIssue(
                severity: .medium,
                category: .authentication,
                message: "Timeout de sesión muy largo",
                recommendation: "Considerar reducir a máximo 1 hora"
            ))
        }
        
        // Validar políticas de auditoría
        if !enableAuditLogging {
            issues.append(SecurityValidationIssue(
                severity: .critical,
                category: .auditing,
                message: "Logging de auditoría deshabilitado",
                recommendation: "Habilitar para cumplir regulaciones médicas"
            ))
        }
        
        // Validar políticas de dispositivo
        if allowSimulatorUsage {
            issues.append(SecurityValidationIssue(
                severity: .medium,
                category: .device,
                message: "Uso en simulador permitido",
                recommendation: "Restringir para datos médicos reales"
            ))
        }
        
        return issues
    }
    
    /// Verificar si la configuración cumple con HIPAA
    static func isHIPAACompliant() -> Bool {
        let issues = validateConfiguration()
        let criticalIssues = issues.filter { $0.severity == .critical }
        return criticalIssues.isEmpty
    }
    
    /// Verificar si la configuración cumple con GDPR
    static func isGDPRCompliant() -> Bool {
        return requireExplicitMedicalDataConsent &&
               !shareDataWithThirdParties &&
               !allowUserTracking
    }
}

// MARK: - 📋 MODELO DE PROBLEMA DE VALIDACIÓN

struct SecurityValidationIssue {
    let severity: SecurityIssueSeverity
    let category: SecurityIssueCategory
    let message: String
    let recommendation: String
    
    var isCritical: Bool {
        return severity == .critical
    }
}

enum SecurityIssueSeverity: String, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
    
    var emoji: String {
        switch self {
        case .low: return "🟢"
        case .medium: return "🟡"
        case .high: return "🟠"
        case .critical: return "🔴"
        }
    }
}

enum SecurityIssueCategory: String, CaseIterable {
    case authentication = "authentication"
    case encryption = "encryption"
    case auditing = "auditing"
    case device = "device"
    case network = "network"
    case privacy = "privacy"
    case development = "development"
    
    var description: String {
        switch self {
        case .authentication: return "Autenticación"
        case .encryption: return "Encriptación"
        case .auditing: return "Auditoría"
        case .device: return "Dispositivo"
        case .network: return "Red"
        case .privacy: return "Privacidad"
        case .development: return "Desarrollo"
        }
    }
}
