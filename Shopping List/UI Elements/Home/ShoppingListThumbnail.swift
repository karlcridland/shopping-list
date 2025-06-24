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
    
    var onTapped: ((ShoppingList?) -> Void)?
    
    var body: some View {
        Button {
            onTapped?(shoppingList)
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
        if let items = shoppingList.items?.allObjects as? [ShoppingItem],
           let shoppers = shoppingList.shoppers?.allObjects as? [Shopper] {
            var results: [String] = []
            if (items.count > 0) {
                results.append("\(items.count) items")
            }
            if (shoppers.count > 0) {
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

#Preview {
    HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
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

#Preview {
    HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

