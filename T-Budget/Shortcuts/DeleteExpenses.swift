//
//  DeleteExpenses.swift
//  T-Budget
//
//  Created by Roberto Esposito on 26/05/25.
//

//
//  ImportExpensesIntent.swift
//  T-Budget
//
//  Created by Roberto Esposito on 26/05/25.
//

import AppIntents
import SwiftUICore
import SwiftData
import OSLog

struct DeleteExpenses: AppIntent {
    static let title: LocalizedStringResource = LocalizedStringResource("Delete")
    static let description: LocalizedStringResource = LocalizedStringResource("Delete all expenses in the given date range")
    
    static let openAppWhenRun: Bool = true
    
    @IntentParameter
    var startDate: Date
    
    @IntentParameter
    var endDate: Date
    
    @IntentParameter
    var confirm: Bool

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let context = DataManager.sharedModelContext
        let fd = FetchDescriptor<Item>()
        let allItems = try context.fetch(fd)
        
        if !confirm {
            return .result(dialog: "Operation cancelled. Note: this operation can be only be performed through a shortcut script. Always add a confirmation dialog before deleting data from the app.")
        }
        
        for item in allItems {
            if item.timestamp > startDate && item.timestamp < endDate {
                os_log("Deleting item %{public}@", log: .default, type: .debug, "\(item)")
                context.delete(item)
            }
        }
        
        return .result(dialog: "Operation completed successfully")
    }
}
