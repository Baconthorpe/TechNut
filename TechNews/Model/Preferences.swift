//
//  Preferences.swift
//  TechNews
//
//  Created by Ezekiel Abuhoff on 6/3/17.
//  Copyright © 2017 Ezekiel Abuhoff. All rights reserved.
//

import Foundation

class Preferences {
    // MARK: Static Properties
    private static let sourcesKey = "TechNutPreferencesSources"
    private static let shared = Preferences()
    private static let defaultSources = ["the-next-web" : true,
                                         "ars-technica" : true,
                                         "engadget" : true,
                                         "hacker-news" : true,
                                         "techcrunch" : true,
                                         "techradar" : true,
                                         "the-verge" : true]
    
    // MARK: Instance Properties
    private var sources: [String : Bool] = defaultSources
    
    // MARK: Static Methods
    internal static func saveSources() {
        shared.saveSources()
    }
    
    internal static func loadSources() {
        shared.loadSources()
    }
    
    internal static func set(source: String, to value: Bool) {
        shared.set(source: source, to: value)
    }
    
    internal static func getSources() -> [String : Bool] {
        return shared.sources
    }
    
    internal static func sourcesThatAreOn() -> [String] {
        let sources = shared.sources
        let filteredSources = sources.filter({ (pair) -> Bool in
            return pair.value
        })
        let onSources = filteredSources.map { (pair) -> String in
            return pair.key
        }
        
        return onSources
    }
    
    // MARK: Setting Preferences
    private func set(source: String, to value: Bool) {
        sources[source] = value
    }
    
    // MARK: Data Persistence
    private func saveSources() {
        UserDefaults.standard.set(sources, forKey: Preferences.sourcesKey)
    }
    
    private func loadSources() {
        // First, we load the data
        let loadedObject = UserDefaults.standard.object(forKey: Preferences.sourcesKey)
        
        if loadedObject == nil {
            // There is no saved source preference data
            return
        }
        
        guard let loadedDictionary = loadedObject as? [String : Bool] else { return }
        
        // There is saved source data and it is in the proper format
        sources = loadedDictionary
    }
}
