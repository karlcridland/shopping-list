//
//  ProfileImageView.swift
//  Shopping List
//
//  Created by Karl Cridland on 02/07/2025.
//

import SwiftUI

struct ProfileImageView: View {
    
    @StateObject private var viewModel = ProfileImageViewModel()
    let height, width, padding: CGFloat
    
    init(uid: String, height: CGFloat, width: CGFloat, padding: CGFloat) {
        self.height = height
        self.width = width
        self.padding = padding
        viewModel.loadImage(for: uid)
    }
    
    init(uid: String, size: CGFloat, padding: CGFloat) {
        self.height = size
        self.width = size
        self.padding = padding
        viewModel.loadImage(for: uid)
    }
    
    var body: some View {
        if let image = viewModel.image {
            Image(uiImage: image)
                .frame(width: width, height: height)
                .background(Color(.systemGroupedBackground))
                .clipShape(.circle)
                .padding([.vertical, .trailing], padding)
        } else {
            Image(systemName: "person.fill")
                .font(.system(size: 24, weight: .bold))
                .frame(width: width, height: height)
                .background(Color(.systemGroupedBackground))
                .foregroundStyle(Color(.charcoal))
                .clipShape(.circle)
                .padding([.vertical, .trailing], padding)
        }
    }
    
}
