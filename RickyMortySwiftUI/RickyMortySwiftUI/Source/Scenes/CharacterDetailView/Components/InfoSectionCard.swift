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
    
    @State private var showCopied = false
    
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

private struct LabeledRow<Content: View>: View {
    let label: String
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 64, alignment: .leading)
            content()
            Spacer()
        }
    }
}


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


@MainActor
final class LocationInfoViewModel: ObservableObject {
    @Published var location: LocationRM?
    @Published var error: String?
    @Published var isLoading = false
    
    private let repo: RickyAndMortyCharactersRepositoryProtocol
    private let url: URL
    
    init(url: URL, repo: RickyAndMortyCharactersRepositoryProtocol = RickyAndMortyCharactersRepository()) {
        self.url = url
        self.repo = repo
    }
    
    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let loc = try await repo.fetchLocation(url: url)
            self.location = loc
        } catch {
            self.error = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
}
