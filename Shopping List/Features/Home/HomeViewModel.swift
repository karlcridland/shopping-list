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
        list.shopperData = NSArray(array: [])
        list.save()

        fetchLists()
        print("2. saving after list creation")
        try? context.save()
        selectedList = list
        showShoppingList = true
    }

    func deleteLists(at offsets: IndexSet) {
        let listsToDelete = offsets.map { shoppingLists[$0] }
        shoppingLists.remove(atOffsets: offsets)
        Task {
            var deleted = false

            for shoppingList in listsToDelete {
                if let id = shoppingList.id {
                    ShoppingListObserver.shared.deleteList.append(id)
                }

                await shoppingList.delete()
                context.delete(shoppingList)
                deleted = true
            }

            if deleted {
                do {
                    try context.save()
                    fetchLists()
                } catch {
                    print("Error deleting list:", error.localizedDescription)
                }
            }
        }
    }
    
    func positionInList(_ shoppingList: ShoppingList) -> Int {
        (self.shoppingLists.firstIndex(where: { $0.id == shoppingList.id }) ?? 0) + 1
    }

    var listSize: Int {
        self.shoppingLists.count + 1
    }
    
}
