//
//  FrontPageController.swift
//  TechNews
//
//  Created by Ezekiel Abuhoff on 5/20/17.
//  Copyright © 2017 Ezekiel Abuhoff. All rights reserved.
//

import UIKit
import Social

class FrontPageController: UIViewController, UITableViewDelegate, UITableViewDataSource, HeadlineCellDelegate, SearchCellDelegate {
    
    // MARK: UI Elements
    @IBOutlet weak var storyTable: UITableView!
    
    // MARK: Data
    private var allStories: [Story] = []
    var stories: [Story] {
        get {
            return allStories
        }
        set(newStories) {
            allStories = newStories
            filteredStories = allStories
        }
    }
    var filteredStories: [Story] = []
    
    // MARK: Selection
    var selectedRow: Int?
    
    // MARK: Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return filteredStories.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return searchCellFor(tableView: tableView, indexPath: indexPath)
        } else if indexPath.section == 1 {
            return headlineCellFor(tableView: tableView, indexPath: indexPath)
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 110
        } else if indexPath.section == 1 {
            return 110
        }
        
        return 110
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: Search Cell
    func newSearch(cell: SearchCell, query: String) {
        let lowercaseQuery = query.lowercased()
        
        filteredStories = stories.filter { (story) -> Bool in
            let inHeadline = story.headline.lowercased().contains(lowercaseQuery)
            let inBlurb = story.blurb.lowercased().contains(lowercaseQuery)
            let inSource = story.sourceNatural.lowercased().contains(lowercaseQuery)
            return inHeadline || inBlurb || inSource
        }
        
        storyTable.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    func searchCleared(cell: SearchCell) {
        filteredStories = stories
        storyTable.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    // MARK: Headline Cell
    func tapOn(cell: HeadlineCell) {
        guard let indexPath = storyTable.indexPathForRow(at: cell.center) else { return }
        guard let url = urlForCell(at: indexPath.row) else { return }
        
        openBrowser(url: url)
    }
    
    func moreOptionsRequested(cell: HeadlineCell) {
        guard let indexPath = storyTable.indexPathForRow(at: cell.center) else { return }
        guard let url = urlForCell(at: indexPath.row) else { return }
        
        displayMoreOptions(for: url)
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        stories = NewsStore.getSharedStoreStories()
        view.backgroundColor = tnTeal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if NewsStore.needsRefresh {
            refreshStoryTable()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "frontPageToWeb" {
            guard let webVC = segue.destination as? WebController else { return }
            guard let presentSelectedRow = selectedRow else { return }
            
            let storyURL = urlForCell(at: presentSelectedRow)
            webVC.url = storyURL
        }
    }
    
    // MARK: Utility
    private func urlForCell(at row: Int) -> String? {
        let selectedStory = stories[row]
        selectedRow = nil
        return selectedStory.storyURL
    }
    
    private func refreshStoryTable() {
        NewsStore.updateSharedStore(completion: { (newStories) in
            NewsStore.needsRefresh = false
            OperationQueue.main.addOperation {
                self.stories = newStories
                self.storyTable.reloadData()
            }
        })
    }
    
    private func searchCellFor(tableView: UITableView, indexPath: IndexPath) -> SearchCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchCell else { return SearchCell() }
        
        cell.delegate = self
        
        return cell
    }
    
    private func headlineCellFor(tableView: UITableView, indexPath: IndexPath) -> HeadlineCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "headlineCell", for: indexPath) as? HeadlineCell else { return HeadlineCell() }
        let story = filteredStories[indexPath.row]
        
        cell.loadImage(url: story.imageURL)
        cell.sourceLabel.text = story.sourceNatural
        cell.headlineLabel.text = story.headline
        
        cell.delegate = self
        cell.panelView.layer.cornerRadius = 5.0
        
        return cell
    }
    
    // MARK: More Options
    private func displayMoreOptions(for url: String) {
        let actionSheet = UIAlertController(title: nil, message: "Share this article on", preferredStyle: .actionSheet)
        let shareToFacebookAction = UIAlertAction(title: "Facebook", style: .default) { (alertAction) in
            self.shareToFacebook(url: url)
        }
        let shareToTwitterAction = UIAlertAction(title: "Twitter", style: .default) { (alertAction) in
            self.shareToTwitter(url: url)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(shareToFacebookAction)
        actionSheet.addAction(shareToTwitterAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func openBrowser(url: String) {
        guard let validURL = URL(string: url) else { return }
        
        UIApplication.shared.open(validURL, options: [:]) { (success) in
            if success {
                print("Successfully opened URL: \(validURL)")
            } else {
                print("Failed to open URL: \(validURL)")
            }
        }
    }
    
    private func shareToFacebook(url: String) {
        guard let validURL = URL(string: url) else { return }
        
        let socialController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        socialController.add(validURL)
        socialController.setInitialText("Via TechNut: ")
        present(socialController, animated: true) { }
    }
    
    private func shareToTwitter(url: String) {
        guard let validURL = URL(string: url) else { return }
        
        let socialController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        socialController.add(validURL)
        socialController.setInitialText("Via TechNut: ")
        present(socialController, animated: true) { }
    }
}

class HeadlineCell: UITableViewCell {
    // MARK: UI Elements
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    // MARK: UI Actions
    @IBAction func moreOptionsTapped(_ sender: Any) {
        if let presentDelegate = privateDelegate {
            presentDelegate.moreOptionsRequested(cell: self)
        }
    }
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        guard let bookmarkButtonImageView = bookmarkButton.imageView else { return }
        if !bookmarkOn {
            bookmarkOn = true
            bookmarkButtonImageView.image = UIImage(named: "bookmark_teal_icon-1")
            bookmarkButton.alpha = 1.0
        } else {
            bookmarkOn = false
            bookmarkButtonImageView.image = UIImage(named: "bookmark_black_icon-1")
            bookmarkButton.alpha = 0.3
        }
    }
    
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
    
    // MARK: Bookmark Properties
    private var bookmarkOn: Bool = false
    
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
    func moreOptionsRequested(cell: HeadlineCell)
}

class SearchCell : UITableViewCell, UISearchBarDelegate {
    // MARK: UI Elements
    @IBOutlet weak var headlineSearchBar: UISearchBar!
    
    // MARK: User Interaction
    internal var delegate: SearchCellDelegate?
    
    // MARK: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let presentDelegate = delegate else { return }
        guard let presentText = searchBar.text else { return }
        
        if searchBar.text == "" {
            presentDelegate.searchCleared(cell: self)
        } else {
            presentDelegate.newSearch(cell: self, query: presentText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(false)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        if let presentDelegate = delegate {
            presentDelegate.searchCleared(cell: self)
        }
        
        searchBar.endEditing(false)
    }
}

protocol SearchCellDelegate {
    func newSearch(cell: SearchCell, query: String)
    func searchCleared(cell: SearchCell)
}
