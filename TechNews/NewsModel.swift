//
//  NewsModel.swift
//  TechNews
//
//  Created by Ezekiel Abuhoff on 5/19/17.
//  Copyright © 2017 Ezekiel Abuhoff. All rights reserved.
//

import Foundation

internal struct Story {
    public let headline: String
    public let blurb: String
    public let source: String
    public let storyURL: String
    public let imageURL: String
}

internal class NewsStore {
    internal var stories: [Story] = []
    
    internal static func updateSharedStore(completion: @escaping ([Story]) -> ()) {
        sharedNewsStore.update(completion: completion)
    }
    
    internal static func getSharedStoreStories() -> [Story] {
        return sharedNewsStore.stories
    }
    
    private func update(completion: @escaping ([Story]) -> ()) {
        NewsAPIClient.sampleGet {
            completion(self.stories)
        }
    }
}

fileprivate let sharedNewsStore = NewsStore()
