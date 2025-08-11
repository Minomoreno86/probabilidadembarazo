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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
