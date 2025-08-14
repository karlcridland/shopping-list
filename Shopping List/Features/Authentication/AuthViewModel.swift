//
//  AuthViewModel.swift
//  Shopping List
//
//  Created by Karl Cridland on 25/06/2025.
//

import FirebaseAuth
import SwiftUI
import CryptoKit
import AuthenticationServices

class AuthViewModel: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @Published var isSignedIn = false
    fileprivate var currentNonce: String?
    
    override init() {
        super.init()
        self.isSignedIn = Auth.auth().currentUser != nil
        listenForAuthChanges()
    }
    
    private func listenForAuthChanges() {
        let _ = Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                self.isSignedIn = user != nil
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            ShoppingListObserver.shared.stopObserving()
        }
        catch {
            
        }
    }
    
    func deleteAccount() {
        Auth.auth().currentUser?.delete()
    }
    
    // MARK: - For use with SignInWithAppleButton
    
    func configure(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.sha256
    }

    func handle(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            guard let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential,
                  let nonce = currentNonce,
                  let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to retrieve Apple identity token.")
                return
            }
            
            let credential = OAuthProvider.credential(providerID: .apple, idToken: idTokenString, rawNonce: nonce)

            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Sign in failed: \(error.localizedDescription)")
                }
                if (result?.user.displayName == nil) {
                    if let givenName = appleIDCredential.fullName?.givenName,
                        let familyName = appleIDCredential.fullName?.familyName {
                        let name = Name(givenName, familyName)
                        Database.users.shoppers.set(name: name)
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = name.full
                        changeRequest?.commitChanges()
                    }
                    else {
                        print("no name loser")
                    }
                }
            }

        case .failure(let error):
            print("Apple Sign-In failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Required for ASAuthorizationController

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }

    // MARK: - Helpers

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms = (0..<16).map { _ in UInt8.random(in: 0...255) }
            for random in randoms where remainingLength > 0 {
                if random < charset.count {
                    result.append(charset[Int(random) % charset.count])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
}

// MARK: - SHA256 for Nonce

fileprivate extension String {
    var sha256: String {
        let data = Data(self.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
