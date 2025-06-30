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
                        let grouped = groupItemsByDay(items)
                        ForEach(grouped, id: \.key) { day, dayItems in
                            Button {
                                self.results = dayItems
                                self.showingResults = true
                            } label: {
                                if let date = dayItems.first?.dateOfPurchase {
                                    Text(date)
                                }
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
    
    func groupItemsByDay(_ items: [ShoppingItem]) -> [(key: String, value: [ShoppingItem])] {
        Dictionary(grouping: items) { String($0.dayOfPurchase) }
            .sorted { $0.key > $1.key }
    }
    
}
