//
//  HomeModule+Injection.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation
import UIKit
import Resolver

final class DefaultHomeModule: HomeModule, FeatureModule {
    // MARK: - Alias
    typealias ViewDataType = HomeViewData
    
    // MARK: - Injection
    @WeakLazyInjected var environment: AppEnvironment?
    
    
    // MARK: - Resolver Registration
    public static func registerServices() {
        Resolver.register { DefaultHomeModule() as HomeModule }
    }
    
    static func register(withViewData viewData: HomeViewData) {
        let name = viewData.resolverName
        Resolver.register(name: name) { makeViewController(viewData: viewData) }
        .scope(.container)
        Resolver.register(name: name) { makeViewModel(viewData: viewData) }
        .scope(.container)
    }
    
    // MARK: - Facotry
    public func makeCoordinator(navigation: UINavigationController, viewData: HomeViewData) -> Coordinator<Void> {
        Self.register(withViewData: viewData)
        return HomeCoordinator(
            navigation: navigation,
            viewData: viewData
        )
    }
    
    private static func makeViewController(viewData: HomeViewData) -> HomeViewController {
        HomeViewController(viewData: viewData)
    }

    private static func makeViewModel(viewData: HomeViewData) -> HomeViewModel {
        DefaultHomeViewModel()
    }
}
