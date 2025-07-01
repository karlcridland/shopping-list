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
            self.shoppingLists = try context.fetch(request)
        } catch {
            print("Failed to fetch shopping lists: \(error)")
        }
    }

    func createList() {
        let list = ShoppingList(context: context)
        list.id = UUID().uuidString
        list.created = Date()
        list.lastUpdated = Date()
        list.owner = Auth.auth().currentUser?.uid
        list.shopperData = [] as NSSet
        list.save()

        saveContext()
        fetchLists()
        selectedList = list
        showShoppingList = true
    }

    func deleteLists(at offsets: IndexSet) {
        for index in offsets {
            let shoppingList = shoppingLists[index]
            Task {
                await shoppingList.delete()
                context.delete(shoppingList)
            }
        }
        saveContext()
        fetchLists()
        selectedList?.save()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
