//
//  das.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 21/9/25.
//

import SwiftUI

struct NoResultsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.secondary)
            Text("No results found")
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NoResultsView()
}
