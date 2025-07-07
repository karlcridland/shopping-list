//
//  UserDatabase.swift
//  Shopping List
//
//  Created by Karl Cridland on 26/06/2025.
//

import FirebaseAuth
import FirebaseStorage
import UIKit

class UserDatabase: BaseDatabase {
    
    let friends = FriendsDatabase()
    let shoppers = ShopperDatabase()
    
    func updateProfile(picture: UIImage, _ onComplete: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            onComplete(false)
            return
        }

        var compression: CGFloat = 0.01
        let minCompression: CGFloat = 0.005
        let targetSizeKB = 100
        var imageData = picture.jpegData(compressionQuality: compression)

        while let data = imageData, data.count > targetSizeKB * 1024 && compression > minCompression {
            compression -= 0.001
            imageData = picture.jpegData(compressionQuality: compression)
        }

        guard let finalData = imageData else {
            onComplete(false)
            return
        }

        let path = "users/\(uid)/profile.jpg"
        let storageRef = Storage.storage().reference().child(path)

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageRef.putData(finalData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Couldn't upload: \(error.localizedDescription)")
                onComplete(false)
            } else {
                onComplete(true)
            }
        }
    }

    
}

extension String {
    
    var isMyUid: Bool {
        return self == Auth.auth().currentUser?.uid
    }
    
}
