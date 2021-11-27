//
//  L10n.swift
//  TrueTest
//
//  Created by amir ardalan on 8/20/21.
//

import Foundation

class LanguageResource {
    let general: GeneralString
    let home: HomeString
    
    
    internal init(general: LanguageResource.GeneralString, home: LanguageResource.HomeString) {
        self.general = general
        self.home = home
    }
}

// MARK: - Home Strings
extension LanguageResource {
    struct HomeString {
        let fetch: String =  "Fetch"
    }
}

// MARK: - General Strings
extension LanguageResource {
    struct GeneralString {
        let notLoaded: String = "Not Loaded"
        let Loading: String = "Loading"
    }
}
