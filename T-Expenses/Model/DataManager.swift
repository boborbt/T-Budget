//
//  DataManager.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 04/01/25.
//

import SwiftData
import Foundation

struct DataManager {
    static let sharedModelContainer: ModelContainer = {
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
    
    @MainActor
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let schema = Schema([
                Item.self,
            ])
            let container = try ModelContainer(for: schema, configurations: config)
            
            container.mainContext.insert(Item(timestamp: Date(day: 4, month: 1, year: 2025), tag: "Car", amount: Decimal(200)))
            container.mainContext.insert(Item(timestamp: Date(day: 4, month: 1, year: 2025), tag: "Home", amount: Decimal(50)))
            container.mainContext.insert(Item(timestamp: Date(day: 7, month: 1, year: 2025), tag: "School", amount: Decimal(10)))
            container.mainContext.insert(Item(timestamp: Date(day: 10, month: 1, year: 2025), tag: "Home", amount: Decimal(10)))
            container.mainContext.insert(Item(timestamp: Date(day: 10, month: 1, year: 2025), tag: "Car", amount: Decimal(40)))
            container.mainContext.insert(Item(timestamp: Date(day: 11, month: 1, year: 2025), tag: "Extra", amount: Decimal(100)))
            container.mainContext.insert(Item(timestamp: Date(day: 4, month: 2, year: 2025), tag: "School", amount: Decimal(30)))
            container.mainContext.insert(Item(timestamp: Date(day: 4, month: 2, year: 2025), tag: "Home", amount: Decimal(50)))
            container.mainContext.insert(Item(timestamp: Date(day: 17, month: 2, year: 2025), tag: "Car", amount: Decimal(20)))
            container.mainContext.insert(Item(timestamp: Date(day: 18, month: 2, year: 2025), tag: "Extra", amount: Decimal(80)))

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
    
    @MainActor static let sharedModelContext: ModelContext = ModelContext(DataManager.sharedModelContainer)
}
