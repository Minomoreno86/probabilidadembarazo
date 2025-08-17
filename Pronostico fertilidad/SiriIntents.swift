import Foundation
import AppIntents
import SwiftUI

// MARK: - 🎯 Siri Commands for Fertility Prognosis

@available(iOS 16.0, *)
struct CalcularFertilidadIntent: AppIntent {
    static var title: LocalizedStringResource = "Calcular Fertilidad"
            static var description: LocalizedStringResource = "Start a new fertility assessment"
    
    func perform() async throws -> some IntentResult {
        // Navegar a la calculadora de fertilidad
        NotificationCenter.default.post(name: NSNotification.Name("OpenFertilityCalculator"), object: nil)
        return .result()
    }
}

@available(iOS 16.0, *)
struct MostrarEvaluacionesIntent: AppIntent {
    static var title: LocalizedStringResource = "Mostrar Evaluaciones"
    static var description: LocalizedStringResource = "Muestra mis evaluaciones de fertilidad"
    
    func perform() async throws -> some IntentResult {
        // Navegar a la lista de evaluaciones
        NotificationCenter.default.post(name: NSNotification.Name("ShowEvaluations"), object: nil)
        return .result()
    }
}

@available(iOS 16.0, *)
struct NuevaEvaluacionIntent: AppIntent {
            static var title: LocalizedStringResource = "New Assessment"
        static var description: LocalizedStringResource = "Create a new fertility assessment"
    
    func perform() async throws -> some IntentResult {
        // Navigate to new assessment
        NotificationCenter.default.post(name: NSNotification.Name("NewEvaluation"), object: nil)
        return .result()
    }
}

@available(iOS 16.0, *)
struct ResultadosRecientesIntent: AppIntent {
    static var title: LocalizedStringResource = "Resultados Recientes"
            static var description: LocalizedStringResource = "Show the most recent results"
    
    func perform() async throws -> some IntentResult {
        // Navegar a resultados recientes
        NotificationCenter.default.post(name: NSNotification.Name("ShowRecentResults"), object: nil)
        return .result()
    }
}

    // MARK: - 📊 Command with Parameters
@available(iOS 16.0, *)
struct EvaluarFertilidadConParametrosIntent: AppIntent {
    static var title: LocalizedStringResource = "Evaluar Fertilidad"
            static var description: LocalizedStringResource = "Evaluate fertility with specific parameters"
    
    @Parameter(title: "Edad")
    var edad: Int
    
    @Parameter(title: "Tiempo intentando concebir (meses)")
    var tiempoIntentando: Int
    
    init() {}
    
    init(edad: Int, tiempoIntentando: Int) {
        self.edad = edad
        self.tiempoIntentando = tiempoIntentando
    }
    
    func perform() async throws -> some IntentResult {
        // Create assessment with parameters
        let parametros = [
            "edad": edad,
            "tiempoIntentando": tiempoIntentando
        ]
        NotificationCenter.default.post(name: NSNotification.Name("EvaluateWithParameters"), object: parametros)
        return .result()
    }
}

// MARK: - 🎨 Shortcuts Personalizados
@available(iOS 16.0, *)
struct PronosticoFertilidadShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: CalcularFertilidadIntent(),
            phrases: [
                "Calcular fertilidad con \(.applicationName)",
                "Evaluar fertilidad en \(.applicationName)",
                "New fertility assessment in \(.applicationName)"
            ],
            shortTitle: "Calcular Fertilidad",
            systemImageName: "heart.fill"
        )
        
        AppShortcut(
            intent: MostrarEvaluacionesIntent(),
            phrases: [
                "Mostrar mis evaluaciones en \(.applicationName)",
                "Ver evaluaciones de fertilidad en \(.applicationName)",
                "Historial de evaluaciones en \(.applicationName)"
            ],
            shortTitle: "Mis Evaluaciones",
            systemImageName: "list.bullet"
        )
        
        AppShortcut(
            intent: NuevaEvaluacionIntent(),
            phrases: [
                            "New assessment in \(.applicationName)",
            "Create fertility assessment in \(.applicationName)",
            "Start assessment in \(.applicationName)"
            ],
                          shortTitle: "New Assessment",
            systemImageName: "plus.circle"
        )
        
        AppShortcut(
            intent: ResultadosRecientesIntent(),
            phrases: [
                "Resultados recientes en \(.applicationName)",
                "Latest fertility results in \(.applicationName)",
                "Ver resultados recientes en \(.applicationName)"
            ],
                          shortTitle: "Recent Results",
            systemImageName: "chart.bar.fill"
        )
        

    }
}

// MARK: - 🔧 Gestor de Notificaciones de Siri
class SiriIntentManager: ObservableObject {
    static let shared = SiriIntentManager()
    
    @Published var shouldOpenCalculator = false
    @Published var shouldShowEvaluations = false
    @Published var shouldNewEvaluation = false
    @Published var shouldShowRecentResults = false
    @Published var evaluationParameters: [String: Any]?
    
    private init() {
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("OpenFertilityCalculator"),
            object: nil,
            queue: .main
        ) { _ in
            self.shouldOpenCalculator = true
        }
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("ShowEvaluations"),
            object: nil,
            queue: .main
        ) { _ in
            self.shouldShowEvaluations = true
        }
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("NewEvaluation"),
            object: nil,
            queue: .main
        ) { _ in
            self.shouldNewEvaluation = true
        }
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("ShowRecentResults"),
            object: nil,
            queue: .main
        ) { _ in
            self.shouldShowRecentResults = true
        }
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("EvaluateWithParameters"),
            object: nil,
            queue: .main
        ) { notification in
            self.evaluationParameters = notification.object as? [String: Any]
            self.shouldOpenCalculator = true
        }
    }
}
