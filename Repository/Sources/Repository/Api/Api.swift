//
//  Api.swift.swift
//  Repository
//
//  Created by Amir on 8/27/1400 AP.
//

import Foundation

enum Api {}

// MARK: - Routing

extension Api {
    enum route: String {
        case propertyList = "https://api-staging.reo.so/api/properties"
    }
}

// MARK: - Api Entities

extension Api {
    struct PropertyList: Decodable {
        public var data: [PropertyItem]
        //public let links: Any
        public let meta: Meta
        
        enum CodingKeys: String, CodingKey{
            case data
            case meta
        }
    }
    
    struct PropertyItem: Decodable {
        let id: String
        let name: String?
        let address: String?
        let image: String?
    }
    
    struct Meta: Decodable {
        let currentPage, from, lastPage: Int?
        //let links: Any?
        let path: String?
        let perPage, to, total: Int?
        
        enum CodingKeys: String, CodingKey{
            case currentPage =  "current_page"
            case lastPage = "last_page"
            case perPage = "per_page"
            case from
            case path
            case to
            case total
        }
    }
}
