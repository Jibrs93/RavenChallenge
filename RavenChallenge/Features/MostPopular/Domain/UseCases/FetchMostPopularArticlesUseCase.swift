//
//  FetchMostPopularArticlesUseCase.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import Foundation

protocol FetchMostPopularArticlesUseCaseProtocol {
    func execute(period: Int) async throws -> [Article]
}

final class FetchMostPopularArticlesUseCase: FetchMostPopularArticlesUseCaseProtocol {
    private let repository: ArticleRepositoryProtocol

    init(repository: ArticleRepositoryProtocol) {
        self.repository = repository
    }

    func execute(period: Int) async throws -> [Article] {
        guard [1, 7, 30].contains(period) else {
            throw NetworkError.invalidURL
        }
        return try await repository.fetchMostPopular(period: period)
    }
}
