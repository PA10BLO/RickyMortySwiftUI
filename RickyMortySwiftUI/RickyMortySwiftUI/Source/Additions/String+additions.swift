//
//  String+additions.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 18/9/25.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    public static var empty: String {
        return ""
    }
}
