//
//  SettingsView.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    
    var signOut: () -> Void
    var deleteAccount: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                Section("Leaving us?") {
                    Button {
                        signOut()
                    } label: {
                        Text("Sign Out")
                    }
                    Button {
                        deleteAccount()
                    } label: {
                        Text("Delete Account")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
    
}

#Preview {
    SettingsView(signOut: {}, deleteAccount: {}).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
