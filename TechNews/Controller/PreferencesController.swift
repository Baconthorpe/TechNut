//
//  PreferencesController.swift
//  TechNews
//
//  Created by Ezekiel Abuhoff on 6/3/17.
//  Copyright © 2017 Ezekiel Abuhoff. All rights reserved.
//

import UIKit

class PreferencesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: UI Elements
    @IBOutlet weak var preferenceTable: UITableView!
    
    // MARK: Model Properties
    private var sources: [String : Bool] {
        get {
            return Preferences.getSources()
        }
    }
    
    // MARK: Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sourceCell", for: indexPath) as? SourceCell else { return UITableViewCell() }
        
        let sourceNames = Array(sources.keys)
        let source = sourceNames[indexPath.row]
        let status = sources[source] ?? false
        
        cell.nameLabel.text = source
        cell.sourceSwitch.setOn(status, animated: false)
        
        return cell
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        
    }
}

class SourceCell: UITableViewCell {
    // MARK: UI Elements
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sourceSwitch: UISwitch!
    
    // MARK: Actions
    @IBAction func toggle(_ sender: Any) {
        
    }
}
