//
//  ShoppingListShoppersView.swift
//  Shopping List
//
//  Created by Karl Cridland on 02/07/2025.
//

import SwiftUI
import CoreData

struct ShoppingListShoppersView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ShoppingListShoppersViewModel
    
    var onChosen: (String) -> Void
    
    init(_ exclude: [String], _ context: NSManagedObjectContext, _ onChosen: @escaping (String) -> Void) {
        self.onChosen = onChosen
        _viewModel = StateObject(wrappedValue: ShoppingListShoppersViewModel(exclude: exclude, context))
    }
    
    var body: some View {
        ZStack {
            if (viewModel.friends.count == 0) {
                NoShoppersDefault()
            }
            else {
                List {
                    ForEach(viewModel.friends) { shopper in
                        Button {
                            if let uid = shopper.uid {
                                onChosen(uid)
                                dismiss()
                            }
                        } label: {
                            HStack {
                                ShopperSettingsThumbnailView(shopper, false, .system(size: 15, weight: .medium))
                                    .foregroundStyle(Color(.label))
                            }
                        }
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Add Friends")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}
