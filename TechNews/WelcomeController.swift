//
//  WelcomeController.swift
//  TechNews
//
//  Created by Ezekiel Abuhoff on 5/20/17.
//  Copyright © 2017 Ezekiel Abuhoff. All rights reserved.
//

import UIKit

class WelcomeController: UIViewController {
    
    // MARK: UI Elements
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var topFlourishBar: UIView!
    @IBOutlet weak var bottomFlourishBar: UIView!
    
    // MARK: UI Constraints
    @IBOutlet weak var topFlourishHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomFlourishHeightConstraint: NSLayoutConstraint!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupFlourishBars()
    }
    
    // MARK: Automated Startup
    private func getData() {
        statusLabel.text = "Retrieving the news..."
        
        NewsStore.updateSharedStore { (stories) in
            OperationQueue.main.addOperation {
                self.dataGotten(success: true)
            }
        }
    }
    
    private func dataGotten(success: Bool) {
        statusLabel.text = "Read all about it!"
        
        animateFlourish {
            self.goToFrontPage()
        }
    }
    
    private func goToFrontPage() {
        performSegue(withIdentifier: "welcomeToFrontPage", sender: self)
    }
    
    // MARK: Flourish Animation
    private func setupFlourishBars() {
        topFlourishBar.backgroundColor = tnTeal
        bottomFlourishBar.backgroundColor = tnTeal
        
        topFlourishHeightConstraint.constant = 5
        bottomFlourishHeightConstraint.constant = 5
    }
    
    private func animateFlourish(andThen completion: @escaping () -> ()) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: { 
            self.topFlourishHeightConstraint.constant = 600
            self.bottomFlourishHeightConstraint.constant = 600
            
            self.view.layoutIfNeeded()
        }) { (completed) in
            completion()
        }
    }
}
