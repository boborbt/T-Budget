//
//  Tags.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 02/01/25.
//

import AppIntents
import SwiftUI



enum Tags: String, CaseIterable, Identifiable {
    case Home, Clothes, Health, Car, Groceries, School, Lunches, Travel, Extras, Other
    var id: Self { self }
    
    static func iconName(_ tag: Tags) -> String {
        switch tag {
        case .Travel: return "airplane"
        case .Home: return "house"
        case .Clothes: return "tshirt"
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
    
    func color() -> Color {
        switch self {
        case .Home: return Color(hex: 0xE41A1C)   // Bright Red
        case .Clothes: return Color(hex: 0x377EB8) // Bright Blue
        case .Health: return Color(hex: 0x4DAF4A)  // Bright Green
        case .Car: return Color(hex: 0x984EA3)     // Purple
        case .Groceries: return Color(hex: 0xFF7F00) // Orange
        case .School: return Color(hex: 0xFFFF33)  // Bright Yellow
        case .Lunches: return Color(hex: 0xA65628) // Brown
        case .Travel: return Color(hex: 0xF781BF)  // Pink
        case .Extras: return Color(hex: 0x999999)  // Gray
        case .Other: return Color(hex: 0x66C2A5)   // Teal
        }
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
        .Clothes:    .init(title: "Clothes",
                           image: .init(systemName: "tshirt")),
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
         .Travel:    .init(title: "Travel",
                          image: .init(systemName: "airplane")),
         .Extras:    .init(title: "Extras",
                           image: .init(systemName: "cup.and.saucer")),
         .Other:     .init(title: "Other",
                           image: .init(systemName: "questionmark.circle"))
    ]
    
    static let tagColors: KeyValuePairs<String,Color> = [
        "Home":       Home.color(),
        "Clothes":    Clothes.color(),
        "Health":     Health.color(),
        "Car":        Car.color(),
        "Groceries":  Groceries.color(),
        "School":     School.color(),
        "Lunches":    Lunches.color(),
        "Travel":     Travel.color(),
        "Extras":     Extras.color(),
        "Other":      Other.color()
    ]
    
}
