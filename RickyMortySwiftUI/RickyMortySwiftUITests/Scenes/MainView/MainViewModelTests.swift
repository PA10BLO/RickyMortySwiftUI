//
//  MainViewModelTests.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 21/9/25.
//

import XCTest
@testable import RickyMortySwiftUI

@MainActor
final class MainViewModelTests: XCTestCase {
    func testRefreshSuccessUpdatesStateToLoaded() async {
        let repository = MockRepository()
        let character = TestFixtures.character(id: 1, name: "Rick Sanchez")
        repository.listCharactersResults = [
            .success(TestFixtures.paginatedResponse(results: [character], pages: 1))
        ]
        
        let sut = MainViewModel(repository: repository)
        await sut.refresh()
        XCTAssertEqual(sut.state, .loaded([character], hasMore: false))
        XCTAssertEqual(repository.listCharactersParameters.map(\.page), [1])
        XCTAssertEqual(repository.listCharactersParameters.map(\.name), [nil])
    }
    
    func testRefreshFailureUpdatesStateToError() async {
        let repository = MockRepository()
        repository.listCharactersResults = [
            .failure(APIError.badStatus(500))
        ]
        let sut = MainViewModel(repository: repository)
        await sut.refresh()
        
        XCTAssertEqual(sut.state, .error(APIError.badStatus(500).errorDescription ?? .empty))
    }
    
    func testLoadMoreIfNeededAppendsNextPage() async {
        let repository = MockRepository()
        let firstPage = (1...10).map { TestFixtures.character(id: $0, name: "Character \($0)") }
        let secondPage = (11...15).map { TestFixtures.character(id: $0, name: "Character \($0)") }
        repository.listCharactersResults = [
            .success(TestFixtures.paginatedResponse(results: firstPage, pages: 2)),
            .success(TestFixtures.paginatedResponse(results: secondPage, pages: 2))
        ]
        let sut = MainViewModel(repository: repository)
        
        await sut.refresh()
        
        guard case .loaded(_, let hasMore) = sut.state else {
            return XCTFail("Expected loaded state after refresh")
        }
        XCTAssertTrue(hasMore)
        
        await sut.loadMoreIfNeeded(currentItem: firstPage[5])
        
        XCTAssertEqual(sut.state, .loaded(firstPage + secondPage, hasMore: false))
        XCTAssertEqual(repository.listCharactersParameters.map(\.page), [1, 2])
    }
    
    func testRefreshUsesSearchQueryWhenTextIsNotEmpty() async {
        let repository = MockRepository()
        repository.listCharactersResults = [
            .success(TestFixtures.paginatedResponse(results: [], pages: 1))
        ]
        let sut = MainViewModel(repository: repository)
        sut.searchText = "Morty"
        
        await sut.refresh()
        
        XCTAssertEqual(repository.listCharactersParameters.map(\.name), [sut.searchText])
    }
}
