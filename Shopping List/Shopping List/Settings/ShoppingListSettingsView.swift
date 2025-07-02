//
//  ShoppingListSettingsView.swift
//  Shopping List
//
//  Created by Karl Cridland on 23/06/2025.
//

import SwiftUI

struct ShoppingListSettingsView: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @ObservedObject var shoppingList: ShoppingList
    
    @FocusState.Binding var focusTitleEdit: Bool
    
    let delay = KeyboardDelay()

    var body: some View {
        List {
            Section("Title") {
                TextField("e.g. The Weekly Shop", text: title)
                    .focused($focusTitleEdit)
                    .submitLabel(.done)
                    .onChange(of: title.wrappedValue) { (_, value) in
                        shoppingList.title = value.count > 0 ? value : nil
                        self.delay.onType {
                            Task {
                                self.save(title: value.cleaned)
                            }
                        }
                    }
            }
            Section("Shoppers") {
                Text(shoppingList.ownerShopper?.name.full ?? "No owner")
                ForEach(shoppingList.shoppersArray) { shopper in
                    Text(shopper.name.full)
                }
                Button {
                    
                } label: {
                    Text("Add shopper")
                }
            }
        }
    }

    private var title: Binding<String> {
        Binding<String>(
            get: { shoppingList.title ?? "" },
            set: { shoppingList.title = $0 }
        )
    }
    
    @MainActor
    private func save(title: String) {
        do {
            shoppingList.save()
            try context.save()
        } catch {
            print("Error saving:", error.localizedDescription)
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
