//
//  ExpShortCutProvider.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 04/01/25.
//


import AppIntents

struct ExpShortCutProvider: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: AddExpenseIntent(),
                    phrases: [ "Add an expense", "Record expense" ],
                    shortTitle: "Add Expense",
                    systemImageName: "eurosign.bank.building"
        )
        AppShortcut(intent: AddExpenseIntent(),
                    phrases: [ "Add an expense", "Record expense" ],
                    shortTitle: "Add Expense",
                    systemImageName: "plus"
        )
        AppShortcut(intent: ExportExpenses(),
                    phrases: ["Export my expenses"],
                    shortTitle: "Export",
                    systemImageName: "square.and.arrow.down"
        )
    }
}
