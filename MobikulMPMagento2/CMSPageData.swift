//
//  CMSPageData.swift
//  Ajmal
//
//  Created by kunal prasad on 05/05/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CMSPageData: UIViewController{

public var cmsId:String!
public var cmsName:String!
let defaults = UserDefaults.standard;
    
@IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.isNavigationBarHidden = false
        self.title = cmsName
      
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.callingHttppApi();
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
    }

    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]();
        requstParams["id"] = cmsId
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/extra/cmsData", currentView: self){success,responseObject in
            if success == 1{
             print("sss", responseObject)
            self.doFurtherProcessingWithResult(data: (responseObject as! NSDictionary))
                
            }else if success == 2{
                self.callingHttppApi();
            }
        }
        
    }

    
    
    


    
    
    
    func doFurtherProcessingWithResult(data :NSDictionary){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true;
             GlobalData.sharedInstance.dismissLoader()
            self.webView.loadHTMLString(data.object(forKey: "content") as! String, baseURL: nil)
            
        }
    }
    
    

    
}
