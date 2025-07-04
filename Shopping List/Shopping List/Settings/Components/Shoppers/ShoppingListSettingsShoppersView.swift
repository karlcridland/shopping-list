//
//  ShoppingListSettingsShoppersView.swift
//  Shopping List
//
//  Created by Karl Cridland on 02/07/2025.
//

import SwiftUI

struct ShoppingListSettingsShoppersView: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var viewModel: ShoppingListSettingsShoppersViewModel
    @Binding var showShoppingList: Bool
    
    let font: Font
    
    init(shoppingList: ShoppingList, showShoppingList: Binding<Bool>, font: Font) {
        self.font = font
        _showShoppingList = showShoppingList
        _viewModel = StateObject(wrappedValue: ShoppingListSettingsShoppersViewModel(shoppingList: shoppingList))
    }

    
    var body: some View {
        Section {
            ShopperSettingsThumbnailView(viewModel.shoppingList.ownerShopper, true, font)
            ForEach(viewModel.shoppers) { shopper in
                ShopperSettingsThumbnailView(shopper, false, font)
                    .swipeActions(allowsFullSwipe: true) {
                        SwipeButton(isDestructive: true, systemImage: "person.crop.circle.badge.minus", label: "Remove") {
                            self.viewModel.removeUser(shopper.uid, context)
                        }
                    }
            }
            Button {
                showShoppingList = true
            } label: {
                Text("Add Shopper")
                    .font(self.font)
            }
        } header: {
            Text("Shoppers")
        } footer: {
            Text("You can only add friends to the shopping list.")
                .font(.footnote)
                .fontWeight(.regular)
                .multilineTextAlignment(.leading)
        }.onAppear {
            print("did appear")
            viewModel.fetchShoppers()
        }
    }
}

