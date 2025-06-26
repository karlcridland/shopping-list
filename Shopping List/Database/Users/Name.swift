//
//  Name.swift
//  Shopping List
//
//  Created by Karl Cridland on 25/06/2025.
//

struct Name {
    
    let givenName, familyName: String
    
    init(_ givenName: String, _ familyName: String) {
        self.givenName = givenName
        self.familyName = familyName
    }
    
    var full: String {
        return [givenName, familyName].joined(separator: " ")
    }
    
    var data: [String: String] {
        return ["givenName": givenName, "familyName": familyName]
    }
    
}
