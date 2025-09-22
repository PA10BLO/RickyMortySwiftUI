//
//  CharacterTypes.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 21/9/25.
//

import Foundation

enum LifeStatus: String {
    
    case alive
    case dead
    case unknown
    
    init(from string: String) {
        switch string.lowercased() {
            case "alive": self = .alive
            case "dead":  self = .dead
            default:      self = .unknown
        }
    }
    
    var localized: String {
        switch self {
            case .alive:   return "lifeStatus.alive".localized
            case .dead:    return "lifeStatus.dead".localized
            case .unknown: return "characterDetail.unknown".localized
        }
    }
}

enum Gender: String {
    case male
    case female
    case genderless
    case unknown
    
    init(from string: String) {
        switch string.lowercased() {
            case "male":       self = .male
            case "female":     self = .female
            case "genderless": self = .genderless
            default:           self = .unknown
        }
    }
    
    var localized: String {
        switch self {
            case .male:       return "gender.male".localized
            case .female:     return "gender.female".localized
            case .genderless: return "gender.genderless".localized
            case .unknown:    return "gender.unknown".localized
        }
    }
}

enum Species: String {
    
    case human,
         alien,
         humanoid,
         poopybutthole,
         mythologicalCreature,
         animal,
         robot,
         cronenberg,
         disease,
         planet,
         unknown
    
    init(from string: String) {
        switch string.lowercased() {
            case "human":                 self = .human
            case "alien":                 self = .alien
            case "humanoid":              self = .humanoid
            case "poopybutthole":         self = .poopybutthole
            case "mythological creature",
                "mythological":           self = .mythologicalCreature
            case "animal":                self = .animal
            case "robot":                 self = .robot
            case "cronenberg":            self = .cronenberg
            case "disease":               self = .disease
            case "planet":                self = .planet
            default:                      self = .unknown
        }
    }
    
    var localized: String {
        switch self {
            case .human:                return "species.human".localized
            case .alien:                return "species.alien".localized
            case .humanoid:             return "species.humanoid".localized
            case .poopybutthole:        return "species.poopybutthole".localized
            case .mythologicalCreature: return "species.mythological_creature".localized
            case .animal:               return "species.animal".localized
            case .robot:                return "species.robot".localized
            case .cronenberg:           return "species.cronenberg".localized
            case .disease:              return "species.disease".localized
            case .planet:               return "species.planet".localized
            case .unknown:              return "species.unknown".localized
        }
    }
}
