//
//  CharacterDetailViewModel.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 18/9/25.
//

import Foundation

@MainActor
final class CharacterDetailViewModel: ObservableObject {
    @Published var character: Character
    
    init(character: Character) {
        self.character = character
    }
}

@MainActor
final class ResourceDetailViewModel: ObservableObject {
    
    enum State: Equatable {
        case loading,
             error(String),
             character(Character),
             location(LocationRM),
             episode(EpisodeRM),
             raw(String)
    }
    
    @Published private(set) var state: State = .loading
    private let repository: RickyAndMortyCharactersRepositoryProtocol
    private let resource: APIResource
    
    init(repo: RickyAndMortyCharactersRepositoryProtocol, url: URL) {
        self.repository = repo
        self.resource = APIResource(url: url)
    }
    
    func load() async {
        state = .loading
        do {
            switch resource {
                case .character(let url):
                    let c = try await repository.fetchCharacter(url: url); state = .character(c)
                case .location(let url):
                    let l = try await repository.fetchLocation(url: url); state = .location(l)
                case .episode(let url):
                    let e = try await repository.fetchEpisode(url: url); state = .episode(e)
                case .unknown(let url):
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let raw = String(data: data, encoding: .utf8) ?? .empty
                    state = .raw(raw)
            }
        } catch { state = .error((error as? LocalizedError)?.errorDescription ?? error.localizedDescription) }
    }
}
