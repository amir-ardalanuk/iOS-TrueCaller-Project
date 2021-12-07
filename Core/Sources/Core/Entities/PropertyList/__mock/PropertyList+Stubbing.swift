//
//  Property+Stubing.swift
//  Core
//
//  Created by Amir on 8/27/1400 AP.
//

import Foundation

public extension PropertyList {
    static func stub(hasMore: Bool = false, nextId: Int? = nil) -> PropertyList {
        .init(list: [.stub()], hasMore: hasMore, nextId: nextId)
    }
}
