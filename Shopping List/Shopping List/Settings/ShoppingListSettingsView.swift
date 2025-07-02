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
    
    let font: Font = .system(size: 16, weight: .medium)
    
    init(shoppingList: ShoppingList, focusTitleEdit: FocusState<Bool>.Binding) {
        _viewModel = StateObject(wrappedValue: ShoppingListSettingsViewModel(shoppingList: shoppingList))
        _focusTitleEdit = focusTitleEdit
    }

    var body: some View {
        List {
            Section("Title") {
                TextField("e.g. The Weekly Shop", text: viewModel.title)
                    .font(self.font)
                    .focused($focusTitleEdit)
                    .submitLabel(.done)
                    .onChange(of: viewModel.title.wrappedValue) { (_, value) in
                        viewModel.shoppingList.title = value.count > 0 ? value : nil
                        viewModel.delay.onType {
                            Task {
                                viewModel.save(title: value.cleaned, context)
                            }
                        }
                    }
            }
            Section("Shoppers") {
                Text(viewModel.shoppingList.ownerShopper?.name.full ?? "No owner")
                    .font(self.font)
                ForEach(viewModel.shoppingList.shoppersArray) { shopper in
                    Text(shopper.name.full)
                        .font(self.font)
                }
                Button {
                    
                } label: {
                    Text("Add shopper")
                        .font(self.font)
                }
            }
            Section {
                Button {
                    
                } label: {
                    VStack(alignment: .leading) {
                        Text(viewModel.isOwnedByUser ? "Delete List" : "Remove yourself from this list")
                            .font(self.font)
                            .multilineTextAlignment(.leading)
                    }
                }
                .foregroundStyle(Color(.systemRed))
            } header: {
                Text("Remove List")
            } footer: {
                Text(viewModel.isOwnedByUser ? "This is permanent and can't be undone." : "You can be added back later")
                    .font(.footnote)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
            }
            
        }
    }
    
}

extension ShoppingList {
    var shoppersArray: [Shopper] {
        (shoppers?.allObjects as? [Shopper]) ?? []
    }
}

class KeyboardDelay {
    
    var clickCount: Int = 0
    var time: TimeInterval
    
    init(_ time: TimeInterval = 0.4) {
        self.time = time
    }
    
    func onType(onValid: @escaping () -> Void) {
        clickCount += 1
        let localCount = clickCount
        Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in
            if (self.clickCount == localCount) {
                onValid()
            }
        }
    }
    
}
