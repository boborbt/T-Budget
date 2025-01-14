//
//  ContentView.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 01/01/25.
//

import SwiftUI
import SwiftData

enum TimeframeType: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case ByMonth = "Month"
    case ByWeek = "Week"
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedItem: Item?
    @State private var showExpensesDetails: Bool = false
    @State private var monthYear: Date = Date()
    @AppStorage("timeframeType") private var timeframeType: TimeframeType = .ByMonth
    
    private let animDuration = 0.001

    
    var body: some View {
        NavigationSplitView {
            VStack {
                ItemListStats(timeframe: timeframeType, date: monthYear, statsTapped: $showExpensesDetails)
                ItemListView(timeframe: timeframeType, date: monthYear, selectedItem: $selectedItem)
            }
            .onOpenURL { incomingURL in
                print("App was opened via URL: \(incomingURL)")
                handleIncomingURL(incomingURL)
            }
            .sheet(isPresented: $showExpensesDetails, content: {
                ExpensesStatsDetailsView(timeframe: timeframeType, date: monthYear)
            })
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Spacer()
                    TimeFrameSelector(
                        date: monthYear,
                        timeframeType: timeframeType,
                        previousAction: {
                            withAnimation(.linear(duration:animDuration)) {
                                monthYear = prevTimeframe()
                            }
                        } ,
                        nextAction: {
                                withAnimation(.linear(duration: animDuration)) {
                                monthYear = nextTimeframe()
                            }
                        },
                        tapAction: {
                            withAnimation(.linear(duration: animDuration)) {
                                monthYear = Date()
                            }
                        }
                    )
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Picker("Visualization", selection: $timeframeType.animation(.linear(duration: animDuration))) {
                        ForEach(TimeframeType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.inline)
                    
                    
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                    Spacer()
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
    
    private func nextTimeframe() -> Date {
        if timeframeType == .ByMonth {
            return monthYear.nextMonth
        } else {
            return monthYear.nextWeek
        }
    }
    
    private func prevTimeframe() -> Date {
        if timeframeType == .ByMonth {
            return monthYear.previousMonth
        } else {
            return monthYear.previousWeek
        }
    }
    
    private func formatDay(date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return Int(formatter.string(from: date))!
    }
    
    func addItem() {
        withAnimation {
            monthYear = Date()
            let newItem = Item(timestamp: Date(), tag: "Other", amount: 0.0)
            selectedItem = newItem
            modelContext.insert(newItem)
        }
    }
    
    private func handleIncomingURL(_ url: URL) {
        guard url.scheme == "t-expapp" else {
            return
        }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL")
            return
        }
        
        guard let action = components.host, action == "add-expense" else {
            print("Unknown URL, we can't handle this one!")
            return
        }
        
        self.addItem()
    }
}





#Preview {
    ContentView()
        .modelContext(DataManager.previewContainer.mainContext)
}
