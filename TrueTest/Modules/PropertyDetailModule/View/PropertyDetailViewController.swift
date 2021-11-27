//
//  PropertyViewController.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation
import UIKit
import Resolver
import Combine
import SwiftUI

class PropertyDetailViewController: UIViewController {
    
    // MARK: - Injection
    @WeakLazyInjected var viewModel: PropertyDetailViewModel?
    //@LazyInjected var l10n: LanguageResource
    
    // MARK: - Property
    let bag = Set<AnyCancellable>()

    // MARK: - Init
    
    init(viewData: ViewData) {
        super.init(nibName: nil, bundle: nil)
        $viewModel.name = viewData.resolverName
        self.title = "Property Detail"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit")
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.send(action: .fetch)
    }
    
    // MARK: - Layouting
    
    func loadSwiftUIView() {
        guard let viewModel = viewModel else {
            return
        }
        let propertyView = PropertyDetailView(publisher: viewModel.publisher, viewAction: { action in })
        let childView = UIHostingController(rootView: propertyView)
        addChild(childView)
        childView.view.frame = self.view.frame
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.frame != .zero, view.subviews.isEmpty {
            loadSwiftUIView()
        }
    }
    
}
                                           
extension PropertyDetailViewModel {
    var publisher: Signal<PropertyDetailView.ViewState> {
        self.statePublisher.compactMap({ state -> PropertyDetailView.ViewState? in
            state.property.flatMap { property in
                PropertyDetailView.ViewState(
                    image: property.image,
                    title: property.title,
                    price: "comming soon...",
                    address: property.address)
            }
        }).eraseToAnyPublisher()
    }
}
