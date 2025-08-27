//
//  ShoppingList.swift
//  Shopping List
//
//  Created by Karl Cridland on 23/08/2025.
//

import Foundation

extension ShoppingList {
    
    private var shoppersArray: [Shopper] {
        shoppers?.allObjects as? [Shopper] ?? []
    }
    
    private func positionInList(_ shopper: Shopper?) -> Int {
        if let shopper = shopper {
            return (self.shoppersArray.firstIndex(where: { $0 == shopper }) ?? 0) + 2
        }
        return 1
    }

    var accessibleListSize: Int {
        self.shoppersArray.count + 1
    }
    
    func accessibilityPosition(_ shopper: Shopper? = nil) -> AccessibilityPosition {
        AccessibilityPosition(position: positionInList(shopper), total: accessibleListSize)
    }
    
}
