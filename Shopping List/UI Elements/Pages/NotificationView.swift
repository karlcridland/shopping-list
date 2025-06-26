//
//  StatisticsView.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import CoreData

struct NotificationView: View {

    var body: some View {
        NavigationView {
            List {
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

#Preview {
    StatisticsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
