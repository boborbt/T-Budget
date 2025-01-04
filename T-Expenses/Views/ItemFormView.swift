//
//  ItemFormView.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 01/01/25.
//

import SwiftUI
import CurrencyField
import Combine

struct ItemFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State var item: Item
    @State var amount: Int
    
    init(item: Item) {
        self.item = item
        self.amount = NSDecimalNumber(decimal: item.amount * 100).intValue
    }
        
    var body: some View {
        Form {
            Section("New Expense") {
                DatePicker("Date", selection: $item.timestamp)
                Picker("Tag", selection: $item.tag) {
                    ForEach(Tags.allCases) { tag in
                        Text(tag.rawValue).tag(tag.rawValue)
                    }
                }
                HStack {
                    Spacer()
                    CurrencyField(value: $amount)
                        .onReceive(Just(amount), perform: { amount in
                            item.amount = Decimal(amount) / 100
                        })
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var item = Item(timestamp: Date(), tag: "Car", amount: 10)
    ItemFormView(item: item)
}
