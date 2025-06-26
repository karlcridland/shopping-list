//
//  NotificationButtonModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 26/06/2025.
//

import CoreData

class NotificationButtonModel: ObservableObject {
    
    static let shared = NotificationButtonModel()
    
    @Published var showNotificationSheet: Bool = false
    @Published var hasNotifications: Bool = false
    
    private init() {}
    
    func startObserving(context: NSManagedObjectContext) {
        Database.users.friends.observeRequests(listener: { shoppers in
            DispatchQueue.main.async {
                self.hasNotifications = !shoppers.isEmpty
            }
        }, context: context)
    }

    func handleTap(_ context: NSManagedObjectContext) {
        showNotificationSheet = true
    }
    
}
