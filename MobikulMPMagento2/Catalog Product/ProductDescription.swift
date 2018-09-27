//
//  ProductDescription.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 14/09/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class ProductDescription: UIViewController {
    

var descriptionData:String!
    
@IBOutlet weak var descriptionWebView: UIWebView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = GlobalData.sharedInstance.language(key: "description")
        
        if descriptionData == ""    {
            GlobalData.sharedInstance.showWarningSnackBar(msg: GlobalData.sharedInstance.language(key: "Nodescriptiondataavailable"))
            self.navigationController?.popViewController(animated: true)
        }
        
        self.descriptionWebView.loadHTMLString(descriptionData, baseURL: nil)
    }

}
