//
//  PDFExportManager.swift
//  Pronostico fertilidad
//
//  Gestor de exportación PDF para reportes médicos profesionales
//

import SwiftUI
import PDFKit
#if os(iOS)
import UIKit
#endif
import Foundation

// MARK: - 📄 PDF EXPORT MANAGER
class PDFExportManager: ObservableObject {
    @Published var isGenerating = false
    @Published var progress: Double = 0.0
    @Published var errorMessage: String?
    
    // Configuración del PDF
    private let pageWidth: CGFloat = 612.0 // 8.5 x 72
    private let pageHeight: CGFloat = 792.0 // 11 x 72
    private let margin: CGFloat = 50.0
    
    // MARK: - 🏥 GENERAR REPORTE MÉDICO
    func generateMedicalReport(
        profile: FertilityProfile,
        result: ImprovedFertilityEngine.ComprehensiveFertilityResult
    ) -> Data? {
        isGenerating = true
        progress = 0.0
        errorMessage = nil
        
        defer {
            isGenerating = false
            progress = 0.0
        }
        
        let pdfMetaData = [
            kCGPDFContextCreator: "FertilyzeAI Medical Suite",
            kCGPDFContextAuthor: "Dr. Jorge Vasquez",
            kCGPDFContextTitle: "Reporte de Fertilidad",
            kCGPDFContextSubject: "Análisis de Fertilidad",
            kCGPDFContextKeywords: "fertilidad, medicina, reproducción, análisis"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let pdfData = renderer.pdfData { context in
            // Página 1: Portada y Resumen
            context.beginPage()
            drawCoverPage(context: context, profile: profile, result: result)
            progress = 0.2
            
            // Página 2: Datos Demográficos y Clínicos
            context.beginPage()
            drawDemographicsPage(context: context, profile: profile)
            progress = 0.4
            
            // Página 3: Resultados de Laboratorio
            context.beginPage()
            drawLaboratoryPage(context: context, profile: profile)
            progress = 0.6
            
            // Página 4: Análisis de Fertilidad
            context.beginPage()
            drawFertilityAnalysisPage(context: context, result: result)
            progress = 0.8
            
            // Página 5: Recomendaciones
            context.beginPage()
            drawRecommendationsPage(context: context, result: result)
            progress = 1.0
        }
        
        return pdfData
    }
    
    // MARK: - 🎨 PORTADA
    private func drawCoverPage(
        context: UIGraphicsPDFRendererContext,
        profile: FertilityProfile,
        result: ImprovedFertilityEngine.ComprehensiveFertilityResult
    ) {
        let cgContext = context.cgContext
        
        // Fondo
        let backgroundRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        cgContext.setFillColor(UIColor.systemBlue.cgColor)
        cgContext.fill(backgroundRect)
        
        // Logo y título
        let titleRect = CGRect(x: margin, y: 100, width: pageWidth - 2 * margin, height: 100)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 32),
            .foregroundColor: UIColor.white
        ]
        "FertilyzeAI Medical Suite".draw(in: titleRect, withAttributes: titleAttributes)
        
