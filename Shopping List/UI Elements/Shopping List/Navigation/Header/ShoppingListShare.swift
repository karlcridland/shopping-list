//
//  ShoppingListShare.swift
//  Shopping List
//
//  Created by Karl Cridland on 23/06/2025.
//

import SwiftUI

struct ShoppingListShare: View, ShoppingListButtonStyle {
    
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .fontWeight(thickness)
                    .foregroundStyle(foreground)
            }
        }
        .frame(width: 22)
        .padding(padding)
        .padding(.horizontal, 2)
        .background(background)
        .cornerRadius(cornerRadius)
        .shadow(color: .black.opacity(0.1), radius: 4)
        .padding(.leading, 24)
    }
    
}

#Preview {
    let shoppingList: ShoppingList = ShoppingList(context: PersistenceController.preview.container.viewContext)
    ShoppingListView(shoppingList: shoppingList).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

