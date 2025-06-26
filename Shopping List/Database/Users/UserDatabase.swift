//
//  UserDatabase.swift
//  Shopping List
//
//  Created by Karl Cridland on 25/06/2025.
//

import FirebaseFirestore
import FirebaseAuth
import CoreData

class UserDatabase: BaseDatabase {
    
    func set(name: Name) {
        guard let user = Auth.auth().currentUser else { return }
        let userDocRef = db.document("users/\(user.uid)")
        userDocRef.setData(name.data) { error in
            if let error = error {
                print("Error writing name: \(error.localizedDescription)")
            }
        }
    }
    
    func search(query: String, context: NSManagedObjectContext) async -> [Shopper] {
        guard !query.isEmpty else { return [] }

        do {
            let snapshots = try await fetchMatchingDocuments(for: query)
            let shoppers = snapshots.process(query: query, context: context)
            return shoppers.sorted { $0.score > $1.score }.map { $0.shopper }
        } catch {
            print("Error searching users: \(error.localizedDescription)")
            return []
        }
    }
    
    func addUser(_ uid: String) {
        guard let user = Auth.auth().currentUser else { return }
        
        let request: [String: Any] = [
            "from": user.uid,
            "to": uid,
            "status": FriendStatus.pending.rawValue,
            "timestamp": Timestamp()
        ]
        
        db.collection("friend_requests").addDocument(data: request) { error in
            if let error = error {
                print("Error sending friend request: \(error.localizedDescription)")
            } else {
                print("Friend request sent to \(uid)")
            }
        }
    }
    
    func accept(_ uid: String) {
        
    }
    
    func reject(_ uid: String) {
        
    }
    
    func observeFriendRequests(listener: @escaping ([Shopper]) -> Void, context: NSManagedObjectContext) {
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
                              let name = doc.get("name") as? String else { return }

                        let shopper = Shopper(context: context)
                        shopper.uid = uid
                        shopper.name = name
                        shoppers.append(shopper)
                    }
                }

                group.notify(queue: .main) {
                    listener(shoppers)
                }
            }
    }
    
    func relationshipTo(_ uid: String?) async -> String {
        if let uid = uid {
            if (uid == Auth.auth().currentUser?.uid) {
                return "This is you"
            }
        }
        return "No mutual friends"
    }
    
    private func fetchMatchingDocuments(for query: String) async throws -> [QueryDocumentSnapshot] {
        let lowerBound = query
        let upperBound = query + "\u{f8ff}"

        async let givenNameSnap = db.collection("users")
            .whereField("givenName", isGreaterThanOrEqualTo: lowerBound)
            .whereField("givenName", isLessThan: upperBound)
            .limit(to: 10)
            .getDocuments()

        async let familyNameSnap = db.collection("users")
            .whereField("familyName", isGreaterThanOrEqualTo: lowerBound)
            .whereField("familyName", isLessThan: upperBound)
            .limit(to: 10)
            .getDocuments()

        let (snap1, snap2) = try await (givenNameSnap, familyNameSnap)
        return snap1.documents + snap2.documents
    }
    
}
