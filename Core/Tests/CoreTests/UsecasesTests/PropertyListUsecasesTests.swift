//
//  PropertyListUsecasesTests.swift
//  CoreTests
//
//  Created by Amir on 11/20/21.
//

import Foundation
import Combine
import XCTest
@testable import Core

class PropertyListUsecasesTest: XCTestCase {

    var cancellable = Set<AnyCancellable>()
    override class func setUp() {
        super.setUp()
    }
    
    
    func testFetch_Success() {
        let sut = MockPropertyListUsecases()
        let mockProperty: Property = .stub()
        sut.resultProvider = {
            Just(PropertyList.init(list: [mockProperty], hasMore: false, nextId: nil))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let expectation = self.expectation(description: "Wait for Result to load.")
        
        var result: PropertyList?
        
        sut.fetchList(count: 1, page: 1)
            .sink { error in
            } receiveValue: { list in
                result = list
                expectation.fulfill()
            }
            .store(in: &cancellable)
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(result)
        XCTAssertEqual(mockProperty, result?.list.first)
        XCTAssertEqual(false, result?.hasMore)
    }

    
    func testFetch_Failed() {
        let sut = MockPropertyListUsecases()
        let error: Error = NSError(domain: "", code: 100, userInfo: [:])
        sut.resultProvider = {
            Future<PropertyList, Error> { promise in
                promise(.failure(error))
            }
            .eraseToAnyPublisher()
        }
        
        let expectation = self.expectation(description: "Wait for Result to load.")
        
        var result: Error?
        
        sut.fetchList(count: 1, page: 1)
            .sink { completion in
                switch completion {
                case let .failure(error):
                    result  = error
                case .finished:
                    break
                }
                expectation.fulfill()
            } receiveValue: { list in
            }
            .store(in: &cancellable)
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(result)
        XCTAssertEqual(error.localizedDescription, result?.localizedDescription)
    }

}
