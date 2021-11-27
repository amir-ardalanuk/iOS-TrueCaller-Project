//
//  FeatureModule.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation

public protocol FeatureModule: AnyEnvironment {
    associatedtype ViewDataType: ViewData
    static func register(withViewData viewData: ViewDataType)
}
