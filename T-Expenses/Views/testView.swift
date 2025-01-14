import SwiftUI

struct DateListView: View {
    @State private var currentDate: Date = Date()
    @State private var offset: CGFloat = 0
    @State private var nextDate: Date? = nil

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            ZStack {
                // Current list view
                listView(for: currentDate)
                    .offset(x: offset)
                
                // Next or previous list view
                if let nextDate = nextDate {
                    listView(for: nextDate)
                        .offset(x: offset + (offset > 0 ? -screenWidth : screenWidth))
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        // Update the offset interactively based on user swipe
                        offset = gesture.translation.width
                        
                        // Preload the next date
                        if nextDate == nil {
                            nextDate = offset < 0
                                ? Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
                                : Calendar.current.date(byAdding: .day, value: -1, to: currentDate)
                        }
                    }
                    .onEnded { gesture in
                        let dragThreshold: CGFloat = screenWidth / 2
                        
                        if abs(gesture.translation.width) > dragThreshold {
                            // Confirm swipe direction
                            if offset < 0 {
                                // Swipe left -> Go to next day
                                currentDate = nextDate ?? currentDate
                            } else if offset > 0 {
                                // Swipe right -> Go to previous day
                                currentDate = nextDate ?? currentDate
                            }
                        }
                        
                        // Reset state
                        withAnimation {
                            offset = 0
                            nextDate = nil
                        }
                    }
            )
            .animation(.easeInOut, value: offset)
            .navigationTitle(dateString(currentDate))
        }
    }

    // MARK: - Helper Methods
    
    func listView(for date: Date) -> some View {
        List(items(for: date), id: \.self) { item in
            Text(item)
        }
    }
    
    func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func items(for date: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return ["Item 1 for \(formatter.string(from: date))", "Item 2 for \(formatter.string(from: date))"]
    }
}

#Preview {
    DateListView()
}
