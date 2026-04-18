//
//  APIEndpoint.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//
//  Docs: https://developer.nytimes.com/docs/most-popular-product/1/overview
//

import Foundation

enum APIEndpoint {
    private static let apiKey = "qTl6HA9lEk9bHwEMNSrdjRAceMnSqQEZ"

    case viewed(period: Int)
    case shared(period: Int)
    case emailed(period: Int)

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nytimes.com"
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "api-key", value: APIEndpoint.apiKey)
        ]
        return components.url
    }

    private var path: String {
        switch self {
        case .viewed(let period):  return "/svc/mostpopular/v2/viewed/\(period).json"
        case .shared(let period):  return "/svc/mostpopular/v2/shared/\(period).json"
        case .emailed(let period): return "/svc/mostpopular/v2/emailed/\(period).json"
        }
    }
}
