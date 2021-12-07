//
//  DefaultNetwork.swift
//  Network
//
//  Created by Amir on 8/27/1400 AP.
//

import Foundation
import Combine

final public class DefaultNetwork: NetworkProtocol {
    
    // MARK: - Property
    var urlSession: URLSession
    var decoder: AnyDecoder
    
    // MARK: - init
    public init(session: URLSession = URLSession.shared, decoder: AnyDecoder = DefaultDecoder()) {
        self.urlSession = session
        self.decoder = decoder
    }
    
    
    // MARK: - DefaultNetwork protocol api's
    
    public func request<T: Decodable>(_ request: URLRequest, result: @escaping (Result<T, NetworkError>) -> Void ) {
        urlSession.dataTask(with: request) { data, _, error in
            guard let data = data else {
                if let error = error {
                    result(.failure(.serverError("Something went wrong! Please try again later: error description" +  error.localizedDescription)))
                } else {
                    result(.failure(NetworkError.uknownError))
                }
                return
            }
            
            guard let decoder = try? self.decoder.decode(T.self, from: data) else {
                result(.failure(NetworkError.decoderError(.decodingFailed)))
                return
            }
            result(.success(decoder))
        }.resume()
    }
    
    // MARK: - Combine Request
    
    public func request<T: Decodable>(_ request: URLRequest, type: T.Type) -> AnyPublisher<T, Error> {
        return self.urlSession.dataTaskPublisher(for: request)
            .tryMap { data, _ in
                try self.decoder.decode(T.self, from: data)
            }
            .mapError({ error -> Error in
                return error
            })
            .eraseToAnyPublisher()
    }
}
