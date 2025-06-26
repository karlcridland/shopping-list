//
//  UserDatabase.swift
//  Shopping List
//
//  Created by Karl Cridland on 26/06/2025.
//

import FirebaseAuth

class UserDatabase {
    
    let friends = FriendsDatabase()
    let shoppers = ShopperDatabase()
    
}

extension String {
    
    var isMyUid: Bool {
        return self == Auth.auth().currentUser?.uid
    }
    
}
