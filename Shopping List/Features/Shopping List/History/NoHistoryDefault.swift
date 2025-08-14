//
//  NoHistoryDefault.swift
//  Shopping List
//
//  Created by Karl Cridland on 23/06/2025.
//

import SwiftUI

struct NoHistoryDefault: View {
    
    private let iconColor: Color = Color(.charcoal).opacity(0.6)
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 24) {
                Text("Mark an item as complete to view your history.")
                    .frame(maxWidth: 300)
                    .foregroundStyle(iconColor)
                    .font(.system(size: 14, weight: .semibold))
                    .multilineTextAlignment(.center)

                ShoppingListAddItem(newBackground: .clear, newFill: .clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.clear, lineWidth: 2)
                )
                .disabled(true)
            }
            .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
    
}
