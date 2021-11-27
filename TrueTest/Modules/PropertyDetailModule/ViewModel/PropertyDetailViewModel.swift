//
//  PropertyDetailViewModel.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation
import Resolver
import Repository
import Combine
import Core
import SwiftUI

protocol PropertyDetailViewModel {
    var didDismissController: PassthroughSubject<Void, Never> { get }
    var state: PropertyDetailViewModelState { get }
    var statePublished: Published<PropertyDetailViewModelState> { get }
    var statePublisher: Published<PropertyDetailViewModelState>.Publisher { get }
    
    init(viewData: PropertyDetailViewData)
    func send(action: PropertyDetailViewModelAction)
}


// MARK: - ViewModel Action

enum PropertyDetailViewModelAction {
    case fetch
    case dismiss
}

// MARK: - ViewModel State

struct PropertyDetailViewModelState {
    var property: Property?
    var loadingState: LoadingState
    var error: String?
    
    init(property: Property?, loadingState: LoadingState = LoadingState.initial, error: String? = nil) {
        self.property = property
        self.loadingState = loadingState
        self.error = error
    }
    
    func update(property: Property) -> Self {
        .init(property: property, loadingState: self.loadingState, error: self.error)
    }
    
    func update(loadingState: LoadingState) -> Self {
        .init(property: self.property, loadingState: loadingState, error: self.error)
    }
    
    
    enum LoadingState: Equatable {
        case loading
        case ready
        
        static var initial: LoadingState {
            .ready
        }
    }
}

// MARK: - ViewModel Concrete

final public class DefaultPropertyDetailViewModel: PropertyDetailViewModel, ObservableObject {
    
    // MARK: - Property
    @Published var state: PropertyDetailViewModelState
    var statePublished: Published<PropertyDetailViewModelState> { _state }
    var statePublisher: Published<PropertyDetailViewModelState>.Publisher { $state }
    var viewData: PropertyDetailViewData
    var didDismissController = PassthroughSubject<Void, Never>()
    
    private let pageCount = 10
    private var cancellableSet = Set<AnyCancellable>()
    
    
    
    //MARK: - Init
    init(viewData: PropertyDetailViewData) {
        self.viewData = viewData
        self.state = .init(property: nil)
    }
    
    // MARK: - Action
    func send(action: PropertyDetailViewModelAction) {
        switch action {
        case .fetch:
            switch viewData.type {
            case .id:
                //FIXME: Need fetch api - for deeplinking
                fatalError("has not implemented yet.")
            case let .profile(property):
                self.state = .init(property: property)
            }
        case .dismiss:
            didDismissController.send(())
        }
    }
}
