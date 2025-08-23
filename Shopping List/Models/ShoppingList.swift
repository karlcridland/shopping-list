//
//  ShoppingList.swift
//  Shopping List
//
//  Created by Karl Cridland on 24/06/2025.
//

import Foundation
import CoreData

extension ShoppingList {
    
    func getOwner(_ context: NSManagedObjectContext) async -> Shopper? {
        if let uid = self.owner {
            return await Database.users.shoppers.get(uid, context)
        }
        return nil
    }
    
    func update(_ item: ShoppingItem, context: NSManagedObjectContext) {
        self.lastUpdated = Date()
        if let id = item.id,
           let items = self.items?.allObjects as? [ShoppingItem],
           let original = items.first(where: {$0.id == id}) {
            original.title = item.title
            original.describe = item.describe
            original.category = item.category
            original.basketDate = item.basketDate
        }
        else {
            item.id = UUID().uuidString
            item.list = self
        }
        self.save()
    }
    
    func remove(_ item: ShoppingItem) {
        self.removeFromItems(item)
        self.save()
    }
    
    func remove(_ item: ShoppingItem, context: NSManagedObjectContext) {
        self.removeFromItems(item)
        context.delete(item)
        self.save()
    }
    
    var completedItemsGroupedByDate: [(PurchaseGroupKey, [ShoppingItem])] {
        let completed = (self.items?.allObjects as? [ShoppingItem])?.filter { $0.basketDate != nil } ?? []

        let grouped = Dictionary(grouping: completed) { item -> PurchaseGroupKey in
            guard let date = item.basketDate else { return PurchaseGroupKey(year: 0, month: 0) }
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            return PurchaseGroupKey(year: year, month: month)
        }

        return grouped.sorted { $0.key < $1.key }
    }
    
    struct PurchaseGroupKey: Hashable, Comparable {
        let year: Int
        let month: Int

        var label: String {
            let monthName = DateFormatter().monthSymbols[month - 1]
            return "\(monthName) \(year)"
        }

        static func < (lhs: PurchaseGroupKey, rhs: PurchaseGroupKey) -> Bool {
            if lhs.year != rhs.year {
                return lhs.year > rhs.year
            }
            return lhs.month > rhs.month
        }
        
    }
    
    var outstanding: [ShoppingItem] {
        if let items = self.items?.allObjects as? [ShoppingItem] {
            return items.filter({$0.basketDate == nil})
        }
        return []
    }
    
    var shareText: String {
        self.outstanding.stringValue
    }
    
    var usersString: String? {
        if let shoppers = self.shoppers?.allObjects as? [Shopper], !shoppers.isEmpty {
            let names = shoppers.map({$0.name.givenName}).formattedSummary()
            return "shared with \(names)"
        }
        return nil
    }
    
    public static func == (lhs: ShoppingList, rhs: ShoppingList) -> Bool {
        lhs.id == rhs.id
    }
    
}

extension [String] {
    
    func formattedList() -> String {
        switch self.count {
        case 0:
            return ""
        case 1:
            return self[0]
        case 2:
            return "\(self[0]) and \(self[1])"
        default:
            let allButLast = self.dropLast().joined(separator: ", ")
            return "\(allButLast), and \(self.last!)"
        }
    }
    
    func formattedSummary() -> String {
        switch self.count {
        case 0:
            return ""
        case 1:
            return self[0]
        case 2:
            return "\(self[0]) and \(self[1])"
        default:
            let firstTwo = "\(self[0]), \(self[1])"
            let remaining = self.count - 2
            return "\(firstTwo), and \(remaining) other" + (remaining > 1 ? "s" : "")
        }
    }
    
}
