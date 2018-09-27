//
//  Forgotpassword.swift
//  MobikulMPMagento2
//
//  Created by Othello on 13/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Forgotpassword: UIViewController {
    
    @IBOutlet weak var emailIdField: UIFloatLabelTextField!


    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var baselineView: UIView!
    
    
    var emailId:String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailIdField.textColor = UIColor.white
        
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.backgroundColor = UIColor(red: 1, green: 1, blue:1, alpha: 1)
        
        submitButton.layer.cornerRadius = 25
        submitButton.layer.masksToBounds = true
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.white.cgColor
    submitButton.setTitle(GlobalData.sharedInstance.language(key: "submit"), for: .normal)
        
        submitButton.setTitleColor(UIColor().HexToColor(hexString: "5897FF"), for: .normal)
        baselineView.layer.cornerRadius = 2.5

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func submitClick(_ sender: UIButton) {
        view.endEditing(true)
        emailId = emailIdField.text!
        
        var isValid = 0;
        var errorMessage = ""
        
        if !GlobalData.sharedInstance.checkValidEmail(data: emailId){
            isValid = 1;
            errorMessage = GlobalData.sharedInstance.language(key: "pleaseentervalidemail");
        }
        
        if isValid == 1{
            GlobalData.sharedInstance.showErrorSnackBar(msg: errorMessage)
            
        }else{
            callingHttppApi()
        }
    }
    
    func callingHttppApi()  {
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        if defaults.object(forKey: "storeId") != nil{
            requstParams["storeId"] = defaults.object(forKey: "storeId") as! String
        }
        let quoteId = defaults.object(forKey:"quoteId");
        let deviceToken = defaults.object(forKey:"deviceToken");
        if(quoteId != nil){
            requstParams["quoteId"] = quoteId
        }
        if deviceToken != nil{
            requstParams["token"] = deviceToken
        }
        
        
        requstParams["email"] = self.emailId
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/forgotpassword", currentView: self){success,responseObject in
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        defaults .set(storeId, forKey: "storeId")
                    }
                }
                
                GlobalData.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
                let dict  = JSON(responseObject as! NSDictionary)
                print(dict)
                if dict["success"].boolValue == true{
                    GlobalData.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                
            }else if success == 2{
                self.callingHttppApi()
                GlobalData.sharedInstance.dismissLoader()
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
