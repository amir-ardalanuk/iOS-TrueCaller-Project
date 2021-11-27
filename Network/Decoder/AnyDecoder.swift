//
//  AnyDecoder.swift
//  Network
//
//  Created by Amir on 8/27/1400 AP.
//

import Foundation

public enum DecoderError: Error {
    case decodingFailed
}

public protocol AnyDecoder {
  func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}
