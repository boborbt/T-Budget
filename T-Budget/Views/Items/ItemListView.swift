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
    let timeframe: TimeframeType
    
    private var filteredItems: [Item] {
        items.filter { item in
            item.timestamp >= startDate && item.timestamp < endDate
        }
    }
    
    init(timeframe: TimeframeType, date: Date, selectedItem: Binding<Item?>) {
        self._selectedItem = selectedItem
        self.timeframe = timeframe
        
        switch timeframe {
        case .ByMonth:
            startDate = date.firstDayOfMonth!
            endDate = date.lastDayOfMonth!
        case .ByWeek:
            startDate = date.firstDayOfWeek!
            endDate = date.lastDayOfWeek!
        }
        
        self._items = Query(sort: \Item.timestamp, order: .reverse)
    }
    
    var body: some View {
        VStack {
            List(selection: $selectedItem) {
                Section {
                    ForEach(filteredItems) { item in
                        NavigationLink {
                            ItemFormView(item: item)
                        } label: {
                            ItemView(item: item)
                        }
                    }
                    .onChange(of: filteredItems) {
                        if let itemId = ActionManager.editItem {
                            self.selectedItem = self.filteredItems.first(where: { item in
                                item.persistentModelID == itemId
                            })
                        }
                    }
                } header: {
                    HStack {
                        Image(systemName: "calendar")
                            .frame(width: 30, alignment: .trailing)
                        Image(systemName: "tag")
                        Text("Tag")
                            .padding(.leading, 8)
                        Spacer()
                        Image(systemName:"eurosign.circle")
                        Text("Amount")
                            .padding(.trailing, 10.0)
                    }
                }
            }
        }
    }    
}

#Preview {
    ItemListView(timeframe: .ByMonth, date: Date(), selectedItem: .constant(nil))
        .modelContext(DataManager.previewContainer.mainContext)
}
