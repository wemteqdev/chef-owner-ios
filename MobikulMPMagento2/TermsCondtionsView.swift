//
//  TermsCondtionsView.swift
//  Chef-Supplier
//
//  Created by Othello on 17/10/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class TermsCondtionsView: UIViewController {
    let defaults = UserDefaults.standard;

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var maintext: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.layer.cornerRadius = 20
        cancelButton.layer.masksToBounds = true
        acceptButton.layer.cornerRadius = 20
        acceptButton.layer.masksToBounds = true
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.white.cgColor
        callingHttppApi()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func callingHttppApi()
    {
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]();
        if self.defaults.object(forKey: "storeId") != nil{
            requstParams["storeId"] = self.defaults.object(forKey: "storeId") as! String
        }
        else{
            requstParams["storeId"] = "0"
            
        }
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/directory/agreement", currentView: self){success,responseObject in
            if success == 1{
                print(responseObject)
                let dict = JSON(responseObject as! NSDictionary)
                self.maintext.text = dict["content"].stringValue
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
