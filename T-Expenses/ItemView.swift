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
                .frame(width: 60, alignment: .trailing)
            Text(item.tag)
                .padding(.all, 8)
            Spacer()
            Text("\(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                .padding(.all, 8)
                .padding(.trailing, 30)
        }.font(tagFont)
    }
}

#Preview {
    ItemView(item: Item(timestamp: Date()+1000000, tag: "Test", amount: 10.0))
}
