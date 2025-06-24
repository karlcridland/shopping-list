//
//  ShoppingListHeader.swift
//  Shopping List
//
//  Created by Karl Cridland on 23/06/2025.
//

import SwiftUI

struct ShoppingListHeader: View {
    
    @Binding var title: String?
    
    var addItem: () -> Void
    var shareList: () -> Void

    var body: some View {
        HStack {
            ShoppingListShare(onClick: shareList)

            Spacer()

            Text(title == "" ? "Shopping List" : title ?? "Shopping List")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.charcoal)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .layoutPriority(1)

            Spacer()
            
            ShoppingListAddItem(onClick: addItem)
        }
    }
}

#Preview {
    let shoppingList: ShoppingList = ShoppingList(context: PersistenceController.preview.container.viewContext)
    ShoppingListView(shoppingList: shoppingList).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
