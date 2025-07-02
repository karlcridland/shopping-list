//
//  ShareSheet.swift
//  Shopping List
//
//  Created by Karl Cridland on 24/06/2025.
//


import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
    
}
