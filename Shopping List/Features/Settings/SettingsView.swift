//
//  SettingsView.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import PhotosUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var context
    
    @StateObject var viewModel: SettingsViewModel
    @State var showProfilePicker: Bool = false
    
    var signOut: () -> Void
    
    init(signOut: @escaping () -> Void) {
        self.signOut = signOut
        _viewModel = StateObject(wrappedValue: SettingsViewModel())
    }
    
    var body: some View {
        List {
            SettingsProfileView(context, $showProfilePicker)
            SettingsAccountView(signOut: signOut, font: viewModel.font)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NotificationButton(model: NotificationButtonModel.shared)
            }
        }
    }
    
}
