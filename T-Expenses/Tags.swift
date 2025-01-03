//
//  Tags.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 02/01/25.
//

enum Tags: String, CaseIterable, Identifiable {
    case Home, Health, Car, Groceries, School, Lunches, Extras, Other
    var id: Self { self }
}
