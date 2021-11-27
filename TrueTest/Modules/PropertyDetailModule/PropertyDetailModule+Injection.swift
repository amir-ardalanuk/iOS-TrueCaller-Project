//
//  HomeModule+Injection.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation
import UIKit
import Resolver

final class DefaultPropertyDetailModule: PropertyDetailModule, FeatureModule {
    // MARK: - Alias
    typealias ViewDataType = PropertyDetailViewData
    
    // MARK: - Injection
    @WeakLazyInjected var environment: AppEnvironment?
    
    
    // MARK: - Resolver Registration
    public static func registerServices() {
        Resolver.register { DefaultPropertyDetailModule() as PropertyDetailModule }
    }
    
    static func register(withViewData viewData: PropertyDetailViewData) {
        let name = viewData.resolverName
        Resolver.register(name: name) { resolver, args in
            makeViewController(viewData: viewData)
        }.scope(.container)
        Resolver.register(name: name) { _, _ in
            makeViewModel(viewData: viewData)
        }.scope(.container)
    }
    
    // MARK: - Facotry
    public func makeCoordinator(navigation: UINavigationController, viewData: PropertyDetailViewData) -> Coordinator<Void> {
        Self.register(withViewData: viewData)
        return PropertyDetailCoordinator(
            navigation: navigation,
            viewData: viewData
        )
    }
    
    private static func makeViewController(viewData: PropertyDetailViewData) -> PropertyDetailViewController {
        PropertyDetailViewController(viewData: viewData)
    }

    private static func makeViewModel(viewData: PropertyDetailViewData) -> PropertyDetailViewModel {
        DefaultPropertyDetailViewModel(viewData: viewData)
    }
}
