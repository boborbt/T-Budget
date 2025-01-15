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

enum TransitionDirection {
    case Forward
    case Backward
    case None
}

extension AnyTransition {

    struct SlideModifier: ViewModifier {
        let width: CGFloat
        @Binding var direction: TransitionDirection

        func body(content: Content) -> some View {
            switch direction {
                case .Forward: return content.offset(x: width)
                case .Backward: return content.offset(x: -width)
                case .None: return content.offset(y: 0)
            }
        }
    }

    static func dynamicSlide(forward: Binding<TransitionDirection>, size: CGSize) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: SlideModifier(width: size.width, direction: forward),
                identity: SlideModifier(width: 0, direction: .constant(.Forward))
            ),

            removal: .modifier(
                active: SlideModifier(width: -size.width, direction: forward),
                identity: SlideModifier(width: 0, direction: .constant(.Forward))
            )
        )
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedItem: Item?
    @State private var showExpensesDetails: Bool = false
    @State private var monthYear: Date = Date()
    @AppStorage("timeframeType") private var timeframeType: TimeframeType = .ByMonth
    @State private var transitionDirection: TransitionDirection = .None
    
    private let animDuration = 0.001
    
    var body: some View {
        GeometryReader { gr in
            NavigationSplitView {
                VStack {
                    Group {
                        ItemListStats(timeframe: timeframeType, date: monthYear, statsTapped: $showExpensesDetails)
                        ItemListView(timeframe: timeframeType, date: monthYear, selectedItem: $selectedItem)
                    }
                    .id(monthYear)
                    .animation(.easeIn(duration:0.25), value: monthYear)
                    .transition(.dynamicSlide(forward: $transitionDirection, size: gr.size))
                    .gesture(getSwipeGesture())
                    
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
                            previousAction: prevTimeframe,
                            nextAction: nextTimeframe,
                            tapAction: todayTimeFrame
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
    
    fileprivate func getSwipeGesture() -> some Gesture {
        DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
            .onEnded { value in
                
                if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                    nextTimeframe()
                }
                else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                    prevTimeframe()
                }
            }
    }
    
    fileprivate func todayTimeFrame() {
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
                monthYear = now
            }
        }
    }
    
    private func nextTimeframe() {
        if timeframeType == .ByMonth {
            monthYear = monthYear.nextMonth
        } else {
            monthYear = monthYear.nextWeek
        }
        
        transitionDirection = .Forward
    }
    
    private func prevTimeframe()  {
        if timeframeType == .ByMonth {
            monthYear = monthYear.previousMonth
        } else {
            monthYear = monthYear.previousWeek
        }
        
        transitionDirection = .Backward
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
