//
//  NetworkError.swift
//  RavenChallenge
//
//  Created by Jonathan Lopez on 17/04/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Int)
    case noInternet
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida."
        case .noData:
            return "No se recibieron datos del servidor."
        case .decodingError(let error):
            return "Error al procesar la respuesta: \(error.localizedDescription)"
        case .serverError(let code):
            return "Error del servidor (código \(code))."
        case .noInternet:
            return "Sin conexión a internet. Mostrando artículos guardados."
        case .unknown(let error):
            return error.localizedDescription
        }
    }

    var isNoInternet: Bool {
        if case .noInternet = self { return true }
        if case .unknown(let e) = self {
            let ns = e as NSError
            return ns.domain == NSURLErrorDomain &&
                [NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost].contains(ns.code)
        }
        return false
    }
}
