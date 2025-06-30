//
//  ShoppingItemPreview.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import CoreData

struct ShoppingItemPreview: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) var dismiss
    
    var item: ShoppingItem

    var body: some View {
        Text("test")
    }

}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let item = ShoppingItem(context: context)
    item.title = "Test Item"
    
    return ShoppingItemPreview(item: item)
        .environment(\.managedObjectContext, context)
}
