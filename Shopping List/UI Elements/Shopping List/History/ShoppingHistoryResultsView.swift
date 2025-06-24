//
//  ShoppingHistoryResultsView.swift
//  Shopping List
//
//  Created by Karl Cridland on 24/06/2025.
//

import SwiftUI

struct ShoppingHistoryResultsView: View {
    
    @State var items: [ShoppingItem]
    
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
//                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                            SwipeButton(systemImage: "arrow.uturn.left.circle", label: "Undo", tint: Color(.accent)) {
//                                markComplete(item)
//                            }
//                        }
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
