//
//  ContentView.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 01/01/25.
//

import SwiftUI
import SwiftData


struct MainItemsView: View {
    let timeframeType: TimeframeType
    let date: Date
    @Binding var selectedItem: Item?
    @Binding var showExpensesDetails: Bool
    
    var body: some View {
        Group {
            VStack {
                ItemListStats(timeframe: timeframeType, date: date, statsTapped: $showExpensesDetails)
                ItemListView(timeframe: timeframeType, date: date, selectedItem: $selectedItem)
            }
        }
        .id(date)
    }
}




struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedItem: Item?
    @State private var showExpensesDetails: Bool = false
    @State private var monthYear: Date = Date()
    @AppStorage("timeframeType") private var timeframeType: TimeframeType = .ByMonth
    @State private var transitionDirection: TransitionDirection = .None
    @State private var offset: CGSize = .zero
    
    private let animDuration = 0.001
    private let verticalTolerance: CGFloat = 100
    
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
                    MainItemsView(timeframeType: timeframeType, date: self.prevTimeframe, selectedItem: $selectedItem, showExpensesDetails: $showExpensesDetails)
                        .offset(x: -gr.size.width)
                    MainItemsView(timeframeType: timeframeType, date: monthYear, selectedItem: $selectedItem, showExpensesDetails: $showExpensesDetails)
                    MainItemsView(timeframeType: timeframeType, date: self.nextTimeframe, selectedItem: $selectedItem, showExpensesDetails: $showExpensesDetails)
                        .offset(x: gr.size.width)
                }
                    .offset(x: offset.width)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                            }
                            .onEnded { _ in
                                if offset.width > 100 {
                                    setPrevTimeframe(screenWidth: gr.size.width)
                                } else if offset.width < -100 {
                                    setNextTimeframe(screenWidth: gr.size.width)
                                } else {
                                    withAnimation {
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
    }
}

extension ContentView {
    
//    fileprivate func getSwipeGesture() -> some Gesture {
//        DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
//            .onChanged { value in
//                print(value.translation)
//            }
//            .onEnded { value in
//                
//                if value.translation.width < 0 && value.translation.height > -verticalTolerance && value.translation.height < verticalTolerance {
//                    nextTimeframe()
//                }
//                else if value.translation.width > 0 && value.translation.height > -verticalTolerance && value.translation.height < verticalTolerance {
//                    prevTimeframe(gr.size.width)
//                }
//            }
//    }
    
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
    
    private func setNextTimeframe(screenWidth: CGFloat) {
        withAnimation {
            offset.width = -screenWidth
        } completion: {
            withAnimation(.linear(duration:0.001)) {
                monthYear = self.nextTimeframe
                offset = .zero
            }
        }
        
//        if timeframeType == .ByMonth {
//            monthYear = monthYear.nextMonth
//        } else {
//            monthYear = monthYear.nextWeek
//        }
//        
//        transitionDirection = .Forward
    }
    
    private func setPrevTimeframe(screenWidth: CGFloat)  {        
        withAnimation {
            offset.width = screenWidth
        } completion: {
            withAnimation(.linear(duration:0.001)) {
                monthYear = self.prevTimeframe
                offset = .zero
            }
        }
//        if timeframeType == .ByMonth {
//            monthYear = monthYear.previousMonth
//        } else {
//            monthYear = monthYear.previousWeek
//        }
//        
//        transitionDirection = .Backward
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
