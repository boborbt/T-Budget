//
//  T_ExpensesApp.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 01/01/25.
//

import SwiftUI
import SwiftData


@main
struct T_Budget: App {
    var sharedModelContainer: ModelContainer = DataManager.sharedModelContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
    
    init() {
        ExpShortCutProvider.updateAppShortcutParameters()
    }
}
