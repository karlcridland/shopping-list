//
//  SettingsProfileView.swift
//  Shopping List
//
//  Created by Karl Cridland on 04/07/2025.
//

import SwiftUI
import CoreData
import PhotosUI

struct SettingsProfileView: View {
    @StateObject var viewModel: SettingsProfileViewModel
    @Binding var showProfilePicture: Bool
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var isUploadgin: Bool = false

    init(_ context: NSManagedObjectContext, _ showProfilePicture: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: SettingsProfileViewModel(context))
        _showProfilePicture = showProfilePicture
    }

    var body: some View {
        Section("Profile") {
            HStack {
                Spacer()
                VStack(alignment: .center, spacing: 20) {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        VStack(alignment: .center, spacing: 5) {
                            ProfileImageView(uid: viewModel.uid, size: 60, image: $selectedImage)
                            Text("tap to upload")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundStyle(Color(.systemBlue))
                        }
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Text(viewModel.name ?? "")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }
            .padding(.vertical, 16)
        }
        .onChange(of: selectedItem) { _, newItem in
            viewModel.extractImage(newItem) { image in
                if let image = image {
                    self.selectedImage = image
                }
            }
        }
    }
}

