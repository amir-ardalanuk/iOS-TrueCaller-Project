#if DEBUG
//
//  MockDecoder.swift
//  Network
//
//  Created by amir ardalani on 8/27/1400 AP.
//

import Foundation

public final class MockDecoder: AnyDecoder {
    
    public var decodeProvider: (() -> Decodable)?
    
    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        if let provider = decodeProvider, let data = provider() as? T {
            return data
        }
        throw DecoderError.decodingFailed
    }
    
    
}
#endif
