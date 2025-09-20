//
//  MainView.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 18/9/25.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("mainView.navigationTitle".localized)
        }
        .task { viewModel.onAppear() }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "mainView.searchBarPrompt".localized)
        .onSubmit(of: .search) {
            Task { await viewModel.refresh() }
        }
        .onChange(of: viewModel.searchText) {
            if viewModel.searchText.isEmpty {
                Task { await viewModel.refresh() }
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
        case .error(let message):
            ErrorView(message: message) { Task { await viewModel.refresh() } }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let items, let hasMore):
            List {
                ForEach(items) { character in
                    NavigationLink(value: character) {
                        CharacterRow(character: character)
                            .onAppear { Task { await viewModel.loadMoreIfNeeded(currentItem: character) } }
                    }
                }
                if hasMore {
                    HStack { Spacer(); ProgressView(); Spacer() }
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: Character.self) { character in
                CharacterDetailView(viewModel: CharacterDetailViewModel(character: character))
            }
        }
    }
}

struct CharacterRow: View {
    let character: Character
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: character.image)) { phase in
                switch phase {
                case .empty: ProgressView()
                case .success(let image): image.resizable().scaledToFill()
                case .failure: Image(systemName: "photo")
                        .resizable().scaledToFit().padding(10)
                @unknown default: EmptyView()
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.headline)
                    .lineLimit(1)
                HStack(spacing: 8) {
                    CharacterInfoView(status: LifeStatus(from: character.status),
                                   species: Species(from: character.species))
                }
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}
