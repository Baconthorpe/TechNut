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
        
        cell.sourceLabel.text = story.source
        cell.headlineLabel.text = story.headline
        
        return UITableViewCell()
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        stories = NewsStore.getSharedStoreStories()
    }
}

class HeadlineCell: UITableViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
}
