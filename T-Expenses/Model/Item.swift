//
//  Item.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 01/01/25.
//

import Foundation
import SwiftData

//Exporting swift data
//https://www.youtube.com/watch?v=LLKLa8IgK3I

@Model
final class Item: Sendable {
    var timestamp: Date
    var tag: String
    var amount: Decimal
    
    init(timestamp: Date, tag: String, amount: Decimal) {
        self.timestamp = timestamp
        self.tag = tag
        self.amount = amount
    }
    
    static func getSumOfExpenses(items: [Item]) -> Decimal {
        return items.reduce(Decimal(0)) { $0 + $1.amount }
    }
}
