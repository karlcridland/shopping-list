//
//  Shopping_ListApp.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct Shopping_ListApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var observer = ShoppingListObserver.shared

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let context = persistenceController.container.viewContext

            Group {
                if Auth.auth().currentUser != nil {
                    if observer.hasSynced {
                        MainView(viewModel: authViewModel)
                            .environment(\.managedObjectContext, context)
                            .onAppear {
                                NotificationButtonModel.shared.startObserving(context: context)
                            }
                    } else {
                        ProgressView("Syncing Shopping Lists...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.accentColor)
                            .onAppear {
                                observer.startObserving(context: context) {
                                    try? context.save()
                                }
                            }
                    }
                } else {
                    AuthView(viewModel: authViewModel)
                        .environment(\.managedObjectContext, context)
                }
            }
        }
    }
}
