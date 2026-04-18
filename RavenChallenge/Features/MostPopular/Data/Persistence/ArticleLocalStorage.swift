//
//  ArticleLocalStorage.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import Foundation

final class ArticleLocalStorage {
    private let fileName = "nyt_popular_articles.json"

    private var fileURL: URL? {
        FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(fileName)
    }

    func save(_ articles: [Article]) {
        guard let url = fileURL else { return }
        guard let data = try? JSONEncoder().encode(articles) else { return }
        try? data.write(to: url, options: .atomic)
    }

    func load() -> [Article] {
        guard
            let url = fileURL,
            let data = try? Data(contentsOf: url),
            let articles = try? JSONDecoder().decode([Article].self, from: data)
        else { return [] }
        return articles
    }

    func clear() {
        guard let url = fileURL else { return }
        try? FileManager.default.removeItem(at: url)
    }
}
