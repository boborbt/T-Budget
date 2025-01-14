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
    
    var nextWeek: Date {
        return Calendar.current.date(byAdding: .day, value: 7, to: self)!
    }
    
    var previousWeek: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)!
    }
    
    var firstDayOfMonth: Date? {
        let calendar = Calendar.current
        
        guard let startOfMonth = calendar.dateInterval(of: .month, for: self)?.start else {
            return nil
        }
        
        return startOfMonth
    }
    
    var lastDayOfMonth: Date? {
        let calendar = Calendar.current
        
        guard let endOfMonth = calendar.dateInterval(of: .month, for: self)?.end else {
            return nil
        }
        
        return endOfMonth
    }
    
    var firstDayOfWeek: Date? {
        let calendar = Calendar.current
        
        // Find the start of the week for the given date
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: self)?.start else {
            return nil
        }
        
        return startOfWeek
    }
    
    var lastDayOfWeek: Date? {
        let calendar = Calendar.current
        
        guard let endOfWeek = calendar.dateInterval(of: .weekOfYear, for: self)?.end else {
            return nil
        }
        
        return endOfWeek
    }
    
    
}
