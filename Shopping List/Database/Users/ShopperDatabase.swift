//
//  UserDatabase.swift
//  Shopping List
//
//  Created by Karl Cridland on 25/06/2025.
//

import FirebaseFirestore
import FirebaseAuth
import CoreData

class ShopperDatabase: BaseDatabase {
    
    func set(name: Name) {
        guard let user = Auth.auth().currentUser else { return }
        let userDocRef = db.document("users/\(user.uid)")
        userDocRef.setData(name.data) { error in
            if let error = error {
                print("Error writing name: \(error.localizedDescription)")
            }
        }
    }
    
    func get(_ uid: String?, _ context: NSManagedObjectContext) async -> Shopper? {
        if let uid = uid {
            do {
                let snapshot = try await db.document("users/\(uid)").getDocument()
                let shopper = snapshot.shopper(from: context)
                if let shopper = shopper, !shopper.isFault {
                    return shopper
                }
            } catch {
                print("Error getting shopper: \(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }
    
    func search(query: String, context: NSManagedObjectContext) async -> [Shopper] {
        guard !query.cleaned.isEmpty else { return [] }
        let lowerQuery = query.cleaned.lowercased()
        do {
            let snapshot = try await db.collection("users")
                .whereField("searchTokens", arrayContains: lowerQuery)
                .getDocuments()
            return snapshot.documents.compactMap({$0.shopper(from: context)})

        } catch {
            print("Error searching users: \(error.localizedDescription)")
            return []
        }
    }
    
}
