//
//  Coordinator.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation
import Combine
import Resolver

public typealias Signal<T> = AnyPublisher<T, Never>

public protocol AnyCoordinator: AnyObject {
    var identifier: UUID { get }
}

public extension Coordinator {
    enum DisposingStrategy {
        case onAll
        case onDispose
    }
}

/// Base abstract coordinator generic over the return type of the `start` method.
open class Coordinator<Result>: NSObject, AnyCoordinator {
    public typealias CoordinationResult = Result
    
    // MARK: - Props
    
    public let identifier = UUID()
    public var cancellableSet = Set<AnyCancellable>()
    
    private var childCoordinators = [UUID: Any]()
    
    // MARK: - Init
    
    public override init() {}
    
    // MARK: - Methods
    
    /// 1. Stores coordinator in a dictionary of child coordinators.
    /// 2. Calls method `start()` on that coordinator.
    /// 3. Depending on the `disposingStrategy` then on `start()` removes coordinator from the dictionary.
    ///
    /// - Parameter coordinator: Coordinator to start.
    /// - Parameter disposingStrategy: The disposing strategy, defaults to onAll.
    /// - Returns: Result of `start()` method.
    public func coordinate<T>(
        to coordinator: Coordinator<T>,
        disposingStrategy: DisposingStrategy = .onAll
    ) -> Signal<T> {
        store(coordinator: coordinator)
        
        let disposingBlock: (() -> Void) = { [weak self, weak coordinator] in
            guard let coordinator = coordinator else { return }
            
            self?.free(coordinator: coordinator)
        }
        
        switch disposingStrategy {
        case .onAll:
            return coordinator.start()
                .handleEvents(receiveOutput: { _ in
                    disposingBlock()
                }, receiveCompletion: { _ in
                    disposingBlock()
                }, receiveCancel: {
                    disposingBlock()
                })
                .eraseToAnyPublisher()
        case .onDispose:
            return coordinator.start()
                .handleEvents(receiveCompletion: { _ in
                    disposingBlock()
                }, receiveCancel: {
                    disposingBlock()
                })
                .eraseToAnyPublisher()
        }
    }
    
    public func coordinateAndSubscribe<T>(to coordinator: Coordinator<T>, resultHandler: ((T) -> Void)? = nil) {
        coordinate(to: coordinator)
            .sink {
                resultHandler?($0)
            }.store(in: &cancellableSet)
    }
    
    public func contains(_ coordinator: AnyCoordinator) -> Bool {
        childCoordinators.keys.contains(coordinator.identifier)
    }
    
    /// Starts job of the coordinator.
    ///
    /// - Returns: Result of coordinator job.
    open func start() -> Signal<Result> {
        fatalError("Start method should be implemented.")
    }
    
    // MARK: - Private Methods
    
    private func store(coordinator: AnyCoordinator) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func free(coordinator: AnyCoordinator) {
        childCoordinators.removeValue(forKey: coordinator.identifier)
    }
}

//extension Coordinator: CustomDebugStringConvertible {
//    public var debugDescription: String {
//        "id = \(identifier) children = \(childCoordinators)"
//    }
//}
