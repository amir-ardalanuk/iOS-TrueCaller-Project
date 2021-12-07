#if DEBUG
//
//  MockPropertyListUsecase.swift
//  Core
//
//  Created by Amir on 8/27/1400 AP.
//

import Foundation
import Combine

public final class MockPropertyListUsecases: PropertyListUsecases {
    
    public init() {}
    
    public var resultProvider: (() -> AnyPublisher<PropertyList, Error>)?
    
    public func fetchList(count: Int, page: Int) -> AnyPublisher<PropertyList, Error> {
        if let provider = resultProvider?() {
            return provider
        }
        return Just(.stub())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

#endif
