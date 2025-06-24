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
        NavigationView {
            List {
            }
            .navigationTitle("Statistics")
        }
    }
    
}

#Preview {
    SettingsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
