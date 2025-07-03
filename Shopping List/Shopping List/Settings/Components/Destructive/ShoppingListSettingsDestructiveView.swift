//
//  ShoppingListSettingsDestructiveView.swift
//  Shopping List
//
//  Created by Karl Cridland on 02/07/2025.
//

import SwiftUI

struct ShoppingListSettingsDestructiveView: View {
    
    let ownedByUser: Bool
    let font: Font
    
    var body: some View {
        Section {
            Button {
                
            } label: {
                VStack(alignment: .leading) {
                    Text(ownedByUser ? "Delete List" : "Remove yourself from this list")
                        .font(self.font)
                        .multilineTextAlignment(.leading)
                }
            }
            .foregroundStyle(Color(.systemRed))
        } header: {
            Text("Remove List")
        } footer: {
            Text(ownedByUser ? "This is permanent and can't be undone." : "You can be added back later")
                .font(.footnote)
                .fontWeight(.regular)
                .multilineTextAlignment(.leading)
        }
    }
    
}
