//
//  ExpensesStats.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 03/01/25.
//

import SwiftUI
import SwiftData
import Charts

struct TaggedExpense: Identifiable {
    var id: String {
        self.tag
    }
    
    let tag: String
    var amount: Decimal
    var items: [Item]
    
    var sortedItems: [Item] {
        self.items.sorted {
            $0.timestamp > $1.timestamp
        }
    }
    
    init(tag: String) {
        self.tag = tag
        self.amount = 0
        self.items = []
    }
}

struct StatsChartView: View {
    @Query private var items: [Item]
    @State private var selectedTaggedExpense: TaggedExpense? = nil
    
    private let startDate: Date
    private let endDate: Date
    private let timeframe: TimeframeType
    private var expenses: [TaggedExpense] {
        var dict: [String:TaggedExpense] = [:]
        for item in self.items {
            var te = dict[item.tag, default:TaggedExpense(tag: item.tag)]
            te.amount += item.amount
            te.items.append(item)
            dict[item.tag] = te
        }
        
        var result: [TaggedExpense] = []
        for kv in (dict.sorted { $0.1.amount > $1.1.amount }) {
            result.append(kv.value)
        }
        
        return result
    }
    
    
    init(timeframe: TimeframeType, date: Date) {
        
        self.timeframe = timeframe
        
        switch timeframe {
        case .ByMonth:
            startDate = date.firstDayOfMonth!
            endDate = date.lastDayOfMonth!
        case .ByWeek:
            startDate = date.firstDayOfWeek!
            endDate = date.lastDayOfWeek!
        }
        
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
            Chart(expenses) { exp in
                SectorMark( angle: .value(
                    exp.tag,
                    exp.amount)
                ).foregroundStyle(
                    by: .value(
                        Text(verbatim: exp.tag),
                        exp.tag
                    )
                )
            }
            .chartLegend(position: .bottom, alignment: .center)
            .padding(.all)
            .overlay {
                RoundedRectangle(cornerRadius:10).strokeBorder()
            }
            .padding(.all, 20.0)
            List {
                ForEach(expenses) { exp in
                    Button {
                        selectedTaggedExpense = exp
                    } label: {
                        HStack {
                            Image(systemName: Tags.iconName(Tags(rawValue:exp.tag) ?? .Other))
                            Text(exp.tag)
                            Spacer()
                            Text("\(exp.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                            Image(systemName: "chevron.right")
                        }
                    }.buttonStyle(.plain)
                }
            }.sheet(item: $selectedTaggedExpense) { te in
                TaggedExpensesView(te:te)
            }
        }
        
    }
}



struct TaggedExpensesView : View {
    let te: TaggedExpense
    fileprivate static let dateColWidth: CGFloat = 120
    fileprivate static let timeColWidth: CGFloat = 70
    
    var body: some View {
        Form {
            Section(header: Header(tag:te.tag)) {
                HStack {
                    Image(systemName: "calendar")
                        .frame(width: Self.dateColWidth)
                    Image(systemName: "clock")
                        .frame(width: Self.timeColWidth)
                    Spacer()
                    Image(systemName: "eurosign.circle")
                }
                List {
                    ForEach(te.sortedItems) { item in
                        HStack {
                            Text(formatDate(item.timestamp))
                                .frame(width: Self.dateColWidth)
                            Text(formatTime(item.timestamp))
                                .frame(width: Self.timeColWidth)
                            Spacer()
                            Text("\(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                        }
                    }
                }
            }
            
        }
    }
    
}

fileprivate struct Header: View {
    let tag: String
    
    var body: some View {
        HStack {
            Tags.icon(rawValue: tag)
            Text(tag)
        }
    }
}


private func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    
    return dateFormatter.string(from: date)
}

private func formatTime(_ date: Date) -> String {
    let hourFormatter = DateFormatter()
    hourFormatter.dateStyle = .none
    hourFormatter.timeStyle = .short
    
    return hourFormatter.string(from: date)
}



#Preview {
    StatsChartView(timeframe: .ByMonth, date: Date())
        .modelContext(DataManager.previewContainer.mainContext)
}
