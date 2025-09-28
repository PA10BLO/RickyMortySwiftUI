//
//  LocationCharactersRow.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 19/9/25.
//

import SwiftUI

struct ResidentsRowView : View {
    
    let spacing: CGFloat = 12
    @State var viewModel: ResidentsRowViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("residentsRow.title".localized).font(.headline)
            
            switch viewModel.state {
            case .loading:
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<8, id: \.self) { _ in AvatarSkeleton() }
                    }
                    .padding(.vertical, 4)
                }
            case .error(let msg):
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text(msg).font(.footnote)
                }
                .foregroundColor(.secondary)
                
            case .loaded(let characters):
                if characters.isEmpty {
                    Text("residentsRow.noResidents".localized).foregroundStyle(.secondary)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(characters) { character in
                                NavigationLink(value: character) {
                                    VStack(spacing: 6) {
                                        AsyncImage(url: URL(string: character.image)) { phase in
                                            switch phase {
                                                case .empty: AvatarSkeleton()
                                                case .success(let img): img.resizable().scaledToFill()
                                                case .failure: Image(systemName: "person.fill")
                                                @unknown default: EmptyView()
                                            }
                                        }
                                        .navigationTitle(String.empty)
                                        .frame(width: 72, height: 72)
                                        .clipShape(Circle())
                                        .overlay(Circle().strokeBorder(Color.green.opacity(0.7), lineWidth: 1))
                                        
                                        Text(character.name)
                                            .font(.caption)
                                            .foregroundColor(Color.green)
                                            .bold()
                                            .lineLimit(Constants.Common.defaultLineLimit)
                                            .frame(width: 80)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .task { await viewModel.load() }
    }
}

struct AvatarSkeleton: View {
    var body: some View { Circle().fill(.gray.opacity(0.15)).frame(width: 72, height: 72) }
}
