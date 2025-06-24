//
//  SettingsView.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import CoreData

struct SettingsView: View {

    var body: some View {
        NavigationView {
            List {
            }
            .navigationTitle("Settings")
        }
    }
    
}

#Preview {
    SettingsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
