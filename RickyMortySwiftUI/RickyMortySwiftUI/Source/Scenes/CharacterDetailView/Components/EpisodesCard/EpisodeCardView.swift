//
//  EpisodeCardView.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 21/9/25.
//

import SwiftUI

struct EpisodeCardView: View {
    
    let character: Character
    
    init(character: Character) {
        self.character = character
    }
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "tv.fill")
                        .imageScale(.medium)
                        .foregroundStyle(.secondary)
                    Text("characterDetailView.episodes".localized)
                        .bold()
                    Spacer()
                }
            }
            .padding(2)
            
            VStack(spacing: 16) {
                Text("characterDetailView.appears".localized + " \(character.episode.count) " + "characterDetailView.episodes".localized)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        ForEach(character.episode, id: \.self) {
                            url in Tag(text: "E\(url.split(separator: "/").last ?? "?")")
                                .foregroundColor(.black)
                                .bold()
                                .overlay(
                                    Capsule().strokeBorder(Color.green.opacity(0.7), lineWidth: 1))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    EpisodeCardView(character: Character(
        id: 1,
        name: "Rick Sanchez",
        status: "Alive",
        species: "Human",
        type: "",
        gender: "Male",
        origin: Character.LocationRef(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"),
        location: Character.LocationRef(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"),
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episode: [
            "https://rickandmortyapi.com/api/episode/1",
            "https://rickandmortyapi.com/api/episode/2"
        ],
        url: "https://rickandmortyapi.com/api/character/1",
        created: "2017-11-04T18:48:46.250Z"
    ))
}
