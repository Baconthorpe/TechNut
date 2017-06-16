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
        let naturalizedSource = Story.naturalized(source: source)
        let status = sources[source] ?? false
        
        cell.delegate = self
        cell.nameLabel.text = naturalizedSource
        cell.sourceSwitch.setOn(status, animated: false)
        cell.panelView.layer.cornerRadius = 5.0
        cell.sourceSwitch.tintColor = tnTeal
        cell.sourceSwitch.onTintColor = tnTeal
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableCell(withIdentifier: "sourcesHeaderCell") else { return nil }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
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
    override func viewDidLoad() {
        view.backgroundColor = tnTeal
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Preferences.saveSources()
    }
}

class SourceCell: UITableViewCell {
    // MARK: UI Elements
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sourceSwitch: UISwitch!
    @IBOutlet weak var panelView: UIView!
    
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
