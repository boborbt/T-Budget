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
    @AppStorage("timeframeType") private var timeframeType: TimeframeType = .ByMonth
    @State private var transitionDirection: TransitionDirection = .None
    @State private var offset: CGSize = .zero

    private static let dragAnimDuration: TimeInterval = 0.5
    private static let resetAfterDragDuration: TimeInterval = 0.001
    private static let verticalTolerance: CGFloat = 100
    private static let horizontalTolerance: CGFloat = 100
    
    var prevTimeframe: Date {
        switch timeframeType {
            case .ByMonth: return monthYear.previousMonth
            case .ByWeek: return monthYear.previousWeek
        }
    }
    
    var nextTimeframe: Date {
        switch timeframeType {
        case .ByMonth: return monthYear.nextMonth
        case .ByWeek: return monthYear.nextWeek
        }
    }

    
    var body: some View {
        GeometryReader { gr in
            NavigationSplitView {
                ZStack {
                    StatsAndListView(timeframeType: timeframeType, date: self.prevTimeframe, selectedItem: $selectedItem, showExpensesDetails: $showExpensesDetails)
                        .offset(x: -gr.size.width)
                    StatsAndListView(timeframeType: timeframeType, date: monthYear, selectedItem: $selectedItem, showExpensesDetails: $showExpensesDetails)
                    StatsAndListView(timeframeType: timeframeType, date: self.nextTimeframe, selectedItem: $selectedItem, showExpensesDetails: $showExpensesDetails)
                        .offset(x: gr.size.width)
                }
                .offset(x: offset.width)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset = gesture.translation
                        }
                        .onEnded { gesture in
                            let remainingOffset = gr.size.width - abs(offset.width)
                            let duration = min(remainingOffset / abs(gesture.velocity.width), 0.5)

                            if offset.width > 100 {
                                setPrevTimeframe(screenWidth: gr.size.width,
                                                 duration: duration)
                            } else if offset.width < -100 {
                                setNextTimeframe(screenWidth: gr.size.width,
                                                 duration: duration)
                            } else {
                                withAnimation(.easeInOut(duration: Self.dragAnimDuration)) {
                                    offset = .zero
                                }
                            }
                        }
                )
                .onOpenURL { incomingURL in
                    print("App was opened via URL: \(incomingURL)")
                    handleIncomingURL(incomingURL)
                }
                .sheet(isPresented: $showExpensesDetails, content: {
                    ExpensesStatsDetailsView(timeframe: timeframeType, date: monthYear)
                })
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        TimeFrameSelector(
                            date: monthYear,
                            timeframeType: timeframeType,
                            previousAction: {  setPrevTimeframe(screenWidth: gr.size.width) },
                            nextAction: { setNextTimeframe(screenWidth: gr.size.width) },
                            tapAction: setTodayTimeframe
                        )
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Picker("Visualization", selection: $timeframeType.animation()) {
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
    }
}

extension ContentView {
    
    
    fileprivate func setTodayTimeframe() {
        if Date() > monthYear {
            transitionDirection = .Forward
        } else {
            transitionDirection = .Backward
        }

        gotoToday()
    }
    
    
    fileprivate func gotoToday() {
        let now = Date()
        if timeframeType == .ByMonth {
            if now.year != monthYear.year || now.month != monthYear.month {
                monthYear = now
            }
        }
        
        if timeframeType == .ByWeek {
            if now.year != monthYear.year ||
                now.month != monthYear.month ||
                now.firstDayOfWeek != monthYear.firstDayOfWeek {
                withAnimation {
                    monthYear = now
                }
            }
        }
    }
    
    private func setNextTimeframe(screenWidth: CGFloat, duration: TimeInterval = dragAnimDuration) {
        withAnimation(.easeInOut(duration: duration)) {
            offset.width = -screenWidth
        } completion: {
            withAnimation(.easeOut(duration: Self.resetAfterDragDuration)) {
                monthYear = self.nextTimeframe
                offset = .zero
            }
        }
    }
    
    private func setPrevTimeframe(screenWidth: CGFloat, duration: TimeInterval = dragAnimDuration)  {
        withAnimation(.easeOut(duration: duration)) {
            offset.width = screenWidth
        } completion: {
            withAnimation(.easeInOut(duration: Self.resetAfterDragDuration)) {
                monthYear = self.prevTimeframe
            }
            offset = .zero
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
