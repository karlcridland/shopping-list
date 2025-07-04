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
    @StateObject private var viewModel: ShoppingListItemsViewModel

    var onEdit: (ShoppingItem) -> Void

    @FetchRequest private var items: FetchedResults<ShoppingItem>

    init(shoppingList: ShoppingList, onEdit: @escaping (ShoppingItem) -> Void) {
        self.shoppingList = shoppingList
        self.onEdit = onEdit
        _viewModel = StateObject(wrappedValue: ShoppingListItemsViewModel(context: shoppingList.managedObjectContext!, shoppingList: shoppingList))

        _items = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingItem.title, ascending: true)],
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "list == %@", shoppingList),
                NSPredicate(format: "basketDate == nil")
            ])
        )
    }

    var body: some View {
        let groupedItems = Dictionary(grouping: items, by: { $0.category })
        let categories = groupedItems.keys.sorted()

        ZStack {
            if items.isEmpty {
                NoItemsDefault()
            } else {
                List {
                    ForEach(categories, id: \.self) { category in
                        let filteredItems = groupedItems[category] ?? []
                        ShoppingCategorySection(
                            category: category,
                            items: filteredItems,
                            onEdit: onEdit,
                            onComplete: viewModel.markComplete,
                            onDelete: viewModel.deleteItem,
                            onPreview: viewModel.preview
                        )
                    }
                }
            }
        }
    }
}

struct ShoppingCategorySection: View {
    let category: Category
    let items: [ShoppingItem]
    let onEdit: (ShoppingItem) -> Void
    let onComplete: (ShoppingItem) -> Void
    let onDelete: (ShoppingItem) -> Void
    let onPreview: (ShoppingItem) -> Void

    var body: some View {
        Section(category.rawValue) {
            ForEach(items) { item in
                ShoppingItemThumbnail(item: item, onClick: {
                    onPreview(item)
                })
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    SwipeButton(systemImage: "pencil", label: "Edit", tint: Color(.systemBlue)) {
                        onEdit(item)
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    SwipeButton(systemImage: "checkmark.circle", label: "Mark Complete", tint: Color(.accent)) {
                        onComplete(item)
                    }
                    SwipeButton(isDestructive: true, systemImage: "trash", label: "Delete") {
                        onDelete(item)
                    }
                }
            }
        }
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
