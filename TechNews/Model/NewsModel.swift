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
    public let timeOfPublication: Date
    
    public var sourceNatural: String {
        get {
            return Story.naturalized(source: source)
        }
    }
    
    public static func naturalized(source: String) -> String {
        return source.replacingOccurrences(of: "-", with: " ")
    }
}

internal class NewsStore {
    // MARK: Static Properties
    internal static var needsRefresh = false
    fileprivate static let sharedNewsStore = NewsStore()
    
    // MARK: Instance Properties
    internal var stories: [Story] = []
    
    // MARK: Updating Data
    internal static func updateSharedStore(completion: @escaping ([Story]) -> ()) {
        sharedNewsStore.update(completion: completion)
    }
    
    internal static func getSharedStoreStories() -> [Story] {
        return sharedNewsStore.stories
    }
    
    
    private func retrieve(source: String, completion: @escaping ([Story]) -> ()) {
        NewsAPIClient.getStories(from: source) { (json, error) in
            guard error == nil else { completion([]); return }
            guard let presentJSON = json else { completion([]); return }
            
            let articlesJSON = NewsAPIClient.articlesFrom(json: presentJSON)
            let source = NewsAPIClient.sourceFrom(json: presentJSON)
            let parsedStories = NewsAPIClient.storiesFrom(articlesJSON: articlesJSON, source: source)
            
            completion(parsedStories)
        }
    }
    
    private func update(completion: @escaping ([Story]) -> ()) {
        let sourcesOfInterest = Preferences.sourcesThatAreOn()
        let targetResponseCount = sourcesOfInterest.count
        var responses = 0
        var collectedStories: [Story] = []
        for sourceOfInterest in sourcesOfInterest {
            retrieve(source: sourceOfInterest, completion: { (freshStories) in
                collectedStories.append(contentsOf: freshStories)
                
                responses += 1
                
                if responses >= targetResponseCount {
                    collectedStories = collectedStories.sorted(by: { (storyOne, storyTwo) -> Bool in
                        return storyOne.timeOfPublication > storyTwo.timeOfPublication
                    })
                    
                    self.stories = collectedStories
                    completion(self.stories)
                }
            })
        }
    }
}


fileprivate extension NewsAPIClient {
    fileprivate static func storiesFrom(articlesJSON: [[String:Any]], source: String) -> [Story] {
        var stories: [Story] = []
        
        for articleJSON in articlesJSON {
            guard let headline = articleJSON["title"] as? String else { continue }
            guard let blurb = articleJSON["description"] as? String else { continue }
            guard let storyURL = articleJSON["url"] as? String else { continue }
            guard let imageURL = articleJSON["urlToImage"] as? String else { continue }
            guard let timeOfPublicationString = articleJSON["publishedAt"] as? String else { continue }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            guard let timeOfPublication = dateFormatter.date(from: timeOfPublicationString) else { continue }
            
            let story = Story(headline: headline,
                              blurb: blurb,
                              source: source,
                              storyURL: storyURL,
                              imageURL: imageURL,
                              timeOfPublication: timeOfPublication)
            
            stories.append(story)
        }
        
        return stories
    }
}
