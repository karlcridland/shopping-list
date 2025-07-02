//
//  MainView.swift
//  Shopping List
//
//  Created by Karl Cridland on 01/07/2025.
//

import SwiftUI

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
                SearchView(context: context)
                    .navigationTitle("Search")
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
                Label("Search", systemImage: "magnifyingglass")
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
