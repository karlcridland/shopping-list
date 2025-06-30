//
//  ShoppingItemCategoryPicker.swift
//  Shopping List
//
//  Created by Karl Cridland on 24/06/2025.
//

import SwiftUI

struct ShoppingItemCategoryPicker: View {
    
    @Binding var category: Category?
    
    var body: some View {
        Section("Category") {
            ForEach(Category.allCases.sorted()) { category in
                Button {
                    self.category = category
                } label: {
                    HStack {
                        let selected = category == self.category
                        Text(category.rawValue)
                            .foregroundStyle(selected ? .accent : .charcoal)
                            .fontWeight(.medium)
                        if selected {
                            Spacer()
                            Image(systemName: "checkmark")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color(.accent))
                        }
                    }
                }
            }
        }
    }
    
}
