//
//  DefaultDecoder.swift
//  Network
//
//  Created by Amir on 8/27/1400 AP.
//

import Foundation

public class DefaultDecoder: AnyDecoder {
    
    public init() {}
    
    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return  try JSONDecoder().decode(T.self, from: data)
    }
}
