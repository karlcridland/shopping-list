//
//  StatisticsView.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import CoreData

struct StatisticsView: View {

    var body: some View {
        List {
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NotificationButton(model: NotificationButtonModel.shared)
            }
        }
    }
    
}

#Preview {
    StatisticsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
