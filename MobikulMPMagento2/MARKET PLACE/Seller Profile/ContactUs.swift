//
//  ContactUs.swift
//  MobikulMp
//
//  Created by kunal prasad on 18/01/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class ContactUs: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var nametextField: UIFloatLabelTextField!
    @IBOutlet weak var emailTextField: UIFloatLabelTextField!
    @IBOutlet weak var subjectTextField: UIFloatLabelTextField!
    @IBOutlet weak var summaryData: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var queryLbl: UILabel!
    
    var contactUsDataDictionary = [String :String]()
    let defaults = UserDefaults.standard;
    var keyBoardFlag:Int = 1
    public var sellerId:String!
    public var productId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summaryData.layer.borderWidth = 1.0
        summaryData.layer.borderColor = UIColor.lightGray.cgColor
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "contactus")
        
        nametextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        emailTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        subjectTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        submitButton.setTitle(GlobalData.sharedInstance.language(key:"submit"), for:.normal)
        
        nametextField.placeholder = GlobalData.sharedInstance.language(key:"entername")
        emailTextField.placeholder = GlobalData.sharedInstance.language(key:"enteremail")
        subjectTextField.placeholder = GlobalData.sharedInstance.language(key:"subject")
        
        queryLbl.text = GlobalData.sharedInstance.language(key: "query")
        
        if((defaults.object(forKey: "customerName")) != nil){
            nametextField.text = defaults.object(forKey: "customerName") as! String?;
        }
        if((defaults.object(forKey: "customerEmail")) != nil){
            emailTextField.text = defaults.object(forKey: "customerEmail") as! String?;
        }
        
        mainViewHeightConstarints.constant = 500
    }
    
    
    
    
    
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        let storeId = defaults.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        
        requstParams["sellerid"] = sellerId
        requstParams["query"] = contactUsDataDictionary["query"]!
        requstParams["subject"] = contactUsDataDictionary["subject"]!
        requstParams["email"] = contactUsDataDictionary["email"]!
        requstParams["name"] =  contactUsDataDictionary["name"]!
        requstParams["productId"] = productId
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/ContactSeller", currentView: self){success,responseObject in
            if success == 1{
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                var dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    GlobalData.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                
                print("dsd", responseObject)
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        contactUsDataDictionary = [String :String]();
        var  isValid:Int = 1
        var errorMessage: String = "Please Fill"
        
        if (summaryData?.text == "") {
            isValid = 0
            errorMessage = GlobalData.sharedInstance.language(key:"pleaseenterquery")
        }
        if subjectTextField?.text == "" {
            isValid = 0
            errorMessage = GlobalData.sharedInstance.language(key:"pleaseentersubject")
        }
        if emailTextField?.text == "" {
            isValid = 0
            errorMessage = GlobalData.sharedInstance.language(key:"pleasefillemailid")
        }
        if !GlobalData.sharedInstance.checkValidEmail(data: emailTextField.text!){
            isValid = 0
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefilllvalidemail");
        }
        if nametextField?.text == "" {
            isValid = 0
            errorMessage = GlobalData.sharedInstance.language(key:"entername")
        }
        
        if isValid == 1 {
            contactUsDataDictionary["name"] = nametextField?.text
            contactUsDataDictionary["email"] = emailTextField?.text
            contactUsDataDictionary["subject"] = subjectTextField?.text
            contactUsDataDictionary["query"] = summaryData?.text
            isValid = 2
        }
        
        if isValid == 0{
            GlobalData.sharedInstance.showWarningSnackBar(msg:errorMessage )
        }
        if isValid == 2 {
            self.callingHttppApi()
        }
    }
}
