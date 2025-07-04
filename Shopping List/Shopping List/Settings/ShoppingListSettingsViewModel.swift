//
//  ShoppingListSettingsViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 02/07/2025.
//

import SwiftUI
import CoreData
import FirebaseAuth

class ShoppingListSettingsViewModel: ObservableObject {
    
    @Published var shoppingList: ShoppingList
    
    let font: Font = .system(size: 15, weight: .medium)
    let delay = KeyboardDelay()
    
    @Published var showShoppingList: Bool = false
    
    init(shoppingList: ShoppingList) {
        self.shoppingList = shoppingList
    }
    
    var title: Binding<String> {
        Binding<String>(
            get: { self.shoppingList.title ?? "" },
            set: { self.shoppingList.title = $0 }
        )
    }
    
    @MainActor
    func save(title: String, _ context: NSManagedObjectContext) {
        do {
            self.shoppingList.save()
            print("7. saving in list settings")
            try context.save()
        } catch {
            print("Error saving:", error.localizedDescription)
        }
    }
    
    var isOwnedByUser: Bool {
        if let uid = Auth.auth().currentUser?.uid,
           let owner = shoppingList.owner {
            return uid == owner
        }
        return false
    }
    
    func addShopper(_ uid: String, _ context: NSManagedObjectContext) {
        if var shoppers = self.shoppingList.shopperData as? [String], !shoppers.contains(uid) {
            shoppers.append(uid)
            self.shoppingList.shopperData = shoppers as NSObject
            self.shoppingList.save()
            print("8. saving when adding shopper to list")
            try? context.save()
        }
    }
    
}
