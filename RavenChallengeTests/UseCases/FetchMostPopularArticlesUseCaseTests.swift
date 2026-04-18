//
//  FetchMostPopularArticlesUseCaseTests.swift
//  RavenChallengeTests
//

import XCTest
@testable import RavenChallenge

final class FetchMostPopularArticlesUseCaseTests: XCTestCase {

    private var mockRepository: MockArticleRepository!
    private var sut: FetchMostPopularArticlesUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockArticleRepository()
        sut = FetchMostPopularArticlesUseCase(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Period validation

    func testExecute_withValidPeriod1_callsRepository() async throws {
        mockRepository.mockArticles = [.mock()]
        let result = try await sut.execute(period: 1)
        XCTAssertEqual(result.count, 1)
    }

    func testExecute_withValidPeriod7_callsRepository() async throws {
        mockRepository.mockArticles = [.mock(), .mock(id: 2)]
        let result = try await sut.execute(period: 7)
        XCTAssertEqual(result.count, 2)
    }

    func testExecute_withValidPeriod30_callsRepository() async throws {
        mockRepository.mockArticles = [.mock()]
        let result = try await sut.execute(period: 30)
        XCTAssertFalse(result.isEmpty)
    }

    func testExecute_withInvalidPeriod_throwsError() async {
        do {
            _ = try await sut.execute(period: 15)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }

    func testExecute_whenRepositoryThrows_propagatesError() async {
        mockRepository.shouldThrowError = NetworkError.serverError(500)
        do {
            _ = try await sut.execute(period: 7)
            XCTFail("Expected error")
        } catch let error as NetworkError {
            if case .serverError(let code) = error {
                XCTAssertEqual(code, 500)
            } else {
                XCTFail("Wrong error type")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testExecute_returnsArticlesFromRepository() async throws {
        let expected = Article.mock(title: "Expected Title")
        mockRepository.mockArticles = [expected]
        let result = try await sut.execute(period: 7)
        XCTAssertEqual(result.first?.title, "Expected Title")
    }
}
