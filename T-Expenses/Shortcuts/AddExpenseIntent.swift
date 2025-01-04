//
//  AddExpenseIntent.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 03/01/25.
//
import AppIntents
import SwiftUICore
import SwiftData

//struct AddExpenseIntent: AppIntent {
////    typealias PerformResult = <#type#>
////    
////    typealias SummaryContent = <#type#>
//
//    
//    static let title: LocalizedStringResource = "Add Expense"
//    
//    static let openAppWhenRun: Bool = true
//    
//    @MainActor
//    func perform() async throws -> some IntentResult {
//        return .result()
//    }
//    
//}

struct AddExpenseIntent: AppIntent {
    static let title: LocalizedStringResource = "Add an expense"
    static let description: LocalizedStringResource = "Adds a new tagged expense to today, initializing it to 0.00 euro"

    /// Launch your app when the system triggers this intent.
    static let openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        
        let context = DataManager.sharedModelContext
        
        let item = Item(timestamp: Date(), tag: "Other", amount: Decimal(111.00))
        context.insert(item)
        return .result()
    }
}
