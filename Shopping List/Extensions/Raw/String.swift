//
//  String.swift
//  Shopping List
//
//  Created by Karl Cridland on 26/06/2025.
//

extension String {
    
    func relevance(to query: String) -> Int {
        if self == query {
            return 3
        } else if self.hasPrefix(query) {
            return 2
        } else if self.contains(query) {
            return 1
        } else {
            return 0
        }
    }
    
}
