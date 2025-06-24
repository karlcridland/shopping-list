//
//  ShoppingItem.swift
//  Shopping List
//
//  Created by Karl Cridland on 24/06/2025.
//

import CoreData

extension ShoppingItem {
    
    static func newInstance(_ id: String, _ title: String, _ describe: String? = nil, _ category: Category, context: NSManagedObjectContext) -> ShoppingItem {
        let item = ShoppingItem(context: context)
        item.id = id
        item.title = title
        item.describe = describe
        item.category = category
        do {
            try context.save()
        }
        catch {
            
        }
        return item
    }
    
}
