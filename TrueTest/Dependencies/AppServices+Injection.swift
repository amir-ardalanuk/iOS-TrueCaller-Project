//
//  AppServices+Injection.swift
//  TrueTest
//
//  Created by amir ardalan on 8/21/21.
//

import Foundation
import Resolver
import Repository
import Core
import Network

final class DefaultAppServices: AppServiesEnvironment {
    // MARK: - Props
    @WeakLazyInjected var environment: AppEnvironment?
    @LazyInjected var propertyListUsecases: PropertyListUsecases

    // MARK: - Init

    static func registerServices() {
        let network = DefaultNetwork()
        Resolver.register { makeAppServices() }
        Resolver.register { DefaultProperyUsecases(network: network) as PropertyListUsecases }
        
        #if MOCK
        Resolver.register { MockPropertyListUsecases() as PropertyListUsecases }
        #endif
    }
    

    // MARK: - Factory

    private static func makeAppServices() -> AppServiesEnvironment {
        DefaultAppServices()
    }
}
