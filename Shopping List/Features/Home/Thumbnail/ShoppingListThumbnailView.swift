//
//  ShoppingListThumbnailView.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import CoreData

struct ShoppingListThumbnailView: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var viewModel: ShoppingListThumbnailViewModel
    @FetchRequest private var items: FetchedResults<ShoppingItem>
    @FetchRequest private var shoppers: FetchedResults<Shopper>

    var onTapped: () -> Void

    init(shoppingList: ShoppingList, _ position: AccessibilityPosition, onTapped: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: ShoppingListThumbnailViewModel(shoppingList: shoppingList, position))
        self.onTapped = onTapped
        _items = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingItem.title, ascending: true)],
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "list == %@", shoppingList),
                NSPredicate(format: "basketDate == nil")
            ])
        )
        _shoppers = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Shopper.uid, ascending: true)],
            predicate: NSPredicate(format: "ANY lists == %@", shoppingList)
        )
    }

    var body: some View {
        Button {
            onTapped()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(.charcoal))
                    Text(viewModel.getSubtitle(items, shoppers))
                        .font(.caption)
                        .foregroundColor(Color(.charcoal).opacity(0.8))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(.charcoal).opacity(0.6))
            }
        }
        .frame(minHeight: 60)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(viewModel.description)
    }
    
}
