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
    @Published var count: Int = 0

    init(shoppingList: ShoppingList) {
        self.shoppingList = shoppingList
        self.update()
    }
    
    func update() {
        self.count = (shoppingList.items?.allObjects as? [ShoppingItem] ?? []).filter({$0.basketDate == nil}).count
    }

    var title: String {
        let t: String? = shoppingList.title
        return t == "" ? "Shopping List" : t ?? "Shopping List"
    }

    var subtitle: String {
        if let shoppers = shoppingList.shoppers?.allObjects as? [Shopper] {
            var results: [String] = []
            if count > 0 {
                results.append("\(count) item\(count == 1 ? "" : "s")")
            }
            if shoppers.count > 1 {
                results.append("\(shoppers.count) people")
            }
            return results.isEmpty ? "Tap to add items to your shopping list" : results.joined(separator: ", ")
        }
        return "Tap to create a new list"
    }
}
