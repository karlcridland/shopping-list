//
//  DocumentSnapshot.swift
//  Shopping List
//
//  Created by Karl Cridland on 26/06/2025.
//

import FirebaseFirestore
import CoreData

fileprivate var shoppers: [Shopper] = []

extension DocumentSnapshot {
        
    func shopper(from context: NSManagedObjectContext) -> Shopper? {
        if let shopper = shoppers.first(where: {$0.uid == documentID}) {
            return shopper
        }
        guard let givenName = self.get("givenName") as? String,
                let familyName = self.get("familyName") as? String else { return nil }
        let shopper = Shopper(context: context)
        shopper.uid = self.documentID
        shopper.givenName = givenName
        shopper.familyName = familyName
        shoppers.append(shopper)
        return shopper
    }
    
}
