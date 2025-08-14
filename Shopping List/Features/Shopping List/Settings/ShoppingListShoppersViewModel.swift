//
//  ShoppingListShoppersViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 02/07/2025.
//

import CoreData

class ShoppingListShoppersViewModel: ObservableObject {
    
    var exclude: [String]
    
    @Published var friends: [Shopper] = []
    
    init(exclude: [String], _ context: NSManagedObjectContext) {
        self.exclude = exclude
        Task {
            let result = await self.getFriends(context)
            await MainActor.run {
                self.friends = result
            }
        }
    }
    
    private func getFriends(_ context: NSManagedObjectContext) async -> [Shopper] {
        await Database.users.friends.get(context).filter({!self.exclude.contains($0.uid ?? "")})
    }
    
}
