//
//  ShopperButton.swift
//  Shopping List
//
//  Created by Karl Cridland on 25/06/2025.
//

import SwiftUI

struct ShopperButton: View {
    
    @State var relationship: String = ""
    @StateObject var shopper: Shopper
    @ObservedObject var viewModel: ShopperButtonViewModel = ShopperButtonViewModel()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                        Text(shopper.name ?? "")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text(relationship)
                            .font(.system(size: 14, weight: .regular))
                            .multilineTextAlignment(.leading)
                    }
                    .task {
                        relationship = await Database.users.relationshipTo(shopper.uid)
                    }
            
            Spacer()
            
            Button {
                if let uid = shopper.uid {
                    viewModel.quickAdd(uid)
                }
            } label: {
                Image(systemName: "person.crop.circle.fill.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color(.systemBlue))
                    .frame(width: 32, height: 32)
                    .padding(12)
            }
            
        }
    }
    
}
