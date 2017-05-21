//
//  FrontPageController.swift
//  TechNews
//
//  Created by Ezekiel Abuhoff on 5/20/17.
//  Copyright © 2017 Ezekiel Abuhoff. All rights reserved.
//

import UIKit

class FrontPageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UI Elements
    @IBOutlet weak var storyTable: UITableView!
    
    // MARK: Data
    var stories: [Story] = []
    
    // MARK: Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "headlineCell", for: indexPath) as? HeadlineCell else { return UITableViewCell() }
        let story = stories[indexPath.row]
        
        cell.loadImage(url: story.imageURL)
        cell.sourceLabel.text = story.source
        cell.headlineLabel.text = story.headline
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "frontPageToWeb", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        stories = NewsStore.getSharedStoreStories()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "frontPageToWeb" {
            guard let webVC = segue.destination as? WebController else { return }
            
            let storyURL = urlForSelectedCell()
            webVC.url = storyURL
        }
    }
    
    // MARK: Utility
    internal func urlForSelectedCell() -> String? {
        guard let selectedIndexPath = storyTable.indexPathForSelectedRow else { return nil }
        
        let selectedStory = stories[selectedIndexPath.row]
        return selectedStory.storyURL
    }
}

class HeadlineCell: UITableViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    
    internal var currentImageURL = ""
    
    internal func loadImage(url: String) {
        currentImageURL = url
        
        ImageCache.getImage(from: url) { (image) in
            guard self.currentImageURL == url else { return }
            self.thumbnailView.image = image
        }
    }
    
//    internal func loadImage(url: String) {
//        guard let verifiedURL = URL(string: url) else { return }
//        
//        currentImageURL = url
//        
//        let task = URLSession.shared.dataTask(with: verifiedURL) { (data, response, error) in
//            guard error == nil else { print("ERROR: \(String(describing: error))"); return }
//            
//            if let response = response {
//                print("RESPONSE: \(response)")
//            }
//            
//            guard let data = data else { print("INVALID IMAGE DATA"); return }
//            guard url == self.currentImageURL else { return }
//            
//            OperationQueue.main.addOperation {
//                let image = UIImage(data: data)
//                self.thumbnailView.image = image
//            }
//        }
//        
//        task.resume()
//    }
}
