//
//  FeatureModule+Injection.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation
import Resolver

final class DefaultFeatureModules: FeatureModulesEnvironment {
    
    // MARK: - Props
    @WeakLazyInjected var environment: AppEnvironment?
    @LazyInjected var homeModule: HomeModule
    @LazyInjected var propertyDetailModule: PropertyDetailModule

    // MARK: - Init

    static func registerServices() {
        Resolver.register { makeFeatureModules() }
        DefaultHomeModule.registerServices()
        DefaultPropertyDetailModule.registerServices()
    }

    // MARK: - Factory

    private static func makeFeatureModules() -> FeatureModulesEnvironment {
        DefaultFeatureModules()
    }
}
