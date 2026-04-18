//
//  PreviewHelpers.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

#if DEBUG
import Foundation

// MARK: - Mock Article

extension Article {
    static func previewMock(
        id: Int = 1,
        title: String = "Can AI Fix America's Broken Political Conversation?",
        abstract: String = "Researchers believe that artificial intelligence could help bridge partisan divides, but critics warn that the same technology could deepen them further.",
        byline: String = "By Jonathan López",
        publishedDate: String = "2024-04-17",
        section: String = "Technology",
        url: String = "https://www.nytimes.com",
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

    static var previewList: [Article] {
        [
            .previewMock(id: 1, title: "Can AI Fix America's Broken Political Conversation?", section: "Technology"),
            .previewMock(id: 2, title: "The Hidden Costs of Remote Work on Urban Economies", byline: "By Maria García", section: "Business"),
            .previewMock(id: 3, title: "A New Study Links Ultra-Processed Foods to Early Death", byline: "By Dr. Ana Ruiz", section: "Health"),
            .previewMock(id: 4, title: "Inside the Race to Build the Next Generation of Batteries", byline: "By Carlos Mendoza", section: "Science"),
            .previewMock(id: 5, title: "How a Small Town in Ohio Became Ground Zero for the Opioid Crisis", byline: "By Sarah Johnson", section: "U.S."),
        ]
    }
}

// MARK: - Mock Repository & UseCase

final class PreviewArticleRepository: ArticleRepositoryProtocol {
    var articles: [Article]
    init(articles: [Article] = Article.previewList) { self.articles = articles }
    func fetchMostPopular(period: Int) async throws -> [Article] { articles }
    func fetchCachedArticles() -> [Article] { articles }
}

final class PreviewFetchUseCase: FetchMostPopularArticlesUseCaseProtocol {
    var articles: [Article]
    init(articles: [Article] = Article.previewList) { self.articles = articles }
    func execute(period: Int) async throws -> [Article] { articles }
}

// MARK: - ViewModel factories

extension ArticleListViewModel {
    static func previewLoaded() -> ArticleListViewModel {
        let repo = PreviewArticleRepository()
        let vm = ArticleListViewModel(useCase: PreviewFetchUseCase(), repository: repo)
        // Pre-populate without async
        return vm
    }
}
#endif
