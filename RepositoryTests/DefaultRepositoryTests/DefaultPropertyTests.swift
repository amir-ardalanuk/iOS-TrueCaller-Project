//
//  DefaultPropertyTests.swift
//  RepositoryTests
//
//  Created by Amir on 8/28/1400 AP.
//

import Foundation
import Combine
import Network
import Core
import XCTest
@testable import Repository

class DefaultPropertyListUsecaesTests: XCTestCase {

    var cancellableSet = Set<AnyCancellable>()
    
    func testFetchingData_ConvertedApiModelToPropertyList_NextPage() {
        let mockNetowrk = MockNetwork()
        let sut = DefaultProperyUsecases(network: mockNetowrk)
        let data = Api.PropertyItem.stub()
        let meta =  Api.Meta(currentPage: 1, from: 1, lastPage: 2, path: nil, perPage: nil, to: nil, total: nil)
        mockNetowrk.resultProvider =  {
            Just(Api.PropertyList(data: [data], meta: meta))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let expectation = self.expectation(description: "fetching")
        var resultList: PropertyList?
        sut.fetchList(count: 10, page: 1).sink { error in
            
        } receiveValue: { list in
            resultList = list
            expectation.fulfill()
        }.store(in: &cancellableSet)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        //FIXME: - should right a converter method / Test it
        let property = Property(title: data.name ?? "Unknown", image: data.image.flatMap { URL(string: $0)}, id: data.id, address: data.address ?? "")
        XCTAssertEqual(property, resultList?.list.first)
        XCTAssertEqual(meta.currentPage! + 1, resultList?.nextId)
        XCTAssertEqual(true, resultList?.hasMore)

    }

    func testFetchingData_ConvertedApiModelToPropertyList_EndPage() {
        let mockNetowrk = MockNetwork()
        let sut = DefaultProperyUsecases(network: mockNetowrk)
        let data = Api.PropertyItem.stub()
        let meta =  Api.Meta(currentPage: 2, from: 2, lastPage: 2, path: nil, perPage: nil, to: nil, total: nil)
        mockNetowrk.resultProvider =  {
            Just(Api.PropertyList(data: [data], meta: meta))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let expectation = self.expectation(description: "fetching")
        var resultList: PropertyList?
        sut.fetchList(count: 10, page: 1).sink { error in
            
        } receiveValue: { list in
            resultList = list
            expectation.fulfill()
        }.store(in: &cancellableSet)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        //FIXME: - should right a converter method / Test it
        let property = Property(title: data.name ?? "Unknown", image: data.image.flatMap { URL(string: $0)}, id: data.id, address: data.address ?? "")
        XCTAssertEqual(property, resultList?.list.first)
        XCTAssertEqual(resultList?.nextId, nil)
        XCTAssertEqual(false, resultList?.hasMore)

    }

}
