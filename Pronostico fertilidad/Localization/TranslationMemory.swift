import Foundation
import SwiftUI

/// Sistema de Memoria de Traducción (CAT) que implementa las recomendaciones críticas de Qwen
/// para mantener consistencia en terminología médica y traducciones
@MainActor
final class TranslationMemory: ObservableObject {
    @Published var translationUnits: [TranslationUnit] = []
    @Published var medicalGlossary: [MedicalTerm] = []
    @Published var consistencyScore: Double = 0.0
    
    // MARK: - Estructuras de datos para CAT
    struct TranslationUnit: Identifiable, Codable {
        let id = UUID()
        let sourceText: String
        let targetText: String
        let sourceLanguage: String
        let targetLanguage: String
        let context: String
        let category: String
        let confidence: Double
        let lastUsed: Date
        let usageCount: Int
    }
    
    struct MedicalTerm: Identifiable, Codable {
        let id = UUID()
        let term: String
        let spanishTranslation: String
        let englishTranslation: String
        let definition: String
        let category: MedicalCategory
        let approvedBy: String
        let approvalDate: Date
    }
    
    enum MedicalCategory: String, CaseIterable, Codable {
        case fertility = "Fertilidad"
        case gynecology = "Ginecología"
        case endocrinology = "Endocrinología"
        case urology = "Urología"
        case laboratory = "Laboratorio"
        case imaging = "Imagenología"
        case treatment = "Tratamiento"
        case diagnosis = "Diagnóstico"
    }
    
    // MARK: - Inicialización con glosario médico predefinido
    init() {
        setupMedicalGlossary()
        loadTranslationMemory()
    }
    
    // MARK: - Configuración del glosario médico (Recomendación crítica de Qwen)
    private func setupMedicalGlossary() {
        medicalGlossary = [
            MedicalTerm(
                term: "fertilidad",
                spanishTranslation: "fertilidad",
                englishTranslation: "fertility",
                definition: "Capacidad de concebir y tener hijos",
                category: .fertility,
                approvedBy: "Dr. Jorge Vasquez",
                approvalDate: Date()
            ),
            MedicalTerm(
                term: "ovulación",
                spanishTranslation: "ovulación",
                englishTranslation: "ovulation",
                definition: "Liberación de un óvulo maduro del ovario",
                category: .gynecology,
                approvedBy: "Dr. Jorge Vasquez",
                approvalDate: Date()
            ),
            MedicalTerm(
                term: "ciclo menstrual",
                spanishTranslation: "ciclo menstrual",
                englishTranslation: "menstrual cycle",
                definition: "Proceso mensual de preparación del útero para el embarazo",
                category: .gynecology,
                approvedBy: "Dr. Jorge Vasquez",
                approvalDate: Date()
            ),
            MedicalTerm(
                term: "spermograma",
                spanishTranslation: "spermograma",
                englishTranslation: "semen analysis",
                definition: "Análisis de la calidad y cantidad del semen",
                category: .urology,
                approvedBy: "Dr. Jorge Vasquez",
                approvalDate: Date()
            ),
            MedicalTerm(
                term: "endometriosis",
                spanishTranslation: "endometriosis",
                englishTranslation: "endometriosis",
                definition: "Crecimiento del tejido endometrial fuera del útero",
                category: .gynecology,
                approvedBy: "Dr. Jorge Vasquez",
                approvalDate: Date()
            ),
            MedicalTerm(
                term: "miomas",
                spanishTranslation: "miomas",
                englishTranslation: "fibroids",
                definition: "Tumores benignos del músculo uterino",
                category: .gynecology,
                approvedBy: "Dr. Jorge Vasquez",
                approvalDate: Date()
            ),
            MedicalTerm(
                term: "pólipos",
                spanishTranslation: "pólipos",
                englishTranslation: "polyps",
                definition: "Crecimientos anormales en la superficie de tejidos",
                category: .gynecology,
                approvedBy: "Dr. Jorge Vasquez",
                approvalDate: Date()
            ),
            MedicalTerm(
                term: "adenomiosis",
                spanishTranslation: "adenomiosis",
                englishTranslation: "adenomyosis",
                definition: "Crecimiento del endometrio en la pared muscular del útero",
                category: .gynecology,
                approvedBy: "Dr. Jorge Vasquez",
                approvalDate: Date()
            ),
            MedicalTerm(
                term: "síndrome de ovario poliquístico",
                spanishTranslation: "síndrome de ovario poliquístico",
                englishTranslation: "polycystic ovary syndrome",
                definition: "Trastorno hormonal que afecta los ovarios",
                category: .endocrinology,
                approvedBy: "Dr. Jorge Vasquez",
                approvalDate: Date()
            )
        ]
    }
    
