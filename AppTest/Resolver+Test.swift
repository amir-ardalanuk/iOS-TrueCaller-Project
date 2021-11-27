//
//  Resolver+Test.swift
//  APITests
//
//  Created by amir ardalan on 8/19/21.
//
import Foundation
@testable import TrueTest
import Repository
import Core
import Resolver

extension Resolver {
    // MARK: - Mock Container
    static var mock = Resolver(parent: .main)
    
    // MARK: - Register Mock Services
    static func registerMockServices() {
        root = Resolver.mock
        defaultScope = .application
        Resolver.mock.register { MockPropertyListUsecases() }
        .implements(PropertyListUsecases.self)
        
    }
}
