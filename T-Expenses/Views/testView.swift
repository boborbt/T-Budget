import SwiftUI



struct TestView: View {
    let dates: [Date] = [Date(),
                         Date().nextMonth,
                         Date().nextMonth.nextMonth,
                         Date().nextMonth.nextMonth.nextMonth
                        ]
    let values: [[Int]] = [[1,2,3], [4,5,6], [7,8,9], [10,11,12], [13,14,15]]
    
    @State var index: Int = 1
    @State var forwardSlide: TransitionDirection = .None
    
    
    var body: some View {
        GeometryReader { gr in
            NavigationStack {
                VStack {
                    List {
                        ForEach(values[index], id: \.self ) { value in
                            Text("\(value)")
                        }
                    }
                        .id(dates[index])
                        .animation(.easeIn(duration:0.5), value: dates[index])
                        .transition(.dynamicSlide(forward: $forwardSlide, size: gr.size))
                }
                .toolbar {
                    ToolbarItem {
                        Button("Previous") {
                            guard index > 0 else { return }
                            index -= 1
                            forwardSlide = .Backward
                        }
                    }
                    ToolbarItem {
                        Button("Next") {
                            guard index < values.count - 1 else { return }
                            index += 1
                            forwardSlide = .Forward
                        }
                    }
                    

                }
              
            }
        }
    }
}

#Preview {
    TestView()
}
