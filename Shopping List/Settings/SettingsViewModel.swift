//
//  SettingsViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 04/07/2025.
//

import SwiftUI
import CoreData

class SettingsViewModel: ObservableObject {
    
    @Published var showProfileUpload: Bool = false
    @Published var font: Font = .system(size: 15, weight: .medium)
    
    init() {
        
    }
    
    func updateProfileImage(_ image: UIImage) {
//        self.profileImage = image
    }
    
}
