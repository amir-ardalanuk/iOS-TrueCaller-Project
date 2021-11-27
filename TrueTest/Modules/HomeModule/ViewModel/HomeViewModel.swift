//
//  HomeViewModel.swift
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

protocol HomeViewModel {
    var state: HomeViewModelState { get }
    var statePublished: Published<HomeViewModelState> { get }
    var statePublisher: Published<HomeViewModelState>.Publisher { get }
    var didSelectProperty: PassthroughSubject<Property, Never> { get }
    func send(action: HomeViewModelAction)
}

// MARK: - ViewModel Action
enum HomeViewModelAction {
    case fetch
    case fetchComplete(PropertyList)
    case fetchFailed(String)
    case didSelect(id: String)
}

// MARK: - ViewModel State

struct HomeViewModelState: Equatable {
    var list: [Property]
    var loadingState: LoadingState
    var error: String?
    
    init(list: [Property], loadingState: LoadingState = LoadingState.initial, error: String? = nil) {
        self.list = list
        self.loadingState = loadingState
        self.error = error
    }
    
    func update(list: [Property]) -> Self {
        .init(list: self.list + list, loadingState: self.loadingState, error: nil)
    }
    
    func update(loadingState: LoadingState) -> Self {
        .init(list: self.list, loadingState: loadingState, error: nil)
    }
    
    func update(error: String?) -> Self {
        .init(list: self.list, loadingState: self.loadingState, error: error)
    }
    
    enum LoadingState: Equatable {
        case loading(Int)
        case ready(hasMore: Bool, next: Int?)
        
        var isLoading: Bool {
            switch self {
            case .loading:
                return true
            case .ready:
                return false
            }
        }
        
        static var initial: LoadingState {
            .ready(hasMore: true, next: 1)
        }
    }
}

final public class DefaultHomeViewModel: HomeViewModel, ObservableObject {
    
    // MARK: - Injection
    
    @LazyInjected(container: .root) private var propertyListUsecase: PropertyListUsecases
    
    // MARK: - Property
    
    @Published var state: HomeViewModelState = HomeViewModelState(list: [])
    var statePublished: Published<HomeViewModelState> { _state }
    var statePublisher: Published<HomeViewModelState>.Publisher { $state }
    var didSelectProperty = PassthroughSubject<Property, Never>()
    
    private let pageCount = 10
    private var cancellableSet = Set<AnyCancellable>()
    
    
    // MARK: - Init
    public init() {
    }
    
    // MARK: - Action
    
    func send(action: HomeViewModelAction) {
        switch action {
        case .fetch:
            fetchPropertyList()
        case let .fetchComplete(propertyList):
            state = state
                .update(list: propertyList.list)
                .update(loadingState: .ready(hasMore: propertyList.hasMore, next: propertyList.nextId))
        case let .fetchFailed(error):
            if case let .loading(page) = state.loadingState {
                state = state.update(loadingState: .ready(hasMore: true, next: page))
            }
            state = state.update(error: error)
                
        case let .didSelect(id):
            if let property = self.state.list.first(where: { $0.id == id }) {
                didSelectProperty.send(property)
            }
        }
    }
    
    // MARK: - Fetch
    
    private func fetchPropertyList() {
        guard case let .ready(hasMore: true, next: page) = state.loadingState, let nextPage = page else {
            return
        }
        self.state = state.update(loadingState: .loading(nextPage))
        propertyListUsecase.fetchList(count: pageCount, page: nextPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.send(action: .fetchFailed(error.localizedDescription))
                case .finished:
                    break
                }
            } receiveValue: { [weak self] list in
                self?.send(action: .fetchComplete(list))
            }.store(in: &cancellableSet)
    }
    
}
