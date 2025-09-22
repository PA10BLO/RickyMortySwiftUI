//
//  ErrorView.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 18/9/25.
//

import SwiftUI

struct Tag: View {
    let text: String;
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.thinMaterial, in: Capsule())
    } }

struct ErrorView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: Constants.ErrorView.sfError)
                .font(.system(size: 42, weight: .semibold))
            Text("errorView.ErrorMessage".localized)
                .font(.title3).bold()
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("errorView.retry".localized, action: retry)
                .buttonStyle(.borderedProminent)
                .tint(Color.green)
        }
        .padding()
    }
}

#Preview {
    ErrorView(
        message: "No se pudo cargar la información del servidor.",
        retry: { print("Retry tapped") }
    )
}
