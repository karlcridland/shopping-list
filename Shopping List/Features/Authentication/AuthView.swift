//
//  AuthView.swift
//  Shopping List
//
//  Created by Karl Cridland on 25/06/2025.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit

struct AuthView: View {
    
    @ObservedObject var viewModel: AuthViewModel
    
    @State private var isSigningIn = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            Spacer()
                .frame(height: 140)
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea(.all)
            
            Image(systemName: "cart")
                .resizable()
                .frame(width: 160, height: 140)
                .aspectRatio(contentMode: .fit)
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea(.all)
                .foregroundStyle(Color(.frost))
                .transformEffect(CGAffineTransform(scaleX: 0.9, y: 0.9))
            
            Spacer()
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Text("We require you to sign in with Apple to use this service.")
                .foregroundStyle(.frost)
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            SignInWithAppleButton(.signIn, onRequest: viewModel.configure, onCompletion: viewModel.handle)
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .padding(.horizontal)
            
            Button {
                
            } label: {
                Text("Privacy Policy")
                    .foregroundStyle(.charcoal)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
        }
        .ignoresSafeArea(.all)
        .padding()
        .background(.accent)
        .overlay {
            if isSigningIn {
                ProgressView("Signing In...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
            }
        }
    }
    
}
