//
//  RequestsDatabase.swift
//  Shopping List
//
//  Created by Karl Cridland on 26/06/2025.
//

import FirebaseFirestore
import FirebaseAuth

class RequestsDatabase: BaseDatabase {
    
    func addUser(_ uid: String, onAlert: @escaping (String) -> Void, onSuccess: @escaping () -> Void) {
        guard let user = Auth.auth().currentUser, user.uid != uid else {
            print("Cannot send request to self")
            return
        }

        let query = db.collection("friend_requests")
            .whereField("from", isEqualTo: user.uid)
            .whereField("to", isEqualTo: uid)

        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error checking existing requests: \(error.localizedDescription)")
                return
            }

            if let docs = snapshot?.documents, !docs.isEmpty {
                onAlert("You've already sent a friend request.")
                return
            }

            let request: [String: Any] = [
                "from": user.uid,
                "to": uid,
                "status": FriendStatus.pending.rawValue,
                "timestamp": Timestamp()
            ]
            let id = [user.uid, uid].sorted().joined(separator: "_")
            self.db.collection("friend_requests").document(id).setData(request) { error in
                if let error = error {
                    print("Error sending friend request: \(error.localizedDescription)")
                } else {
                    onSuccess()
                }
            }
        }
    }
    
    func accept(_ uid: String, onComplete: @escaping () -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }

        let docId = [uid, currentUserUID].sorted().joined(separator: "_")
        let requestRef = db.collection("friend_requests").document(docId)

        requestRef.updateData([
            "status": FriendStatus.accepted.rawValue,
            "updated": Timestamp()
        ]) { error in
            if let error = error {
                print("Failed to accept friend request: \(error.localizedDescription)")
            } else {
                self.writeFriendLink(between: currentUserUID, and: uid, onComplete: onComplete)
            }
        }
    }
    
    func reject(_ uid: String, onComplete: @escaping () -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }

        let docId = [uid, currentUserUID].sorted().joined(separator: "_")
        let requestRef = db.collection("friend_requests").document(docId)

        requestRef.updateData([
            "status": FriendStatus.rejected.rawValue,
            "updated": Timestamp()
        ]) { error in
            if let error = error {
                print("Failed to reject friend request: \(error.localizedDescription)")
            } else {
                onComplete()
            }
        }
    }
    
    private func writeFriendLink(between uidA: String, and uidB: String, onComplete: @escaping () -> Void) {
        let timestamp = Timestamp()

        let userAFriendsRef = db.collection("users").document(uidA).collection("friends").document(uidB)
        let userBFriendsRef = db.collection("users").document(uidB).collection("friends").document(uidA)

        print("Writing friend link from: \(userAFriendsRef.path)")
        print("Writing friend link to: \(userBFriendsRef.path)")
        print("Acting as: \(Auth.auth().currentUser?.uid ?? "nil")")

        let batch = db.batch()
        batch.setData(["uid": uidB, "timestamp": timestamp], forDocument: userAFriendsRef)
        batch.setData(["uid": uidA, "timestamp": timestamp], forDocument: userBFriendsRef)

        batch.commit { error in
            if let error = error {
                print("🔥 Firestore batch commit error: \(error.localizedDescription)")
            } else {
                print("✅ Friendship established between \(uidA) and \(uidB)")
                onComplete()
            }
        }
    }
    
}
