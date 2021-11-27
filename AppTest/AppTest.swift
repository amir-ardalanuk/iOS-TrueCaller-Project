//
//  AppTest.swift
//  AppTest
//
//  Created by Amir on 11/22/21.
//

import Core
import Repository
import XCTest
import Resolver
import Combine
@testable import TrueTest

class DefaultHomeViewModelTests: XCTestCase {
    var mockPropertyListUsecase: MockPropertyListUsecases!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockPropertyListUsecase = Resolver.resolve(PropertyListUsecases.self) as! MockPropertyListUsecases
        
    }
    
    func test_fetchPropertyList_successfulyChangeState() {
        let mockList = PropertyList(list: [.stub()], hasMore: false)
         
        mockPropertyListUsecase.resultProvider = {
            Just(mockList)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let expectation = self.expectation(description: "fetching")
        
        let sut = DefaultHomeViewModel()
        sut.send(action: .fetch)
        var result: HomeViewModelState?
        sut.statePublisher.sink { value in
            if case .ready = value.loadingState  {
                result = value
                expectation.fulfill()
            } else {
                
            }
        }.store(in: &cancellables)
        wait(for: [expectation], timeout: 4)
        XCTAssertEqual(sut.state.loadingState, .ready(hasMore: false, next: nil))
        XCTAssertEqual(sut.state.list, mockList.list)
        
    }
    
    func test_fetchPropertyList_stateHasMore_changeStateToLoading() {
        let propertyList: [Property] = [.stub()]
         
        mockPropertyListUsecase.resultProvider = {
            Just(.init(list: propertyList, hasMore: true, nextId: 3))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let sut = DefaultHomeViewModel()
        sut.state = HomeViewModelState(list: propertyList, loadingState: .ready(hasMore: true, next: 2), error: nil)
        
        sut.send(action: .fetch)
        var result: HomeViewModelState?
        sut.statePublisher.sink { value in
            result = value
        }
        .store(in: &cancellables)
        XCTAssertEqual(result?.loadingState, .loading(2))
    }
    
    func test_fetchPropertyList_stateWithoutMore_changeStateNotChange() {
        let propertyList: [Property] = [.stub()]
        let sut = DefaultHomeViewModel()
        let state = HomeViewModelState(list: propertyList, loadingState: .ready(hasMore: false, next: nil), error: nil)
        sut.state = state
        
        sut.send(action: .fetch)
        var result: HomeViewModelState?
        sut.statePublisher.sink { value in
            result = value
        }
        .store(in: &cancellables)
        XCTAssertEqual(result, state)
        XCTAssertEqual(result?.loadingState, state.loadingState)
        XCTAssertEqual(result?.list, state.list)
        XCTAssertEqual(result?.error, state.error)
    }
    
    func test_fetchPropertyList_errorHappend_changeStateToError() {
        let sut = DefaultHomeViewModel()
        let mockError = NSError(domain: "auth exp ", code: 403, userInfo: [:])
        
        mockPropertyListUsecase.resultProvider = {
            Fail.init(error: mockError)
                .eraseToAnyPublisher()
        }
        
        let expectation = self.expectation(description: "fetching")
        
        sut.send(action: .fetch)
        var result: HomeViewModelState?
        sut.statePublisher.sink { value in
            guard value.error != nil else {
                return
            }
            result = value
            expectation.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectation], timeout: 2)
        cancellables.forEach { $0.cancel() }
        XCTAssertNotNil(result?.error)
        XCTAssertEqual(result?.loadingState, HomeViewModelState.LoadingState.initial)
        XCTAssertEqual(result?.error, mockError.localizedDescription)
    }
    
    func test_fetchPropertyList_selectProperty_didSelectedPropertyCallSuccessfully() {
        let property: Property = .stub()
        let sut = DefaultHomeViewModel()
        sut.state = .init(list: [property])
        
        let expectation = self.expectation(description: "clicking")
        
        var result: Property?
        sut.didSelectProperty.sink { value in
            result = value
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        sut.send(action: .didSelect(id: property.id))
        
        wait(for: [expectation], timeout: 2)
        cancellables.forEach { $0.cancel() }
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, property.id)
    }
}
