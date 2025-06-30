//
//  ShoppingListButtonStyle.swift
//  Shopping List
//
//  Created by Karl Cridland on 23/06/2025.
//

import SwiftUI

protocol ShoppingListButtonStyle {
    var thickness: Font.Weight { get }
    var foreground: Color { get }
    var background: Color { get }
    var padding: CGFloat { get }
    var cornerRadius: CGFloat { get }
}

extension ShoppingListButtonStyle {
    var thickness: Font.Weight { .bold }
    var foreground: Color { Color(.white) }
    var background: Color { Color.accentColor }
    var padding: CGFloat { 10 }
    var cornerRadius: CGFloat { 8 }
}
