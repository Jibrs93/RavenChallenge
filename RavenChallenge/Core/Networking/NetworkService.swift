//
//  NetworkService.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        do {
            let (data, response) = try await session.data(from: url)

            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }
            guard (200...299).contains(http.statusCode) else {
                throw NetworkError.serverError(http.statusCode)
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            let ns = error as NSError
            if ns.domain == NSURLErrorDomain &&
               [NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost].contains(ns.code) {
                throw NetworkError.noInternet
            }
            throw NetworkError.unknown(error)
        }
    }
}
