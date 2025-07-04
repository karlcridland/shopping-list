//
//  Shopper.swift
//  Shopping List
//
//  Created by Karl Cridland on 25/06/2025.
//

import Foundation

extension Shopper {
    
    public var id: String {
        return self.uid ?? UUID().uuidString
    }
    
    public override var description: String {
        return "\(self.name.full) (\(self.uid!))"
    }
    
    var name: Name {
        return Name(givenName ?? "", familyName ?? "")
    }
    
}

enum FriendStatus: String {
    case pending = "Pending"
    case accepted = "Accepted"
    case rejected = "Rejected"
    case requestReceived = "Request Received"
}
