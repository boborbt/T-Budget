//
//  StatsAndListView.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 17/01/25.
//

import SwiftUI

struct StatsAndListView: View {
    let timeframeType: TimeframeType
    let date: Date
    @Binding var selectedItem: Item?
    @Binding var showExpensesDetails: Bool
    
    var body: some View {
        Group {
            VStack {
                Button(action: { showExpensesDetails = true } ) {
                    StatsSummary(timeframe: timeframeType, date: date)
                }
                ItemListView(timeframe: timeframeType, date: date, selectedItem: $selectedItem)
            }
        }
        .id(date)
    }
}

#Preview {
    StatsAndListView(timeframeType: .ByWeek, date: Date(), selectedItem: .constant(nil), showExpensesDetails: .constant(false))
        .modelContext(DataManager.previewContainer.mainContext)
}
