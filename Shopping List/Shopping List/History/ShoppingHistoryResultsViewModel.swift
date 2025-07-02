//
//  ShoppingHistoryResultsViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 01/07/2025.
//

import CoreData

class ShoppingHistoryResultsViewModel: ObservableObject {
    @Published var items: [ShoppingItem]

    init(items: [ShoppingItem]) {
        self.items = items
    }

    var categories: [Category] {
        Array(Set(items.compactMap { $0.category })).sorted()
    }
    
    func undoItem(_ item: ShoppingItem, _ context: NSManagedObjectContext) {
        item.basketDate = nil
        item.list?.save()
        items.removeAll { $0.id == item.id }
        try? context.save()
    }
    
}
