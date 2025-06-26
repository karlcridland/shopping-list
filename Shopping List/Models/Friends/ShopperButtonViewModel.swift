//
//  ShopperButtonViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 25/06/2025.
//

import Combine

class ShopperButtonViewModel: ObservableObject {
    
    func quickAdd(_ uid: String) {
        Database.users.addUser(uid)
    }
    
}
