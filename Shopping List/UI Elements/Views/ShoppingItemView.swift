//
//  ShoppingItemView.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import CoreData

struct ShoppingItemView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) var dismiss
    
    var id: String?
    
    @State var title: String = ""
    @State var subtitle: String = ""
    @State var category: Category?
    
    @FocusState private var isFocused: Bool
    
    var editingItem: ShoppingItem?
    
    var onComplete: (ShoppingItem) -> Void

    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                ScrollViewReader { _ in
                    List {
                        Section("Title") {
                            TextField("e.g. Tomatoes", text: $title)
                                .focused($isFocused)
                                .submitLabel(.done)
                                .onSubmit { isFocused = false }
                        }
                        
                        Section("Description (optional)") {
                            TextField("e.g. Riper the better!", text: $subtitle)
                                .submitLabel(.done)
                        }
                        
                        ShoppingItemCategoryPicker(category: $category)
                        
                    }
                    .simultaneousGesture(
                        DragGesture().onChanged { _ in
                            if (isFocused) {
                                isFocused = false
                            }
                        }
                    )
                }
//                VStack(alignment: .trailing) {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        ShoppingItemImagePicker { image in
//                            
//                        } onClick: {
//                            isFocused = false
//                        }
//                    }
//                }
            }
        }
        .navigationTitle(title.isEmpty ? "New Item" : title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if let category = self.category {
                        if let item = self.editingItem {
                            item.title = title
                            item.describe = subtitle
                            item.category = category
                            onComplete(item)
                        }
                        else {
                            let item = ShoppingItem.newInstance(UUID().uuidString, title, subtitle, category, context: context)
                            onComplete(item)
                        }
                        dismiss()
                    }
                }
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || category == nil)
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .task {
            if let item = editingItem {
                title = item.title ?? ""
                subtitle = item.describe ?? ""
                category = item.category
            }
            else {
                self.isFocused = true
            }
        }
    }

}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let item = ShoppingItem(context: context)
    item.title = "Test Item"
    
    return ShoppingItemView(editingItem: item) { _ in }
        .environment(\.managedObjectContext, context)
}
