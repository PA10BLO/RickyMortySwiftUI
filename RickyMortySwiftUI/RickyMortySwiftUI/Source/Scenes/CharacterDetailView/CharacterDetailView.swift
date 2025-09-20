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
                        CharacterInfoView(status: LifeStatus(from: viewModel.character.status),
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

                GroupBox("characterDetailView.episodes".localized) {
                    Text("characterDetailView.appears".localized + " \(viewModel.character.episode.count) " + "characterDetailView.episodes".localized)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack { ForEach(viewModel.character.episode, id: \.self) { url in Tag(text: "E\(url.split(separator: "/").last ?? "?")") } }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
