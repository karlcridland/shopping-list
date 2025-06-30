//
//  FriendsView.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import CoreData

struct FriendsView: View {
    @Environment(\.managedObjectContext) private var context

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Shopper.familyName, ascending: true)],
        animation: .default)
    private var shoppers: FetchedResults<Shopper>

    var body: some View {
        SearchView(context: context)
        .background(Color(.systemGroupedBackground))
    }
    
    private func removeFriend(offsets: IndexSet) {
        withAnimation {
            offsets.map { shoppers[$0] }.forEach(context.delete)

            do {
                try context.save()
            } catch {
                fatalError("Unresolved error \(error as NSError)")
            }
        }
    }

}

#Preview {
    FriendsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
