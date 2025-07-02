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
    
    let delay = KeyboardDelay()
    
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
    
}
