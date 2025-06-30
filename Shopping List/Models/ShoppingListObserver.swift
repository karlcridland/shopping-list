//
//  ShoppingListObserver.swift
//  Shopping List
//
//  Created by Karl Cridland on 28/06/2025.
//

import Foundation
import CoreData
import FirebaseAuth
import FirebaseFirestore


final class ShoppingListObserver: ObservableObject {
    
    static let shared = ShoppingListObserver()
    
    var deleteList: [String] = []
    
    private var listeners: [ListenerRegistration] = []
    
    private init() {}
    
    func startObserving(context: NSManagedObjectContext) {
        stopObserving()
        self.listeners = Database.shopping.getListeners { (snapshot, error) in
            self.handle(snapshot: snapshot, error: error, context: context)
        }
    }

    private func handle(snapshot: QuerySnapshot?, error: Error?, context: NSManagedObjectContext) {
        guard let documents = snapshot?.documents else {
            print("Error syncing shopping lists: \(error?.localizedDescription ?? "Unknown error")")
            return
        }

        Task {
            await context.perform {
                for doc in documents {
                    if (!self.deleteList.contains(doc.documentID)) {
                        let list = self.fetchOrCreateList(id: doc.documentID, context: context)
                        if list.shouldUpdate(from: (doc.get("lastUpdated") as? Timestamp)) {
                            list.extract(from: doc, context: context)
                        }
                    }
                }

                do {
                    try context.save()
                } catch {
                    print("Failed to download lists: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchOrCreateList(id: String, context: NSManagedObjectContext) -> ShoppingList {
        let request: NSFetchRequest<ShoppingList> = ShoppingList.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        if let existing = (try? context.fetch(request))?.first {
            return existing
        } else {
            let newList = ShoppingList(context: context)
            newList.id = id
            return newList
        }
    }

    func stopObserving() {
        listeners.forEach { $0.remove() }
        listeners.removeAll()
    }
}

extension ShoppingList {
    
    func extract(from doc: QueryDocumentSnapshot, context: NSManagedObjectContext) {
        self.title = doc.get("title") as? String
        self.owner = doc.get("owner") as? String
        self.created = (doc.get("created") as? Timestamp)?.dateValue()
        self.lastUpdated = (doc.get("lastUpdated") as? Timestamp)?.dateValue()
        
        var shoppingItems: [ShoppingItem] = []
        if let itemsData = doc.get("items") as? [[String: Any]] {
            itemsData.forEach { itemData in
                if let id = itemData["id"] as? String {
                    let item = self.fetchOrCreateItem(id: id, context: context)
                    item.title = itemData["title"] as? String
                    item.describe = itemData["describe"] as? String
                    item.categoryRaw = itemData["category"] as? String
                    item.addedDate = (itemData["addedDate"] as? Timestamp)?.dateValue()
                    item.basketDate = (itemData["basketDate"] as? Timestamp)?.dateValue()
                    shoppingItems.append(item)
                }
            }
        }
        self.items = NSSet(array: shoppingItems)
        
        Task {
            self.ownerShopper = await Database.users.shoppers.get(self.owner ?? "", context)
            if let shoppers = doc.get("shoppers") as? [String] {
                self.shopperData = shoppers as NSObject
                var shopperList: [Shopper] = []

                for id in shoppers {
                    if let shopper = await Database.users.shoppers.get(id, context) {
                        shopperList.append(shopper)
                    }
                }

                await context.perform {
                    self.shoppers = NSSet(array: shopperList)
                }
            }
        }
    }
    
    func fetchOrCreateItem(id: String, context: NSManagedObjectContext) -> ShoppingItem {
        let request: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        if let existing = (try? context.fetch(request))?.first {
            return existing
        } else {
            let newList = ShoppingItem(context: context)
            newList.id = id
            return newList
        }
    }
    
    func shouldUpdate(from timestamp: Timestamp?) -> Bool {
        if let date = timestamp?.dateValue(),
           let original = self.lastUpdated {
            return date >= original
        }
        return true
    }
    
}
