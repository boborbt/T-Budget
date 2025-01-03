//
//  ExpensesStats.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 03/01/25.
//

import SwiftUI
import SwiftData

struct TaggedExpense: Identifiable {
    var id: String {
        self.tag
    }
    
    let tag: String
    let amount: Decimal
}

struct ExpensesStatsDetails: View {
    @Query private var items: [Item]
    
    private let startDate: Date
    private let endDate: Date
    private var expenses: [TaggedExpense] {
        var dict: [String:Decimal] = [:]
        for item in self.items {
            dict[item.tag, default:Decimal(0.0)] += item.amount
        }
        
        var result: [TaggedExpense] = []
        for kv in (dict.sorted { $0.1 > $1.1 }) {
            result.append(TaggedExpense(tag:kv.key, amount:kv.value))
        }
        
        return result
    }

    
    init(month: Int, year: Int) {
        startDate = Date(day: 1, month: month, year: year)
        endDate = Date(day:1, month: (month+1 == 13) ? 1 : month+1, year: (month+1 == 13) ? year+1 : year)

        let predicate = #Predicate<Item> { item in
            if item.timestamp >= startDate && item.timestamp < endDate {
                return true
            } else {
                return false
            }
        }
        self._items = Query(filter: predicate)
    }
    
    var body: some View {
        List {
            ForEach(expenses) { exp in
                HStack {
                    Text(exp.tag)
                    Spacer()
                    Text("\(exp.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                }
            }
        }
    }
}

#Preview {
    ExpensesStatsDetails(month: 1, year: 2024)
}
