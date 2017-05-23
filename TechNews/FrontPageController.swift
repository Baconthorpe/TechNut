//
//  FrontPageController.swift
//  TechNews
//
//  Created by Ezekiel Abuhoff on 5/20/17.
//  Copyright © 2017 Ezekiel Abuhoff. All rights reserved.
//

import UIKit

class FrontPageController: UIViewController, UITableViewDelegate, UITableViewDataSource, HeadlineCellDelegate {
    
    // MARK: UI Elements
    @IBOutlet weak var storyTable: UITableView!
    
    // MARK: Data
    var stories: [Story] = []
    
    // MARK: Selection
    var selectedRow: Int?
    
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
        cell.sourceLabel.text = story.sourceNatural
        cell.headlineLabel.text = story.headline
        
        cell.delegate = self
        cell.panelView.layer.cornerRadius = 5.0
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "frontPageToWeb", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: Headline Cell
    func tapOn(cell: HeadlineCell) {
        guard let indexPath = storyTable.indexPathForRow(at: cell.center) else { return }
        
        selectedRow = indexPath.row
        performSegue(withIdentifier: "frontPageToWeb", sender: self)
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        stories = NewsStore.getSharedStoreStories()
        view.backgroundColor = tnTeal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if NewsStore.needsRefresh {
            NewsStore.updateSharedStore(completion: { (newStories) in
                NewsStore.needsRefresh = false
                OperationQueue.main.addOperation {
                    self.stories = newStories
                    self.storyTable.reloadData()
                }
            })
        }
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
        guard let presentSelectedRow = selectedRow else { return nil }
        
        let selectedStory = stories[presentSelectedRow]
        selectedRow = nil
        return selectedStory.storyURL
    }
}

class HeadlineCell: UITableViewCell {
    // MARK: UI Elements
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var panelView: UIView!
    
    // MARK: Image Loading Properties
    internal var currentImageURL = ""
    
    // MARK: User Interaction Properties
    internal var delegate: HeadlineCellDelegate? {
        get {
            return privateDelegate
        }
        set(newDelegate) {
            addTapRecognizer()
            privateDelegate = newDelegate
        }
    }
    private var privateDelegate: HeadlineCellDelegate?
    
    // MARK: User Interaction
    func addTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapRecognizer.numberOfTapsRequired = 1
        addGestureRecognizer(tapRecognizer)
    }
    
    func tapped() {
        if let presentDelegate = privateDelegate {
            presentDelegate.tapOn(cell: self)
        }
    }
    
    // MARK: Image Loading
    internal func loadImage(url: String) {
        currentImageURL = url
        
        ImageCache.getImage(from: url) { (image) in
            guard self.currentImageURL == url else { return }
            self.thumbnailView.image = image
        }
    }
}

protocol HeadlineCellDelegate {
    func tapOn(cell: HeadlineCell)
}