        // Subtítulo
        let subtitleRect = CGRect(x: margin, y: 180, width: pageWidth - 2 * margin, height: 50)
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.white.withAlphaComponent(0.9)
        ]
        "Reporte de Análisis de Fertilidad".draw(in: subtitleRect, withAttributes: subtitleAttributes)
        
        // Información del paciente
        let patientRect = CGRect(x: margin, y: 300, width: pageWidth - 2 * margin, height: 200)
        drawPatientInfo(context: cgContext, rect: patientRect, profile: profile)
        
        // Resultado principal
        let resultRect = CGRect(x: margin, y: 520, width: pageWidth - 2 * margin, height: 100)
        drawMainResult(context: cgContext, rect: resultRect, result: result)
        
        // Fecha y pie de página
        let dateRect = CGRect(x: margin, y: pageHeight - 100, width: pageWidth - 2 * margin, height: 50)
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.white.withAlphaComponent(0.8)
        ]
        let dateString = "Generado el: \(DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .short))"
        dateString.draw(in: dateRect, withAttributes: dateAttributes)
    }
    
    // MARK: - 👤 INFORMACIÓN DEL PACIENTE
    private func drawPatientInfo(context: CGContext, rect: CGRect, profile: FertilityProfile) {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.white
        ]
        
        let contentAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.white.withAlphaComponent(0.9)
        ]
        
        var yPosition: CGFloat = rect.minY
        
        // Título
        "INFORMACIÓN DEL PACIENTE".draw(
            at: CGPoint(x: rect.minX, y: yPosition),
            withAttributes: titleAttributes
        )
        yPosition += 30
        
        // Datos básicos
        let basicInfo = [
            "Edad: \(Int(profile.age)) años",
            "Altura: \(Int(profile.height)) cm",
            "Peso: \(Int(profile.weight)) kg",
            "IMC: \(String(format: "%.1f", profile.bmi))"
        ]
        
        for info in basicInfo {
            info.draw(
                at: CGPoint(x: rect.minX, y: yPosition),
                withAttributes: contentAttributes
            )
            yPosition += 20
        }
        
        yPosition += 20
        
        // Duración de infertilidad
        if let duration = profile.infertilityDuration {
            "Duración de infertilidad: \(String(format: "%.1f", duration)) años".draw(
                at: CGPoint(x: rect.minX, y: yPosition),
                withAttributes: contentAttributes
            )
            yPosition += 20
        }
        
        // Embarazos previos
        "Embarazos previos: \(profile.previousPregnancies)".draw(
            at: CGPoint(x: rect.minX, y: yPosition),
            withAttributes: contentAttributes
        )
    }
    
    // MARK: - 📊 RESULTADO PRINCIPAL
    private func drawMainResult(context: CGContext, rect: CGRect, result: ImprovedFertilityEngine.ComprehensiveFertilityResult) {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]
        
        let contentAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white.withAlphaComponent(0.9)
        ]
        
        // Título
        "RESULTADO PRINCIPAL".draw(
            at: CGPoint(x: rect.minX, y: rect.minY),
            withAttributes: titleAttributes
        )
        
        // Probabilidades
        let annualProb = String(format: "%.1f", result.annualProbability * 100)
        let monthlyProb = String(format: "%.1f", result.monthlyProbability * 100)
        
        "Probabilidad Anual: \(annualProb)%".draw(
            at: CGPoint(x: rect.minX, y: rect.minY + 30),
            withAttributes: contentAttributes
        )
        
        "Probabilidad Mensual: \(monthlyProb)%".draw(
            at: CGPoint(x: rect.minX, y: rect.minY + 50),
            withAttributes: contentAttributes
        )
        
        "Categoría: \(result.category.rawValue)".draw(
            at: CGPoint(x: rect.minX, y: rect.minY + 70),
            withAttributes: contentAttributes
        )
    }
    
    // MARK: - 📋 PÁGINA DEMOGRÁFICA
    private func drawDemographicsPage(context: UIGraphicsPDFRendererContext, profile: FertilityProfile) {
        let cgContext = context.cgContext
        
        // Título de página
        let titleRect = CGRect(x: margin, y: 50, width: pageWidth - 2 * margin, height: 50)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.black
        ]
        "DATOS DEMOGRÁFICOS Y CLÍNICOS".draw(in: titleRect, withAttributes: titleAttributes)
        
        var yPosition: CGFloat = 120
        
        // Sección: Información Básica
        drawSection(context: cgContext, title: "INFORMACIÓN BÁSICA", yPosition: &yPosition)
        
        let basicData = [
            ("Edad", "\(Int(profile.age)) años"),
            ("Altura", "\(Int(profile.height)) cm"),
            ("Peso", "\(Int(profile.weight)) kg"),
            ("IMC", String(format: "%.1f", profile.bmi)),
            ("Categoría IMC", getBMICategory(profile.bmi))
        ]
        
        drawDataTable(context: cgContext, data: basicData, yPosition: &yPosition)
        
        // Sección: Historia Ginecológica
        yPosition += 30
        drawSection(context: cgContext, title: "HISTORIA GINECOLÓGICA", yPosition: &yPosition)
        
        var gynecologyData: [(String, String)] = []
        
        if let cycleLength = profile.cycleLength {
            gynecologyData.append(("Duración del ciclo", "\(Int(cycleLength)) días"))
        }
        
        if let infertilityDuration = profile.infertilityDuration {
            gynecologyData.append(("Duración de infertilidad", "\(String(format: "%.1f", infertilityDuration)) años"))
        }
        
        gynecologyData.append(("Embarazos previos", "\(profile.previousPregnancies)"))
        gynecologyData.append(("SOP", profile.hasPcos ? "Sí" : "No"))
        
        if profile.hasPcos {
            gynecologyData.append(("Hirsutismo", profile.hirsutismSeverity.displayName))
            gynecologyData.append(("Acné", profile.acneSeverity.displayName))
            gynecologyData.append(("Morfología ovárica", profile.ovarianMorphology.displayName))
        }
        
        gynecologyData.append(("Endometriosis", profile.endometriosisStage > 0 ? "Grado \(profile.endometriosisStage)" : "No"))
        gynecologyData.append(("Miomas", profile.myomaType.displayName))
        gynecologyData.append(("Adenomiosis", profile.adenomyosisType.displayName))
        gynecologyData.append(("Pólipos", profile.polypType.displayName))
        gynecologyData.append(("HSG", profile.hsgResult.displayName))
        gynecologyData.append(("Cirugía pélvica", profile.hasPelvicSurgery ? "Sí (\(profile.numberOfPelvicSurgeries) cirugías)" : "No"))
        gynecologyData.append(("OTB", profile.hasOtb ? "Sí (\(profile.otbMethod.displayName))" : "No"))
        
        drawDataTable(context: cgContext, data: gynecologyData, yPosition: &yPosition)
    }
    
    // MARK: - 🧪 PÁGINA DE LABORATORIO
    private func drawLaboratoryPage(context: UIGraphicsPDFRendererContext, profile: FertilityProfile) {
        let cgContext = context.cgContext
        
        // Título de página
        let titleRect = CGRect(x: margin, y: 50, width: pageWidth - 2 * margin, height: 50)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.black
        ]
        "RESULTADOS DE LABORATORIO".draw(in: titleRect, withAttributes: titleAttributes)
        
        var yPosition: CGFloat = 120
        
        // Sección: Hormonas
        drawSection(context: cgContext, title: "PERFIL HORMONAL", yPosition: &yPosition)
        
        var hormoneData: [(String, String)] = []
        
        if let amh = profile.amhValue {
            hormoneData.append(("AMH", "\(String(format: "%.2f", amh)) ng/mL"))
        }
        
        if let tsh = profile.tshValue {
            hormoneData.append(("TSH", "\(String(format: "%.2f", tsh)) mIU/L"))
        }
        
        if let prolactin = profile.prolactinValue {
            hormoneData.append(("Prolactina", "\(String(format: "%.1f", prolactin)) ng/mL"))
        }
        
        if let insulin = profile.insulinValue {
            hormoneData.append(("Insulina", "\(String(format: "%.1f", insulin)) μIU/mL"))
        }
        
        if let glucose = profile.glucoseValue {
            hormoneData.append(("Glucosa", "\(String(format: "%.0f", glucose)) mg/dL"))
        }
        
        if let homaIr = profile.homaIr {
            hormoneData.append(("HOMA-IR", "\(String(format: "%.2f", homaIr))"))
        }
        
        hormoneData.append(("Anti-TPO", profile.tpoAbPositive ? "Positivo" : "Negativo"))
        
        drawDataTable(context: cgContext, data: hormoneData, yPosition: &yPosition)
        
        // Sección: Factor Masculino
        yPosition += 30
        drawSection(context: cgContext, title: "FACTOR MASCULINO", yPosition: &yPosition)
        
        var maleFactorData: [(String, String)] = []
        
        if let concentration = profile.spermConcentration {
            maleFactorData.append(("Concentración", "\(String(format: "%.1f", concentration)) millones/mL"))
        }
        
        if let motility = profile.spermProgressiveMotility {
            maleFactorData.append(("Motilidad progresiva", "\(String(format: "%.1f", motility))%"))
        }
        
        if let morphology = profile.spermNormalMorphology {
            maleFactorData.append(("Morfología normal", "\(String(format: "%.1f", morphology))%"))
        }
        
        if let volume = profile.semenVolume {
            maleFactorData.append(("Volumen", "\(String(format: "%.1f", volume)) mL"))
        }
        
        if let dnaFrag = profile.spermDNAFragmentation {
            maleFactorData.append(("Fragmentación DNA", "\(String(format: "%.1f", dnaFrag))%"))
        }
        
        maleFactorData.append(("Varicocele", profile.hasVaricocele ? "Sí" : "No"))
        maleFactorData.append(("Cultivo seminal", profile.seminalCulturePositive ? "Positivo" : "Negativo"))
        
        drawDataTable(context: cgContext, data: maleFactorData, yPosition: &yPosition)
    }
    
    // MARK: - 📊 PÁGINA DE ANÁLISIS
    private func drawFertilityAnalysisPage(context: UIGraphicsPDFRendererContext, result: ImprovedFertilityEngine.ComprehensiveFertilityResult) {
        let cgContext = context.cgContext
        
        // Título de página
        let titleRect = CGRect(x: margin, y: 50, width: pageWidth - 2 * margin, height: 50)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.black
        ]
        "ANÁLISIS DE FERTILIDAD".draw(in: titleRect, withAttributes: titleAttributes)
        
        var yPosition: CGFloat = 120
        
        // Sección: Resultados Principales
        drawSection(context: cgContext, title: "RESULTADOS PRINCIPALES", yPosition: &yPosition)
        
        let mainResults = [
            ("Probabilidad Anual", "\(String(format: "%.1f", result.annualProbability * 100))%"),
            ("Probabilidad Mensual", "\(String(format: "%.1f", result.monthlyProbability * 100))%"),
            ("Puntuación de Fertilidad", "\(String(format: "%.1f", result.fertilityScore))"),
            ("Categoría", result.category.rawValue),
            ("Nivel de Confianza", "\(String(format: "%.0f", result.confidenceLevel * 100))%"),
            ("Complejidad de Tratamiento", result.treatmentComplexity.rawValue),
            ("Nivel de Urgencia", result.urgencyLevel.rawValue)
        ]
        
        drawDataTable(context: cgContext, data: mainResults, yPosition: &yPosition)
        
        // Sección: Factores Clave
        yPosition += 30
        drawSection(context: cgContext, title: "FACTORES CLAVE", yPosition: &yPosition)
        
        let sortedFactors = result.keyFactors.sorted { $0.value < $1.value }
        var factorData: [(String, String)] = []
        
        for (factor, value) in sortedFactors.prefix(10) {
            let impact = value < 1.0 ? "Reducción" : "Aumento"
            let percentage = String(format: "%.1f", abs(1.0 - value) * 100)
            factorData.append((factor, "\(impact) \(percentage)%"))
        }
        
        drawDataTable(context: cgContext, data: factorData, yPosition: &yPosition)
        
        // Sección: Análisis Detallado
        yPosition += 30
        drawSection(context: cgContext, title: "ANÁLISIS DETALLADO", yPosition: &yPosition)
        
        let analysisRect = CGRect(x: margin, y: yPosition, width: pageWidth - 2 * margin, height: 200)
        let analysisAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.black
        ]
        
        result.detailedAnalysis.draw(in: analysisRect, withAttributes: analysisAttributes)
    }
    
    // MARK: - 💊 PÁGINA DE RECOMENDACIONES
    private func drawRecommendationsPage(context: UIGraphicsPDFRendererContext, result: ImprovedFertilityEngine.ComprehensiveFertilityResult) {
        let cgContext = context.cgContext
        
        // Título de página
        let titleRect = CGRect(x: margin, y: 50, width: pageWidth - 2 * margin, height: 50)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.black
        ]
        "RECOMENDACIONES MÉDICAS".draw(in: titleRect, withAttributes: titleAttributes)
        
        var yPosition: CGFloat = 120
        
        // Agrupar recomendaciones por prioridad
        let criticalRecs = result.recommendations.filter { $0.priority == .critical }
        let highRecs = result.recommendations.filter { $0.priority == .high }
        let mediumRecs = result.recommendations.filter { $0.priority == .medium }
        let lowRecs = result.recommendations.filter { $0.priority == .low }
        
        // Recomendaciones Críticas
        if !criticalRecs.isEmpty {
            drawRecommendationSection(context: cgContext, title: "🚨 CRÍTICAS", recommendations: criticalRecs, yPosition: &yPosition)
        }
        
        // Recomendaciones Altas
        if !highRecs.isEmpty {
            drawRecommendationSection(context: cgContext, title: "⚡ ALTA PRIORIDAD", recommendations: highRecs, yPosition: &yPosition)
        }
        
        // Recomendaciones Medias
        if !mediumRecs.isEmpty {
            drawRecommendationSection(context: cgContext, title: "💊 MEDIA PRIORIDAD", recommendations: mediumRecs, yPosition: &yPosition)
        }
        
        // Recomendaciones Bajas
        if !lowRecs.isEmpty {
            drawRecommendationSection(context: cgContext, title: "🌱 BAJA PRIORIDAD", recommendations: lowRecs, yPosition: &yPosition)
        }
        
        // Pie de página con disclaimer
        let disclaimerRect = CGRect(x: margin, y: pageHeight - 150, width: pageWidth - 2 * margin, height: 100)
        let disclaimerAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.gray
        ]
        
        let disclaimer = """
        DISCLAIMER MÉDICO:
        Este reporte es una herramienta de apoyo educativo y no debe reemplazar el consejo médico profesional. 
        Siempre consulte con un especialista en reproducción asistida para evaluación y tratamiento personalizados.
        
        Generado por FertilyzeAI Medical Suite
        """
        
        disclaimer.draw(in: disclaimerRect, withAttributes: disclaimerAttributes)
    }
    
    // MARK: - 🎨 FUNCIONES AUXILIARES
    private func drawSection(context: CGContext, title: String, yPosition: inout CGFloat) {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.systemBlue
        ]
        
        title.draw(
            at: CGPoint(x: margin, y: yPosition),
            withAttributes: titleAttributes
        )
        yPosition += 25
    }
    
    private func drawDataTable(context: CGContext, data: [(String, String)], yPosition: inout CGFloat) {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .medium),
            .foregroundColor: UIColor.black
        ]
        
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.darkGray
        ]
        
        for (title, value) in data {
            title.draw(
                at: CGPoint(x: margin, y: yPosition),
                withAttributes: titleAttributes
            )
            
            value.draw(
                at: CGPoint(x: margin + 200, y: yPosition),
                withAttributes: valueAttributes
            )
            
            yPosition += 18
        }
        
        yPosition += 10
    }
    
    private func drawRecommendationSection(
        context: CGContext,
        title: String,
        recommendations: [ImprovedFertilityEngine.Recommendation],
        yPosition: inout CGFloat
    ) {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.systemBlue
        ]
        
        let contentAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.black
        ]
        
        // Título de sección
        title.draw(
            at: CGPoint(x: margin, y: yPosition),
            withAttributes: titleAttributes
        )
        yPosition += 20
        
        // Recomendaciones
        for recommendation in recommendations {
            let titleString = "• \(recommendation.title)"
            titleString.draw(
                at: CGPoint(x: margin, y: yPosition),
                withAttributes: contentAttributes
            )
            yPosition += 16
            
            let descriptionRect = CGRect(x: margin + 20, y: yPosition, width: pageWidth - 2 * margin - 20, height: 60)
            recommendation.description.draw(in: descriptionRect, withAttributes: contentAttributes)
            yPosition += 70
            
            // Evitar que se salga de la página
            if yPosition > pageHeight - 200 {
                break
            }
        }
        
        yPosition += 10
    }
    
    private func getBMICategory(_ bmi: Double) -> String {
        switch bmi {
        case ..<18.5:
            return "Bajo peso"
        case 18.5..<25:
            return "Normal"
        case 25..<30:
            return "Sobrepeso"
        default:
            return "Obesidad"
        }
    }
}

// MARK: - 📱 EXTENSIONES DE VISTA
extension PDFExportManager {
    func sharePDF(
        profile: FertilityProfile,
        result: ImprovedFertilityEngine.ComprehensiveFertilityResult
    ) -> UIActivityViewController? {
        guard let pdfData = generateMedicalReport(profile: profile, result: result) else {
            errorMessage = "Error al generar el PDF"
            return nil
        }
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Reporte_Fertilidad.pdf")
        
        do {
            try pdfData.write(to: tempURL)
            
            let activityVC = UIActivityViewController(
                activityItems: [tempURL],
                applicationActivities: nil
            )
            
            // Configurar para iPad
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = UIApplication.shared.windows.first?.rootViewController?.view
                popover.sourceRect = CGRect(x: 0, y: 0, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            return activityVC
        } catch {
            errorMessage = "Error al guardar el PDF: \(error.localizedDescription)"
            return nil
        }
    }
}
