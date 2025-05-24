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
                    phrases: [ "Add an expense to \(.applicationName)", "Record expense in \(.applicationName)" ],
                    shortTitle: "Add Expense",
                    systemImageName: "eurosign.bank.building"
        )
        AppShortcut(intent: ExportExpenses(),
                    phrases: ["Export my expenses from \(.applicationName)"],
                    shortTitle: "Export",
                    systemImageName: "square.and.arrow.up"
        )
        AppShortcut(intent: ExportExpensesInRange(),
                    phrases: ["Export my expenses from \(.applicationName) between dates"],
                    shortTitle: "Export in range",
                    systemImageName: "square.and.arrow.up")
    }
}
