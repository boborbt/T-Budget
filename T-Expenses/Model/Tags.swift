//
//  Tags.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 02/01/25.
//

import AppIntents
import SwiftUI


enum Tags: String, CaseIterable, Identifiable {
    case Home, Health, Car, Groceries, School, Lunches, Extras, Other
    var id: Self { self }
    
    static func iconName(_ tag: Tags) -> String {
        switch tag {
        case .Home: return "house"
        case .Health: return "cross.case"
        case .Car: return "car"
        case .Groceries: return "takeoutbag.and.cup.and.straw"
        case .School: return "graduationcap"
        case .Lunches: return "fork.knife"
        case .Extras: return "cup.and.saucer"
        case .Other: return "questionmark.circle"
        }
    }
    
    static func icon(rawValue: String) -> Image {
        guard let tag = Tags(rawValue: rawValue) else {
            return Image(systemName: "questionmark")
        }
        let iconName = Tags.iconName(tag)
        
        return Image(systemName: iconName)
    }
}

extension Tags: AppEnum {
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Tags")
    }
    
    // It would be much better to just use Tags.iconName(Tags.<TAG>) instead of hard constants,
    // but for no apparent reason the DisplayRepresentation.Image structs are not initialized
    // properly unless one uses hard constants. I assume this is a bug in the framework/compiler
    // or something really weird I don't understand about swift (note, the compiler compile the
    // source just fine, but then the images do not appear in the shortcut UI when asking for
    // the Tag).
    static let caseDisplayRepresentations: [Tags : DisplayRepresentation] = [
        .Home:       .init(title: "Home",
                           image: .init(systemName: "house")),
        .Health:     .init(title: "Health",
                           image: .init(systemName:"cross.case")),
         .Car:       .init(title: "Car",
                           image: .init(systemName:"car")),
         .Groceries: .init(title: "Groceries",
                           image: .init(systemName: "takeoutbag.and.cup.and.straw")),
         .School:    .init(title: "School",
                           image: .init(systemName: "graduationcap")),
         .Lunches:   .init(title: "Lunches",
                           image: .init(systemName: "fork.knife")),
         .Extras:    .init(title: "Extras",
                           image: .init(systemName: "cup.and.saucer")),
         .Other:     .init(title: "Other",
                           image: .init(systemName: "questionmark.circle"))
    ]
    
}
