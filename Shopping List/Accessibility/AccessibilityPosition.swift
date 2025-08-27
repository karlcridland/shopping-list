//
//  AccessibilityPosition.swift
//  Shopping List
//
//  Created by Karl Cridland on 23/08/2025.
//

struct AccessibilityPosition {
    var position: Int
    var total: Int
    
    var label: String {
        return "\(position) of \(total)"
    }
}
