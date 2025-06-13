//
//  Limit.swift
//  T-Expenses
//
//  Created by Roberto Esposito on 23/02/25.
//

import Foundation
import SwiftData
import OSLog

@Model
final class Limit: Sendable {
    var tag: String = "Other"
    var amount: Decimal = Decimal(0.0)
    
    init(tag: String, amount: Decimal) {
        self.tag = tag
        self.amount = amount
    }
    
    @MainActor
    static func cleanup() throws -> [String] {
        
        let context = DataManager.sharedModelContext
        let limits = try context.fetch(FetchDescriptor<Limit>())
        
        var tags_count: [String: Int] = [:]
            
        for limit in limits {
            tags_count[limit.tag, default: 0] += 1
        }
        
        var errors: [String?] = []
        for (k,v) in tags_count {
            errors.append(cleanupLimit(context: context, limits:limits, tag: k, count: v))
        }
                
        return errors.compactMap({ $0 })
    }
    
    static private func cleanupLimit(context:  ModelContext, limits:[Limit], tag: String, count: Int) -> String? {
        guard count > 1 else { return nil }
        
        var count = count // mutable local copy of count
        for limit in limits {
            if limit.tag == tag && limit.amount == 0 && count > 1 {
                context.delete(limit)
                count -= 1
            }
        }
        
        if count > 1 {
            return tag
        }
        
        return nil
    }
}
