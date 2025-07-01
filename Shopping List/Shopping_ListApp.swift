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
                                observer.startObserving(context: context)
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


struct MainView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject private var notificationModel = NotificationButtonModel.shared
    @State private var selectedTab: Int = 0  // Track the selected tab

    var viewModel: AuthViewModel

    var body: some View {
        TabView(selection: $selectedTab) {
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
            .tag(0)

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
            .tag(1)

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
            .tag(2)

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
            .tag(3)
        }
        .onChange(of: selectedTab) { (_, _) in
            notificationModel.showNotificationSheet = false
        }
    }
}
