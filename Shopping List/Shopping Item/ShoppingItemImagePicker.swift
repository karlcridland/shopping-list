//
//  ShoppingItemImagePicker.swift
//  Shopping List
//
//  Created by Karl Cridland on 24/06/2025.
//

import SwiftUI

struct ShoppingItemImagePicker: View {
    
    @State var image: UIImage?
    
    var onUpload: (UIImage) -> Void
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Image(systemName: "camera.fill")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color(.systemGroupedBackground))
                .padding(24)
                .padding(.leading, 2)
                .background(Color(.charcoal).opacity(0.7))
                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .bottomLeft]))
        }
        .padding(.bottom, 20)
    }
    
    private struct RoundedCorner: Shape {
        var radius: CGFloat
        var corners: UIRectCorner

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }
    
}
