//
//  MostPopularAssembly.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import Foundation

enum MostPopularAssembly {
    static func makeArticleListViewModel() -> ArticleListViewModel {
        let networkService = NetworkService()
        let localStorage  = ArticleLocalStorage()
        let repository    = ArticleRepositoryImpl(
            networkService: networkService,
            localStorage: localStorage
        )
        let useCase = FetchMostPopularArticlesUseCase(repository: repository)
        return ArticleListViewModel(useCase: useCase, repository: repository)
    }
}
