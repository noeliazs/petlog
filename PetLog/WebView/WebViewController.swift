//
//  WebViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 26/08/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKNavigationDelegate {
    
   var webView: WKWebView!
    
    var url: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print(url)
        
        webView = WKWebView()
        view = webView
        webView.navigationDelegate = self
        load(url: url)

    }
    
    
    public func load(url: String){
        webView.load(URLRequest(url: URL(string: url)!))
        webView.allowsBackForwardNavigationGestures = true
        webView.reload()
    }



}
