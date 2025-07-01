//
//  ShoppingHistoryResultsView.swift
//  Shopping List
//
//  Created by Karl Cridland on 24/06/2025.
//

import SwiftUI
import CoreData

class ShoppingHistoryResultsViewModel: ObservableObject {
    @Published var items: [ShoppingItem]

    init(items: [ShoppingItem]) {
        self.items = items
    }

    var categories: [Category] {
        Array(Set(items.compactMap { $0.category })).sorted()
    }
    
    func undoItem(_ item: ShoppingItem, _ context: NSManagedObjectContext) {
        item.basketDate = nil
        item.list?.save()
        items.removeAll { $0.id == item.id }
        try? context.save()
    }
    
}


struct ShoppingHistoryResultsView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel: ShoppingHistoryResultsViewModel

    init(items: [ShoppingItem]) {
        _viewModel = StateObject(wrappedValue: ShoppingHistoryResultsViewModel(items: items))
    }

    var body: some View {
        let groupedItems = Dictionary(grouping: viewModel.items, by: { $0.category })
        let sortedCategories = viewModel.categories

        return List {
            ForEach(sortedCategories, id: \.self) { category in
                if let filteredItems = groupedItems[category] {
                    Section(category.rawValue) {
                        ForEach(filteredItems) { item in
                            ShoppingItemThumbnail(item: item)
                                .disabled(true)
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    SwipeButton(
                                        systemImage: "arrow.uturn.left.circle",
                                        label: "Undo",
                                        tint: Color(.accent)
                                    ) {
                                        viewModel.undoItem(item, context)
                                        if viewModel.items.isEmpty {
                                            dismiss()
                                        }
                                    }
                                }
                        }
                    }
                }
            }
        }
    }

}
