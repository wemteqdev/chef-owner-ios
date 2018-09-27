//
//  SellerWebViewController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 28/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerWebViewController: UIViewController {

    
@IBOutlet weak var webView: UIWebView!
var message:String!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadHTMLString(message, baseURL: nil)
    }

   

}
