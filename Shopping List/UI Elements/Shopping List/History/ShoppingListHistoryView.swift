//
//  ShoppingListHistoryView.swift
//  Shopping List
//
//  Created by Karl Cridland on 23/06/2025.
//

import SwiftUI

struct ShoppingListHistoryView: View {
    
    @ObservedObject var shoppingList: ShoppingList
    
    @FetchRequest var items: FetchedResults<ShoppingItem>
    
    @State private var showingResults: Bool = false
    @State private var results: [ShoppingItem] = []

    init(shoppingList: ShoppingList) {
        self.shoppingList = shoppingList
        
        _items = FetchRequest<ShoppingItem>(
            sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingItem.basketDate, ascending: true)],
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "list == %@", shoppingList),
                NSPredicate(format: "basketDate != nil")
            ])
        )
    }
    
    var body: some View {
        if items.isEmpty {
            NoHistoryDefault()
        } else {
            List {
                ForEach(shoppingList.completedItemsGroupedByDate, id: \.0) { group, items in
                    Section(group.label) {
                        if let title = items.first?.dateOfPurchase {
                            Button {
                                self.results = items
                                showingResults = true
                            } label: {
                                Text(title)
                            }
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $showingResults) {
                ShoppingHistoryResultsView(items: $results)
            }
        }
    }
    
}
