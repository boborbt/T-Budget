//
//  ContentView.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 01/01/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedItem: Item?
    @State private var showExpensesDetails: Bool = false
    @State private var monthYear: Date = Date()
    
    let monthYearFormat = Date.FormatStyle()
        .month(.abbreviated)
        .year(.defaultDigits)
        .day(.omitted)
        .locale(Locale(identifier: "en_US"))
    
    var body: some View {
        NavigationSplitView {
            VStack {
                ItemListStats(month: monthYear.month, year: monthYear.year, statsTapped: $showExpensesDetails)
                ItemListView(month: monthYear.month, year: monthYear.year, selectedItem: $selectedItem)
            }
            .onOpenURL { incomingURL in
                print("App was opened via URL: \(incomingURL)")
                handleIncomingURL(incomingURL)
            }
            .sheet(isPresented: $showExpensesDetails, content: {
                ExpensesStatsDetailsView(month: monthYear.month, year: monthYear.year)
            })
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Spacer()
                    Button(action: {
                        monthYear = monthYear.previousMonth
                    }, label: {
                        Image(systemName: "chevron.left")
                    })
                    
                    Button( action:{
                        monthYear = Date()
                    }, label: {
                        Text("\(monthYear.formatted(monthYearFormat))")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        
                    })
                    
                    Button( action: {
                        monthYear = monthYear.nextMonth
                    }, label: {
                        Image(systemName: "chevron.right")
                    })
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
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
