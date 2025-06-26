//
//  ShoppingListThumbnail.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import CoreData

struct ShoppingListThumbnail: View {
    
    @ObservedObject var shoppingList: ShoppingList
    @FetchRequest var items: FetchedResults<ShoppingItem>
    
    var onTapped: () -> Void

    init(shoppingList: ShoppingList, onTapped: @escaping () -> Void) {
        self.shoppingList = shoppingList
        self.onTapped = onTapped
        
        _items = FetchRequest<ShoppingItem>(
            sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingItem.title, ascending: true)],
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "list == %@", shoppingList),
                NSPredicate(format: "basketDate == nil")
            ])
        )
    }
    
    var body: some View {
        Button {
            onTapped()
        } label: {
            HStack {
                VStack (alignment: .leading, spacing: 5, content: {
                    Text(self.title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(.charcoal))
                    Text(self.subtitle)
                        .font(.caption)
                        .foregroundColor(Color(.charcoal).opacity(0.8))
                })
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(.charcoal).opacity(0.6))
            }
        }
        .frame(minHeight: 60)
    }
    
    var title: String {
        let t: String? = self.shoppingList.title
        return t == "" ? "Shopping List" : t ?? "Shopping List"
    }
    
    var subtitle: String {
        if let shoppers = shoppingList.shoppers?.allObjects as? [Shopper] {
            var results: [String] = []
            if (items.count > 0) {
                results.append("\(items.count) item\(items.count == 1 ? "" : "s")")
            }
            if (shoppers.count > 1) {
                results.append("\(shoppers.count) people")
            }
            if (results.count > 0) {
                return results.joined(separator: ", ")
            }
            return "Tap to add items to your shopping list"
        }
        return "Tap to create a new list"
    }
    
}

struct NewShoppingListThumbnail: View {
    
    var onCreate: (() -> Void)?
    
    var body: some View {
        Button {
            onCreate?()
        } label: {
            HStack {
                VStack (alignment: .leading, spacing: 5, content: {
                    Text(self.title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(.charcoal))
                    Text(self.subtitle)
                        .font(.caption)
                        .foregroundColor(Color(.charcoal).opacity(0.8))
                })
                Spacer()
                Image(systemName: "plus.circle")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(.charcoal).opacity(0.6))
            }
        }
        .frame(minHeight: 60)
    }
    
    var title: String {
        "Create new shopping list"
    }
    
    var subtitle: String {
        return "Tap to create a new list"
    }
    
}
