//
//  MockArticleRepository.swift
//  RavenChallengeTests
//

@testable import RavenChallenge
import Foundation

final class MockArticleRepository: ArticleRepositoryProtocol {
    var mockArticles: [Article] = []
    var shouldThrowError: Error?
    var cachedArticles: [Article] = []

    func fetchMostPopular(period: Int) async throws -> [Article] {
        if let error = shouldThrowError { throw error }
        return mockArticles
    }

    func fetchCachedArticles() -> [Article] {
        cachedArticles
    }
}
