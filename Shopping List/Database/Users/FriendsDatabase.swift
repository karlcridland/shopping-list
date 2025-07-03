//
//  FriendsDatabase.swift
//  Shopping List
//
//  Created by Karl Cridland on 26/06/2025.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import CoreData

class FriendsDatabase: BaseDatabase {
    
    let requests = RequestsDatabase()
    
    func get(_ context: NSManagedObjectContext) async -> [Shopper] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        
        let snapshot = try? await db.collection("users").document(uid).collection("friends").getDocuments()
        
        guard let documents = snapshot?.documents else { return [] }
        
        var shoppers: [Shopper] = []
        
        for doc in documents {
            if let shopper = await Database.users.shoppers.get(doc.documentID, context) {
                shoppers.append(shopper)
            }
        }
        
        return shoppers
    }

    
    func mutualFriends(to uid: String) async -> Int {
        guard let currentUID = Auth.auth().currentUser?.uid else { return 0 }

        do {
            let myFriendsSnap = try await db.collection("users").document(currentUID).collection("friends").getDocuments()
            let theirFriendsSnap = try await db.collection("users").document(uid).collection("friends").getDocuments()

            let myFriendIDs = Set(myFriendsSnap.documents.map { $0.documentID })
            let theirFriendIDs = Set(theirFriendsSnap.documents.map { $0.documentID })

            return myFriendIDs.intersection(theirFriendIDs).count
        } catch {
            print("Error fetching mutual friends: \(error.localizedDescription)")
            return 0
        }
    }
    
    func friends(with uid: String) async -> Date? {
        guard let user = Auth.auth().currentUser else { return nil }
        do {
            let friends = try await db.collection("users").document(user.uid).collection("friends").getDocuments()
            if let document = friends.documents.first(where: {$0.documentID == uid}),
               let timestamp: Timestamp = document.data()["timestamp"] as? Timestamp {
                return timestamp.dateValue()
            }
        } catch {
            print("Error checking friends: \(error.localizedDescription)")
        }
        return nil
    }
    
    func relationship(to uid: String) async -> FriendStatus? {
        guard let currentUser = Auth.auth().currentUser else { return nil }

        do {
            let youSentQuery = db.collection("friend_requests")
                .whereField("from", isEqualTo: currentUser.uid)
                .whereField("to", isEqualTo: uid)
                .limit(to: 1)

            let youSentSnapshot = try await youSentQuery.getDocuments()

            if let doc = youSentSnapshot.documents.first,
               let statusString = doc.data()["status"] as? String,
               let status = FriendStatus(rawValue: statusString) {
                return status // .pending / .accepted / .rejected
            }

            let theySentQuery = db.collection("friend_requests")
                .whereField("from", isEqualTo: uid)
                .whereField("to", isEqualTo: currentUser.uid)
                .limit(to: 1)

            let theySentSnapshot = try await theySentQuery.getDocuments()

            if let doc = theySentSnapshot.documents.first,
               let statusString = doc.data()["status"] as? String,
               statusString == FriendStatus.pending.rawValue {
                return .requestReceived
            }

            return nil
        } catch {
            print("Error determining relationship status: \(error.localizedDescription)")
            return nil
        }
    }
    
    func observeRequests(listener: @escaping ([Shopper]) -> Void, context: NSManagedObjectContext) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }

        db.collection("friend_requests")
            .whereField("to", isEqualTo: currentUID)
            .whereField("status", isEqualTo: FriendStatus.pending.rawValue)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    print("Error observing friend requests: \(String(describing: error))")
                    return
                }

                let fromUIDs = snapshot.documents.compactMap { $0.get("from") as? String }
                var shoppers: [Shopper] = []
                let group = DispatchGroup()

                for uid in fromUIDs {
                    group.enter()
                    self.db.collection("users").document(uid).getDocument { doc, error in
                        defer { group.leave() }
                        guard let doc = doc, doc.exists,
                              let shopper = doc.shopper(from: context) else { return }
                        shoppers.append(shopper)
                    }
                }

                group.notify(queue: .main) {
                    listener(shoppers)
                }
            }
    }
    
}
