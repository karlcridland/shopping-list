//
//  QueryDocumentSnapshot.swift
//  Shopping List
//
//  Created by Karl Cridland on 26/06/2025.
//

import FirebaseFirestore
import CoreData

extension [QueryDocumentSnapshot] {
    
    func process(query: String, context: NSManagedObjectContext) -> [(shopper: Shopper, score: Int)] {
        
        var seen = Set<String>()
        var results: [(Shopper, Int)] = []

        let lowerQuery = query.lowercased()

        for doc in self {
            let uid = doc.documentID
            guard !seen.contains(uid) else { continue }

            let given = (doc.get("givenName") as? String) ?? ""
            let family = (doc.get("familyName") as? String) ?? ""
            let fullName = [given, family].joined(separator: " ").trimmingCharacters(in: .whitespaces)
            let lowerName = fullName.lowercased()

            let score = lowerName.relevance(to: lowerQuery)

            let shopper = Shopper(context: context)
            shopper.uid = uid
            shopper.name = fullName

            results.append((shopper, score))
            seen.insert(uid)
        }

        return results
    }
    
}
