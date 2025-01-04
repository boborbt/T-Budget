//
//  DataManager.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 04/01/25.
//

import SwiftData

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
    
    @MainActor static let sharedModelContext: ModelContext = ModelContext(DataManager.sharedModelContainer)
}
