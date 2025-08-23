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
    
    var position, total: Int

    init(shoppingList: ShoppingList, _ position: Int, _ total: Int) {
        self.shoppingList = shoppingList
        self.position = position
        self.total = total
    }

    var title: String {
        let t: String? = shoppingList.title
        return t == "" ? "Shopping List" : t ?? "Shopping List"
    }
    
    func getSubtitle(_ items: FetchedResults<ShoppingItem>, _ shoppers: FetchedResults<Shopper>) -> String {
        var results: [String] = []
        if items.count > 0 {
            results.append("\(items.count) item\(items.count == 1 ? "" : "s")")
        }
        if let users = shoppingList.usersString, !users.isEmpty {
            results.append(users)
        }
        return results.isEmpty ? "Tap to add items to your shopping list" : results.joined(separator: ", ")
    }
    
    var itemsString: String? {
        let items = shoppingList.outstanding
        return "\(items.count) item\(items.count == 1 ? "" : "s")"
    }
    
    var description: String {
        return [
            "Shopping list",
            self.shoppingList.title,
            self.shoppingList.usersString,
            self.itemsString,
            "Button",
            "\(position) of \(total)."
        ].compactMap({$0}).joined(separator: ", ")
    }

}
