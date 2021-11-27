//
//  NetworkProtocol.swift
//  Network
//
//  Created by Amir on 8/27/1400 AP.
//

import Foundation
import Combine

public enum NetworkError: Error, Equatable {
    case uknownError
    case decoderError(DecoderError)
    case serverError(String)
    case invalidURL
}

public protocol NetworkProtocol {
    func request<T: Decodable>(_ request: URLRequest, result: @escaping (Result<T, NetworkError>) -> Void )
    func request<T: Decodable>(_ request: URLRequest, type: T.Type) -> AnyPublisher<T, Error>
}
