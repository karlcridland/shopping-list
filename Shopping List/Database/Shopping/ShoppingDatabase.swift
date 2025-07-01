//
//  ShoppingDatabase.swift
//  Shopping List
//
//  Created by Karl Cridland on 25/06/2025.
//

import Foundation
import CoreData
import FirebaseAuth
import FirebaseFirestore

class ShoppingDatabase: BaseDatabase {
    
    func observeShoppingLists(context: NSManagedObjectContext) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("shopping_lists")
            .whereField("owner", isEqualTo: uid)
            .observe(context)
        db.collection("shopping_lists")
            .whereField("shoppers", arrayContains: uid)
            .observe(context)
    }
    
    func save(_ shoppingList: ShoppingList) async {
        if let id = shoppingList.id {
            do {
                try await db.collection("shopping_lists").document(id)
                    .setData(shoppingList.data)
            }
            catch {
                print("Error saving shopping list: \(error.localizedDescription)")
            }
        }
    }
    
    func delete(_ shoppingList: ShoppingList) async {
        if let id = shoppingList.id {
            do {
                try await db.collection("shopping_lists").document(id)
                    .delete()
            }
            catch {
                print("Error deleting shopping list: \(error.localizedDescription)")
            }
        }
    }
    
    func getListeners(handle: @escaping (String, QuerySnapshot?, Error?) -> Void) -> [ListenerRegistration] {
        let id: String = UUID().uuidString
        var listeners: [ListenerRegistration] = []
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        let ref = self.db.collection("shopping_lists")
        let ownedLists = ref.whereField("owner", isEqualTo: uid)
        let sharedLists = ref.whereField("shoppers", arrayContains: uid)
        [ownedLists, sharedLists].forEach { listener in
            listeners.append(
                listener.addSnapshotListener { snapshot, error in
                    handle(id, snapshot, error)
                }
            )
        }
        return listeners
    }
    
}

extension ShoppingList {
    
    func save() {
        Task {
            await Database.shopping.save(self)
        }
    }
    
    func delete() async {
        if let id = self.id {
            ShoppingListObserver.shared.deleteList.append(id)
        }
        await Database.shopping.delete(self)
    }
    
    var data: [String: Any] {
        if let id = self.id,
           let owner = self.owner,
           let created = self.created,
           let lastUpdated = self.lastUpdated {
            let shoppers = self.shopperData as? [String] ?? []
            let itemData: [[String: Any]] = items?.compactMap { ($0 as? ShoppingItem)?.data } ?? []
            return [
                "id": id,
                "title": title ?? "",
                "owner": owner,
                "shoppers": shoppers,
                "items": itemData,
                "created": created,
                "lastUpdated": lastUpdated
            ]
        }
        print(self.id ?? "No ID", self.owner ?? "No Owner", self.created ?? "No Created", self.lastUpdated ?? "No Last Updated", self.title ?? "No Title")
        return [:]
    }
    
}

extension ShoppingItem {
    
    var data: [String: Any] {
        if let id = self.id,
           let title = self.title,
           let describe = self.describe {
            var result: [String: Any] = [
                "id": id,
                "title": title,
                "describe": describe,
                "category": categoryRaw ?? Category.miscellaneous.rawValue,
                "addedDate": Timestamp(date: addedDate ?? Date())
            ]
            if let basketDate = basketDate {
                result["basketDate"] = Timestamp(date: basketDate)
            }
            else {
                result["basketDate"] = nil
            }
            return result
        }
        return [:]
    }
    
}
