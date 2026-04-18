//
//  ArticleRepositoryProtocol.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import Foundation

protocol ArticleRepositoryProtocol {
    /// Fetches most popular articles from the network. Falls back to cache when offline.
    func fetchMostPopular(period: Int) async throws -> [Article]
    /// Returns the last successfully cached articles (offline access).
    func fetchCachedArticles() -> [Article]
}
