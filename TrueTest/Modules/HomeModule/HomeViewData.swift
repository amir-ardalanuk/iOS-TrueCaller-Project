//
//  HomeViewData.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation
import Resolver

public struct HomeViewData: Equatable, ViewData {
    public static func == (lhs: HomeViewData, rhs: HomeViewData) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    public let resolverName: Resolver.Name
    public init() {
        id = UUID().uuidString
        resolverName = .init(id)
    }
}
