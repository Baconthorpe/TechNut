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
}
