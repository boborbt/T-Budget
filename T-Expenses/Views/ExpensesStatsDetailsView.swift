//
//  ExpensesStats.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 03/01/25.
//

import SwiftUI
import SwiftData
import Charts

struct TaggedExpense: Identifiable {
    var id: String {
        self.tag
    }
    
    let tag: String
    let amount: Decimal
}

struct ExpensesStatsDetailsView: View {
    @Query private var items: [Item]
    
    private let startDate: Date
    private let endDate: Date
    private let timeframe: TimeframeType
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

    
    init(timeframe: TimeframeType, date: Date) {
        
        self.timeframe = timeframe
        
        switch timeframe {
        case .ByMonth:
            startDate = date.firstDayOfMonth!
            endDate = date.lastDayOfMonth!
        case .ByWeek:
            startDate = date.firstDayOfWeek!
            endDate = date.lastDayOfWeek!
        }

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
        VStack {
            Chart(expenses) { exp in
                SectorMark( angle: .value(
                    exp.tag,
                    exp.amount)
                ).foregroundStyle(
                    by: .value(
                        Text(verbatim: exp.tag),
                        exp.tag
                    )
                )
            }
            .chartLegend(position: .bottom, alignment: .center)
            .padding(.all)
            .overlay {
                RoundedRectangle(cornerRadius:10).strokeBorder()
            }
            .padding(.all, 20.0)
            List {
                ForEach(expenses) { exp in
                    HStack {
                        Image(systemName: Tags.iconName(Tags(rawValue:exp.tag) ?? .Other))
                        Text(exp.tag)
                        Spacer()
                        Text("\(exp.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                    }
                }
            }
        }
        
    }
}

#Preview {
    ExpensesStatsDetailsView(timeframe: .ByMonth, date: Date())
        .modelContext(DataManager.previewContainer.mainContext)
}
