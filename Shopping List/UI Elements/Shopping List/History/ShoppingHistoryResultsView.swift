//
//  ShoppingHistoryResultsView.swift
//  Shopping List
//
//  Created by Karl Cridland on 24/06/2025.
//

import SwiftUI

struct ShoppingHistoryResultsView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @Binding var items: [ShoppingItem]
    
    var body: some View {
        List {
            let categories = Array(Set(items.compactMap { $0.category })).sorted()
            
            ForEach(categories, id: \.self) { category in
                let filtered = items.filter { $0.category == category }
                Section(category.rawValue) {
                    ForEach(filtered) { item in
                        ShoppingItemThumbnail(item: item, onClick: {
//                            preview(item)
                        })
                        .disabled(true)
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            SwipeButton(systemImage: "arrow.uturn.left.circle", label: "Undo", tint: Color(.accent)) {
                                item.basketDate = nil
                                item.list?.save()
                                items.removeAll { $0.id == item.id }
                                try? context.save()
                                if (items.count == 0) {
                                    dismiss()
                                }
                            }
                        }
//                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                            SwipeButton(isDestructive: true, systemImage: "trash", label: "Delete") {
//                                deleteItem(item)
//                            }
//                        }
                    }
                }
            }
        }
        .task {
            print(items.count)
        }
    }
    
}
