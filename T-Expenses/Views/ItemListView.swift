//
//  ItemList.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 04/01/25.
//
import SwiftUI
import SwiftData

struct ItemListView: View {
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
                .onChange(of: items) {
                    if let itemId = ActionManager.editItem {
                        self.selectedItem = self.items.first(where: { item in
                            item.persistentModelID == itemId
                        })
                    }
                }
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
