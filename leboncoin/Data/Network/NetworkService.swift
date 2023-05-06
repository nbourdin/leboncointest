//
//  NetworkService.swift
//  leboncoin
//
//  Created by Nicolas on 04/05/2023.
//

import Foundation

protocol NetworkService: AnyObject {

    @discardableResult
    func load<T>(_ resource: Resource<T>) async -> Result<T, NetworkError>
}

/// Defines the Network service errors.
enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case jsonDecodingError
    case unknownError(error: Error)
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidRequest, .invalidRequest):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.jsonDecodingError, .jsonDecodingError):
            return true
        case let (.unknownError(lhsError), .unknownError(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

protocol AppJSONDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

final class AppJSONDecoderImpl: JSONDecoder, AppJSONDecoder {
    override init() {
        super.init()
        self.dateDecodingStrategy = .formatted(.iso8601Full)
    }
}


final class NetworkServiceImpl: NetworkService {
    private let session: URLSession
    private let decoder: AppJSONDecoder
    init(
        session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral),
        decoder: AppJSONDecoder = AppJSONDecoderImpl()
    ) {
        self.session = session
        self.decoder = decoder
    }

    @discardableResult
    func load<T>(_ resource: Resource<T>) async -> Result<T, NetworkError> {
        do {
            let (data, response) = try await session.data(from: resource.url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                return .failure(.invalidResponse)
            }
            
            guard let dto = try? decoder.decode(T.self, from: data) else {
                return .failure(.jsonDecodingError)
            }
            return .success(dto)
        } catch let error {
            return .failure(.unknownError(error: error))
        }
        

    }

}

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+SSSS"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
