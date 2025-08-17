//
//  String+Localization.swift
//  Pronostico fertilidad
//
//  Extension to facilitate localization throughout the application
//

import Foundation

extension String {
    
    /// Returns the localized version of the string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Returns the localized version of the string with arguments
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
    
    /// Returns the localized version of the string with one argument
    func localized(with argument: CVarArg) -> String {
        return String(format: self.localized, argument)
    }
    
    /// Returns the localized version of the string with multiple arguments
    func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

// MARK: - Localization Keys
/// Constants for localization keys
struct LocalizationKeys {
    
    // MARK: - App Branding
    static let appName = "FertilyzeAI"
    static let medicalSuite = "Medical Suite"
    
    // MARK: - Login & Authentication
    static let welcome = "Bienvenido"
    static let secureSignIn = "Inicia sesión de forma segura con Passkeys o Apple Sign In"
    static let continueWithoutAccount = "Continuar sin cuenta"
    static let configureBiometric = "Configura tu identidad biométrica segura"
    static let verifyingAuthentication = "Verificando autenticación..."
    static let authenticationError = "Error de Autenticación"
    
    // MARK: - Main Content
    static let fertilityPrognosis = "Pronóstico de"
    static let fertility = "FERTILIDAD"
    static let advancedMedicalAI = "Inteligencia Artificial Médica Avanzada"
    static let scientificEvidence = "Evidencia Científica"
    static let advancedAI = "IA Avanzada"
    static let medicalValidation = "Validación Médica"
    static let systemMetrics = "Métricas del Sistema"
    static let realTime = "Tiempo real"
    static let assessments = "Evaluaciones"
    static let completed = "Completadas"
    static let accuracy = "Precisión"
    static let clinicalValidation = "Validación Clínica"
    static let references = "Referencias"
    static let scientificArticles = "Artículos Científicos"
    static let algorithms = "Algoritmos"
    static let clinicalBenchmarks = "Benchmarks Clínicos"
    
    // MARK: - Features
    static let fertilityAssessmentAI = "Evaluación de fertilidad con inteligencia artificial médica de última generación"
    static let nonLinearInteractions = "15 Interacciones No Lineales"
    static let clinicalBenchmarksCount = "21 Benchmarks Clínicos"
    static let eshreAsrmEvidence = "Evidencia Científica ESHRE/ASRM"
    static let startAdvancedAssessment = "Iniciar Evaluación Avanzada"
    
    // MARK: - Profiles
    static let myAssessments = "Mis Evaluaciones"
    static let new = "Nueva"
    static let assessment = "Evaluación"
    static let dropToDelete = "Suelta para eliminar"
    static let created = "Creada:"
    static let years = "años"
    static let bmi = "IMC"
    static let complete = "completo"
    static let progress = "progreso"
    
    // MARK: - Medical Information
    static let scientificallyValidated = "Validado Científicamente"
    static let basedOnGuidelines = "Basado en guías ESHRE, ASRM, OMS y más de 847 referencias científicas"
    
    // MARK: - Settings
    static let settings = "Configuración"
    static let fertilityPrognosisApp = "Pronóstico Fertilidad"
    static let version = "Versión 2.1.0"
    static let versionBuild = "Versión 2.1.0 (Build 2024.12)"
    static let exampleTitle = "Título de ejemplo"
    static let appVersion = "Versión de la Aplicación"
    static let voiceNavigationEnabled = "Navegación por voz habilitada"
    static let adaptiveTextSizes = "Tamaños de texto adaptativos"
    static let activeSession = "Sesión Activa"
    static let signOut = "Cerrar Sesión"
    static let exitAppSecurely = "Salir de la aplicación de forma segura"
    static let confirmSignOut = "¿Estás seguro de que deseas cerrar sesión? Se eliminarán todos los datos locales."
    static let signOutDataWarning = "Al cerrar sesión se eliminarán todos los datos locales no sincronizados"
    
    // MARK: - About & Information
    static let aboutApp = "Acerca de la Aplicación"
    static let appDescription = "Herramienta profesional para el cálculo de pronóstico de fertilidad basada en evidencia médica actualizada. Incluye algoritmos avanzados, interacciones no lineales y benchmarks clínicos."
    static let medicalReferences = "Referencias Médicas"
    static let shareWithColleagues = "Comparte la app con colegas médicos"
    static let legalAndMedical = "Legal y Médico"
    static let termsAndPolicies = "Términos, políticas y avisos importantes"
    static let information = "Información"
    static let versionSupportSocial = "Versión, soporte y redes sociales"
    
