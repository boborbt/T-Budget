//
//  DataManager.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 04/01/25.
//

import SwiftData
import Foundation

struct DataManager {
    @MainActor
    static let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Limit.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            let limits = try container.mainContext.fetch(FetchDescriptor<Limit>())
            if limits.isEmpty {
                for tag in Tags.allCases {
                    container.mainContext.insert(Limit(tag: tag.rawValue, amount: Decimal(0)))
                }
                
                try container.mainContext.save()
            }
            
            return container
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
                Limit.self
            ])
            let container = try ModelContainer(for: schema, configurations: config)
            let now = Date()
            
            container.mainContext.insert(Item(timestamp: Date(day: now.day - 4  , month: now.month, year: now.year), tag: "Car", amount: Decimal(200)))
            container.mainContext.insert(Item(timestamp: Date(day: now.day - 2  , month: now.month, year: now.year), tag: "Home", amount: Decimal(50)))
            container.mainContext.insert(Item(timestamp: Date(day: now.day      , month: now.month, year: now.year), tag: "Groceries", amount: Decimal(10.50)))
            container.mainContext.insert(Item(timestamp: Date(day: now.day +  1 , month: now.month, year: now.year), tag: "Home", amount: Decimal(10)))
            container.mainContext.insert(Item(timestamp: Date(day: now.day +  2 , month: now.month, year: now.year), tag: "Car", amount: Decimal(40)))
            container.mainContext.insert(Item(timestamp: Date(day: now.day + 7  , month: now.month, year: now.year), tag: "Extra", amount: Decimal(100)))
            container.mainContext.insert(Item(timestamp: Date(day: 27           , month: now.previousMonth.month, year: now.year), tag: "School", amount: Decimal(30)))
            container.mainContext.insert(Item(timestamp: Date(day: 27           , month: now.previousMonth.month, year: now.year), tag: "Home", amount: Decimal(50)))
            container.mainContext.insert(Item(timestamp: Date(day: 28           , month: now.previousMonth.month, year: now.year), tag: "Car", amount: Decimal(20)))
            container.mainContext.insert(Item(timestamp: Date(day: 28           , month: now.previousMonth.month, year: now.year), tag: "Extra", amount: Decimal(80)))
            
            container.mainContext.insert(Limit(tag: "Car", amount: 100))
            container.mainContext.insert(Limit(tag: "Groceries", amount: 50))
            container.mainContext.insert(Limit(tag: "School", amount: 200))

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
    
    @MainActor static let sharedModelContext: ModelContext = ModelContext(DataManager.sharedModelContainer)
}
