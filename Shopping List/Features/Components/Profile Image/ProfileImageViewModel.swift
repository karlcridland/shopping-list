//
//  ProfileImageViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 26/06/2025.
//

import FirebaseStorage
import SwiftUI

class ProfileImageViewModel: ObservableObject {

    private var storage: Storage
    private let fileManager = FileManager.default

    init(storage: Storage = Storage.storage()) {
        self.storage = storage
    }

    func loadImage(for uid: String, onComplete: @escaping (UIImage?) -> Void) {
        if let cachedImage = loadImageFromCache(uid: uid) {
            onComplete(cachedImage)
            return
        }

        let path = "users/\(uid)/profile.jpg"
        let ref = storage.reference(withPath: path)

        ref.downloadURL { url, error in
            guard let url = url, error == nil else {
                print("Failed to get download URL:", error?.localizedDescription ?? "Unknown error")
                DispatchQueue.main.async {
                    onComplete(nil)
                }
                return
            }

            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print("Error downloading image data:", error.localizedDescription)
                    DispatchQueue.main.async {
                        onComplete(nil)
                    }
                    return
                }

                guard let data = data, let uiImage = UIImage(data: data) else {
                    print("Failed to convert data to UIImage")
                    DispatchQueue.main.async {
                        onComplete(nil)
                    }
                    return
                }

                // 3. Save to cache
                self.saveImageToCache(uid: uid, imageData: data)

                DispatchQueue.main.async {
                    onComplete(uiImage)
                }
            }.resume()
        }
    }

    private func cacheDirectoryURL() -> URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    }

    private func imageCachePath(for uid: String) -> URL? {
        cacheDirectoryURL()?.appendingPathComponent("profile_\(uid).jpg")
    }

    private func saveImageToCache(uid: String, imageData: Data) {
        guard let path = imageCachePath(for: uid) else { return }
        do {
            try imageData.write(to: path)
        } catch {
            print("Failed to save image to cache:", error.localizedDescription)
        }
    }

    private func loadImageFromCache(uid: String) -> UIImage? {
        guard let path = imageCachePath(for: uid),
              fileManager.fileExists(atPath: path.path),
              let data = try? Data(contentsOf: path),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
}
