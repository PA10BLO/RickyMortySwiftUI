//
//  CharacterDetailViewModel.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 18/9/25.
//

import Foundation

@Observable
final class CharacterDetailViewModel: ObservableObject {
    var character: Character
    
    init(character: Character) {
        self.character = character
    }
}
