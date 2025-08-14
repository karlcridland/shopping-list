//
//  ShoppingListView.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import CoreData

struct ShoppingListView: View {
    
    @Environment(\.managedObjectContext) private var context

    @ObservedObject var shoppingList: ShoppingList
    @StateObject private var viewModel: ShoppingListViewModel
    
    @FocusState private var focusTitleEdit: Bool

    init(shoppingList: ShoppingList) {
        self.shoppingList = shoppingList
        _viewModel = StateObject(wrappedValue: ShoppingListViewModel(shoppingList: shoppingList, context: shoppingList.managedObjectContext!))
    }

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    ShoppingListHeaderView(
                        title: $shoppingList.title,
                        addItem: { viewModel.startNewItemEdit() },
                        shareList: { viewModel.isSharing = true }
                    )

                    HStack(spacing: 10) {
                        ShoppingListMenuButton(title: "Items", displaying: $viewModel.showItems, onClick: viewModel.resetDisplay)
                        ShoppingListMenuButton(title: "History", displaying: $viewModel.showHistory, onClick: viewModel.resetDisplay)
                        ShoppingListMenuButton(title: "Settings", displaying: $viewModel.showSettings, onClick: viewModel.resetDisplay)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .onAppear {
                    viewModel.onAppear()
                }

                if viewModel.showItems {
                    ShoppingListItemsView(shoppingList: shoppingList, onEdit: { item in
                        viewModel.startNewItemEdit(existingItem: item)
                    })
                }

                if viewModel.showHistory {
                    ShoppingListHistoryView(shoppingList: shoppingList)
                }

                if viewModel.showSettings {
                    ShoppingListSettingsView(shoppingList: shoppingList, focusTitleEdit: $focusTitleEdit)
                }
            }
            .navigationDestination(isPresented: $viewModel.showNewItem) {
                ShoppingItemView(editingItem: viewModel.editingItem) { item in
                    viewModel.saveItem(item)
                }
            }
            .sheet(isPresented: $viewModel.isSharing) {
                ShareSheet(activityItems: [shoppingList.shareText])
            }
        }
    }
}
