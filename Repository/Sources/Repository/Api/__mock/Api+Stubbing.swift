//
//  Api+Stubbing.swift
//  Repository
//
//  Created by Amir on 8/28/1400 AP.
//

import Foundation
extension Api.PropertyItem {
    static func stub(id: String = UUID().uuidString) -> Self {
        return Api.PropertyItem(id:  id, name: "name", address: "address", image: "image ")
    }
}
