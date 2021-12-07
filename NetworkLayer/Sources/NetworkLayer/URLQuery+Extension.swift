//
//  URLQuery.swift
//  Network
//
//  Created by Amir on 8/27/1400 AP.
//

import Foundation

public extension Collection where Element == URLQueryItem {
    subscript(_ name: String) -> String? {
        first(where: { $0.name == name })?.value
    }
}

public extension Array where Element == URLQueryItem {
    init<T: LosslessStringConvertible>(_ dictionary: [String: T]) {
        self = dictionary.map({ (key, value) -> Element in
            URLQueryItem(name: key, value: String(value))
        })
    }
}
