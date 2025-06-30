//
//  NoItemsDefault.swift
//  Shopping List
//
//  Created by Karl Cridland on 23/06/2025.
//

import SwiftUI

struct NoItemsDefault: View {
    
    private let iconColor: Color = Color(.charcoal).opacity(0.6)
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 24) {
                Text("You have no items in your shopping list,\nadd an item by tapping this icon:")
                    .frame(maxWidth: 300)
                    .foregroundStyle(iconColor)
                    .font(.system(size: 14, weight: .semibold))
                    .multilineTextAlignment(.center)

                ShoppingListAddItem(newBackground: .clear, newFill: iconColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(iconColor, lineWidth: 2)
                )
                .disabled(true)
            }
            .padding()
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
    
}
