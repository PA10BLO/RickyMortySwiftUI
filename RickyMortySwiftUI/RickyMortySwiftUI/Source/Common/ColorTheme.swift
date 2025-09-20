//
//  ColorTheme.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 19/9/25.
//


import SwiftUI

enum ColorTheme {
    
    static let portalGreen = Color(hex: 0x00FF9D)
    static let rickCyan = Color(hex: 0x00B5CC)
    static let mortyYellow = Color(hex: 0xF4DF4E)
    static let plumbusPink = Color(hex: 0xFF7AA2)
    static let spaceBlack = Color(hex: 0x0B0F14)
    static let cardFill = Color.black.opacity(0.2)
    static let accent = portalGreen

    static let gradientPortal = LinearGradient(
        colors: [portalGreen, rickCyan],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )

    static let gradientHot = LinearGradient(
        colors: [plumbusPink, mortyYellow],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
}
