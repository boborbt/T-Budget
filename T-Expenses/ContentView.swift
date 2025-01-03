//
//  ContentView.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 01/01/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedItem: Item?
    @State private var showExpensesDetails: Bool = false
    @State private var monthYear: Date = Date()

    let monthYearFormat = Date.FormatStyle()
        .month(.abbreviated)
        .year(.defaultDigits)
        .day(.omitted)
        .locale(Locale(identifier: "en_US"))
    
    var body: some View {
        NavigationSplitView {
            VStack {
                ItemListStats(month: monthYear.month, year: monthYear.year, statsTapped: $showExpensesDetails)
                ItemList(month: monthYear.month, year: monthYear.year, selectedItem: $selectedItem)
            }
            .sheet(isPresented: $showExpensesDetails, content: {
                ExpensesStatsDetails(month: monthYear.month, year: monthYear.year)
            })
            .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            monthYear = monthYear.previousMonth
                        }, label: {
                            Image(systemName: "chevron.left")
                        })
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button( action:{
                           monthYear = Date()
                        }, label: {
                            Text("\(monthYear.formatted(monthYearFormat))")
                                .font(.headline)
                                .foregroundColor(.accentColor)

                        })
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button( action: {
                            monthYear = monthYear.nextMonth
                        }, label: {
                            Image(systemName: "chevron.right")
                        })
                    }
      
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
        } detail: {
            if let selectedItem {
                ItemFormView(item: selectedItem)
            } else {
                Text("None")
            }
        }
    }
    
    private func formatDay(date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return Int(formatter.string(from: date))!
    }

    private func addItem() {
        withAnimation {
            monthYear = Date()
            let newItem = Item(timestamp: Date(), tag: "Other", amount: 0.0)
            selectedItem = newItem
            modelContext.insert(newItem)
        }
    }
}

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
        HStack {
            Label("\(items.count) items", systemImage: "bolt.fill")
            Label("\(items.reduce(Decimal(0.0)) { $0 + $1.amount }, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))", systemImage: "eurosign.bank.building")
        }
        .onTapGesture {
            statsTapped = true
        }
    }

}

struct ItemList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @Binding private var selectedItem: Item?
    let startDate: Date
    let endDate: Date
    
    init(month: Int, year: Int, selectedItem: Binding<Item?>) {
        self._selectedItem = selectedItem
        
        startDate = Date(day: 1, month: month, year: year)
        endDate = Date(day:1, month: (month+1 == 13) ? 1 : month+1, year: (month+1 == 13) ? year+1 : year)
        let predicate = #Predicate<Item> { item in
            if item.timestamp >= startDate && item.timestamp < endDate {
                return true
            } else {
                return false
            }
        }

        
        self._items = Query(filter: predicate, sort: \Item.timestamp, order: .reverse)
    }
    
    var body: some View {
        VStack {
            List(selection: $selectedItem) {
                ForEach(items) { item in
                    NavigationLink {
                        ItemFormView(item: item)
                    } label: {
                        ItemView(item: item)
                    }
                }
                .onDelete(perform: deleteItems)
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
