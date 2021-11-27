//
//  HomeCoordinator.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//
import Foundation
import UIKit
import Combine
import Resolver

final class HomeCoordinator: Coordinator<Void> {
    // MARK: - Dependencies
    @LazyInjected private var viewController: HomeViewController
    @LazyInjected private var viewModel: HomeViewModel
    @LazyInjected private var enviroment: AppEnvironment
    
    // MARK: - Props
    private weak var navigationController: UINavigationController?
    private let result = PassthroughSubject<Void, Never>()

    // MARK: - Init

    init(navigation: UINavigationController, viewData: HomeViewData) {
        self.navigationController = navigation
        super.init()
        
        $viewController.name = viewData.resolverName
        $viewModel.name = viewData.resolverName
    }
    
    deinit {
        print("DEINIT")
    }

    // MARK: - Coordinator

    override func start() -> Signal<Void> {
        navigationController?.viewControllers = [viewController]
        
        observingDidSelectProperty()
        
        return result.eraseToAnyPublisher()
    }
}


extension HomeCoordinator {
    func observingDidSelectProperty() {
        self.viewModel.didSelectProperty
            .map { PropertyDetailViewData(type: .profile($0)) }
            .flatMap { [weak self] viewData -> Signal<Void> in
                guard let self = self else { return Just(Void()).eraseToAnyPublisher()}
                return self.cooridnateToPropertyDetail(viewData: viewData)
            }
            .sink { _ in}.store(in: &cancellableSet)
    }

    func cooridnateToPropertyDetail(viewData: PropertyDetailViewData) -> Signal<Void> {
        guard let navigation = self.navigationController else { return Just(()).eraseToAnyPublisher() }
        let coordinate = enviroment.modules.propertyDetailModule.makeCoordinator(navigation: navigation, viewData: viewData)
        return self.coordinate(to: coordinate)
    }
}
