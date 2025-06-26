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
    
    @State private var showPreview = false
    @State private var previewItem: ShoppingItem?
    
    var onEdit: (ShoppingItem) -> Void
    
    @FetchRequest var items: FetchedResults<ShoppingItem>

    init(shoppingList: ShoppingList, onEdit: @escaping (ShoppingItem) -> Void) {
        self.shoppingList = shoppingList
        self.onEdit = onEdit
        
        _items = FetchRequest<ShoppingItem>(
            sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingItem.title, ascending: true)],
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "list == %@", shoppingList),
                NSPredicate(format: "basketDate == nil")
            ])
        )
    }

    var body: some View {
        if items.isEmpty {
            NoItemsDefault()
        } else {
            List {
                let categories = Array(Set(items.compactMap { $0.category })).sorted()
                
                ForEach(categories, id: \.self) { category in
                    let filtered = items.filter { $0.category == category }
                    Section(category.rawValue) {
                        ForEach(filtered) { item in
                            ShoppingItemThumbnail(item: item, onClick: {
                                preview(item)
                            })
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                SwipeButton(systemImage: "pencil", label: "Edit", tint: Color(.systemBlue)) {
                                    onEdit(item)
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                SwipeButton(systemImage: "checkmark.circle", label: "Mark Complete", tint: Color(.accent)) {
                                    markComplete(item)
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                SwipeButton(isDestructive: true, systemImage: "trash", label: "Delete") {
                                    deleteItem(item)
                                }
                            }
                        }
                    }
                }
            }
//            .sheet(isPresented: $showPreview) {
//                if let item = previewItem {
//                    ShoppingItemPreview(item: item)
//                }
//            }
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
    
    private func preview(_ item: ShoppingItem) {
        previewItem = item
        showPreview = true
    }
    
    private func markComplete(_ item: ShoppingItem) {
        print("marking complete")
        item.basketDate = Date()
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
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
        onEdit(item)
    }
    
}

struct SwipeButton: View {
    
    var isDestructive: Bool = false
    var systemImage: String
    var label: String
    var tint: Color?
    
    var onClick: () -> Void
    
    var body: some View {
        Button(role: isDestructive ? .destructive : .none) {
            onClick()
        } label: {
            Label(label, systemImage: systemImage)
                .fontWeight(.semibold)
        }
        .tint(isDestructive ? nil : tint)
    }
}
