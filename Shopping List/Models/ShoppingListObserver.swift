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
    private var listeningFor: [String] = []
    private var hasUpdated: [String] = []
    
    @Published var hasSynced: Bool = false
    
    private init() {}
    func startObserving(context: NSManagedObjectContext, onFinish: @escaping () -> Void) {
        stopObserving()

        self.listeners = Database.shopping.getListeners { (id, snapshot, error) in
            self.listeningFor.append(id)
            self.handle(snapshot: snapshot, error: error, context: context) {
                self.listeningFor.removeAll(where: { $0 == id })
                let isFinished = self.listeningFor.isEmpty
                DispatchQueue.main.async {
                    self.hasSynced = isFinished
                    if isFinished {
                        onFinish()
                    }
                }
            }
        }
    }

    private func handle(snapshot: QuerySnapshot?, error: Error?, context: NSManagedObjectContext, onFinish: @escaping () -> Void) {
        guard let documents = snapshot?.documents else {
            print("Error syncing shopping lists: \(error?.localizedDescription ?? "Unknown error")")
            return
        }

        Task {
            await context.perform {
                for doc in documents {
                    if (!self.deleteList.contains(doc.documentID)) {
                        let list = self.fetchOrCreateList(id: doc.documentID, context: context)
                        if list.shouldUpdate(from: (doc.get("lastUpdated") as? Timestamp), firstUpdate: !self.hasUpdated.contains(doc.documentID)) {
                            list.extract(from: doc, context: context)
                        }
                        self.hasUpdated.append(doc.documentID)
                    }
                }
            }
            onFinish()
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
    
    func shouldIgnore(_ id: String?) -> Bool {
        if let id = id {
            return self.deleteList.contains(id)
        }
        return false
    }
}

extension ShoppingList {
    
    func extract(from doc: QueryDocumentSnapshot, context: NSManagedObjectContext) {
        self.title = doc.get("title") as? String
        self.owner = doc.get("owner") as? String
        self.created = (doc.get("created") as? Timestamp)?.dateValue()
        self.lastUpdated = (doc.get("lastUpdated") as? Timestamp)?.dateValue()
        self.shopperData = NSArray(array: doc.get("shoppers") as? [String] ?? [])
        
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
        self.items = NSSet(safeArray: shoppingItems)
        
        Task {
            self.ownerShopper = await Database.users.shoppers.get(self.owner ?? "", context)
            if let shoppers = self.shopperData as? [String] {
                var shopperList: [Shopper] = []

                for id in shoppers {
                    if let originals = self.shoppers?.allObjects as? [Shopper],
                       let shopper = originals.first(where: {$0.uid == id}) {
                        shopperList.append(shopper)
                    }
                    else if let shopper = await Database.users.shoppers.get(id, context) {
                        shopperList.append(shopper)
                    }
                }

                await context.perform {
                    self.shoppers = NSSet(safeArray: shopperList)
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
    
    func shouldUpdate(from timestamp: Timestamp?, firstUpdate: Bool) -> Bool {
        if (firstUpdate) {
            return true
        }
        if let date = timestamp?.dateValue(),
           let original = self.lastUpdated {
            return date >= original
        }
        return true
    }
    
}

extension NSSet {
    convenience init?(safeArray array: [Any?]) {
        let cleaned = array.compactMap { $0 }
        guard cleaned.count == array.count else {
            return nil
        }
        self.init(array: cleaned)
    }
}
