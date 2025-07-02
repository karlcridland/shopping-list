//
//  Query.swift
//  Shopping List
//
//  Created by Karl Cridland on 27/06/2025.
//

import CoreData
import FirebaseFirestore

extension Query {
    
    func observe(_ context: NSManagedObjectContext) {
        self.addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching shopping lists: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            Task {
                await context.perform {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingList")
                    let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    _ = try? context.execute(batchDelete)
                }

                for doc in documents {
                    let shoppingList = ShoppingList(context: context)
                    shoppingList.id = doc.documentID
                    shoppingList.title = doc.get("title") as? String
                    shoppingList.owner = doc.get("owner") as? String
                    shoppingList.created = (doc.get("created") as? Timestamp)?.dateValue()
                    shoppingList.lastUpdated = (doc.get("lastUpdated") as? Timestamp)?.dateValue()

                    if let shopperIDs = doc.get("shoppers") as? [String] {
                        shoppingList.shopperData = shopperIDs as NSObject
                        var relatedShoppers: [Shopper] = []
                        for uid in shopperIDs {
                            if let shopper = await Database.users.shoppers.get(uid, context) {
                                relatedShoppers.append(shopper)
                            }
                        }
                        await context.perform {
                            shoppingList.shoppers = NSSet(array: relatedShoppers)
                        }
                    }
                }

                await context.perform {
                    try? context.save()
                }
            }
        }
    }
    
}