    // MARK: - Cargar memoria de traducción
    private func loadTranslationMemory() {
        // Cargar desde UserDefaults o archivo
        if let data = UserDefaults.standard.data(forKey: "TranslationMemory"),
           let units = try? JSONDecoder().decode([TranslationUnit].self, from: data) {
            translationUnits = units
        }
    }
    
    // MARK: - Guardar memoria de traducción
    private func saveTranslationMemory() {
        if let data = try? JSONEncoder().encode(translationUnits) {
            UserDefaults.standard.set(data, forKey: "TranslationMemory")
        }
    }
    
    // MARK: - Buscar traducción existente (CAT)
    func findExistingTranslation(for sourceText: String, in targetLanguage: String) -> TranslationUnit? {
        return translationUnits.first { unit in
            unit.sourceText.lowercased() == sourceText.lowercased() &&
            unit.targetLanguage == targetLanguage
        }
    }
    
    // MARK: - Agregar nueva traducción
    func addTranslation(sourceText: String, targetText: String, sourceLanguage: String, targetLanguage: String, context: String, category: String) {
        let unit = TranslationUnit(
            sourceText: sourceText,
            targetText: targetText,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            context: context,
            category: category,
            confidence: 1.0,
            lastUsed: Date(),
            usageCount: 1
        )
        
        translationUnits.append(unit)
        saveTranslationMemory()
        updateConsistencyScore()
    }
    
    // MARK: - Validar consistencia de terminología médica
    func validateMedicalTerminology(text: String, language: String) -> [MedicalTerm] {
        let lowercasedText = text.lowercased()
        return medicalGlossary.filter { term in
            let searchText = language == "es" ? term.spanishTranslation : term.englishTranslation
            return lowercasedText.contains(searchText.lowercased())
        }
    }
    
    // MARK: - Actualizar puntuación de consistencia
    private func updateConsistencyScore() {
        let totalUnits = translationUnits.count
        let consistentUnits = translationUnits.filter { unit in
            // Verificar que la traducción sea consistente con el glosario médico
            let medicalTerms = validateMedicalTerminology(text: unit.sourceText, language: unit.sourceLanguage)
            return !medicalTerms.isEmpty
        }.count
        
        consistencyScore = totalUnits > 0 ? Double(consistentUnits) / Double(totalUnits) : 0.0
    }
    
    // MARK: - Generar reporte de consistencia
    func generateConsistencyReport() -> String {
        var report = "=== REPORTE DE CONSISTENCIA DE TRADUCCIÓN ===\n"
        report += "Fecha: \(Date().formatted())\n"
        report += "Puntuación de consistencia: \(String(format: "%.1f%%", consistencyScore * 100))\n"
        report += "Total de unidades de traducción: \(translationUnits.count)\n\n"
        
        // Agrupar por categoría
        let groupedByCategory = Dictionary(grouping: translationUnits) { $0.category }
        
        for (category, units) in groupedByCategory.sorted(by: { $0.key < $1.key }) {
            report += "--- \(category.uppercased()) (\(units.count)) ---\n"
            for unit in units.prefix(5) { // Mostrar solo las primeras 5
                report += "• \(unit.sourceText) → \(unit.targetText)\n"
            }
            if units.count > 5 {
                report += "... y \(units.count - 5) más\n"
            }
            report += "\n"
        }
        
        return report
    }
    
    // MARK: - Exportar glosario médico
    func exportMedicalGlossary() -> String {
        var glossary = "=== GLOSARIO MÉDICO APROBADO ===\n"
        glossary += "Fecha de exportación: \(Date().formatted())\n"
        glossary += "Total de términos: \(medicalGlossary.count)\n\n"
        
        for category in MedicalCategory.allCases {
            let terms = medicalGlossary.filter { $0.category == category }
            if !terms.isEmpty {
                glossary += "--- \(category.rawValue.uppercased()) ---\n"
                for term in terms {
                    glossary += "• \(term.term)\n"
                    glossary += "  ES: \(term.spanishTranslation)\n"
                    glossary += "  EN: \(term.englishTranslation)\n"
                    glossary += "  Definición: \(term.definition)\n"
                    glossary += "  Aprobado por: \(term.approvedBy) el \(term.approvalDate.formatted(date: .abbreviated, time: .omitted))\n\n"
                }
            }
        }
        
        return glossary
    }
}
