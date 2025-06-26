//
//  ShoppingList.swift
//  Shopping List
//
//  Created by Karl Cridland on 24/06/2025.
//

import Foundation
import CoreData

extension ShoppingList {
    
    func update(_ item: ShoppingItem, context: NSManagedObjectContext) {
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
    }
    
    func remove(_ item: ShoppingItem) {
        self.removeFromItems(item)
    }
    
    func remove(_ item: ShoppingItem, context: NSManagedObjectContext) {
        self.removeFromItems(item)
        context.delete(item)
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
                return lhs.year > rhs.year // most recent year first
            }
            return lhs.month > rhs.month // most recent month first
        }
    }
    
    var outstanding: [ShoppingItem] {
        if let items = self.items?.allObjects as? [ShoppingItem] {
            return items.filter({$0.basketDate == nil})
        }
        return []
    }
    
    var shareText: String {
        var results: [String] = []
        self.outstanding.sorted(by: {$0.category < $1.category}).forEach { item in
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
