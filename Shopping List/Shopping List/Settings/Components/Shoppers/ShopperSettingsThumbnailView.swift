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
    
    init(_ shopper: Shopper?, _ isOwner: Bool, _ font: Font) {
        self.shopper = shopper
        self.isOwner = isOwner
        self.font = font
    }
    
    var body: some View {
        if let shopper = self.shopper {
            HStack(spacing: 0) {
                ProfileImageView(uid: shopper.uid ?? "", size: 40, padding: 10)
                VStack(alignment: .leading) {
                    Text(shopper.name.full)
                        .font(font)
                    if (isOwner) {
                        Text("Owner of list")
                    }
                }
            }
        }
    }
    
}
