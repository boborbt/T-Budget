//
//  TimeframeType.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 15/01/25.
//


enum TimeframeType: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case ByMonth = "Month"
    case ByWeek = "Week"
}