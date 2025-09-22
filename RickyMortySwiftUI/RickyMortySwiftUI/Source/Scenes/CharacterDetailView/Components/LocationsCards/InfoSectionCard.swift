//
//  Untitled.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 18/9/25.
//

import SwiftUI

struct InfoSectionCard: View {
    
    let title: String
    let icon: String
    let name: String
    let urlString: String?
    let cornerRadiusSize: CGFloat = 16
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title3.weight(.semibold))
                Text(title)
                    .font(.headline)
                Spacer()
            }
            
            if let urlString, let url = URL(string: urlString), !urlString.isEmpty {
                LocationDescription(url: url)
            }  else {
                Text("characterDetail.unknown".localized)
                    .font(.subheadline)
                    .bold()
            }
        }
        .padding(16)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadiusSize, style: .continuous)
                .strokeBorder(.separator.opacity(0.25)))
        .accessibilityElement(children: .contain)
    }
}
