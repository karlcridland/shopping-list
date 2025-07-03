//
//  ShoppingListItemsViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 30/06/2025.
//

import Foundation
import CoreData
import SwiftUI

class ShoppingListItemsViewModel: ObservableObject {
    @Published var items: [ShoppingItem] = []
    @Published var previewItem: ShoppingItem?
    @Published var showPreview = false

    private var context: NSManagedObjectContext
    private var shoppingList: ShoppingList

    init(context: NSManagedObjectContext, shoppingList: ShoppingList) {
        self.context = context
        self.shoppingList = shoppingList
        fetchItems()
    }

    func fetchItems() {
        let request: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ShoppingItem.title, ascending: true)]
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "list == %@", shoppingList),
            NSPredicate(format: "basketDate == nil")
        ])
        do {
            items = try context.fetch(request)
        } catch {
            print("Failed to fetch shopping items: \(error)")
        }
    }

    func deleteItem(_ item: ShoppingItem) {
        item.list = nil
        save()
    }

    func markComplete(_ item: ShoppingItem) {
        item.basketDate = Date()
        save()
    }

    func preview(_ item: ShoppingItem) {
        previewItem = item
        showPreview = true
    }

    func save() {
        do {
            shoppingList.save()
            print("6. saving on list save")
            try context.save()
            fetchItems()
        } catch {
            print("Unresolved error \(error.localizedDescription)")
        }
    }

    func categories() -> [Category] {
        Array(Set(items.compactMap { $0.category })).sorted()
    }

    func items(for category: Category) -> [ShoppingItem] {
        items.filter { $0.category == category }
    }
}
