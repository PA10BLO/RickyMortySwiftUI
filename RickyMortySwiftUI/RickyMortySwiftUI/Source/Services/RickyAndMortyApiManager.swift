//
//  RepositoryModel.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 18/9/25.
//

import Foundation

protocol Networking {
    func fetch<T: Decodable>(_ url: URL) async throws -> T
}

enum APIError: LocalizedError {
    case invalidURL
    case badStatus(Int)
    case decoding(Error)
    case underlying(Error)
    case noResults
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL inválida"
        case .badStatus(let code): return "Respuesta HTTP no válida: \(code)"
        case .decoding(let err): return "Error decodificando datos: \(err.localizedDescription)"
        case .underlying(let err): return err.localizedDescription
        case .noResults: return "No se han encontrado resultados"
        }
    }
}

extension APIError {
    enum Kind: Equatable {
        case invalidURL
        case badStatus(Int)
        case decoding
        case underlying
        case noResults
    }

    var kind: Kind {
        switch self {
        case .invalidURL:          return .invalidURL
        case .badStatus(let c):    return .badStatus(c)
        case .decoding:            return .decoding
        case .underlying:          return .underlying
        case .noResults:           return .noResults
        }
    }
}

enum APIResource: Equatable {
    
    case character(URL)
    case location(URL)
    case episode(URL)
    case unknown(URL)
    
    init(url: URL) {
        let path = url.path.lowercased()
        if path.contains("/character/") { self = .character(url) }
        else if path.contains("/location/") { self = .location(url) }
        else if path.contains("/episode/") { self = .episode(url) }
        else { self = .unknown(url) }
    }
}

struct RickyAndMortyApiManager: Networking {
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(_ url: URL) async throws -> T {
        do {
            var request = URLRequest(url: url)
            request.cachePolicy = .returnCacheDataElseLoad
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw APIError.badStatus(-1) }
            if http.statusCode == 404 {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errorMsg = json["error"] as? String,
                   errorMsg == "There is nothing here" {
                    throw APIError.noResults
                } else {
                    throw APIError.badStatus(404)
                }
            }
            guard 200..<300 ~= http.statusCode else { throw APIError.badStatus(http.statusCode) }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decoding(error)
            }
        } catch {
            throw APIError.noResults
        }
    }
}
