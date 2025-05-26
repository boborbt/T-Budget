//
//  ConfigureLimitsView.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 23/02/25.
//

import SwiftUI
import CurrencyField
import SwiftData


struct ConfigureLimitsView: View {
    @Environment(\.modelContext) var context
    @Query private var limits: [Limit]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Budget allocation") {
                    List {
                        ForEach(limits) { limit in
                            NavigationLink {
                                LimitFormView(limit: limit)
                            } label: {
                                HStack {
                                    Image(systemName: Tags.iconName(Tags(rawValue: limit.tag)!))
                                    Text(limit.tag)
                                    Spacer()
                                    Text(limit.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ConfigureLimitsView()
        .modelContext(DataManager.previewContainer.mainContext)
}
