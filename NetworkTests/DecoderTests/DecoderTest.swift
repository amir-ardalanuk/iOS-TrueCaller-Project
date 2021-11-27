//
//  DecoderTest.swift
//  NetworkTests
//
//  Created by Amir on 8/27/1400 AP.
//

import Foundation
import XCTest
@testable import Network

final class DefaultDecoderTest: XCTestCase {
    // MARK: - Properties
    let sut: AnyDecoder = DefaultDecoder()
}

extension DefaultDecoderTest {
  func testDecodeEntitySuccessfully() {
    let mockEntity = mockEntity()
    let mockEntityData = try? JSONEncoder().encode(mockEntity)
    let decodedData = try? sut.decode(TestEntity.self, from: mockEntityData!)
    XCTAssertNotNil(decodedData)
    XCTAssertEqual(mockEntity, decodedData)
  }
    
    func testNullDataDecodeFailure() {
      let decodedData = try? sut.decode(TestEntity.self, from: Data())
      XCTAssertEqual(decodedData, nil)
    }
}

