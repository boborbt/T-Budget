//
//  Limit.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 23/02/25.
//

import Foundation
import SwiftData

@Model
final class Limit {
    var tag: String = "Other"
    var amount: Decimal = Decimal(0.0)
    
    init(tag: String, amount: Decimal) {
        self.tag = tag
        self.amount = amount
    }    
}
