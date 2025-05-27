//
//  ExpensesParser.swift
//  T-Budget
//
//  Created by Roberto Esposito on 26/05/25.
//

import OSLog

struct ExpensesParser {
    var expenses: [Item] = []
    var errors: [String] = []
    let data: String
    
    init(data: String) {
        self.data = data
    }
    
    // Parses an expenses file. Correct format contains 4 columns: date,hour,tag,amount.
    mutating func parse() {
        let rows = data.split(separator:"\n")
        guard !rows.isEmpty else {
            os_log("Input file is empty", type: .error)
            return
        }
        
        let cols = rows[0].split(separator:";")
        guard cols.count == 4 else {
            os_log("Invalid CSV format, expecting 4 columns, but found %d columns", type: .error, cols.count)
            return
        }
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yy HH:mm"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()

        rows.dropFirst().forEach { row in
            let cols = row.split(separator: ";")
            guard cols.count == 4 else {
                let errMsg = String("Invalid format for row \(String(row))")
                errors.append(errMsg)
                os_log("%@", type: .error, errMsg)
                return
            }
            
            let dateString = "\(cols[0]) \(cols[1])"
            guard let date = dateFormatter.date(from: dateString) else {
                let errMsg = String("Invalid date format in row \(String(row))")
                errors.append(errMsg)
                os_log("%@", type: .error, errMsg)
                return
            }
            
            guard let tag = Tags(rawValue: String(cols[2])) else {
                let errMsg = String("Cannot parse tag name in row: \(String(row))")
                errors.append(errMsg)
                os_log("%@", type: .error, errMsg)
                return
            }
            
            guard let amount = Decimal(string: String(cols[3])) else {
                let errMsg = String("Invalid amount format in row: \(String(row))")
                errors.append(errMsg)
                os_log("%@", type: .error, errMsg)
                return
            }
            
            expenses.append(Item(timestamp: date, tag: tag.rawValue, amount: amount))
            
            return
        }
    }
}
