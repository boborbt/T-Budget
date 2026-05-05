//
//  ItemListStats.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 04/01/25.
//
import SwiftUI
import SwiftData

struct StatsSummary: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    let startDate: Date
    let endDate: Date
    let timeframe: TimeframeType
    
    private var filteredItems: [Item] {
        items.filter { item in
            item.timestamp >= startDate && item.timestamp < endDate
        }
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
        
        self._items = Query()
    }
    
    var body: some View {
        VStack {
            HStack {
                Label("\(filteredItems.count) items", systemImage: "bolt.fill")
                Label("\(filteredItems.reduce(Decimal(0.0)) { $0 + $1.amount }, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))", systemImage: "eurosign.bank.building")
            }
        }
    }

}

#Preview {
    StatsSummary(timeframe: .ByMonth, date: Date())
        .modelContext(DataManager.previewContainer.mainContext)
}
