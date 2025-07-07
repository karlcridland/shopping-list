//
//  ProfileImageView.swift
//  Shopping List
//
//  Created by Karl Cridland on 02/07/2025.
//

import SwiftUI

struct ProfileImageView: View {
    
    @StateObject private var viewModel = ProfileImageViewModel()
    let uid: String?
    let height, width, padding: CGFloat
    @Binding var image: UIImage?
    
    init(uid: String?, height: CGFloat, width: CGFloat, padding: CGFloat = 0, image: Binding<UIImage?>) {
        self.uid = uid
        self.height = height
        self.width = width
        self.padding = padding
        _image = image
    }
    
    init(uid: String?, size: CGFloat, padding: CGFloat = 0, image: Binding<UIImage?>) {
        self.uid = uid
        self.height = size
        self.width = size
        self.padding = padding
        _image = image
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .background(Color(.systemGroupedBackground))
                    .clipShape(Circle())
                    .padding([.vertical, .trailing], padding)
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: width, height: height)
                    .background(Color(.systemGroupedBackground))
                    .foregroundStyle(Color(.charcoal))
                    .clipShape(Circle())
                    .padding([.vertical, .trailing], padding)
            }
        }
        .onAppear {
            if let uid = uid, image == nil{
                viewModel.loadImage(for: uid) { image in
                    self.image = image
                }
            }
        }
    }
}
