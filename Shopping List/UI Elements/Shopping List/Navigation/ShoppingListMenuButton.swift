//
//  ShoppingListMenuButton.swift
//  Shopping List
//
//  Created by Karl Cridland on 23/06/2025.
//

import SwiftUI

struct ShoppingListMenuButton: View {
    
    @State var title: String
    @Binding var displaying: Bool
    
    @State var onClick: (() -> Void)
    
    var body: some View {
        Button {
            onClick()
            displaying = true
        } label: {
            withAnimation {
                Text(title.lowercased())
                    .font(.title3)
                    .fontWeight(.semibold)
                    .underline(displaying)
                    .padding(5)
                    .foregroundColor(displaying ? .accent : .charcoal.opacity(0.7))
            }
        }
    }
    
}

#Preview {
    let shoppingList: ShoppingList = ShoppingList(context: PersistenceController.preview.container.viewContext)
    ShoppingListView(shoppingList: shoppingList).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
