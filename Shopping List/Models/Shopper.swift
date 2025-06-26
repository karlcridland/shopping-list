//
//  Shopper.swift
//  Shopping List
//
//  Created by Karl Cridland on 25/06/2025.
//

extension Shopper {
    
    public override var description: String {
        return "\(self.name!) (\(self.uid!))"
    }
    
}

enum FriendStatus: String {
    case pending = "Pending"
    case accepted = "Accepted"
    case rejected = "Rejected"
}
