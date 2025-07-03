//
//  ShoppingListSettingsView.swift
//  Shopping List
//
//  Created by Karl Cridland on 23/06/2025.
//

import SwiftUI

struct ShoppingListSettingsView: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var viewModel: ShoppingListSettingsViewModel
    
    @FocusState.Binding var focusTitleEdit: Bool
    
    init(shoppingList: ShoppingList, focusTitleEdit: FocusState<Bool>.Binding) {
        _viewModel = StateObject(wrappedValue: ShoppingListSettingsViewModel(shoppingList: shoppingList))
        _focusTitleEdit = focusTitleEdit
        shoppingList.setUniqueShoppers()
    }
    
    var body: some View {
        List {
            Section("Title") {
                TextField("e.g. The Weekly Shop", text: viewModel.title)
                    .font(viewModel.font)
                    .focused($focusTitleEdit)
                    .submitLabel(.done)
                    .onChange(of: viewModel.title.wrappedValue) { (_, value) in
                        viewModel.shoppingList.title = value.count > 0 ? value : nil
                        viewModel.delay.onType {
                            viewModel.save(title: value.cleaned, context)
                        }
                    }
            }
            
            ShoppingListSettingsShoppersView(shoppingList: viewModel.shoppingList, showShoppingList: $viewModel.showShoppingList, font: viewModel.font)
            ShoppingListSettingsDestructiveView(ownedByUser: viewModel.isOwnedByUser, font: viewModel.font)
            
            
        }
        .sheet(isPresented: $viewModel.showShoppingList) {
            if let shoppers = viewModel.shoppingList.shopperData as? [String] {
                ShoppingListShoppersView(shoppers, context) { uid in
                    self.viewModel.addShopper(uid, context)
                }
                .onAppear {
                    print(shoppers)
                }
            }
        }
    }
    
}
