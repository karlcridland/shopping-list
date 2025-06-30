//
//  ShoppingItemThumbnail.swift
//  Shopping List
//
//  Created by Karl Cridland on 23/06/2025.
//

import SwiftUI
import UIKit

struct ShoppingItemThumbnail: View {
    
    @State var item: ShoppingItem
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(item.title ?? "")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.charcoal)
                    if let description = item.describe, !description.isEmpty {
                        Text(description)
                            .font(.subheadline)
                            .foregroundStyle(.charcoal.opacity(0.8))
                            .fontWeight(.semibold)
                    }
                }
                if let image = item.image {
                    Image(uiImage: image)
                        .frame(width: 100, height: 100)
                        .clipShape(.circle)
                }
            }
        }
        .padding(5)
    }
    
}

extension ShoppingItem {
    
    var image: UIImage? {
        return nil
    }
    
}
