//
//  ItemFormView.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 01/01/25.
//

import SwiftUI
import CurrencyField
import Combine

@MainActor
struct DeleteButton: View {
    @State var isShowingDeleteConfirmation: Bool = false
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }

    
    var body: some View {
        Button("Delete", systemImage: "trash", role: .destructive) {
            isShowingDeleteConfirmation = true
        }
        .buttonStyle(.bordered)
        .confirmationDialog("Are you sure?",
                            isPresented: $isShowingDeleteConfirmation,
                            actions: {
            Button("Delete", role: .destructive, action: action)
        })
    }
}

struct ItemFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State var item: Item
    @State var amount: Int
    @State var isShowingDeleteConfirmation: Bool = false
    
    init(item: Item) {
        self.item = item
        self.amount = NSDecimalNumber(decimal: item.amount * 100).intValue
    }
    
    let font: Font = .system(size: 14).monospaced()
        
    var body: some View {
        Form {
            Section("New Expense") {
                HStack {
                    Image(systemName: "calendar")
                    DatePicker("Date", selection: $item.timestamp)
                }
                HStack {
                    Image(systemName: "tag")
                    Text("Tag")
                        .frame(width:100, alignment: .leading)
                    Picker("Tag", selection: $item.tag) {
                        ForEach(Tags.allCases) { tag in
                            HStack {
                                Image(systemName: Tags.iconName(tag))
                                    .symbolRenderingMode(.palette)
                                Text(tag.rawValue).frame(width:100)
                            }.tag(tag.rawValue)
                        }
                        .padding(.leading)
                        .font(font)
                    }.pickerStyle(.wheel)
                }
                HStack {
                    Image(systemName: "eurosign.circle")
                    Text("Amount")
                        .frame(width:100, alignment: .leading)
                    Spacer()
                    CurrencyField(value: $amount)
                        .onReceive(Just(amount), perform: { amount in
                            item.amount = Decimal(amount) / 100
                        })
                        .font(font)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                DeleteButton() {
                    modelContext.delete(item)
                    dismiss()
                }
                                
                Button("Done", systemImage: "return") {
                    dismiss()
                }.buttonStyle(.borderedProminent)
            }
        }

    }
}

#Preview {
    @Previewable @State var item = Item(timestamp: Date(), tag: "Car", amount: 10)
    ItemFormView(item: item)
}

#Preview {
    @Previewable @State var item = Item(timestamp: Date(), tag: "Health", amount: 10)
    @State var preferredColumn = NavigationSplitViewColumn.detail

    NavigationSplitView(preferredCompactColumn: $preferredColumn) {
        Button("click") {
        }
    }
    detail: {
        if false {
            Text("some view")
        } else {
            ItemFormView(item: item)
        }
    }

}
