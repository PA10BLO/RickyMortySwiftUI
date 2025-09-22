//
//  CharacterDetailViewModelTests.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 21/9/25.
//

import XCTest
@testable import RickyMortySwiftUI

@MainActor
class CharacterDetailViewModelTests: XCTestCase {
    
    func testLoadCharacterUpdatesState() async {
        let repository = MockRepository()
        let character = TestFixtures.character(id: 42, name: "Character 42")
        repository.fetchCharacterResults = [
            .success(character)
        ]
        let url = URL(string: "https://example.com/character/42")!
        let sut = ResourceDetailViewModel(repo: repository, url: url)
        
        await sut.load()
        
        XCTAssertEqual(sut.state, .character(character))
        XCTAssertEqual(repository.fetchCharacterURLs, [url])
    }
    
    func testLoadLocationUpdatesState() async {
        let repository = MockRepository()
        let location = TestFixtures.location(id: 7, name: "Citadel")
        repository.fetchLocationResults = [
            .success(location)
        ]
        let url = URL(string: "https://example.com/location/7")!
        let sut = ResourceDetailViewModel(repo: repository, url: url)
        
        await sut.load()
        
        XCTAssertEqual(sut.state, .location(location))
        XCTAssertEqual(repository.fetchLocationURLs, [url])
    }
    
    func testLoadEpisodeFailureSetsErrorState() async {
        let repository = MockRepository()
        repository.fetchEpisodeResults = [
            .failure(APIError.badStatus(404))
        ]
        let url = URL(string: "https://example.com/episode/404")!
        let sut = ResourceDetailViewModel(repo: repository, url: url)
        
        await sut.load()
        
        XCTAssertEqual(sut.state, .error(APIError.badStatus(404).errorDescription ?? .empty))
        XCTAssertEqual(repository.fetchEpisodeURLs, [url])
    }
}
