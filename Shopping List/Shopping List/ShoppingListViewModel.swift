//
//  ShoppingListViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 30/06/2025.
//

import Foundation
import CoreData
import SwiftUI

class ShoppingListViewModel: ObservableObject {
    @Published var showItems = true
    @Published var showHistory = false
    @Published var showSettings = false
    @Published var showNewItem = false
    @Published var isSharing = false
    
    @Published var editingItem: ShoppingItem?

    let shoppingList: ShoppingList
    let context: NSManagedObjectContext

    init(shoppingList: ShoppingList, context: NSManagedObjectContext) {
        self.shoppingList = shoppingList
        self.context = context
    }

    func onAppear() {
        if shoppingList.title?.isEmpty ?? true {
            resetDisplay()
            showSettings = true
        }
    }

    func resetDisplay() {
        showItems = false
        showHistory = false
        showSettings = false
    }

    func startNewItemEdit(existingItem: ShoppingItem? = nil) {
        editingItem = existingItem
        showNewItem = true
        resetDisplay()
        showItems = true
    }

    func saveItem(_ item: ShoppingItem) {
        do {
            shoppingList.update(item, context: context)
            try context.save()
        } catch {
            print("Failed to save item: \(error.localizedDescription)")
        }
    }
}
