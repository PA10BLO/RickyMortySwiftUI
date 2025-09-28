//
//  MainViewModel.swift
//  RickyMortySwiftUI
//
//  Created by Pablo on 18/9/25.
//

import Foundation

@Observable
final class MainViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case loading
        case loaded([Character], hasMore: Bool)
        case error(String)
        case noResults
    }
    
    private(set) var state: State = .idle
    var searchText: String = String.empty
    
    private let repository: RickyAndMortyCharactersRepositoryProtocol
    private var currentPage: Int = Constants.MainView.initialCurrentPage
    private var totalPages: Int = Constants.MainView.initialTotalPages
    private var isFetching = false
    private var lastQuery: String = String.empty
    
    init(repository: RickyAndMortyCharactersRepositoryProtocol) {
        self.repository = repository
    }
    
    func onAppear() {
        if case .idle = state { Task { await refresh() } }
    }
    
    func refresh() async {
        guard !isFetching else { return }
        isFetching = true
        defer { isFetching = false }
        state = .loading
        currentPage = 1
        lastQuery = searchText
        do {
            let response = try await repository.listCharacters(page: currentPage, name: lastQuery.isEmpty ? nil : lastQuery)
            totalPages = response.info.pages
            state = .loaded(response.results, hasMore: currentPage < totalPages)
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .noResults:
                    state = .noResults
                    
                    // opcional: casos especiales
                case .underlying(let err as URLError) where err.code == .timedOut:
                    state = .error("Se ha agotado el tiempo de espera.")
                    
                default:
                    state = .error(apiError.errorDescription ?? "Ha ocurrido un error.")
                }
            } else {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func loadMoreIfNeeded(currentItem item: Character?) async {
        guard
            case .loaded(let items, let hasMore) = state,
            hasMore,
            let item,
            let itemIndex = items.firstIndex(where: { $0.id == item.id })
        else { return }
        
        let offset = min(5, items.count)
        let thresholdIndex = items.index(items.endIndex, offsetBy: -offset)
        
        if itemIndex >= thresholdIndex {
            await loadNextPage()
        }
    }
    
    private func loadNextPage() async {
        guard !isFetching else { return }
        guard currentPage < totalPages else { return }
        isFetching = true
        defer { isFetching = false }
        do {
            currentPage += 1
            let response = try await repository.listCharacters(page: currentPage, name: lastQuery.isEmpty ? nil : lastQuery)
            if case .loaded(let existing, _) = state {
                let merged = existing + response.results
                state = .loaded(merged, hasMore: currentPage < response.info.pages)
            } else {
                state = .noResults
            }
        } catch {
            state = .error((error as? LocalizedError)?.errorDescription ?? error.localizedDescription)
        }
    }
}
