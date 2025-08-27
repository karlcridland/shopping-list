//
//  ContentView.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: HomeViewModel

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(context: context))
    }

    var body: some View {
        List {
            ForEach(viewModel.shoppingLists, id: \.id) { shoppingList in
                ShoppingListThumbnailView(shoppingList: shoppingList, viewModel.accessibilityPosition(shoppingList)) {
                    viewModel.selectedList = shoppingList
                    viewModel.showShoppingList = true
                }
                .contentShape(Rectangle())
            }
            .onDelete { indexSet in
                withAnimation {
                    viewModel.deleteLists(at: indexSet)
                }
            }
            
            NewShoppingListThumbnail(viewModel.listSize) {
                viewModel.createList()
            }
        }
        .onAppear {
            viewModel.fetchLists()
        }
        .listRowSpacing(10)
        .contentMargins(.top, 12)
        .navigationDestination(isPresented: $viewModel.showShoppingList) {
            if let shoppingList = viewModel.selectedList {
                ShoppingListView(shoppingList: shoppingList)
            }
        }
    }
    
}
