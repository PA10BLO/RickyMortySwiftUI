//
//  LocationDescriptionView.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 21/9/25.
//

import SwiftUI

struct LocationDescription: View {
    
    @State var viewModel: LocationInfoViewModel
    
    var body: some View {
        HStack {
            if viewModel.isLoading {
                ProgressView().scaleEffect(0.8)
            } else if let location = viewModel.location {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center, spacing: 4) {
                        Text(location.name)
                            .font(.headline)
                        Text("• \(location.type)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    ResidentsRowView(viewModel: ResidentsRowViewModel(urls: location.residents))
                }
            } else if let error = viewModel.error {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .onTapGesture { Task { await viewModel.load() } }
            }
        }
        .task { await viewModel.load() }
    }
}
