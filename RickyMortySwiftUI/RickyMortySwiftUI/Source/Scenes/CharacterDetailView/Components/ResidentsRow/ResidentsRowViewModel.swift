//
//  ResidentsRowViewModel.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 19/9/25.
//

import Foundation

class ResidentsRowViewModel: ObservableObject {
    
    @Published var residents: [String]?
    
    var error: String?
    
    enum State: Equatable { case loading, loaded([Character]), error(String) }
    @Published private(set) var state: State = .loading
    
    private let repo: RickyAndMortyCharactersRepositoryProtocol
    private let urls: [String]
    
    init(repo: RickyAndMortyCharactersRepositoryProtocol = RickyAndMortyCharactersRepository(), urls: [String]) {
            self.repo = repo
            self.urls = urls
        }
    
    func load() async {
        guard !urls.isEmpty else { state = .loaded([]); return }
        state = .loading
        do {
            let ids = urls.compactMap { URL(string: $0)?.lastPathComponent }.compactMap(Int.init)
            let characters = try await repo.fetchCharacters(ids: ids)
            state = .loaded(characters)
        } catch {
            state = .error((error as? LocalizedError)?.errorDescription ?? error.localizedDescription)
        }
    }
}
