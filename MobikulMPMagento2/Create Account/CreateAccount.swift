//
//  CreateAccount.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 18/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CreateAccount: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource{
    
    let defaults = UserDefaults.standard;
    var createAccountModel:CreateAccountModel!
    
    
    @IBOutlet weak var prefixTextField: UIFloatLabelTextField!
    @IBOutlet weak var firstNametextField: UIFloatLabelTextField!
    @IBOutlet weak var middleNametextField: UIFloatLabelTextField!
    @IBOutlet weak var lastNametextField: UIFloatLabelTextField!
    @IBOutlet weak var suffixtextfield: UIFloatLabelTextField!
    @IBOutlet weak var emailTextFeild: UIFloatLabelTextField!
    @IBOutlet weak var mobileNumbertextfield: UIFloatLabelTextField!
    @IBOutlet weak var dateOfBirthTextfield: UIFloatLabelTextField!
    @IBOutlet weak var taxvalueTextField: UIFloatLabelTextField!
    @IBOutlet weak var genderTextField: UIFloatLabelTextField!
    @IBOutlet weak var passwordtextField: HideShowPasswordTextField!
    @IBOutlet weak var confirmTextField: HideShowPasswordTextField!
    @IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var prefixTextfieldHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var middleNameheightConstraints: NSLayoutConstraint!
    @IBOutlet weak var suffixtextFieldHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var mobileNumberHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var dateOfBirthTextHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var taxValueHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var genderheightConstarints: NSLayoutConstraint!
    var prefixValueArray:NSArray = []
    var suffixValueArray:NSArray = []
    var genderValueArray:NSMutableArray = [];
    @IBOutlet weak var registerButton: UIButton!
    var keyBoardFlag:Int = 1
    var whichApitoprocess:String = ""
    var movetoSignal:String = ""
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var marketPlaceView: UIView!
    @IBOutlet weak var doyouwanttobecomesellerLabel: UILabel!
    @IBOutlet weak var shopurltextField: SkyFloatingLabelTextField!
    @IBOutlet weak var shopNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var marketPlaceHeight: NSLayoutConstraint!
    var isSellerChoice:Bool = false
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        mainViewHeightConstarints.constant = 900;
        whichApitoprocess = ""
        callingHttppApi()
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "createaccount")
        
        prefixTextField.placeholder = GlobalData.sharedInstance.language(key: "prefix")
        firstNametextField.placeholder = GlobalData.sharedInstance.language(key: "firstname")
        lastNametextField.placeholder = GlobalData.sharedInstance.language(key: "lastname")
        middleNametextField.placeholder = GlobalData.sharedInstance.language(key: "middlename")
        suffixtextfield.placeholder = GlobalData.sharedInstance.language(key: "suffix")
        emailTextFeild.placeholder = GlobalData.sharedInstance.language(key: "email")
        mobileNumbertextfield.placeholder = GlobalData.sharedInstance.language(key: "mobileno")
        dateOfBirthTextfield.placeholder = GlobalData.sharedInstance.language(key: "dob")
        taxvalueTextField.placeholder = GlobalData.sharedInstance.language(key: "taxvat")
        genderTextField.placeholder = GlobalData.sharedInstance.language(key: "gender")
        passwordtextField.placeholder = GlobalData.sharedInstance.language(key: "password")
        confirmTextField.placeholder = GlobalData.sharedInstance.language(key: "conpassword")
        
        registerButton.setTitle(GlobalData.sharedInstance.language(key: "register"), for: .normal)
        registerButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        prefixTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        firstNametextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        lastNametextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        middleNametextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        suffixtextfield.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        emailTextFeild.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        mobileNumbertextfield.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        dateOfBirthTextfield.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        taxvalueTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        genderTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        passwordtextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        confirmTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        self.mainView.isHidden = true;
        
        shopNameTextField.placeholder = GlobalData.sharedInstance.language(key: "shopname")
        shopurltextField.placeholder = GlobalData.sharedInstance.language(key: "shopurl")
        self.marketPlaceHeight.constant = 50;
        self.shopurltextField.isHidden = true
        self.shopNameTextField.isHidden = true
        
        doyouwanttobecomesellerLabel.text = GlobalData.sharedInstance.language(key: "doyouwanttobecomeseller")
    }
    
    
    func donePressed(_ sender: UIBarButtonItem) {
        dateOfBirthTextfield.resignFirstResponder()
        prefixTextField.resignFirstResponder()
        suffixtextfield.resignFirstResponder()
        genderTextField.resignFirstResponder()
    }
    
    
    @IBAction func becomeSellerClick(_ sender: UISwitch) {
        if sender.isOn{
            isSellerChoice = true
            self.marketPlaceHeight.constant = 150;
            
            self.shopurltextField.isHidden = false
            self.shopNameTextField.isHidden = false
            self.mainViewHeightConstarints.constant += 100;
        }else{
            isSellerChoice = false
            self.marketPlaceHeight.constant = 50;
            self.shopurltextField.isHidden = true
            self.shopNameTextField.isHidden = true
            self.mainViewHeightConstarints.constant -= 100;
        }
        
    }
    
    
    
    
    func callingHttppApi(){
        
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        if whichApitoprocess == "createaccount"{
            
            var requstParams = [String:Any]();
            let quoteId = defaults.object(forKey:"quoteId");
            let deviceToken = defaults.object(forKey:"deviceToken");
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["websiteId"] = DEFAULT_WEBSITE_ID
            if quoteId != nil{
                requstParams["quoteId"] = quoteId;
            }
            if deviceToken != nil{
                requstParams["token"] = deviceToken
            }
            requstParams["firstName"] = firstNametextField.text
            requstParams["lastName"] = lastNametextField.text
            requstParams["email"] = emailTextFeild.text
            requstParams["prefix"] = prefixTextField.text
            requstParams["suffix"] = suffixtextfield.text
            requstParams["middleName"] = middleNametextField.text
            requstParams["mobile"] = mobileNumbertextfield.text
            requstParams["dob"] = dateOfBirthTextfield.text
            requstParams["taxvat"] = taxvalueTextField.text
            requstParams["isSocial"] = "0"
            requstParams["pictureURL"] = ""
            requstParams["password"] = passwordtextField.text
            var value:String = ""
            if genderTextField.text == "Male"{
                value = "1"
            }else if genderTextField.text == "Female"{
                value = "0"
            }
            
            requstParams["gender"] = value
            requstParams["becomeSeller"] = "0"
            if isSellerChoice == true{
                requstParams["shopUrl"] = shopurltextField.text
//                requstParams["storeName"] = shopNameTextField.text
                requstParams["becomeSeller"] = "1"
            }
            
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/createAccount", currentView: self){success,responseObject in
                if success == 1{
                    print(responseObject)
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        self.defaults.set(dict["customerEmail"].stringValue, forKey: "customerEmail")
                        self.defaults.set(dict["customerToken"].stringValue, forKey: "customerId")
                        self.defaults.set(dict["customerName"].stringValue, forKey: "customerName")
                        if(self.defaults.object(forKey: "quoteId") != nil){
                            self.defaults.set(nil, forKey: "quoteId")
                            self.defaults.synchronize();
                        }
                        UserDefaults.standard.removeObject(forKey: "quoteId")
                        if dict["isSeller"].intValue == 0{
                            self.defaults.set("f", forKey: "isSeller")
                        }else{
                            self.defaults.set("t", forKey: "isSeller")
                        }
                        
                        if dict["isPending"].intValue == 0{
                            self.defaults.set("f", forKey: "isPending")
                            
                        }else{
                            self.defaults.set("t", forKey: "isPending")
                        }
                        
                        
                        if dict["isAdmin"].intValue == 0{
                            self.defaults.set("f", forKey: "isAdmin")
                        }else{
                            self.defaults.set("t", forKey: "isAdmin")
                        }
                        
                        
                        self.defaults.synchronize()
                        GlobalData.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                        if self.movetoSignal == "cart"{
                            self.performSegue(withIdentifier: "checkout", sender: self)
                        }
                        self.tabBarController?.tabBar.isHidden = false
                        self.navigationController?.popToRootViewController(animated:true)
                        
                    }
                    else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                    
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        }
        else{
            var requstParams = [String:Any]();
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/createAccountFormData", currentView: self){success,responseObject in
                if success == 1{
                    
                    print(responseObject)
                    self.createAccountModel = CreateAccountModel(data:JSON(responseObject as! NSDictionary))
                    self.doFurtherProcessingwithResult()
                    self.view.isUserInteractionEnabled = true
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
        
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    
    
    
    
    @IBAction func prefixClick(_ sender: Any) {
        if createAccountModel.isPrefixHasOption == true{
            let thePicker = UIPickerView()
            thePicker.tag = 1000;
            prefixTextField.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    
    @IBAction func suffixClick(_ sender: UIFloatLabelTextField) {
        if createAccountModel.isPrefixHasOption == true{
            let thePicker = UIPickerView()
            thePicker.tag = 2000;
            suffixtextfield.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    
    @IBAction func dateOfBirthClick(_ sender: Any) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.tag = 4000;
        datePickerView.datePickerMode = UIDatePickerMode.date
        dateOfBirthTextfield.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(CreateAccount.datePickerFromValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func genderClick(_ sender: UIFloatLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 3000;
        genderTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = createAccountModel.dateFormat
        dateOfBirthTextfield.text = dateFormatter.string(from: sender.date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1000){
            return self.prefixValueArray.count;
        }else if(pickerView.tag == 2000){
            return self.suffixValueArray.count;
        }else if(pickerView.tag == 3000){
            return self.genderValueArray.count;
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1000{
            return prefixValueArray.object(at: row) as? String
            
        }else if pickerView.tag == 2000{
            return suffixValueArray.object(at: row) as? String
            
        }else if pickerView.tag == 3000{
            return genderValueArray.object(at: row) as? String
            
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.tag == 1000){
            prefixTextField.text = prefixValueArray.object(at: row) as? String
        }else if(pickerView.tag == 2000){
            suffixtextfield.text = suffixValueArray.object(at: row) as? String
        }else if(pickerView.tag == 3000){
            genderTextField.text = genderValueArray.object(at: row) as? String
        }
        
        
        
    }
    
    
    
    func doFurtherProcessingwithResult(){
        self.mainView.isHidden = false;
        GlobalData.sharedInstance.dismissLoader()
        
        prefixValueArray = createAccountModel.prefixValue! as NSArray
        suffixValueArray = createAccountModel.suffixValue! as NSArray
        if createAccountModel.isGenderRequired{
            self.genderValueArray = ["Female", "Male"];
        }else{
            self.genderValueArray = ["Female", "Male",""];
        }
        
        self.mainViewHeightConstarints.constant -= 350;
        var totalHeight:CGFloat = 0;
        self.prefixTextfieldHeightConstarints.constant = 0;
        self.middleNameheightConstraints.constant = 0
        self.suffixtextFieldHeightConstarints.constant = 0
        self.mobileNumberHeightConstarints.constant = 0
        self.dateOfBirthTextHeightConstraints.constant = 0
        self.taxValueHeightConstarints.constant = 0
        self.genderheightConstarints.constant = 0
        
        self.prefixTextField.isHidden = true
        self.middleNametextField.isHidden = true
        self.suffixtextfield.isHidden = true
        self.mobileNumbertextfield.isHidden = true
        self.dateOfBirthTextfield.isHidden = true
        self.taxvalueTextField.isHidden = true
        self.genderTextField.isHidden = true;
        
        print("adad",createAccountModel.isPrefixVisible)
        
        
        if createAccountModel.isPrefixVisible{
            self.prefixTextField.isHidden = false
            totalHeight += 50;
            self.prefixTextfieldHeightConstarints.constant = 50
        }
        if createAccountModel.isMiddleNameVisible{
            self.middleNametextField.isHidden = false
            totalHeight += 50;
            self.middleNameheightConstraints.constant = 50
        }
        if createAccountModel.isSuffixVisible{
            self.suffixtextfield.isHidden = false
            totalHeight += 50;
            self.suffixtextFieldHeightConstarints.constant = 50
        }
        if createAccountModel.isMobileNumberVisible{
            self.mobileNumbertextfield.isHidden = false
            totalHeight += 50;
            self.mobileNumberHeightConstarints.constant = 50
        }
        if createAccountModel.isDobVisible{
            self.dateOfBirthTextfield.isHidden = false
            totalHeight += 50;
            self.dateOfBirthTextHeightConstraints.constant = 50
        }
        if createAccountModel.isTaxVisible{
            self.taxvalueTextField.isHidden = false
            totalHeight += 50;
            self.taxValueHeightConstarints.constant = 50
        }
        if createAccountModel.isGenderVisible{
            self.genderTextField.isHidden = false;
            totalHeight += 50;
            self.genderheightConstarints.constant = 50
        }
        self.mainViewHeightConstarints.constant += totalHeight;
        
        
    }
    
    
    
    @IBAction func registerClick(_ sender: Any) {
        var errorMessage = "";
        var isValid:Int = 1;
        print("calling")
        if firstNametextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillfirstname");
        }else if lastNametextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefilllastname");
        }else if !GlobalData.sharedInstance.checkValidEmail(data: emailTextFeild.text!){
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefilllvalidemail");
        }else if passwordtextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillpassword");
        }else if confirmTextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillconfirmnewpassword");
        }
        if createAccountModel.isPrefixRequired{
            if prefixTextField.text == ""{
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "plesefillprefix")
            }
        }
        if createAccountModel.isSuffixRequired{
            if suffixtextfield.text == ""{
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "plesefillsuffix")
            }
        }
        if createAccountModel.isMobileNumberRequired{
            if mobileNumbertextfield.text == ""{
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "pleasefillmobilenumber")
            }
        }
        if createAccountModel.isDobRequired{
            if dateOfBirthTextfield.text == ""{
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "plesefilldob")
            }
        }
        if createAccountModel.isTaxRequired{
            if taxvalueTextField.text == ""{
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "plesefilltaxvat")
            }
        }
        if createAccountModel.isGenderRequired{
            if genderTextField.text == ""{
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "plesefillgender")
            }
        }
        if isSellerChoice == true && shopurltextField.text == ""{
            isValid = 0;
            errorMessage = "Fill Shop URL"
        }
        if isSellerChoice == true && shopNameTextField.text == ""{
            isValid = 0;
            errorMessage = "Fill Shop Name"
        }
        
        
        if isValid == 0{
            GlobalData.sharedInstance.showErrorSnackBar(msg: errorMessage)
        }else{
            
            if passwordtextField.text != confirmTextField.text{
                GlobalData.sharedInstance.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key: "passwordnotmatch"))
            }
            else if (passwordtextField.text?.characters.count)! < 6{
                GlobalData.sharedInstance.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key: "passwordlength"))
            }
            else{
                whichApitoprocess = "createaccount"
                callingHttppApi()
                
            }
            
            
        }
        
    }
    
    
    
    
}
