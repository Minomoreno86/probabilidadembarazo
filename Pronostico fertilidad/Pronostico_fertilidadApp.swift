//
//  Pronostico_fertilidadApp.swift
//  Pronostico fertilidad
//
//  Created by Jorge Vasquez rodriguez on 11/08/2025.
//

import SwiftUI
import SwiftData

@main
struct Pronostico_fertilidadApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var appleSignInManager = AppleSignInManager()
    
    // MARK: - 🗄️ CONFIGURACIÓN DE BASE DE DATOS
    // Nota: Usando memoria temporal durante desarrollo debido a cambios en el modelo
    // Para producción, cambiar isStoredInMemoryOnly a false
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FertilityProfile.self,
            FertilityCalculationResult.self,
        ])
        // Configuración temporal para desarrollo - usar memoria durante pruebas
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environmentObject(appleSignInManager)
                .environment(\.themeColors, ThemeColors.current(themeManager.currentTheme))
                .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
                .onAppear {
                    // Forzar la aplicación del tema
                    themeManager.objectWillChange.send()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
