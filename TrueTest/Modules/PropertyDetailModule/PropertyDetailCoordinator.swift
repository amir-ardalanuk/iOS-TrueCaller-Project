//
//  PropertyDetailCoordinator.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//
import Foundation
import UIKit
import Combine
import Resolver

final class PropertyDetailCoordinator: Coordinator<Void> {
    // MARK: - Dependencies
    @LazyInjected private var viewController: PropertyDetailViewController
    @LazyInjected private var viewModel: PropertyDetailViewModel

    // MARK: - Props
    private weak var navigationController: UINavigationController?
    private let result = PassthroughSubject<Void, Never>()
    

    // MARK: - Init

    init(navigation: UINavigationController, viewData: PropertyDetailViewData) {
        self.navigationController = navigation
        super.init()
        self.navigationController?.delegate = self
        $viewController.name = viewData.resolverName
        $viewModel.name = viewData.resolverName
    }
    
    deinit {
        self.$viewController.release()
        self.$viewModel.release()
    }

    // MARK: - Coordinator

    override func start() -> Signal<Void> {
        navigationController?.pushViewController(viewController, animated: true)
        return result.eraseToAnyPublisher()
    }
}

extension PropertyDetailCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if !navigationController.viewControllers.contains(self.viewController) {
            self.result.send(())
        }
    }
}
