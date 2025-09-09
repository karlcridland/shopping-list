//
//  ProfileView.swift
//  Shopping List
//
//  Created by Karl Cridland on 09/09/2025.
//

import SwiftUI

struct ProfileView: View {
    
//    @ObservedObject var viewModel: ProfileViewModel
    @State var shopper: Shopper
    
    var body: some View {
        Text(shopper.name.full)
    }
    
}
