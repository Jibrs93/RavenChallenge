//
//  MockFetchUseCase.swift
//  RavenChallengeTests
//

@testable import RavenChallenge
import Foundation

final class MockFetchUseCase: FetchMostPopularArticlesUseCaseProtocol {
    var mockArticles: [Article] = []
    var shouldThrowError: Error?
    private(set) var executedPeriod: Int?

    func execute(period: Int) async throws -> [Article] {
        executedPeriod = period
        if let error = shouldThrowError { throw error }
        return mockArticles
    }
}

// MARK: - Article test factory

extension Article {
    static func mock(
        id: Int = 1,
        title: String = "Test Article",
        abstract: String = "Abstract text",
        byline: String = "By John Doe",
        publishedDate: String = "2024-01-15",
        section: String = "U.S.",
        url: String = "https://nytimes.com/test",
        thumbnailURL: String? = nil,
        imageURL: String? = nil,
        source: String = "The New York Times"
    ) -> Article {
        Article(
            id: id,
            title: title,
            abstract: abstract,
            byline: byline,
            publishedDate: publishedDate,
            section: section,
            url: url,
            thumbnailURL: thumbnailURL,
            imageURL: imageURL,
            source: source
        )
    }
}
