//
//  ArticleRepositoryImpl.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import Foundation

final class ArticleRepositoryImpl: ArticleRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let localStorage: ArticleLocalStorage

    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        localStorage: ArticleLocalStorage = ArticleLocalStorage()
    ) {
        self.networkService = networkService
        self.localStorage = localStorage
    }

    func fetchMostPopular(period: Int) async throws -> [Article] {
        guard let url = APIEndpoint.viewed(period: period).url else {
            throw NetworkError.invalidURL
        }

        do {
            let response: MostPopularResponse = try await networkService.fetch(
                MostPopularResponse.self, from: url
            )
            let articles = response.results.map { $0.toDomain() }
            localStorage.save(articles)
            return articles
        } catch let error as NetworkError where error.isNoInternet {
            let cached = localStorage.load()
            if !cached.isEmpty { return cached }
            throw error
        }
    }

    func fetchCachedArticles() -> [Article] {
        localStorage.load()
    }
}
