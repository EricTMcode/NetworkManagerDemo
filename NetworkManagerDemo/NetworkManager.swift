//
//  NetworkManager.swift
//  NetworkManagerDemo
//
//  Created by Eric on 12/03/2026.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case request(String)
    case httpReponse
    case httpStatusCode(Int)
    case decoding

    var userMessage: String {
        switch self {
        case .request(let message):
            message
        case .httpStatusCode(let code):
            switch code {
            case 401: "Your session has expired. Please sign in again."
            case 403: "You don't have permission to do that."
            case 404: "We couldn't find what you were looking for."
            case 429: "Too many requests. Please try again later."
            case 500...599: "The server is having trouble, please try again later."
            default: "Something went wrong. Please try again later."
            }
        default: "Something went wrong. Please try again later."
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }

    func fetchAndDecodeJSON<T: Decodable>(from url: String, configureDecoder: ((JSONDecoder) -> ())? = nil) async throws(NetworkError) -> T {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            throw NetworkError.badURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Network error: Response was not HTTPURLResponse")
                throw NetworkError.httpReponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP error: status code \(httpResponse.statusCode)")
                throw NetworkError.httpStatusCode(httpResponse.statusCode)
            }

            do {
                let decoder = JSONDecoder()
                configureDecoder?(decoder)
                return try decoder.decode(T.self, from: data)
            } catch let error as DecodingError {
                print(decodingError(error: error))
                throw NetworkError.decoding
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                print("Data as string: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
                throw NetworkError.decoding
            }

        } catch {
            print("Request error \(error.localizedDescription)")
            throw NetworkError.request(error.localizedDescription)
        }
    }

    func decodingError(error: DecodingError) -> String {
        switch error {
        case .typeMismatch(let type, let context):
            """
            Decoding Error: Type mismatch for type \(type)
            Context: \(context.debugDescription)
            Coding path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
            """
        case .valueNotFound(let type, let context):
            """
            Decoding Error: Value of type \(type) not found
            Context: \(context.debugDescription)
            Coding path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
            """
        case .keyNotFound(let codingKey, let context):
            """
            Decoding Error: Key '\(codingKey.stringValue)' not found
            Context: \(context.debugDescription)
            Coding path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
            """
        case .dataCorrupted(let context):
            """
            Decoding Error: Data corrupted
            Context: \(context.debugDescription)
            Coding path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
            """
        @unknown default:
            """
            Unknown error: \(error.localizedDescription)
            """
        }
    }
}
