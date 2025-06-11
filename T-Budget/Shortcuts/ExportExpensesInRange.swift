//
//  ExportExpenses.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 05/01/25.
//

import AppIntents
import SwiftUI
import SwiftData


struct ExportExpensesInRange: AppIntent {
    static let title: LocalizedStringResource = LocalizedStringResource("Export expenses between dates")
    static let description: LocalizedStringResource = LocalizedStringResource("Export all expenses within a given date range to a CSV representation")
    
    
    @IntentParameter
    var start: Date
    
    @IntentParameter
    var end: Date
        
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let context = DataManager.sharedModelContext
        let fd = FetchDescriptor<Item>()
        let allItems = try context.fetch(fd)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        timeFormatter.locale = Locale(identifier: Locale.current.identifier)
        
        let amountFormatter = NumberFormatter()
        amountFormatter.maximumFractionDigits = 2
        amountFormatter.minimumFractionDigits = 0

        var result: String = "date;hour;tag;amount\n"
        
        for item in allItems {
            if item.timestamp < start || item.timestamp > end {
                continue
            }
            
            let date:String = dateFormatter.string(from: item.timestamp)
            let time:String = timeFormatter.string(from: item.timestamp)
            let tag:String = item.tag
            let amount:String = amountFormatter.string(for: item.amount) ?? "Err"
            
            let line = "\(date);\(time);\(tag);\(amount)\n"
            result.append(line)
        }
        
        return .result(value: result)
    }
}
