//
//  ShoppingListSettingsShoppersViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 02/07/2025.
//

import CoreData

class ShoppingListSettingsShoppersViewModel: ObservableObject {
    
    @Published var shoppingList: ShoppingList
    @Published var shoppers: [Shopper]
    
    init(shoppingList: ShoppingList) {
        self.shoppingList = shoppingList
        self.shoppers = shoppingList.shoppers?.allObjects as? [Shopper] ?? []
    }
    
    func removeUser(_ uid: String?, _ context: NSManagedObjectContext) {
        if var shoppers = self.shoppingList.shopperData as? [String] {
            shoppers.removeAll(where: {$0 == uid})
            self.shoppingList.shopperData = NSArray(array: shoppers)
            self.shoppers.removeAll(where: {$0.uid == uid})
            self.shoppingList.save()
            try? context.save()
        }
    }
    
    func fetchShoppers() {
        self.shoppers = shoppingList.shoppers?.allObjects as? [Shopper] ?? []
    }
    
}
