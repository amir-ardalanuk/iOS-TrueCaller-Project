//
//  DefaultPropertyListUsecases.swift
//  Repository
//
//  Created by Amir on 8/27/1400 AP.
//

import Foundation
import Combine
import Core
import NetworkLayer

public struct DefaultProperyUsecases: PropertyListUsecases {
    
    let network: NetworkProtocol
    
    public init(network: NetworkProtocol) {
        self.network = network
    }
    
    public func fetchList(count: Int, page: Int) -> AnyPublisher<PropertyList, Error> {
        let pagingParameters = [
            "per_page": count,
            "page": page
        ]
        var urlComponent = URLComponents(string: Api.route.propertyList.rawValue)!
        urlComponent.queryItems = .init(pagingParameters)
        guard let url = urlComponent.url else {
            fatalError("URL not created correctly")
        }
        
        return network.request(.init(url: url), type: Api.PropertyList.self)
            .map { response -> PropertyList in
                let nextId: Int? = (response.meta.currentPage == response.meta.lastPage) ? nil : response.meta.currentPage.flatMap { $0 + 1 }
                return PropertyList(
                    list: response.data.map { Property(propertyItem: $0)},
                    hasMore: response.meta.currentPage != response.meta.lastPage,
                    nextId: nextId
                )
            }
            .eraseToAnyPublisher()
    }
}

extension Property {
    init(propertyItem: Api.PropertyItem) {
        self = .init(
            title: propertyItem.name ?? "Unknown",
            image: propertyItem.image.flatMap { URL(string: $0) },
            id: propertyItem.id, address: propertyItem.address ?? "address")
    }
}
