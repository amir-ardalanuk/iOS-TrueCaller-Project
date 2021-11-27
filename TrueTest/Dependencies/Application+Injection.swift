//
//  Application+Injection.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation
import UIKit
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        DefaultAppEnvironment.registerAllServices()
    }
}

final class DefaultAppEnvironment: AppEnvironment {
    
    @LazyInjected var mainApplication: UIApplication
    @LazyInjected var mainBundle: Bundle
    @LazyInjected var modules: FeatureModulesEnvironment
    @LazyInjected var servies: AppServiesEnvironment

    static func registerAllServices() {
        Resolver.defaultScope = .application
        Resolver.register { makeAppEnvironment() }
        Resolver.register { UIApplication.shared }
        Resolver.register { Bundle.main }
        Resolver.register { LanguageResource(general: .init(), home: .init()) }

        DefaultFeatureModules.registerServices()
        DefaultAppServices.registerServices()
        
    }
    

    // MARK: - Factory

    private static func makeAppEnvironment() -> AppEnvironment {
        DefaultAppEnvironment()
    }

}
