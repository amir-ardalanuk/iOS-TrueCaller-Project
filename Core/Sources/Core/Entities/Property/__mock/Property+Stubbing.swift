//
//  Property+Stubing.swift
//  Core
//
//  Created by Amir on 8/27/1400 AP.
//

import Foundation

public extension Property {
    static func stub(id: String = UUID().uuidString ) -> Property {
        .init(title: "Amir", image: URL(string:""), id: id, address: "address")
    }
}
