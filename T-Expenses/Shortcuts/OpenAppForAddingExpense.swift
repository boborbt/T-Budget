//
//  OpenAppForAddingExpense.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 05/01/25.
//

import AppIntents
import SwiftUICore
import SwiftData


struct OpenAppForAddingExpense: AppIntent {
    // TODO: look at the following
    //    https://stackoverflow.com/questions/73263899/how-to-open-specific-view-in-swiftui-app-using-appintents
    static let title: LocalizedStringResource = "Open the app for adding an expense"
    static let description: LocalizedStringResource = "Open the app and adds a new tagged expense to today, initializing it to 0.00 euro"

    /// Launch your app when the system triggers this intent.
    static let openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        
        let context = DataManager.sharedModelContext
        
        let item = Item(timestamp: Date(), tag: "Other", amount: Decimal(0.00))
        
        print(String(describing: item.persistentModelID))
        
        context.insert(item)
        try context.save()
        
        print(String(describing: item.persistentModelID))
        
        ActionManager.editItem = item.persistentModelID
        return .result()
    }
}
