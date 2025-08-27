//
//  ShopperSettingsThumbnailView.swift
//  Shopping List
//
//  Created by Karl Cridland on 02/07/2025.
//

import SwiftUI

struct ShopperSettingsThumbnailView: View {
    
    let shopper: Shopper?
    let isOwner: Bool
    let font: Font
    let position: AccessibilityPosition
    @State var image: UIImage?
    
    init(_ shopper: Shopper?, _ isOwner: Bool, _ font: Font, _ position: AccessibilityPosition) {
        self.shopper = shopper
        self.isOwner = isOwner
        self.font = font
        self.position = position
    }
    
    var body: some View {
        if let shopper = self.shopper {
            HStack(spacing: 0) {
                ProfileImageView(uid: shopper.uid ?? "", size: 40, padding: 10, image: $image)
                VStack(alignment: .leading) {
                    Text(shopper.name.full)
                        .font(font)
                    if (isOwner) {
                        Text("Owner of list")
                    }
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityLabel ?? "")
        }
    }
    
    var accessibilityLabel: String? {
        var results: [String?] = [shopper?.name.full]
        if (isOwner) {
            results.append("Owner of list")
        }
        return results.compactMap({$0}).joined(separator: ", ")
    }
    
}
