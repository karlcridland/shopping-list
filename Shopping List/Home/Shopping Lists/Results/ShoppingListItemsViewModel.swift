//
//  ShoppingListItemsViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 30/06/2025.
//

import SwiftUI
import CoreData

class ShoppingListItemsViewModel: ObservableObject {

    @Published var items: [ShoppingItem] = []
    private(set) var shoppingList: ShoppingList

    init(shoppingList: ShoppingList, context: NSManagedObjectContext) {
        self.shoppingList = shoppingList
        self.fetchItems(context: context)
    }

    func fetchItems(context: NSManagedObjectContext) {
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

    func preview(_ item: ShoppingItem) {
        // implementation remains as needed
    }

    func deleteItem(_ item: ShoppingItem, _ context: NSManagedObjectContext) {
        item.list = nil
        do {
            shoppingList.save()
            try context.save()
            fetchItems(context: context)
        } catch {
            print("Delete failed: \(error)")
        }
    }

    func markComplete(_ item: ShoppingItem, _ context: NSManagedObjectContext) {
        item.basketDate = Date()
        do {
            shoppingList.save()
            try context.save()
            fetchItems(context: context)
        } catch {
            print("Mark complete failed: \(error)")
        }
    }

    func removeItems(at offsets: IndexSet, from filteredItems: [ShoppingItem], _ context: NSManagedObjectContext) {
        withAnimation {
            for index in offsets {
                context.delete(filteredItems[index])
            }
            shoppingList.save()
            do {
                try context.save()
                fetchItems(context: context)
            } catch {
                print("Remove items failed: \(error)")
            }
        }
    }
}
