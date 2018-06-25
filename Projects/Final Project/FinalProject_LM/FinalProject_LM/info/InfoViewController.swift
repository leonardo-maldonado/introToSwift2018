//
//  InfoViewController.swift
//  FinalProject_LM
//
//  Created by Leonardo Maldonado on 6/18/18.
//  Copyright © 2018 Leonardo Maldonado. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebview()
    }
    
    func loadWebview() {
        let urlString = "https://data.pr.gov/Seguridad-P-blica/" +
            "Incidencia-Crime-Map/3fy3-2bc5"
        guard let url = URL(string: urlString)
            else { return }
        let request = URLRequest(url: url)
        webView.load(request);
    }
}
