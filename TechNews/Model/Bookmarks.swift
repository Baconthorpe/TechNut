//
//  Bookmarks.swift
//  TechNews
//
//  Created by Ezekiel Abuhoff on 8/5/17.
//  Copyright © 2017 Ezekiel Abuhoff. All rights reserved.
//

import Foundation

class Bookmarks {
    // MARK: Static Properties
    private static let bookmarkedStoriesKey = "TechNutBookmarks"
    private static let shared = Bookmarks()
    internal static var bookmarkedStories: [Story] {
        return Bookmarks.shared.bookmarkedStories
    }
    
    // MARK: Instance Properties
    private lazy var bookmarkedStories: [Story] = self.getStoredBookmarks()
    
    // MARK: Static Methods
    internal static func isStoryBookmarked(storyURL: String) -> Bool {
        let matches = shared.bookmarkedStories.filter { (story) -> Bool in
            return storyURL == story.storyURL
        }
        return !matches.isEmpty
    }
    
    internal static func toggle(bookmark: Story) {
        shared.toggle(bookmark: bookmark)
    }
    
    // MARK: Adding and Removing Bookmarks
    private func toggle(bookmark: Story) {
        let startingNumberOfBookmarks = bookmarkedStories.count
        bookmarkedStories = bookmarkedStories.filter({ (bookmarkedStory) -> Bool in
            return bookmarkedStory.storyURL != bookmark.storyURL
        })
        
        if startingNumberOfBookmarks == bookmarkedStories.count {
            bookmarkedStories.append(bookmark)
        }
        
        saveBookmarkedStories()
    }
    
    // MARK: Data Persistence
    private func arrayOfBookmarkDictionaries() -> [[String : String]] {
        return bookmarkedStories.map({ (story) -> [String : String] in
            return story.asDictionary()
        })
    }
    
    private func bookmarksFromArrayOfDictionaries(storedStories: [[String : String]]) -> [Story] {
        let parsedStories = storedStories.map({ (storedStory) -> Story in
            guard let parsedStory = Story.from(dictionary: storedStory) else {
                return Story(headline: "", blurb: "", source: "", storyURL: "", imageURL: "", timeOfPublication: Date(timeIntervalSinceNow: 0))
            }
            return parsedStory
        })
        
        return parsedStories.filter({ (story) -> Bool in
            return story.storyURL != ""
        })
    }
    
    private func saveBookmarkedStories() {
        UserDefaults.standard.set(arrayOfBookmarkDictionaries(), forKey: Bookmarks.bookmarkedStoriesKey)
    }
    
    private func loadBookmardkedStories() {
        bookmarkedStories = getStoredBookmarks()
    }
    
    private func getStoredBookmarks() -> [Story] {
        // First, we load the data
        let loadedObject = UserDefaults.standard.object(forKey: Bookmarks.bookmarkedStoriesKey)
        
        if loadedObject == nil {
            // There is no saved bookmark data
            return []
        }
        
        guard let loadedArray = loadedObject as? [[String : String]] else { return  [] }
        
        // There is saved source data and it is in the proper format
        return bookmarksFromArrayOfDictionaries(storedStories: loadedArray)
    }
}
