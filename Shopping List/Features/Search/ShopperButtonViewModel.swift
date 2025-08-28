//
//  ShopperButtonViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 25/06/2025.
//

import Combine
import FirebaseAuth
import SwiftUI

class ShopperButtonViewModel: ObservableObject {
    
    @Published var subtitle: String = ""
    @Published var status: FriendStatus?
    @Published var hasLoaded: Bool = false
    
    let shopper: Shopper
    
    init(_ shopper: Shopper) {
        self.shopper = shopper
    }
    
    @MainActor
    func getSubtitle() async {
        guard let uid = shopper.uid else { return }

        if uid == Auth.auth().currentUser?.uid {
            subtitle = "This is you"
            hasLoaded = true
            return
        }

        async let friendDate = Database.users.friends.friends(with: uid)
        async let relationshipStatus = Database.users.friends.relationship(to: uid)
        async let mutualCount = Database.users.friends.mutualFriends(to: uid)

        if let date = await friendDate {
            subtitle = "Friends since \(date.formatted(date: .abbreviated, time: .omitted))"
            self.status = .accepted
        } else if let status = await relationshipStatus {
            self.status = status
            switch status {
            case .pending:
                subtitle = "Friend request sent"
            case .requestReceived:
                subtitle = "Accept friend request?"
            default:
                subtitle = ""
            }
        } else {
            let mutuals = await mutualCount
            subtitle = "\(mutuals) mutual friend\(mutuals == 1 ? "" : "s")"
        }

        hasLoaded = true
    }
    
    func quickAdd(_ uid: String, onAlert: @escaping (String) -> Void) {
        Database.users.friends.requests.addUser(uid, onAlert: onAlert, onSuccess: {
            self.status = .pending
            self.subtitle = "Friend request sent"
        })
    }
    
    func accept() {
        guard let uid = shopper.uid else { return }
        Database.users.friends.requests.accept(uid) {
            self.status = .accepted
        }
    }
    
    func reject() {
        guard let uid = shopper.uid else { return }
        Database.users.friends.requests.reject(uid) {
            self.status = .rejected
        }
    }
    
}