    // MARK: - Medical Disclaimer
    static let importantMedicalNotice = "Aviso Médico Importante"
    static let diagnosticSupportTool = "Esta herramienta es de apoyo diagnóstico. Siempre consulta con un médico profesional."
    static let diagnosticSupportOnly = "Esta herramienta es de apoyo diagnóstico únicamente. Los resultados no reemplazan el criterio médico profesional. Siempre consulta con un especialista en medicina reproductiva para decisiones clínicas."
    static let diagnosticSupportConsult = "Apoyo diagnóstico - Consulta médico profesional"
    static let copyright = "© 2024 Dr. Jorge Vásquez - Medicina Reproductiva"
    
    // MARK: - Calculator & Results
    static let medicalAssessment = "Evaluación Médica"
    static let analysis = "Análisis"
    static let score = "Puntuación"
    static let clinicalInterpretation = "Interpretación Clínica"
    static let completeMedicalAnalysis = "Análisis Médico Completo"
    static let clinicalAssessment = "Evaluación Clínica"
    static let detailedMedicalAnalysis = "Análisis médico detallado"
    static let autoGeneratedAnalysis = "Análisis generado automáticamente"
    static let criticalInteractions = "Interacciones Críticas:"
    static let andMore = "... y %d más"
    
    // MARK: - Medical Evaluations
    static let detailedPCOSAssessment = "Evaluación Detallada del SOP"
    static let androgenicManifestations = "Manifestaciones Androgénicas"
    static let mildChinHair = "Leve (vello en mentón)"
    static let moderateChinCheekHair = "Moderado (vello en mentón + mejillas)"
    static let moderatePersistentAcne = "Moderado (acné persistente)"
    static let severeCysticAcne = "Severo (acné quístico)"
    static let ovarianAssessment = "Evaluación Ovárica"
    static let polycysticOvaries = "Ovarios poliquísticos (>12 folículos)"
    static let gradeIMinimal = "Grado I (mínima)"
    static let largestFibroidSize = "Tamaño del mioma más grande"
    static let endometrialPolyps = "Pólipos Endometriales"
    static let noPolyps = "Sin pólipos"
    static let single = "Único"
    static let multiple = "Múltiples"
    static let hsg = "Histerosalpingografía (HSG)"
    static let unilateralObstruction = "Obstrucción unilateral"
    static let bilateralObstruction = "Obstrucción bilateral"
    static let otbDiagnosticMethod = "Método de Diagnóstico OTB"
    static let coagulation = "Coagulación"
    static let salpingectomy = "Salpingectomía"
    
    // MARK: - Fertility Calculations
    static let excellent = "Excelente"
    static let good = "Buena"
    static let moderate = "Moderada"
    static let low = "Baja"
    static let veryLow = "Muy Baja"
    static let critical = "Crítica"
    static let excellentFertility = "Fertilidad excelente. Coito programado con monitoreo."
    static let goodFertility = "Buena fertilidad. Inducción de ovulación recomendada."
    static let moderateFertility = "Fertilidad moderada. IUI con estimulación controlada."
    static let lowFertility = "Fertilidad baja. FIV/ICSI indicada."
    static let veryLowFertility = "Fertilidad muy baja. FIV/ICSI con PGT-A."
    static let criticalFertility = "Fertilidad crítica. Técnicas reproductivas avanzadas."
    
    // MARK: - Interactions & Visualization
    static let enhancingFactors = "Factores que se potencian entre sí"
    static let criticalFactors = "Críticas"
    static let factorInteractionVisualization = "Visualización de cómo interactúan los factores"
    static let independentFactors = "Esto significa que los factores actúan de forma independiente y las probabilidades calculadas no requieren ajustes adicionales."
    
    // MARK: - Font Selection
    static let customizeTypography = "Personaliza la Tipografía"
    static let fertilityAnalysis = "Análisis de Fertilidad"
    static let diagnosticSupportToolShort = "Herramienta de apoyo diagnóstico"
    static let prognosisResult = "Resultado del pronóstico: 85%"
    static let importantMedicalInfo = "Información médica importante que debe ser legible para todos los usuarios."
    
    // MARK: - Passkeys & Authentication
    static let authenticationCancelled = "Autenticación cancelada"
    static let authenticationErrorShort = "Error de autenticación"
    static let invalidResponse = "Respuesta inválida"
    static let couldNotProcessAuth = "No se pudo procesar la autenticación"
    static let unknownError = "Error desconocido"
    static let passkeyUser = "Usuario Passkey"
    static let faceID = "Face ID"
    static let touchID = "Touch ID"
    static let biometrics = "Biometría"
    static let authentication = "Autenticación"
    
    // MARK: - General UI
    static let termsAndPrivacy = "Al continuar, aceptas nuestros términos de servicio y política de privacidad"
    static let diagnosticSupportAlways = "Esta herramienta es de apoyo diagnóstico. Siempre consulta con criterio médico profesional."
    
    // MARK: - Profile Count
    static let singleAssessment = "%d evaluación"
    static let multipleAssessments = "%d evaluaciones"
    static let completedSingle = "completada"
    static let completedMultiple = "completadas"
}
