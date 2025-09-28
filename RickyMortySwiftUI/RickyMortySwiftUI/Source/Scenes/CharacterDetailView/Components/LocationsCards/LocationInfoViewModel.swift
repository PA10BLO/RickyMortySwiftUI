//
//  LocationInfoViewModel.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 21/9/25.
//

import Foundation
import Observation

@Observable
final class LocationInfoViewModel {
    
    var location: Location?
    var error: String?
    var isLoading = false
    let repository: RickyAndMortyCharactersRepositoryProtocol
    let url: URL
    
    init(url: URL, repository: RickyAndMortyCharactersRepositoryProtocol = RickyAndMortyCharactersRepository()) {
        self.url = url
        self.repository = repository
    }
    
    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let loc = try await repository.fetchLocation(url: url)
            self.location = loc
        } catch {
            self.error = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
}

