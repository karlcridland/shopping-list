//
//  ShoppingListItemsView.swift
//  Shopping List
//
//  Created by Karl Cridland on 23/06/2025.
//

import SwiftUI

struct ShoppingListItemsView: View {
    @Environment(\.managedObjectContext) private var context
    
    @ObservedObject var shoppingList: ShoppingList
    
    var onEdit: (ShoppingItem) -> Void

    var body: some View {
        let items: [ShoppingItem] = (shoppingList.items?.allObjects as? [ShoppingItem]) ?? []

        if items.isEmpty {
            NoItemsDefault()
        } else {
            List {
                let categories = Array(Set(items.compactMap { $0.category })).sorted()
                
                ForEach(categories, id: \.self) { category in
                    let filtered = items.filter { $0.category == category }
                    Section(category.rawValue) {
                        ForEach(filtered, id: \.category) { item in
                            ShoppingItemThumbnail(item: item, onClick: { item in
                                onEdit(item)
                            })
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteItem(item)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                        .fontWeight(.semibold)
                                }
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                } label: {
                                    Label("Edit", systemImage: "checkmark.circle")
                                        .fontWeight(.semibold)
                                }
                                .tint(Color(.accent))
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func deleteItem(_ item: ShoppingItem) {
        item.list = nil
        do {
            try context.save()
        } catch {
            fatalError("Unresolved error \(error as NSError)")
        }
    }
    
    private func removeItems(at offsets: IndexSet, from filteredItems: [ShoppingItem]) {
        withAnimation {
            for index in offsets {
                context.delete(filteredItems[index])
            }
            do {
                try context.save()
            } catch {
                fatalError("Unresolved error \(error as NSError)")
            }
        }
    }
    
    private func editItem(_ item: ShoppingItem) {
        print(item.title ?? "")
    }
}
