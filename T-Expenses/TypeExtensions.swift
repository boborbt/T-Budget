//
//  TypeExtensions.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 01/01/25.
//

import Foundation

extension Date: Sendable {
    var day: Int { Calendar.current.component(.day, from: self) }
    var month: Int { Calendar.current.component(.month, from: self )}
    var year: Int { Calendar.current.component(.year, from: self )}
    
    init(day: Int, month: Int, year: Int) {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        let date = gregorianCalendar.date(from: dateComponents)!
        self.init(timeInterval: 0, since: date)
    }
    
    var nextMonth: Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)!
    }
    
    var previousMonth: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }
}
