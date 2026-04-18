//
//  ArticleListViewModelTests.swift
//  RavenChallengeTests
//

import XCTest
@testable import RavenChallenge

@MainActor
final class ArticleListViewModelTests: XCTestCase {

    private var mockUseCase: MockFetchUseCase!
    private var mockRepository: MockArticleRepository!
    private var sut: ArticleListViewModel!

    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchUseCase()
        mockRepository = MockArticleRepository()
        sut = ArticleListViewModel(useCase: mockUseCase, repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockUseCase = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Initial state

    func testInitialState_isIdle() {
        XCTAssertEqual(sut.state, .idle)
        XCTAssertTrue(sut.articles.isEmpty)
        XCTAssertFalse(sut.isShowingCached)
    }

    func testInitialPeriod_isSeven() {
        XCTAssertEqual(sut.selectedPeriod, 7)
    }

    func testPeriodOptions_containsOneSevenThirty() {
        XCTAssertEqual(sut.periodOptions, [1, 7, 30])
    }

    // MARK: - Load articles — success

    func testLoadArticles_success_stateIsLoaded() async {
        mockUseCase.mockArticles = [.mock()]
        await sut.loadArticles()
        XCTAssertEqual(sut.state, .loaded)
    }

    func testLoadArticles_success_articlesArePopulated() async {
        let articles = [Article.mock(id: 1), Article.mock(id: 2)]
        mockUseCase.mockArticles = articles
        await sut.loadArticles()
        XCTAssertEqual(sut.articles.count, 2)
    }

    func testLoadArticles_success_isShowingCachedIsFalse() async {
        mockUseCase.mockArticles = [.mock()]
        await sut.loadArticles()
        XCTAssertFalse(sut.isShowingCached)
    }

    // MARK: - Load articles — network error

    func testLoadArticles_networkError_stateIsError() async {
        mockUseCase.shouldThrowError = NetworkError.serverError(503)
        await sut.loadArticles()
        if case .error = sut.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected error state")
        }
    }

    func testLoadArticles_networkError_articlesAreEmpty() async {
        mockUseCase.shouldThrowError = NetworkError.serverError(503)
        await sut.loadArticles()
        XCTAssertTrue(sut.articles.isEmpty)
    }

    // MARK: - Offline fallback

    func testLoadArticles_noInternet_withCache_showsCachedArticles() async {
        mockUseCase.shouldThrowError = NetworkError.noInternet
        mockRepository.cachedArticles = [.mock(title: "Cached")]
        await sut.loadArticles()
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertTrue(sut.isShowingCached)
        XCTAssertEqual(sut.articles.first?.title, "Cached")
    }

    func testLoadArticles_noInternet_noCache_stateIsError() async {
        mockUseCase.shouldThrowError = NetworkError.noInternet
        mockRepository.cachedArticles = []
        await sut.loadArticles()
        if case .error = sut.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected error state when no cache available")
        }
    }

    // MARK: - UseCases receives correct period

    func testLoadArticles_passesSelectedPeriodToUseCase() async {
        sut.selectedPeriod = 30
        mockUseCase.mockArticles = [.mock()]
        await sut.loadArticles()
        XCTAssertEqual(mockUseCase.executedPeriod, 30)
    }
}
