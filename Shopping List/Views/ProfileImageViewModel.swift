//
//  ProfileImageViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 26/06/2025.
//


import FirebaseStorage
import SwiftUI

class ProfileImageViewModel: ObservableObject {

    private var storage = Storage.storage()

    func loadImage(for uid: String, onComplete: @escaping (UIImage) -> Void) {
        let path = "users/\(uid)/profile.jpg"
        let ref = storage.reference(withPath: path)

        ref.downloadURL { url, error in
            guard let url = url, error == nil else {
                print("Failed to get download URL:", error?.localizedDescription ?? "Unknown error")
                return
            }

            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data, let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        onComplete(uiImage)
                    }
                }
            }.resume()
        }
    }
}
