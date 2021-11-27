//
//  Enviroment.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation
import UIKit
import Repository
import Core

public protocol AnyEnvironment {
    var environment: AppEnvironment? { get }
    static func registerServices()
}

public protocol AppEnvironment: AnyObject {
    var mainApplication: UIApplication { get }
    var mainBundle: Bundle { get }

    var modules: FeatureModulesEnvironment { get }
    var servies: AppServiesEnvironment { get }
}

public protocol FeatureModulesEnvironment: AnyEnvironment {
    var homeModule: HomeModule { get }
    var propertyDetailModule: PropertyDetailModule { get }
}

public protocol AppServiesEnvironment: AnyEnvironment {
    var propertyListUsecases: PropertyListUsecases { get }
}
