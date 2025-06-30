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
    }
    
}

#Preview {
    StatisticsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
