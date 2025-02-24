//
//  LimitFormView.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 23/02/25.
//

import SwiftUI
import SwiftData
import CurrencyField
import Combine

struct LimitFormView: View {
    let limit: Limit
    let tag: Tags
    @State var limitValue: Int
    
    init(limit: Limit) {
        self.limit = limit
        self.tag = Tags(rawValue: limit.tag)!
        self.limitValue = NSDecimalNumber(decimal: limit.amount).intValue * 100
    }
    
    var body: some View {
        Form {
            Section("Item limit") {
                HStack {
                    Image(systemName: Tags.iconName(tag))
                        .frame(width: 40)
                    Text(tag.rawValue)
                    
                    Spacer()
                    
                    CurrencyField(value: $limitValue)
                        .onReceive(Just(limitValue), perform: { amount in
                            limit.amount = Decimal(amount) / 100
                        })
                }
            }
        }
    }
}

#Preview {
    LimitFormView(limit: Limit(tag: "Car", amount: 100))
}
