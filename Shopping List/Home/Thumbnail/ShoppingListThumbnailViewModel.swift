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

    init(shoppingList: ShoppingList) {
        self.shoppingList = shoppingList
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
        if shoppers.count > 1 {
            results.append("\(shoppers.count) people")
        }
        return results.isEmpty ? "Tap to add items to your shopping list" : results.joined(separator: ", ")
    }

}
