//
//  AppCoordinator.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation
import Resolver
import UIKit
import Combine

final class AppCoordinator: Coordinator<Void> {
    
    // MARK: - Dependencies
    
    @LazyInjected private var features: FeatureModulesEnvironment
    
    // MARK: - Properies
    private let window: UIWindow
    private let result = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    // MARK: - Coordinator
    
    override func start() -> Signal<Void> {
        setupObservers()
        
        return result.eraseToAnyPublisher()
    }
    
    // MARK: - Observers
    
    private func setupObservers() {
        self.startApp()
    }
}

// MARK: - Startup

extension AppCoordinator {
    private func startApp() {
        startHomeRoot(viewData: .init())
    }
}

// MARK: - Home

extension AppCoordinator {
    private func startHomeRoot(viewData: HomeViewData) {
        let startable = UINavigationController()
        window.rootViewController = startable
        let coordinator = features.homeModule
            .makeCoordinator(navigation: startable, viewData: viewData)
        
        coordinator.coordinate(to: coordinator)
            .sink { _ in }
            .store(in: &cancellableSet)
        
    }
    
}
