//
//  Status.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 18/9/25.
//

import SwiftUI

extension LifeStatus {
    var color: Color {
        switch self {
            case .alive:   return .green
            case .dead:    return .red
            case .unknown: return .gray
        }
    }
}

struct SubheadlineCharacterTitleView: View {
    
    let status: LifeStatus
    let species: Species
    let gender: Gender?
    var size: CGFloat = 10
    
    init(status: LifeStatus, species: Species, gender: Gender? = nil, size: CGFloat = 10) {
        self.status = status
        self.species = species
        self.gender = gender
        self.size = size
    }
    
    private var descriptionText: String {
        let parts: [String?] = [
            "\(status.localized.localized) • \(species.localized.localized)",
            gender?.localized.localized
        ]
        return parts.compactMap { $0 }.joined(separator: " • ")
    }
    
    var body: some View {
        Circle()
            .fill(status.color)
            .frame(width: size, height: size)
        Text(descriptionText)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .lineLimit(Constants.Common.defaultLineLimit)
    }
}
