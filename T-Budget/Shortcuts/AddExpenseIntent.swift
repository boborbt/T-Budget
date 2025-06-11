//
//  AddExpenseIntent.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 03/01/25.
//
import AppIntents
import SwiftData


struct AddExpenseIntent: AppIntent {
    static let title: LocalizedStringResource = "Add an expense"
    static let description: LocalizedStringResource = "Adds a new tagged expense to today, initializing it to 0.00 euro"

    /// Launch your app when the system triggers this intent.
    static let openAppWhenRun: Bool = false
    
    @IntentParameter
    var amount: Double?
    
    @IntentParameter
    var tag: Tags?
    
    @MainActor
    func perform() async throws -> some IntentResult {
        guard let amount = amount else {
            throw $amount.needsValueError("Please insert amount")
        }
        
        guard let tag = tag else {
            throw $tag.needsValueError("Please insert tag")
        }
        
        if(amount < 0.01) {
            return .result()
        }
        
        
        let context = DataManager.sharedModelContext
        
        let item = Item(timestamp: Date(), tag: tag.rawValue, amount: Decimal(amount))

        context.insert(item)
        try context.save()
        
        return .result()
    }
}

