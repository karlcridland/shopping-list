//
//  ContentView.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var context

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ShoppingList.lastUpdated, ascending: false)],
        animation: .default)
    private var items: FetchedResults<ShoppingList>

    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(items) { shoppingList in
                    Button {
                        path.append(shoppingList)
                    } label: {
                        ShoppingListThumbnail(shoppingList: shoppingList)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .onDelete(perform: deleteShoppingList)
                
                NewShoppingListThumbnail {
                    createShoppingList()
                }
            }
            .listRowSpacing(10)
            .contentMargins(.top, 12)
            .navigationTitle("Shopping Lists")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(removing: nil)
            .navigationDestination(for: ShoppingList.self) { shoppingList in
                ShoppingListView(shoppingList: shoppingList)
                    .environment(\.managedObjectContext, context)
            }
        }
        .ignoresSafeArea()
    }

    private func createShoppingList() {
        withAnimation {
            let newShoppingList = ShoppingList(context: context)
            newShoppingList.created = Date()
            newShoppingList.lastUpdated = Date()
            newShoppingList.id = UUID().uuidString
            do {
                try context.save()
                path.append(newShoppingList)
            } catch let error as NSError {
                print("Core Data save failed: \(error), \(error.userInfo)")
            }
        }
    }
    
    private func deleteShoppingList(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(context.delete)
            do {
                try context.save()
            } catch {
                fatalError("Unresolved error \(error as NSError)")
            }
        }
    }
    
    private func deleteAllShoppingLists(offsets: IndexSet) {
        for item in items {
            context.delete(item)
        }

        do {
            try context.save()
            print("Deleted all shopping lists.")
        } catch {
            print("Error deleting shopping lists:", error.localizedDescription)
        }
    }
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
