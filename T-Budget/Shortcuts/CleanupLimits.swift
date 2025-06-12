//
//  CleanupLimits.swift
//  T-Budget
//
//  Created by Roberto Esposito on 12/06/25.
//

import AppIntents
import SwiftData
import OSLog


struct CleanupLimits: AppIntent {
    static let title: LocalizedStringResource = "Cleanup expense limits"
    static let description: LocalizedStringResource = "Deduplicate expense categories if they get messed up by CoreData migration. It everything went well, it returns an empty array, otherwise it returns the list of tags that could not be cleaned up. Limits cannot be cleaned up if more than one limit has an amount set."
    


    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<[String]>  {
        
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
        
        return .result(value: errors.compactMap({ $0 }))
    }
    
    func cleanupLimit(context:  ModelContext, limits:[Limit], tag: String, count: Int) -> String? {
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
