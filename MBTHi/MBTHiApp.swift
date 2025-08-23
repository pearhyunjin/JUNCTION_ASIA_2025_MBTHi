//
//  MBTHiApp.swift
//  MBTHi
//
//  Created by 배현진 on 8/23/25.
//

import SwiftUI
import SwiftData

@main
struct MBTHiApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Stock.self,
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
