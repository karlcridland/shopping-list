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
    
    @State private var showItems: Bool = true
    @State private var showHistory: Bool = false
    @State private var showSettings: Bool = false
    @State private var showNewItem: Bool = false
    @State private var isSharing: Bool = false
    
    @FocusState private var focusTitleEdit: Bool
    
    @State private var editingItem: ShoppingItem?

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    ShoppingListHeader(title: $shoppingList.title, addItem: {
                        editingItem = nil
                        showNewItem = true
                        resetDisplay()
                        self.showItems = true
                    }, shareList: {
                        isSharing = true
                    })
                    HStack(spacing: 10) {
                        ShoppingListMenuButton(title: "Items", displaying: $showItems, onClick: resetDisplay)
                        ShoppingListMenuButton(title: "History", displaying: $showHistory, onClick: resetDisplay)
                        ShoppingListMenuButton(title: "Settings", displaying: $showSettings, onClick: resetDisplay)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .onAppear {
                    if shoppingList.title?.isEmpty ?? true {
                        resetDisplay()
                        showSettings = true
                        focusTitleEdit = true
                    }
                }
                if (showItems) {
                    ShoppingListItemsView(shoppingList: shoppingList, onEdit: { item in
                        editingItem = item
                        showNewItem = true
                    })
                }
                if (showHistory) {
                    ShoppingListHistoryView(shoppingList: shoppingList)
                }
                if (showSettings) {
                    ShoppingListSettingsView(shoppingList: shoppingList, focusTitleEdit: $focusTitleEdit)
                }
                    
            }
            .toolbar(removing: nil)
            .navigationDestination(isPresented: $showNewItem) {
                ShoppingItemView(editingItem: editingItem) { item in
                    do {
                        shoppingList.update(item, context: context)
                        try context.save()
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .sheet(isPresented: $isSharing) {
                ShareSheet(activityItems: [shoppingList.shareText])
            }
        }
    }
    
    func resetDisplay() {
        showItems = false
        showHistory = false
        showSettings = false
    }

}

#Preview {
    let shoppingList: ShoppingList = ShoppingList(context: PersistenceController.preview.container.viewContext)
    ShoppingListView(shoppingList: shoppingList).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
