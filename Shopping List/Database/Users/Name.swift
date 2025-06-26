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
    
    var data: [String: Any] {
        return [
            "givenName": givenName,
            "familyName": familyName,
            "searchTokens": full.generateSearchTokens()
        ]
    }
    
}

extension String {
    
    func generateSearchTokens() -> [String] {
        var components = self
            .lowercased()
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        components.append(self.lowercased())

        var tokens = Set<String>()

        for word in components {
            for i in 1...word.count {
                let prefix = String(word.prefix(i))
                tokens.insert(prefix)
            }
        }

        return Array(tokens).sorted()
    }
    
    var cleaned: String {
        self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
            .replacingOccurrences(of: "[^a-zA-Z0-9 ]", with: "", options: .regularExpression)
    }
    
}
