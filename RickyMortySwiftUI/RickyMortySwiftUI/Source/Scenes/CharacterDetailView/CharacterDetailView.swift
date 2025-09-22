//
//  CharacterDetailView.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 18/9/25.
//

import SwiftUI

struct CharacterDetailView: View {
    @StateObject var viewModel: CharacterDetailViewModel
    @State private var repository = RickyAndMortyCharactersRepository()
    @Binding var path: NavigationPath
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: viewModel.character.image)) { phase in
                    switch phase {
                    case .empty: ZStack { Color.gray.opacity(0.1); ProgressView() }
                    case .success(let image): image.resizable().scaledToFill()
                    case .failure: Image(systemName: "photo").resizable().scaledToFit().padding(20)
                    @unknown default: EmptyView()
                    }
                }
                .frame(height: 280)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.character.name)
                        .font(.largeTitle).bold()
                    HStack(spacing: 10) {
                        SubheadlineCharacterTitleView(status: LifeStatus(from: viewModel.character.status),
                                                      species: Species(from: viewModel.character.species),
                                                      gender: Gender(from: viewModel.character.gender))
                    }
                }
                
                InfoSectionCard(
                    title: "characterDetailView.sectionTitle".localized,
                    icon: "globe.americas.fill",
                    name: viewModel.character.origin.name,
                    urlString: viewModel.character.origin.url
                )
                
                InfoSectionCard(
                    title: "characterDetailView.location".localized,
                    icon: "mappin.and.ellipse",
                    name: viewModel.character.location.name,
                    urlString: viewModel.character.location.url
                )
                
                EpisodeCardView(character: viewModel.character)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    path = NavigationPath()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
                .foregroundColor(.green.opacity(0.8))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


