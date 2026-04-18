//
//  ArticleResponseDTO.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import Foundation

// MARK: - Root response

struct MostPopularResponse: Decodable {
    let status: String
    let numResults: Int
    let results: [ArticleDTO]

    enum CodingKeys: String, CodingKey {
        case status
        case numResults = "num_results"
        case results
    }
}

// MARK: - Article DTO

struct ArticleDTO: Decodable {
    let id: Int
    let title: String
    let abstract: String
    let byline: String
    let publishedDate: String
    let section: String
    let url: String
    let media: [MediaDTO]?
    let source: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case abstract
        case byline
        case publishedDate = "published_date"
        case section
        case url
        case media
        case source
    }

    func toDomain() -> Article {
        let imageMedia = media?.first { $0.type == "image" }
        let thumbnail = imageMedia?.mediaMetadata?
            .first { $0.format == "Standard Thumbnail" }?.url
        let largestImage = imageMedia?.mediaMetadata?
            .max { $0.width < $1.width }?.url

        return Article(
            id: id,
            title: title,
            abstract: abstract,
            byline: byline,
            publishedDate: publishedDate,
            section: section,
            url: url,
            thumbnailURL: thumbnail,
            imageURL: largestImage,
            source: source
        )
    }
}

// MARK: - Media DTOs

struct MediaDTO: Decodable {
    let type: String
    let mediaMetadata: [MediaMetadataDTO]?

    enum CodingKeys: String, CodingKey {
        case type
        case mediaMetadata = "media-metadata"
    }
}

struct MediaMetadataDTO: Decodable {
    let url: String
    let format: String
    let height: Int
    let width: Int
}
