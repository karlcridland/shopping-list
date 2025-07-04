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
    
    init(uid: String?, height: CGFloat, width: CGFloat, padding: CGFloat) {
        self.uid = uid
        self.height = height
        self.width = width
        self.padding = padding
    }
    
    init(uid: String?, size: CGFloat, padding: CGFloat) {
        self.uid = uid
        self.height = size
        self.width = size
        self.padding = padding
    }
    
    var body: some View {
        Group {
            if let image = viewModel.image {
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
            if let uid = uid {
                viewModel.loadImage(for: uid)
            }
        }
    }
}
