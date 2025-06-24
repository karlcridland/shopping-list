//
//  FriendsView.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import CoreData

struct FriendsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Shopper.name, ascending: true)],
        animation: .default)
    private var shoppers: FetchedResults<Shopper>

    var body: some View {
        NavigationView {
            List {
                ForEach(shoppers) { shopper in
                    
                }
                .onDelete(perform: removeFriend)
            }
            .navigationTitle("Friends")
            .toolbar(removing: nil)
        }
    }
    
    private func removeFriend(offsets: IndexSet) {
        withAnimation {
            offsets.map { shoppers[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                fatalError("Unresolved error \(error as NSError)")
            }
        }
    }

}

#Preview {
    FriendsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
