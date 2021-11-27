//
//  PropertyDetailModule.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation
import UIKit

public protocol PropertyDetailModule {
    func makeCoordinator(
        navigation: UINavigationController,
        viewData: PropertyDetailViewData
    ) -> Coordinator<Void>
}
