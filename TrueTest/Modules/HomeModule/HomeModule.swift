//
//  HomeModule.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation
import UIKit

public protocol HomeModule {
    func makeCoordinator(
        navigation: UINavigationController,
        viewData: HomeViewData
    ) -> Coordinator<Void>
}
