//
//  Date.swift
//  Shopping List
//
//  Created by Karl Cridland on 27/06/2025.
//

import Foundation

extension Date {
    
    func componentValue(_ component: Calendar.Component) -> Int {
        let calendar = Calendar.current
        return calendar.component(component, from: self)
    }
    
}
