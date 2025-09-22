//
//  MockRepository.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 21/9/25.
//

import Foundation
@testable import RickyMortySwiftUI

final class MockRepository: RickyAndMortyCharactersRepositoryProtocol {
    
    enum MockError: Error { case missingResult }
    
    var listCharactersResults: [Result<PaginatedResponse<Character>, Error>] = []
    private(set) var listCharactersParameters: [(page: Int?, name: String?)] = []
    
    var fetchCharacterResults: [Result<Character, Error>] = []
    private(set) var fetchCharacterURLs: [URL] = []
    
    var fetchCharactersResults: [Result<[Character], Error>] = []
    private(set) var fetchCharactersParameters: [[Int]] = []
    
    var fetchLocationResults: [Result<Location, Error>] = []
    private(set) var fetchLocationURLs: [URL] = []
    
    var fetchEpisodeResults: [Result<Episode, Error>] = []
    private(set) var fetchEpisodeURLs: [URL] = []
    
    func listCharacters(page: Int?, name: String?) async throws -> PaginatedResponse<Character> {
        listCharactersParameters.append((page, name))
        guard !listCharactersResults.isEmpty else { throw MockError.missingResult }
        let result = listCharactersResults.removeFirst()
        return try result.get()
    }
    
    func fetchCharacters(ids: [Int]) async throws -> [Character] {
        fetchCharactersParameters.append(ids)
        guard !fetchCharactersResults.isEmpty else { throw MockError.missingResult }
        let result = fetchCharactersResults.removeFirst()
        return try result.get()
    }
    
    func fetchCharacter(url: URL) async throws -> Character {
        fetchCharacterURLs.append(url)
        guard !fetchCharacterResults.isEmpty else { throw MockError.missingResult }
        let result = fetchCharacterResults.removeFirst()
        return try result.get()
    }
    
    func fetchLocation(url: URL) async throws -> Location {
        fetchLocationURLs.append(url)
        guard !fetchLocationResults.isEmpty else { throw MockError.missingResult }
        let result = fetchLocationResults.removeFirst()
        return try result.get()
    }
    
    func fetchEpisode(url: URL) async throws -> Episode {
        fetchEpisodeURLs.append(url)
        guard !fetchEpisodeResults.isEmpty else { throw MockError.missingResult }
        let result = fetchEpisodeResults.removeFirst()
        return try result.get()
    }
    
}

enum TestFixtures {
    
    static func character(id: Int = 1, name: String = "Rick Sanchez") -> Character {
        Character(
            id: id,
            name: name,
            status: "Alive",
            species: "Human",
            type: .empty,
            gender: "Male",
            origin: .init(name: "Earth", url: "https://example.com/location/1"),
            location: .init(name: "Earth", url: "https://example.com/location/1"),
            image: "https://example.com/image.png",
            episode: ["https://example.com/episode/1"],
            url: "https://example.com/character/\(id)",
            created: "2017-11-04T18:48:46.250Z"
        )
    }
    
    static func paginatedResponse(results: [Character], pages: Int) -> PaginatedResponse<Character> {
        PaginatedResponse(
            info: PageInfo(count: results.count, pages: pages, next: nil, prev: nil),
            results: results
        )
    }
    
    static func location(id: Int = 1, name: String = "Earth") -> Location {
        Location(
            id: id,
            name: name,
            type: "Planet",
            dimension: "Dimension C-137",
            residents: [],
            url: "https://example.com/location/\(id)",
            created: "2017-11-04T18:48:46.250Z"
        )
    }
    
}
