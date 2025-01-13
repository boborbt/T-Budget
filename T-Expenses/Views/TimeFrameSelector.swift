//
//  TimeFrameSelector.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 13/01/25.
//

import SwiftUI

struct TimeFrameSelector: View {
    
    private let timeframeType: TimeframeType
    private let nextTimeFrameAction: () -> Void
    private let previousTimeFrameAction: () -> Void
    private let curTimeFrameTapAction: () -> Void
    private let date: Date
    
    let monthYearFormat = Date.FormatStyle()
        .month(.abbreviated)
        .year(.defaultDigits)
        .day(.omitted)
        .locale(Locale(identifier: "en_US"))
    
    let monthNameFormat = Date.FormatStyle()
        .month(.abbreviated)
        .day(.omitted)
        .year(.omitted)
        .locale(Locale(identifier: "en_US"))
    
    init(date: Date, timeframeType: TimeframeType, previousAction: @escaping () -> Void, nextAction: @escaping () -> Void, tapAction: @escaping () -> Void) {
        self.date = date
        self.timeframeType = timeframeType
        previousTimeFrameAction = previousAction
        nextTimeFrameAction = nextAction
        curTimeFrameTapAction = tapAction
    }
        
    var body: some View {
        HStack {
            Button(action: previousTimeFrameAction,
                   label: {
                Image(systemName: "chevron.left")
            })
            
            Button( action: curTimeFrameTapAction,
                    label: {
                Text(formatDate())
                    .font(.headline)
                    .foregroundColor(.accentColor)
                
            })
            
            Button( action: nextTimeFrameAction,
                    label: {
                Image(systemName: "chevron.right")
            })
        }
    }
    
    func formatDate() -> String {
        if timeframeType == .ByMonth {
            return "\(date.formatted(monthYearFormat))"
        } else {
            let firstDayOfWeek = date.firstDayOfWeek!.day
            let lastDayOfWeek = date.lastDayOfWeek!.day
            let monthNumber = date.firstDayOfWeek!.formatted(monthNameFormat)
            return "\(firstDayOfWeek) - \(lastDayOfWeek) \(monthNumber)" 
        }
    }
}

#Preview {
    TimeFrameSelector(date: Date(),
                      timeframeType: .ByMonth,
                      previousAction: {},
                      nextAction: {},
                      tapAction: {})
}

#Preview {
    TimeFrameSelector(date: Date(),
                      timeframeType: .ByWeek,
                      previousAction: {},
                      nextAction: {},
                      tapAction: {})
}

