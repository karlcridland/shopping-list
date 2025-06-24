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
    
    var yearOfPurchase: Int? {
        if let date = self.basketDate {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            return year
        }
        return nil
    }
    
    var monthOfPurchase: Int? {
        if let date = self.basketDate {
            let calendar = Calendar.current
            let month = calendar.component(.month, from: date)
            return month
        }
        return nil
    }
    
    var dayOfPurchase: Int? {
        if let date = self.basketDate {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            return day
        }
        return nil
    }
    
}

extension Int {
    
    var toMonth: String {
        if (self >= 0 && self < 12) {
            return ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"][self]
        }
        return ""
    }
    
}
