//
//  ItemListStats.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 04/01/25.
//
import SwiftUI
import SwiftData

struct ItemListStats: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @Binding private var statsTapped: Bool
    let startDate: Date
    let endDate: Date
    
    init(month: Int, year: Int, statsTapped: Binding<Bool>) {
        self._statsTapped = statsTapped

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
        VStack {
            HStack {
                Label("\(items.count) items", systemImage: "bolt.fill")
                Label("\(items.reduce(Decimal(0.0)) { $0 + $1.amount }, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))", systemImage: "eurosign.bank.building")
            }
            .onTapGesture {
                statsTapped = true
            }
        }
    }

}

#Preview {
    ItemListStats(month: 1, year: 2025, statsTapped: .constant(false))
        .modelContext(DataManager.previewContainer.mainContext)
}
