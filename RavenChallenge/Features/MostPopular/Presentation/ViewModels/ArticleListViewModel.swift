//
//  ArticleListViewModel.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import Foundation
import Combine

// MARK: - Loading state

enum LoadingState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
}

// MARK: - ViewModel

@MainActor
final class ArticleListViewModel: ObservableObject {

    // MARK: Published state
    @Published private(set) var articles: [Article] = []
    @Published private(set) var state: LoadingState = .idle
    @Published private(set) var isShowingCached = false
    @Published var selectedPeriod: Int = 7

    // MARK: Constants
    let periodOptions: [Int] = [1, 7, 30]

    // MARK: Dependencies
    private let useCase: FetchMostPopularArticlesUseCaseProtocol
    private let repository: ArticleRepositoryProtocol
    private var periodCancellable: AnyCancellable?

    init(
        useCase: FetchMostPopularArticlesUseCaseProtocol,
        repository: ArticleRepositoryProtocol
    ) {
        self.useCase = useCase
        self.repository = repository

        // Re-fetch automatically when period changes
        periodCancellable = $selectedPeriod
            .dropFirst()
            .sink { [weak self] _ in
                guard let self else { return }
                Task { await self.loadArticles() }
            }
    }

    // MARK: - Intents

    func loadArticles() async {
        guard state != .loading else { return }
        state = .loading
        isShowingCached = false

        do {
            let fetched = try await useCase.execute(period: selectedPeriod)
            articles = fetched
            state = .loaded
        } catch let error as NetworkError {
            if error.isNoInternet {
                let cached = repository.fetchCachedArticles()
                if !cached.isEmpty {
                    articles = cached
                    state = .loaded
                    isShowingCached = true
                    return
                }
            }
            articles = []
            state = .error(error.errorDescription ?? "Error desconocido")
        } catch {
            articles = []
            state = .error(error.localizedDescription)
        }
    }

    func retry() {
        Task { await loadArticles() }
    }
}
