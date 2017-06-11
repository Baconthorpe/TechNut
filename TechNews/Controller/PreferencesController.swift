//
//  PreferencesController.swift
//  TechNews
//
//  Created by Ezekiel Abuhoff on 6/3/17.
//  Copyright © 2017 Ezekiel Abuhoff. All rights reserved.
//

import UIKit

class PreferencesController: UIViewController, UITableViewDelegate, UITableViewDataSource, SourceCellDelegate {
    // MARK: UI Elements
    @IBOutlet weak var preferenceTable: UITableView!
    
    // MARK: Model Properties
    private lazy var sources: [String : Bool] = Preferences.getSources()
    
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
        
        cell.delegate = self
        cell.nameLabel.text = source
        cell.sourceSwitch.setOn(status, animated: false)
        
        return cell
    }
    
    // MARK: Source Cell
    func sourceCellToggled(cell: SourceCell, toggle: Bool) {
        guard let indexPath = preferenceTable.indexPathForRow(at: cell.center) else { return }
        
        let selectedRow = indexPath.row
        let sourceNames = Array(sources.keys)
        let source = sourceNames[selectedRow]
        Preferences.set(source: source, to: toggle)
        NewsStore.needsRefresh = true
    }
    
    // MARK: Life Cycle
    override func viewWillDisappear(_ animated: Bool) {
        Preferences.saveSources()
    }
}

class SourceCell: UITableViewCell {
    // MARK: UI Elements
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sourceSwitch: UISwitch!
    
    //MARK: Delegate
    internal var delegate: SourceCellDelegate?
    
    // MARK: Actions
    @IBAction func toggle(_ sender: Any) {
        if let presentDelegate = delegate {
            presentDelegate.sourceCellToggled(cell: self, toggle: sourceSwitch.isOn)
        }
    }
}

protocol SourceCellDelegate {
    func sourceCellToggled(cell: SourceCell, toggle: Bool)
}