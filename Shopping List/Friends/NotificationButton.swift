//
//  NotificationButton.swift
//  Shopping List
//
//  Created by Karl Cridland on 26/06/2025.
//

import SwiftUI
import CoreData

struct NotificationButton: View {
    @Environment(\.managedObjectContext) var context
    @ObservedObject var model: NotificationButtonModel
    
    @State private var isWiggling = false
    @State private var hasWiggled = true
    
    var body: some View {
        Button {
            model.handleTap(context)
        } label: {
            Image(systemName: model.hasNotifications ? "bell.badge.fill" : "bell.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(model.hasNotifications ? Color(.red) : Color(.charcoal), .charcoal)
                .font(.system(size: 16, weight: .semibold))
                .rotationEffect(Angle(degrees: hasWiggled ? 0 : isWiggling ? 8 : -8))
                .animation(model.hasNotifications ? Animation.easeInOut(duration: 0.15).repeatCount(6, autoreverses: true) : .default, value: isWiggling)
                .shadow(color: .black.opacity(0.1), radius: 4)
                .padding(8)
        }
        .onChange(of: model.hasNotifications, { hadNotif, hasNotif in
            if hasNotif && !hadNotif {
                hasWiggled = false
                isWiggling = true
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                    self.hasWiggled = true
                }
            } else {
                isWiggling = false
            }
        })
    }
}
