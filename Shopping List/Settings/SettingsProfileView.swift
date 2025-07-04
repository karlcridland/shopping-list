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
                            ProfileImageView(uid: viewModel.uid, size: 50, padding: 0)
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
            guard let item = newItem else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                }
            }
        }
    }
}

