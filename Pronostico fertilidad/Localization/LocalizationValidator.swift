import Foundation
import SwiftUI

/// Validador de localización que implementa las recomendaciones críticas de Qwen
/// para detectar inconsistencias, claves faltantes y problemas de terminología médica
@MainActor
final class LocalizationValidator: ObservableObject {
    @Published var validationResults: [ValidationIssue] = []
    @Published var isValidationComplete = false
    
    // MARK: - Tipos de problemas identificados por Qwen
    enum IssueSeverity: String, CaseIterable {
        case critical = "Crítico"
        case major = "Grave"
        case minor = "Menor"
        
        var color: Color {
            switch self {
            case .critical: return .red
            case .major: return .orange
            case .minor: return .yellow
            }
        }
    }
    
    struct ValidationIssue: Identifiable {
        let id = UUID()
        let severity: IssueSeverity
        let category: String
        let description: String
        let recommendation: String
        let affectedFiles: [String]
    }
    
    // MARK: - Validación principal siguiendo Qwen
    func performFullValidation() async {
        validationResults.removeAll()
        
        // 1. Validar balance de archivos (Recomendación crítica de Qwen)
        await validateFileBalance()
        
        // 2. Validar claves faltantes
        await validateMissingKeys()
        
        // 3. Validar terminología médica
        await validateMedicalTerminology()
        
        // 4. Validar sistema de cambio de idioma
        await validateLanguageSwitching()
        
        // 5. Validar textos hardcodeados
        await validateHardcodedTexts()
        
        DispatchQueue.main.async {
            self.isValidationComplete = true
        }
    }
    
    // MARK: - Validación de balance de archivos
    private func validateFileBalance() async {
        let esPath = Bundle.main.path(forResource: "es", ofType: "lproj")
        let enPath = Bundle.main.path(forResource: "en", ofType: "lproj")
        
        guard let esPath = esPath, let enPath = enPath else {
            addIssue(.critical, "Archivos de localización", "No se encontraron archivos es.lproj o en.lproj", "Verificar que los archivos estén en el bundle correcto", ["Bundle"])
            return
        }
        
        let esStringsPath = (esPath as NSString).appendingPathComponent("Localizable.strings")
        let enStringsPath = (enPath as NSString).appendingPathComponent("Localizable.strings")
        
        do {
            let esContent = try String(contentsOfFile: esStringsPath, encoding: .utf8)
            let enContent = try String(contentsOfFile: enStringsPath, encoding: .utf8)
            
            let esLines = esContent.components(separatedBy: .newlines).filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            let enLines = enContent.components(separatedBy: .newlines).filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            
            let difference = abs(esLines.count - enLines.count)
            
            if difference > 50 {
                addIssue(.critical, "Balance de archivos", "Diferencia masiva entre archivos: ES (\(esLines.count)) vs EN (\(enLines.count)) líneas", "Sincronizar ambos archivos para tener el mismo número de claves", ["es.lproj", "en.lproj"])
            } else if difference > 10 {
                addIssue(.major, "Balance de archivos", "Diferencia significativa entre archivos: ES (\(esLines.count)) vs EN (\(enLines.count)) líneas", "Revisar claves faltantes en ambos idiomas", ["es.lproj", "en.lproj"])
            }
        } catch {
            addIssue(.critical, "Lectura de archivos", "Error al leer archivos de localización: \(error.localizedDescription)", "Verificar permisos y estructura de archivos", ["es.lproj", "en.lproj"])
        }
    }
    
    // MARK: - Validación de claves faltantes
    private func validateMissingKeys() async {
        // Implementar validación de claves faltantes
        addIssue(.major, "Claves faltantes", "Validación de claves faltantes pendiente de implementación", "Implementar comparación automática de claves entre idiomas", ["Localizable.strings"])
    }
    
    // MARK: - Validación de terminología médica (Recomendación crítica de Qwen)
    private func validateMedicalTerminology() async {
        let medicalTerms = [
            "fertilidad", "ovulación", "ciclo menstrual", "spermograma", "endometriosis",
            "miomas", "pólipos", "adenomiosis", "síndrome de ovario poliquístico"
        ]
        
        for term in medicalTerms {
            // Verificar que los términos médicos estén presentes en ambos idiomas
            addIssue(.critical, "Terminología médica", "Verificar traducción correcta de: \(term)", "Revisar con especialista médico y validar en ambos idiomas", ["es.lproj", "en.lproj"])
        }
    }
    
    // MARK: - Validación del sistema de cambio de idioma
    private func validateLanguageSwitching() async {
        // Verificar que el sistema de cambio de idioma esté funcionando
        let currentLang = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "es"
        
        if currentLang == "es" {
            addIssue(.major, "Sistema de idioma", "Idioma actual: Español. Verificar cambio a inglés", "Probar cambio de idioma y verificar que la UI se actualice", ["LocaleManager", "LocalizationManager"])
        } else {
            addIssue(.major, "Sistema de idioma", "Idioma actual: \(currentLang). Verificar cambio a español", "Probar cambio de idioma y verificar que la UI se actualice", ["LocaleManager", "LocalizationManager"])
        }
    }
    
    // MARK: - Validación de textos hardcodeados
    private func validateHardcodedTexts() async {
        addIssue(.major, "Textos hardcodeados", "Validación de textos hardcodeados pendiente de implementación", "Implementar escaneo automático del código para detectar textos sin localizar", ["*.swift"])
    }
    
    // MARK: - Métodos auxiliares
    private func addIssue(_ severity: IssueSeverity, _ category: String, _ description: String, _ recommendation: String, _ affectedFiles: [String]) {
        let issue = ValidationIssue(
            severity: severity,
            category: category,
            description: description,
            recommendation: recommendation,
            affectedFiles: affectedFiles
        )
        
        DispatchQueue.main.async {
            self.validationResults.append(issue)
        }
    }
    
    // MARK: - Generar reporte de validación
    func generateValidationReport() -> String {
        var report = "=== REPORTE DE VALIDACIÓN DE LOCALIZACIÓN ===\n"
        report += "Fecha: \(Date().formatted())\n"
        report += "Total de problemas: \(validationResults.count)\n\n"
        
        for severity in IssueSeverity.allCases {
            let issues = validationResults.filter { $0.severity == severity }
            if !issues.isEmpty {
                report += "--- \(severity.rawValue.uppercased()) (\(issues.count)) ---\n"
                for issue in issues {
                    report += "• \(issue.description)\n"
                    report += "  Recomendación: \(issue.recommendation)\n"
                    report += "  Archivos afectados: \(issue.affectedFiles.joined(separator: ", "))\n\n"
                }
            }
        }
        
        return report
    }
}
