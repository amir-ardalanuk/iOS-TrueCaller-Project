//
//  ProprtyListServies.swift
//  Core
//
//  Created by Amir on 8/27/1400 AP.
//

import Foundation
import Combine

public protocol PropertyListUsecases {
    func fetchList(count: Int, page: Int) -> AnyPublisher<PropertyList, Error>
}
