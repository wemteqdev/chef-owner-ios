//
//  ShowDownloadFile.swift
//  Shop767
//
//  Created by Webkul on 23/06/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class ShowDownloadFile: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    public var documentUrl:NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlRequest = URLRequest(url: documentUrl as URL)
        webView.loadRequest(urlRequest)
        webView.scalesPageToFit = true
    }
    
    @IBAction func shareToOther(_ sender: Any) {
        do{
            let largeImageData = try Data(contentsOf: documentUrl as URL)
            let activityItems = [largeImageData]
            let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            if UI_USER_INTERFACE_IDIOM() == .phone {
                self.present(activityController, animated: true, completion: { })
            }else {
                let popup = UIPopoverController(contentViewController: activityController)
                popup.present(from: CGRect(x: CGFloat(self.view.frame.size.width / 2), y: CGFloat(self.view.frame.size.height / 4), width: CGFloat(0), height: CGFloat(0)), in: self.view, permittedArrowDirections: .any, animated: true)
            }
        }catch{
        }
    }
}
