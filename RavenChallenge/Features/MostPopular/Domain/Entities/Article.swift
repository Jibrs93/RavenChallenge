//
//  Article.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import Foundation

struct Article: Identifiable, Codable, Equatable, Sendable {
    let id: Int
    let title: String
    let abstract: String
    let byline: String
    let publishedDate: String
    let section: String
    let url: String
    let thumbnailURL: String?
    let imageURL: String?
    let source: String

    // MARK: - Computed helpers

    var formattedDate: String {
        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd"
        guard let date = input.date(from: publishedDate) else { return publishedDate }
        let output = DateFormatter()
        output.dateStyle = .medium
        output.timeStyle = .none
        return output.string(from: date)
    }

    var cleanByline: String {
        byline.hasPrefix("By ") ? String(byline.dropFirst(3)) : byline
    }

    var sectionUppercased: String {
        section.uppercased()
    }
}
