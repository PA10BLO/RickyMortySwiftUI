//
//  ResidentsRowViewModel.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 19/9/25.
//

import Foundation

@MainActor
class ResidentsRowViewModel: ObservableObject {
    
    @Published var residents: [String]?
    @Published private(set) var state: State = .loading
    private let repository: RickyAndMortyCharactersRepositoryProtocol
    private let urls: [String]
    var error: String?
    
    enum State: Equatable {
        case loading, loaded([Character]), error(String)
    }
    
    init(repo: RickyAndMortyCharactersRepositoryProtocol = RickyAndMortyCharactersRepository(), urls: [String]) {
            self.repository = repo
            self.urls = urls
        }
    
    func load() async {
        guard !urls.isEmpty else { state = .loaded([]); return }
        state = .loading
        do {
            let ids = urls.compactMap { URL(string: $0)?.lastPathComponent }.compactMap(Int.init)
            let characters = try await repository.fetchCharacters(ids: ids)
            state = .loaded(characters)
        } catch {
            state = .error((error as? LocalizedError)?.errorDescription ?? error.localizedDescription)
        }
    }
}
