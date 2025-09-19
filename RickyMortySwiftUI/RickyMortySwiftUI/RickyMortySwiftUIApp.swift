//
//  RickyMortySwiftUIApp.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 18/9/25.
//

import SwiftUI

@main
struct RickyMortySwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(
                viewModel: MainViewModel(
                    repository: RickyAndMortyCharactersRepository()
                )
            )
        }
    }
}
