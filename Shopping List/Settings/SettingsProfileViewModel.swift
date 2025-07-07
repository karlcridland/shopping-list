//
//  SettingsProfileViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 04/07/2025.
//

import SwiftUI
import FirebaseAuth
import CoreData
import PhotosUI

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
    
    func extractImage(_ newItem: PhotosPickerItem?, _ onComplete: @escaping (UIImage?) -> Void) {
        guard let item = newItem else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                Database.users.updateProfile(picture: image) { didUpload in
                    onComplete(didUpload ? image : nil)
                }
            }
        }
    }
    
}
