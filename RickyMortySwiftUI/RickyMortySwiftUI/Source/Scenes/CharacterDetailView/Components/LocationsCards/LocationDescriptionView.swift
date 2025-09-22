//
//  LocationDescriptionView.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 21/9/25.
//

import SwiftUI

struct LocationDescription: View {
    let url: URL
    @StateObject private var vm: LocationInfoViewModel
    
    init(url: URL) {
        self.url = url
        _vm = StateObject(wrappedValue: LocationInfoViewModel(url: url))
    }
    
    var body: some View {
        HStack {
            if vm.isLoading {
                ProgressView().scaleEffect(0.8)
            } else if let location = vm.location {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center, spacing: 4) {
                        Text(location.name)
                            .font(.headline)
                        Text("• \(location.type)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    ResidentsRowView(residentURLs: location.residents)
                }
            } else if let error = vm.error {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .onTapGesture { Task { await vm.load() } }
            }
        }
        .task { await vm.load() }
    }
}
