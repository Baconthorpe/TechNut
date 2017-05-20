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
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        getData()
    }
    
    // MARK: Automated Startup
    func getData() {
        statusLabel.text = "Retrieving the news..."
        
        NewsStore.updateSharedStore { (stories) in
            OperationQueue.main.addOperation {
                self.dataGotten(success: true)
            }
        }
    }
    
    func dataGotten(success: Bool) {
        statusLabel.text = "Read all about it!"
        
        UIView.animate(withDuration: 3.0, animations: { 
            self.statusLabel.alpha = 0.0
        }) { (completed) in
            self.statusLabel.alpha = 1.0
            self.goToFrontPage()
        }
    }
    
    func goToFrontPage() {
        performSegue(withIdentifier: "welcomeToFrontPage", sender: self)
    }
}
