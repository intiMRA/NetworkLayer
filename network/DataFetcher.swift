//
//  DataFetcher.swift
//
//  Created by Inti Albuquerque on 14/08/22.
//

import Foundation

protocol DecoderProtocol {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

protocol EncoderProtocol {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}
extension JSONDecoder: DecoderProtocol {}
extension JSONEncoder: EncoderProtocol {}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum DataFetcherUtils {
    private static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    static func defaultDecoder(
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    ) -> JSONDecoder {
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

extension Encodable {
    func encode(encoder: EncoderProtocol) -> Data? {
        return try? encoder.encode(self)
    }
}

struct DataFetcherRequest {
    let url: String
    let headers: [String: String]?
    let body: Data?
    let requestTimeOut: Float?
    let httpMethod: HTTPMethod
    
    init(url: String,
                headers: [String: String]? = nil,
                reqBody: Encodable? = nil,
                reqTimeout: Float? = nil,
                httpMethod: HTTPMethod,
                encoder: EncoderProtocol = DataFetcherUtils.encoder
    ) {
        self.url = url
        self.headers = headers
        self.body = reqBody?.encode(encoder: encoder)
        self.requestTimeOut = reqTimeout
        self.httpMethod = httpMethod
    }
    
    func buildURLRequest(with url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers ?? [:]
        urlRequest.httpBody = body
        return urlRequest
    }
}

struct DataFetcherError: Error {
    let title: String
    let message: String
}

protocol DataFetcherProtocol {
    var requestTimeOut: Float { get }
    
    func request<ResponseType: Decodable>(_ req: DataFetcherRequest, decoder: DecoderProtocol) async throws -> ResponseType
}

actor DataFetcher: DataFetcherProtocol {
    
    static let defaultDataFetcher = DataFetcher()
    
    let requestTimeOut: Float
    
    init(requestTimeOut: Float = 30) {
        self.requestTimeOut = requestTimeOut
    }
    
    func request<ResponseType: Decodable>(
        _ req: DataFetcherRequest,
        decoder: DecoderProtocol = DataFetcherUtils.defaultDecoder()) async throws -> ResponseType {
            
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = TimeInterval(req.requestTimeOut ?? requestTimeOut)
            
            guard let url = URL(string: req.url) else {
                throw DataFetcherError(
                    title: "Invalid Url",
                    message: "The Url you are trying to call in not valid"
                )
            }
            let data = try await URLSession.shared.data(for: req.buildURLRequest(with: url))
            return try decoder.decode(ResponseType.self, from: data.0)
        }
}
