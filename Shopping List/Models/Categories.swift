//
//  Categories.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import ObjectiveC

enum Category: String, CaseIterable, Identifiable, Comparable {
    
    var id: String {
        return self.rawValue
    }
    
    case frozen = "Frozen"
    case vegetables = "Vegetables"
    case fruits = "Fruits"
    case confectionary = "Confectionary"
    case baking = "Baking"
    case bakery = "Bakery"
    case electronics = "Electronics"
    case dairy = "Dairy"
    case meat = "Meat"
    case drinks = "Drinks"
    case household = "Household"
    case toiletries = "Toiletries"
    case clothing = "Clothing"
    case petSupplies = "Pet Supplies"
    case baby = "Baby"
    case pharmacy = "Pharmacy"
    case miscellaneous = "Miscellaneous"
    
    static func <(lhs: Category, rhs: Category) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    static func >(lhs: Category, rhs: Category) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
    
    static func <=(lhs: Category, rhs: Category) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
    
    static func >=(lhs: Category, rhs: Category) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }
    
}

extension ShoppingItem {
    var category: Category {
        get {
            if let cat = categoryRaw as? String {
                return Category(rawValue: cat) ?? .miscellaneous
            }
            return .miscellaneous
        }
        set {
            categoryRaw = newValue.rawValue as NSObject
        }
    }
}
