//
//  RavenChallengeTests.swift
//  RavenChallengeTests
//
//  Created by Jonathan Lopez on 17/04/26.
//

// RavenChallengeTests.swift
// Main test suite entry. Feature-specific tests are in their own files:
//   - ViewModels/ArticleListViewModelTests.swift
//   - UseCases/FetchMostPopularArticlesUseCaseTests.swift

import Testing
@testable import RavenChallenge

struct RavenChallengeTests {
    @Test func articleCleanByline_removesByPrefix() {
        let article = Article.mock(byline: "By Jane Doe")
        #expect(article.cleanByline == "Jane Doe")
    }

    @Test func articleCleanByline_noPrefix_unchanged() {
        let article = Article.mock(byline: "Jane Doe")
        #expect(article.cleanByline == "Jane Doe")
    }

    @Test func articleSectionUppercased_isUppercase() {
        let article = Article.mock(section: "technology")
        #expect(article.sectionUppercased == "TECHNOLOGY")
    }
}
