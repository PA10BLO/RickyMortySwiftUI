//
//  LocationInfoViewModel.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 21/9/25.
//

import Foundation

@MainActor
final class LocationInfoViewModel: ObservableObject {
    
    @Published var location: Location?
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
