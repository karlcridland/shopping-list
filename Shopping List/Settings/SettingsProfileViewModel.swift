//
//  SettingsProfileViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 04/07/2025.
//

import SwiftUI
import FirebaseAuth
import CoreData

@MainActor
class SettingsProfileViewModel: ObservableObject {
    
    let uid: String?
    @Published var name: String?
    
    init(_ context: NSManagedObjectContext) {
        self.uid = Auth.auth().currentUser?.uid
        Task {
            self.name = await Database.users.shoppers.get(uid, context)?.name.full ?? ""
        }
    }
    
}
