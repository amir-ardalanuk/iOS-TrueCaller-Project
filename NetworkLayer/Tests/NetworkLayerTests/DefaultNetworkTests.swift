//
//  DefaultNetworkTests.swift
//  NetworkTests
//
//  Created by Amir on 8/27/1400 AP.
//

import Foundation
import XCTest
@testable import NetworkLayer

final class DefaultNetworkTest: XCTestCase {
    // MARK: - Properties
    var sut: NetworkProtocol!
    var decoder: MockDecoder!
    
    // MARK: - Life Cycle
    override func setUp() {
        self.decoder = MockDecoder()
        self.sut = DefaultNetwork(decoder: decoder)
        super.setUp()
    }
}

extension DefaultNetworkTest {
    
    func testFetchGETApiSuccessfully() {
        let url = URL(string: "https://google.com")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        decoder.decodeProvider = {
            return String("Data Received")
        }
        let expectation = self.expectation(description: "Wait for \(url) to load.")
        var data: String?
        sut.request(request) { (result: Result<String, NetworkError>) in
            data = try? result.get()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(data)
    }
    
    func testFetchGETApiFailure() {
        let url = URL(string: "https://mockingurl.c")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        request.timeoutInterval = 4
        let expectation = self.expectation(description: "Wait for \(url) to load.")
        var error: NetworkError?
        decoder.decodeProvider = {
            return String("Data Received")
        }
        
        sut.request(request) { (result: Result<Data, NetworkError>) in
            guard case .failure(let networkError) = result else {
                return XCTFail("Expected to be a failure but got a success with \(result)")
            }
            error = networkError
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(error)
    }
}


