//
//  Tags.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 02/01/25.
//

import AppIntents

enum Tags: String, CaseIterable, Identifiable {
    case Home, Health, Car, Groceries, School, Lunches, Extras, Other
    var id: Self { self }
}


extension Tags: AppEnum {
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Tags")
    }
    
    static let caseDisplayRepresentations: [Tags : DisplayRepresentation] = [
        .Home: DisplayRepresentation(title: "Home"),
        .Health: DisplayRepresentation(title: "Health"),
        .Car: DisplayRepresentation(title: "Car"),
        .Groceries: DisplayRepresentation(title: "Groceries"),
        .School: DisplayRepresentation(title: "School"),
        .Lunches: DisplayRepresentation(title: "Lunches"),
        .Extras: DisplayRepresentation(title: "Extras"),
        .Other: DisplayRepresentation(title: "Other")
    ]
    
}
