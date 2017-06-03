//
//  WebController.swift
//  TechNews
//
//  Created by Ezekiel Abuhoff on 5/20/17.
//  Copyright © 2017 Ezekiel Abuhoff. All rights reserved.
//

import UIKit

class WebController: UIViewController {
    
    // MARK: UI Elements
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: UI Actions
    @IBAction func openInBrowserTapped(_ sender: Any) {
        openPageInBrowser()
    }
    
    // MARK: Passed-In Data
    var url: String?
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        loadPage()
    }
    
    // MARK: Populating Page
    internal func loadPage() {
        guard let presentURL = url else { return }
        guard let validURL = URL(string: presentURL) else { return }
        
        let request = URLRequest(url: validURL)
        webView.loadRequest(request)
    }
    
    // MARK: Opening Browser
    internal func openPageInBrowser() {
        guard let presentURL = url else { return }
        guard let validURL = URL(string: presentURL) else { return }
        
        UIApplication.shared.open(validURL, options: [:]) { (success) in
            if success {
                print("Successfully opened URL: \(validURL)")
            } else {
                print("Failed to open URL: \(validURL)")
            }
        }
    }
}
