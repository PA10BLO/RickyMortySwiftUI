//
//  ResidentRowViewModelTests.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 21/9/25.
//

import XCTest
@testable import RickyMortySwiftUI

@MainActor
class LocationInfoViewModelTests: XCTestCase {

    func testLoadSuccessStoresLocation() async {
        let repository = MockRepository()
        let url = URL(string: "https://example.com/location/1")!
        let location = TestFixtures.location(id: 1, name: "Earth")
        repository.fetchLocationResults = [
            .success(location)
        ]
        let sut = LocationInfoViewModel(url: url, repo: repository)

        await sut.load()

        XCTAssertEqual(sut.location, location)
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(repository.fetchLocationURLs, [url])
    }

    func testLoadFailureSetsError() async {
        let repository = MockRepository()
        let url = URL(string: "https://example.com/location/99")!
        repository.fetchLocationResults = [
            .failure(APIError.badStatus(404))
        ]
        let sut = LocationInfoViewModel(url: url, repo: repository)

        await sut.load()

        XCTAssertNil(sut.location)
        XCTAssertEqual(sut.error, APIError.badStatus(404).errorDescription)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(repository.fetchLocationURLs, [url])
    }
}
