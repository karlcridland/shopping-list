//
//  ShoppingItem.swift
//  Shopping List
//
//  Created by Karl Cridland on 24/06/2025.
//

import CoreData

extension ShoppingItem {
    
    static func newInstance(_ id: String, _ title: String, _ describe: String? = nil, _ category: Category, context: NSManagedObjectContext) -> ShoppingItem {
        let item = ShoppingItem(context: context)
        item.id = id
        item.title = title
        item.describe = describe
        item.category = category
        item.addedDate = Date()
        return item
    }
    
    var dateOfPurchase: String? {
        if let date = self.basketDate {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            let month = DateFormatter()
            month.dateFormat = "MMMM"
            let year = calendar.component(.year, from: date)
            
            let suffix: String
            switch day {
            case 1, 21, 31: suffix = "st"
            case 2, 22: suffix = "nd"
            case 3, 23: suffix = "rd"
            default: suffix = "th"
            }
            
            return "\(day)\(suffix) \(month.string(from: date)) \(year)"
        }
        return nil
    }
    
    var yearOfPurchase: Int {
        return self.basketDate?.componentValue(.year) ?? -1
    }
    
    var monthOfPurchase: Int {
        return self.basketDate?.componentValue(.month) ?? -1
    }
    
    var dayOfPurchase: Int {
        return self.basketDate?.componentValue(.day) ?? -1
    }
    
}

extension [ShoppingItem] {
    
    var stringValue: String {
        var results: [String] = []
        self.sorted(by: {$0.category < $1.category}).forEach { item in
            if let title = item.title {
                var text: [String] = [title]
                if let describe = item.describe, !describe.isEmpty {
                    text.append("\(describe)")
                }
                results.append("• \(text.joined(separator: " - "))")
            }
        }
        return results.joined(separator: "\n")
    }
    
}

