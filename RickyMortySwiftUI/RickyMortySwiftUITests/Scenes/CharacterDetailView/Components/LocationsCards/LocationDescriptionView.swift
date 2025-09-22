//
//  LocationDescriptionView.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 21/9/25.
//

import XCTest
@testable import RickyMortySwiftUI
import SwiftUICore

@MainActor
class LocationDescriptionViewTests: XCTestCase {

    func testInitializerStoresURL() {
        let url = URL(string: "https://example.com/location/5")!
        let sut = LocationDescription(url: url)

        XCTAssertEqual(sut.url, url)
    }
}
