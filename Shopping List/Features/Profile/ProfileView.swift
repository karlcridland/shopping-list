//
//  ProfileView.swift
//  Shopping List
//
//  Created by Karl Cridland on 09/09/2025.
//

import SwiftUI
import CoreData

struct ProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    
    init(shopper: Shopper) {
        self.viewModel = ProfileViewModel(shopper: shopper)
    }
    
    var body: some View {
        Text(viewModel.shopper.name.full)
    }
    
}


#Preview {
    let context = PersistenceController.preview.container.viewContext
    let shopper = Shopper(context: context)
    shopper.givenName = "Karl"
    shopper.familyName = "Cridland"
    
    return ProfileView(shopper: shopper)
        .environment(\.managedObjectContext, context)
}
