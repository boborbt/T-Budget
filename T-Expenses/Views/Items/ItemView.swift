//
//  ItemView.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 01/01/25.
//

import SwiftUI

struct ItemView: View {
    @State var item: Item
    let tagFont: Font = .system(size: 14).monospaced()
    
    var body: some View {
        HStack {
            Text("\(item.timestamp.day)")
                .frame(width: 30, alignment: .trailing)
            Image(systemName: Tags.iconName(Tags(rawValue: item.tag) ?? .Other))
            Text(item.tag)
                .padding(.all, 8)
            Spacer()
            Text("\(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                .padding([.top, .leading, .bottom], 8)
        }.font(tagFont)
    }
}

#Preview {
    ItemView(item: Item(timestamp: Date()+1000000, tag: "Groceries", amount: 10.0))
}
