//
//  DefaultDecodet+Stubbing.swift
//  NetworkTests
//
//  Created by Amir on 8/27/1400 AP.
//

import Foundation
// MARK: - Helper functions
extension DefaultDecoderTest {
    struct TestEntity: Codable, Equatable {
        var name: String
        var id: String
    }
    
    func mockEntity() -> TestEntity {
        TestEntity(
            name: "Test", id: UUID().uuidString)
    }

}
