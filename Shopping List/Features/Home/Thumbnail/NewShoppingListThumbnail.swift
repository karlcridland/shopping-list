//
//  NewShoppingListThumbnail.swift
//  Shopping List
//
//  Created by Karl Cridland on 30/06/2025.
//

import SwiftUI

struct NewShoppingListThumbnail: View {
    
    let size: Int
    var onCreate: () -> Void
    
    init(_ size: Int, _ onCreate: @escaping () -> Void) {
        self.size = size
        self.onCreate = onCreate
    }
    
    var body: some View {
        Button {
            onCreate()
        } label: {
            HStack {
                VStack (alignment: .leading, spacing: 5, content: {
                    Text(self.title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(.charcoal))
                    Text(self.subtitle)
                        .font(.caption)
                        .foregroundColor(Color(.charcoal).opacity(0.8))
                })
                Spacer()
                Image(systemName: "plus.circle")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(.charcoal).opacity(0.6))
            }
        }
        .frame(minHeight: 60)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Create new shopping list, Button, \(size) of \(size)")
    }
    
    var title: String {
        "Create new shopping list"
    }
    
    var subtitle: String {
        return "Tap to create a new list"
    }
    
}
