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

struct ImportExpenses: AppIntent {
    static let title: LocalizedStringResource = LocalizedStringResource("Import")
    static let description: LocalizedStringResource = LocalizedStringResource("Import all expenses to a CSV representation")
    
    static let openAppWhenRun: Bool = true
    
    @IntentParameter
    var file: IntentFile

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let fileContent = String(decoding: file.data, as: UTF8.self)
        
        var data = ExpensesParser(data: fileContent)
        data.parse()
        
        if data.errors.count > 0 {
            let errMsg = "Found \(data.errors.count) errors in parsing the input file"
            os_log("%@", type: .error, errMsg)
            return .result(dialog: IntentDialog(stringLiteral: errMsg))
        }
        

        let context = DataManager.sharedModelContext

        for expense in data.expenses {
            context.insert(expense)
        }

        
        return .result(dialog: "Import completed successfully")
    }
}
