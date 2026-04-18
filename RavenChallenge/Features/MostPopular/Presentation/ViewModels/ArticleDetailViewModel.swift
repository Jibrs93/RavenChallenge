//
//  ArticleDetailViewModel.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import Foundation

// ArticleDetailViewModel has no mutable state, so it does not need ObservableObject.
// The view holds it as a plain stored property.
@MainActor
final class ArticleDetailViewModel {
    let article: Article

    init(article: Article) {
        self.article = article
    }

    var articleURL: URL? {
        URL(string: article.url)
    }
}
