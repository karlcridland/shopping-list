//
//  SettingsAccountView.swift
//  Shopping List
//
//  Created by Karl Cridland on 04/07/2025.
//

import SwiftUI

struct SettingsAccountView: View {
    
    let signOut: () -> Void
    let font: Font
    
    var body: some View {
        Section("Account") {
            Button {
                signOut()
            } label: {
                Text("Sign Out")
                    .font(font)
                    .foregroundStyle(Color(.systemRed))
            }
        }
    }
    
}
