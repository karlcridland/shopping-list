//
//  ShoppingListAddItem.swift
//  Shopping List
//
//  Created by Karl Cridland on 23/06/2025.
//

import SwiftUI

struct ShoppingListAddItem: View, ShoppingListButtonStyle {
    
    @State var newBackground: Color?
    @State var newFill: Color?
    var onClick: (() -> Void)?
    
    var body: some View {
        Button {
            onClick?()
        } label: {
            HStack {
                Image(systemName: "bag")
                    .fontWeight(thickness)
                    .foregroundStyle(newFill ?? foreground)
                Image(systemName: "plus")
                    .fontWeight(thickness)
                    .foregroundStyle(newFill ?? foreground)
            }
        }
        .frame(width: 50)
        .padding(padding)
        .background(newBackground ?? background)
        .cornerRadius(cornerRadius)
        .shadow(color: .black.opacity(0.1), radius: 4)
    }
    
}

#Preview {
    let shoppingList: ShoppingList = ShoppingList(context: PersistenceController.preview.container.viewContext)
    ShoppingListView(shoppingList: shoppingList).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}



