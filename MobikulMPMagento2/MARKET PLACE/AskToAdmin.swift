//
//  AskToAdmin.swift
//  MobikulMp
//
//  Created by kunal prasad on 28/01/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class AskToAdmin: UIViewController {
    
    @IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var subjectTextField: UIFloatLabelTextField!
    @IBOutlet weak var queryTextField: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var queryLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "askquestiontoadmin")
        
        UITextField().bottomBorder(texField: subjectTextField)
        subjectTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        subjectTextField.placeholder = GlobalData.sharedInstance.language(key:"subject")
        
        submitButton.setTitle(GlobalData.sharedInstance.language(key:"submit"), for: .normal)
        submitButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR);
        
        queryLbl.text = GlobalData.sharedInstance.language(key: "query")
        
        mainViewHeightConstarints.constant = 500
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        let storeId = defaults.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        requstParams["query"] = queryTextField.text
        requstParams["subject"] = subjectTextField.text
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/askquestiontoadmin", currentView: self){success,responseObject in
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        defaults .set(storeId, forKey: "storeId")
                    }
                }
                GlobalData.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
                var dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    GlobalData.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                print("sss", responseObject)
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    @IBAction func AskToAdminButton(_ sender: Any) {
        var  isValid:Int = 1
        var errorMessage: String = GlobalData.sharedInstance.language(key: "pleasefill")
        if subjectTextField.text == ""{
            errorMessage = errorMessage+" "+GlobalData.sharedInstance.language(key:"subject");
            isValid = 0
        }
        else if queryTextField.text == ""{
            errorMessage = GlobalData.sharedInstance.language(key:"pleaseenterquery");
            isValid = 0
        }
        
        if isValid == 0{
            GlobalData.sharedInstance.showWarningSnackBar(msg: errorMessage)
            
        }
        if isValid == 1{
            self.callingHttppApi()
        }
    }
}
