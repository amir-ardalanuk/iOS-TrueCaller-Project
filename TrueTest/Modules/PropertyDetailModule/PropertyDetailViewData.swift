//
//  PropertyDetailViewData.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation
import Resolver
import Core

public struct PropertyDetailViewData: Equatable, ViewData {
    public static func == (lhs: PropertyDetailViewData, rhs: PropertyDetailViewData) -> Bool {
        lhs.id == rhs.id
    }
    
    public enum PropertyDetailViewType: Equatable {
        case profile(Property)
        case id(String)
    }
    
    let id: String
    public let resolverName: Resolver.Name
    public let type: PropertyDetailViewType
    
    public init(type: PropertyDetailViewType) {
        self.type = type
        id = UUID().uuidString
        resolverName = .init(id)
    }
}

