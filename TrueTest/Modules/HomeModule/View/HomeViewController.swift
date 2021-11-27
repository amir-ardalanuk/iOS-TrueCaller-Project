//
//  HomeViewController.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation
import UIKit
import Resolver
import Combine
import SwiftUI

class HomeViewController: UIViewController {
    
    // MARK: - Injection
    @LazyInjected var viewModel: HomeViewModel
    @LazyInjected var l10n: LanguageResource
    
    // MARK: - Property
    let bag = Set<AnyCancellable>()

    // MARK: - Init
    
    init(viewData: ViewData) {
        super.init(nibName: nil, bundle: nil)
        $viewModel.name = viewData.resolverName
        self.title = "Property List"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.send(action: .fetch)
    }
    
    // MARK: - Layouting
    func loadSwiftUIView() {
        let propertyView = ProperyListView(publisher: viewModel.propertyListPubliser, viewAction: { [weak self] action in
            self?.viewModel.send(action:  HomeViewModelAction(action: action))
        })
        let childView = UIHostingController(rootView: propertyView)
        addChild(childView)
        childView.view.frame = self.view.frame
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
    override func loadView() {
        view = UIView()
        view.backgroundColor = .red
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.frame != .zero, view.subviews.isEmpty {
            loadSwiftUIView()
        }
    }
}
                                           
extension HomeViewModel {
    var propertyListPubliser: Signal<ProperyListView.ViewState> {
        self.statePublisher.map { state -> ProperyListView.ViewState in
            ProperyListView.ViewState(
                items: state.list.map { PropertyItem.Property(id: $0.id, title: $0.title) },
                isLoading: state.loadingState.isLoading
            )
        }.eraseToAnyPublisher()
    }
    
    
}

extension HomeViewModelAction {
    init(action: ProperyListView.ViewAction) {
        switch action {
        case .fetch:
            self = .fetch
        case .error:
            self = .fetchFailed("")
        case .didSelect(id: let id):
            self = .didSelect(id: id)
        }
    }
}
