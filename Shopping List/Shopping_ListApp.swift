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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if Auth.auth().currentUser != nil {
                MainView(viewModel: authViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                AuthView(viewModel: authViewModel)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}

struct MainView: View {
    
    var viewModel: AuthViewModel
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            FriendsView()
                .tabItem {
                    Label("Friends", systemImage: "person.2.fill")
                }
            StatisticsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.pie")
                }
            SettingsView(signOut: viewModel.signOut, deleteAccount: viewModel.deleteAccount)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        
    }
}
