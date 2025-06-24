//
//  ShoppingListSettingsView.swift
//  Shopping List
//
//  Created by Karl Cridland on 23/06/2025.
//

import SwiftUI

struct ShoppingListSettingsView: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @ObservedObject var shoppingList: ShoppingList
    
    @FocusState.Binding var focusTitleEdit: Bool

    var body: some View {
        List {
            Section("Title") {
                TextField("e.g. The Weekly Shop", text: title)
                    .focused($focusTitleEdit)
                    .onChange(of: title.wrappedValue) { (_, value) in
                        self.save(title: value)
                    }
            }
//            Section("Shoppers") {
//                let shoppers: [Shopper] = shoppingList.shoppers?.allObjects as? [Shopper] ?? []
//                List {
//                    ForEach(shoppers) { shopper in
//                        Text(shopper.name ?? "")
//                    }
//                }
//            }
        }
    }

    private var title: Binding<String> {
        Binding<String>(
            get: { shoppingList.title ?? "" },
            set: { shoppingList.title = $0 }
        )
    }
    
    private func save(title: String) {
        do {
            shoppingList.title = title.count > 0 ? title : nil
            try context.save()
        } catch {
            print("Error saving:", error.localizedDescription)
        }
    }
    
}

#Preview {
    let shoppingList: ShoppingList = ShoppingList(context: PersistenceController.preview.container.viewContext)
    ShoppingListView(shoppingList: shoppingList).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
