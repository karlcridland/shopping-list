//
//  HomeViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 27/06/2025.
//

import Foundation
import CoreData
import FirebaseAuth

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var shoppingLists: [ShoppingList] = []
    @Published var selectedList: ShoppingList?
    @Published var showShoppingList: Bool = false

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        self.fetchLists()
    }

    func fetchLists() {
        let request: NSFetchRequest<ShoppingList> = ShoppingList.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ShoppingList.lastUpdated, ascending: false)]

        do {
            self.shoppingLists = try context.fetch(request).filter({!ShoppingListObserver.shared.shouldIgnore($0.id)})
        } catch {
            print("Failed to fetch shopping lists: \(error)")
        }
    }

    func createList() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let list = ShoppingList(context: context)
        list.id = UUID().uuidString
        list.title = ""
        list.created = Date()
        list.lastUpdated = Date()
        list.owner = uid
        list.shopperData = NSSet(array: [])
        list.save()

        fetchLists()
        print("2. saving after list creation")
        try? context.save()
        selectedList = list
        showShoppingList = true
    }

    func deleteLists(at offsets: IndexSet) {
        Task {
            var deleted = false
            for index in offsets {
                let shoppingList = shoppingLists[index]

                if let id = shoppingList.id {
                    ShoppingListObserver.shared.deleteList.append(id)
                }
                
                await shoppingList.delete()

                context.delete(shoppingList)
                deleted = true
            }

            if deleted {
                do {
                    print("3. Saving after list deletion")
                    try context.save()
                    fetchLists()
                } catch {
                    print("Error deleting list:", error.localizedDescription)
                }
            }
        }
    }
}
