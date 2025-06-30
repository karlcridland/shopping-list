//
//  ShoppingListThumbnailViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 30/06/2025.
//

import SwiftUI
import CoreData

class ShoppingListThumbnailViewModel: ObservableObject {
    
    @Published var shoppingList: ShoppingList
    @Published var items: [ShoppingItem] = []

    init(shoppingList: ShoppingList, context: NSManagedObjectContext) {
        self.shoppingList = shoppingList
        self.fetchItems(context: context)
    }

    private func fetchItems(context: NSManagedObjectContext) {
        let request: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ShoppingItem.title, ascending: true)]
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "list == %@", shoppingList),
            NSPredicate(format: "basketDate == nil")
        ])
        
        do {
            self.items = try context.fetch(request)
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }

    var title: String {
        let t: String? = shoppingList.title
        return t == "" ? "Shopping List" : t ?? "Shopping List"
    }

    var subtitle: String {
        if let shoppers = shoppingList.shoppers?.allObjects as? [Shopper] {
            var results: [String] = []
            if !items.isEmpty {
                results.append("\(items.count) item\(items.count == 1 ? "" : "s")")
            }
            if shoppers.count > 1 {
                results.append("\(shoppers.count) people")
            }
            return results.isEmpty ? "Tap to add items to your shopping list" : results.joined(separator: ", ")
        }
        return "Tap to create a new list"
    }
}
