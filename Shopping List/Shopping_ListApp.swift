//
//  Shopping_ListApp.swift
//  Shopping List
//
//  Created by Karl Cridland on 21/06/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
}

@main
struct Shopping_ListApp: App {
    
    @Environment(\.managedObjectContext) private var context
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            if Auth.auth().currentUser != nil {
                MainView(viewModel: authViewModel)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .task {
                        NotificationButtonModel.shared.startObserving(context: context)
                    }
            } else {
                AuthView(viewModel: authViewModel)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}

struct MainView: View {
    
    @Environment(\.managedObjectContext) private var context
    @ObservedObject private var notificationModel = NotificationButtonModel.shared
    var viewModel: AuthViewModel

    var body: some View {
        TabView {
            
            NavigationStack {
                HomeView(context: context)
                    .navigationTitle("Shopping Lists")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            NotificationButton(model: notificationModel)
                        }
                    }
                    .navigationDestination(isPresented: $notificationModel.showNotificationSheet) {
                        NotificationView()
                    }
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NavigationStack {
                FriendsView()
                    .navigationTitle("Friends")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            NotificationButton(model: notificationModel)
                        }
                    }
                    .navigationDestination(isPresented: $notificationModel.showNotificationSheet) {
                        NotificationView()
                    }
            }
            .tabItem {
                Label("Friends", systemImage: "person.2.fill")
            }

            NavigationStack {
                StatisticsView()
                    .navigationTitle("Statistics")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            NotificationButton(model: notificationModel)
                        }
                    }
                    .navigationDestination(isPresented: $notificationModel.showNotificationSheet) {
                        NotificationView()
                    }
            }
            .tabItem {
                Label("Stats", systemImage: "chart.pie")
            }

            NavigationStack {
                SettingsView(signOut: viewModel.signOut, deleteAccount: viewModel.deleteAccount)
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(isPresented: $notificationModel.showNotificationSheet) {
                        NotificationView()
                    }
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}
