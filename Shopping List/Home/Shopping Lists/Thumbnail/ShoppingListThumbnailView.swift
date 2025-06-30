//
//  ShoppingListThumbnailView.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import CoreData

struct ShoppingListThumbnailView: View {
    
    @StateObject private var viewModel: ShoppingListThumbnailViewModel

    var onTapped: () -> Void

    init(shoppingList: ShoppingList, context: NSManagedObjectContext, onTapped: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: ShoppingListThumbnailViewModel(shoppingList: shoppingList, context: context))
        self.onTapped = onTapped
    }

    var body: some View {
        Button {
            onTapped()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(.charcoal))
                    Text(viewModel.subtitle)
                        .font(.caption)
                        .foregroundColor(Color(.charcoal).opacity(0.8))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(.charcoal).opacity(0.6))
            }
        }
        .frame(minHeight: 60)
    }
    
}
