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
            Ingredient.self,
            Recipe.self,
            RecipeIngredient.self,
            MenuOption.self,
            Order.self,
            OrderItem.self
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
            HomeView()
                .onAppear {
                    setupInitialData()
                }
        }
        .modelContainer(sharedModelContainer)
    }
    
    private func setupInitialData() {
        let context = sharedModelContainer.mainContext
        
        // Mock 데이터가 없으면 삽입
        if !MockDataManager.hasMockData(in: context) {
            MockDataManager.insertAllMockData(in: context)
        }
    }
}
