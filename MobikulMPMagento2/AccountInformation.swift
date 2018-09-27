//
//  AccountInformation.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 21/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class AccountInformation: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    let defaults = UserDefaults.standard;
    var accountInfoModel:AccountInformationModel!
    
    @IBOutlet weak var prefixTextField: UIFloatLabelTextField!
    @IBOutlet weak var prefixtextFieldHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var firstNameTextField: UIFloatLabelTextField!
    @IBOutlet weak var middleNameTextField: UIFloatLabelTextField!
    @IBOutlet weak var middleNameTextFieldHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var lasttNametextField: UIFloatLabelTextField!
    @IBOutlet weak var suffixtextField: UIFloatLabelTextField!
    @IBOutlet weak var suffixtextFieldHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var emailtextField: UIFloatLabelTextField!
    @IBOutlet weak var mobileNumbertextFeild: UIFloatLabelTextField!
    @IBOutlet weak var mobileNumberTextFeildheightConstarints: NSLayoutConstraint!
    @IBOutlet weak var dobTextFeild: UIFloatLabelTextField!
    @IBOutlet weak var dobTextFeildheightConstarints: NSLayoutConstraint!
    @IBOutlet weak var taxValuetextField: UIFloatLabelTextField!
    @IBOutlet weak var taxValueHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var genderTextFeild: UIFloatLabelTextField!
    @IBOutlet weak var genderTextFeildHeightConstarints: NSLayoutConstraint!
    
    
    @IBOutlet weak var currentPasswordTextField: HideShowPasswordTextField!
    @IBOutlet weak var passwordtextFeildHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var confirmtextFeild: HideShowPasswordTextField!
    @IBOutlet weak var confirmtextFeildHeightConstarints: NSLayoutConstraint!
    
    
    @IBOutlet weak var confirmNewTextField: HideShowPasswordTextField!
    
    @IBOutlet weak var confirmNewTextFieldHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var changePasswordLabel: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var changeEmailLabel: UILabel!
    
    
    var keyBoardFlag:Int = 1
    var prefixValueArray:NSArray = []
    var suffixValueArray:NSArray = []
    var genderValueArray:NSMutableArray = [];
    var changePasswordFlag:Bool = false
    var whichApiToProcess:String = ""
    var changeEmailFlag:Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
        
        self.navigationController?.isNavigationBarHidden = false
        passwordtextFeildHeightConstarints.constant = 0
        confirmtextFeildHeightConstarints.constant = 0
        confirmNewTextFieldHeightConstarints.constant = 0
        self.mainViewHeightConstarints.constant = 600;
        GlobalData.sharedInstance.removePreviousNetworkCall()
        GlobalData.sharedInstance.dismissLoader()
        self.callingHttppApi()
        
        
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "myaccountinformation")
        
        
        prefixTextField.placeholder = GlobalData.sharedInstance.language(key: "prefix")
        firstNameTextField.placeholder = GlobalData.sharedInstance.language(key: "firstname")
        middleNameTextField.placeholder = GlobalData.sharedInstance.language(key: "middlename")
        lasttNametextField.placeholder = GlobalData.sharedInstance.language(key: "lastname")
        suffixtextField.placeholder = GlobalData.sharedInstance.language(key: "suffix")
        emailtextField.placeholder = GlobalData.sharedInstance.language(key: "email")
        mobileNumbertextFeild.placeholder = GlobalData.sharedInstance.language(key: "mobileno")
        dobTextFeild.placeholder = GlobalData.sharedInstance.language(key: "dob")
        taxValuetextField.placeholder = GlobalData.sharedInstance.language(key: "taxvat")
        genderTextFeild.placeholder = GlobalData.sharedInstance.language(key: "gender")
        currentPasswordTextField.placeholder = GlobalData.sharedInstance.language(key: "currentpassword")
        confirmtextFeild.placeholder = GlobalData.sharedInstance.language(key: "confirmpassword")
        confirmNewTextField.placeholder = GlobalData.sharedInstance.language(key: "confirmnewpassword")
        changePasswordLabel.text = GlobalData.sharedInstance.language(key: "changepassword")
        changeEmailLabel.text = GlobalData.sharedInstance.language(key: "changeemail")
        
        prefixTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        firstNameTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        middleNameTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        lasttNametextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        suffixtextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        emailtextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        dobTextFeild.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        taxValuetextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        currentPasswordTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        confirmtextFeild.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        confirmNewTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        genderTextFeild.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        mobileNumbertextFeild.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        self.mainView.isHidden = true;
        
        
        saveButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        saveButton.layer.cornerRadius = 5
        saveButton.clipsToBounds = true
        saveButton.setTitle("save", for: .normal)
        
        emailtextField.isEnabled = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        if self.isMovingToParentViewController{
            print("4nd pushed")
        }else{
            print("clear the previous")
            GlobalData.sharedInstance.removePreviousNetworkCall()
            GlobalData.sharedInstance.dismissLoader()
        }
    }
    
    
    @IBAction func changeEmailClick(_ sender: UISwitch) {
        if sender.isOn{
            emailtextField.isEnabled = true
            changeEmailFlag = true
            passwordtextFeildHeightConstarints.constant = 50;
        }else{
            emailtextField.isEnabled = false
            changeEmailFlag = false
            if changePasswordFlag == false{
                passwordtextFeildHeightConstarints.constant = 0;
            }
        }
        
        
    }
    
    
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        if whichApiToProcess == "customerEditPost"{
            var requstParams = [String:Any]();
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["websiteId"] = DEFAULT_WEBSITE_ID
            requstParams["customerToken"] = defaults.object(forKey: "customerId") as! String
            requstParams["firstName"] = firstNameTextField.text
            requstParams["lastName"] = lasttNametextField.text
            requstParams["email"] = emailtextField.text
            requstParams["prefix"] = prefixTextField.text
            requstParams["suffix"] = suffixtextField.text
            requstParams["middleName"] = middleNameTextField.text
            requstParams["mobile"] = mobileNumbertextFeild.text
            requstParams["dob"] = dobTextFeild.text
            requstParams["taxvat"] = taxValuetextField.text
            requstParams["currentPassword"] = currentPasswordTextField.text
            var value:String = ""
            if genderTextFeild.text == "Male"{
                value = "1"
            }else if genderTextFeild.text == "Female"{
                value = "0"
            }
            requstParams["newPassword"] = confirmNewTextField.text
            requstParams["confirmPassword"] = confirmtextFeild.text
            if changePasswordFlag == true{
                requstParams["doChangePassword"] = "1"
            }else{
                requstParams["doChangePassword"] = "0"
            }
            
            if changeEmailFlag == true{
                requstParams["doChangeEmail"] = "1"
            }else{
                requstParams["doChangeEmail"] = "0"
            }
            
            
            
            requstParams["gender"] = value
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/saveAccountInfo", currentView: self){success,responseObject in
                if success == 1{
                    
                    GlobalData.sharedInstance.dismissLoader()
                    
                    
                    let dict = responseObject as! NSDictionary
                    
                    print(dict)
                    if dict.object(forKey: "success") as! Bool == true{
                        GlobalData.sharedInstance.showSuccessMessageWithBack(view: self,message:dict.object(forKey: "message") as! String )
                        
                        var name = self.firstNameTextField.text!+" "+self.lasttNametextField.text!
                        self.defaults.set(name, forKey: "customerName")
                        self.defaults.synchronize()
                        self.navigationController?.popViewController(animated: true)
                        
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict.object(forKey: "message") as! String)
                    }
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else{
            var requstParams = [String:Any]();
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["websiteId"] = DEFAULT_WEBSITE_ID
            requstParams["customerToken"] = defaults.object(forKey: "customerId") as! String
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/accountInfoData", currentView: self){success,responseObject in
                if success == 1{
                    
                    print((responseObject as! NSDictionary))
                    self.accountInfoModel  = AccountInformationModel(data: JSON(responseObject as! NSDictionary))
                    self.doFurtherProcessingwithResult()
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
        
    }
    
    
    
    @IBAction func selectPrefix(_ sender: UIFloatLabelTextField) {
        if accountInfoModel.isPrefixHasOption == true{
            let thePicker = UIPickerView()
            thePicker.tag = 1000;
            prefixTextField.inputView = thePicker
            thePicker.delegate = self
        }
        
    }
    
    @IBAction func selectSuffix(_ sender: Any) {
        if accountInfoModel.isPrefixHasOption == true{
            let thePicker = UIPickerView()
            thePicker.tag = 2000;
            suffixtextField.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    
    @IBAction func selctDob(_ sender: Any) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.tag = 4000;
        datePickerView.datePickerMode = UIDatePickerMode.date
        dobTextFeild.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AccountInformation.datePickerFromValueChanged), for: UIControlEvents.valueChanged)
    }
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = accountInfoModel.dateFormat
        dobTextFeild.text = dateFormatter.string(from: sender.date)
    }
    
    
    @IBAction func selectGender(_ sender: Any) {
        let thePicker = UIPickerView()
        thePicker.tag = 3000;
        genderTextFeild.inputView = thePicker
        thePicker.delegate = self
        
    }
    
    
    @IBAction func changePasswordClick(_ sender: UISwitch) {
        if sender.isOn{
            changePasswordFlag = true;
            passwordtextFeildHeightConstarints.constant = 50;
            confirmtextFeildHeightConstarints.constant = 50
            confirmNewTextFieldHeightConstarints.constant = 50
            
        }else{
            changePasswordFlag = false;
            if changeEmailFlag == false{
                passwordtextFeildHeightConstarints.constant = 0;
            }
            confirmtextFeildHeightConstarints.constant = 0
            confirmNewTextFieldHeightConstarints.constant = 0
        }
        
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
            suffixtextField.text = suffixValueArray.object(at: row) as? String
        }else if(pickerView.tag == 3000){
            genderTextFeild.text = genderValueArray.object(at: row) as? String
        }
    }
    
    @IBAction func dismissKeyBoard(_ sender: Any) {
        view.endEditing(true)
    }
    
    func doFurtherProcessingwithResult(){
        GlobalData.sharedInstance.dismissLoader()
        self.mainView.isHidden = false;
        prefixTextField.text = accountInfoModel.receivePrefixValue
        firstNameTextField.text = accountInfoModel.firstName
        middleNameTextField.text = accountInfoModel.middleName
        lasttNametextField.text = accountInfoModel.lastName
        suffixtextField.text = accountInfoModel.receiveSuffixValue
        emailtextField.text = accountInfoModel.emailId
        mobileNumbertextFeild.text = accountInfoModel.mobileNumber
        dobTextFeild.text = accountInfoModel.dobValue
        taxValuetextField.text = accountInfoModel.taxValue
        
        prefixValueArray = accountInfoModel.prefixValue! as NSArray
        suffixValueArray = accountInfoModel.suffixValue! as NSArray
        if accountInfoModel.isGenderRequired{
            self.genderValueArray = ["Female", "Male"]
        }else{
            self.genderValueArray = ["Female", "Male",""]
        }
        
        let pos:Int = accountInfoModel.genderValue ?? 0
        genderTextFeild.text = self.genderValueArray[pos] as? String ?? ""
        
        
        prefixtextFieldHeightConstarints.constant = 0;
        middleNameTextFieldHeightConstarints.constant = 0
        suffixtextFieldHeightConstarints.constant = 0
        mobileNumberTextFeildheightConstarints.constant = 0
        dobTextFeildheightConstarints.constant = 0
        taxValueHeightConstarints.constant = 0
        genderTextFeildHeightConstarints.constant = 0
        
        var totalHeight:CGFloat = 0
        
        if accountInfoModel.isPrefixVisible{
            totalHeight += 50
            prefixtextFieldHeightConstarints.constant = 50
        }
        if accountInfoModel.isMiddleNameVisible{
            totalHeight += 50
            middleNameTextFieldHeightConstarints.constant = 50
        }
        if accountInfoModel.isSuffixVisible{
            totalHeight += 50
            suffixtextFieldHeightConstarints.constant = 50
        }
        if accountInfoModel.isMobileNumberVisible{
            totalHeight += 50
            mobileNumberTextFeildheightConstarints.constant = 50
        }
        if accountInfoModel.isDobVisible{
            totalHeight += 50
            dobTextFeildheightConstarints.constant = 50
        }
        if accountInfoModel.isTaxVisible{
            totalHeight += 50
            taxValueHeightConstarints.constant = 50
        }
        if accountInfoModel.isGenderVisible{
            totalHeight += 50
            genderTextFeildHeightConstarints.constant = 50
        }
        
        self.mainViewHeightConstarints.constant += totalHeight
    }
    
    
    @IBAction func SaveClick(_ sender: UIButton) {
        var errorMessage = "";
        var isValid:Int = 1;
        if firstNameTextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillfirstname")
        }
        else if lasttNametextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefilllastname")
        }
        else if emailtextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillemailid")
        }
        else if changePasswordFlag == true{
            if currentPasswordTextField.text == ""{
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "pleasefillcurrentpassowrd")
            }
            if confirmtextFeild.text == ""{
                isValid = 0;
                errorMessage =  GlobalData.sharedInstance.language(key: "pleasefillnewpassword")
            }
            if confirmNewTextField.text == ""{
                isValid = 0;
                errorMessage =  GlobalData.sharedInstance.language(key: "pleasefillconfirmnewpassword")
            }
            if confirmNewTextField.text != confirmtextFeild.text{
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "passwordnotmatch")
            }
        }else if changeEmailFlag == true{
            if currentPasswordTextField.text == ""{
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "pleasefillcurrentpassowrd")
            }
        }
        if accountInfoModel.isPrefixRequired{
            if prefixTextField.text == ""{
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "plesefillprefix")
            }
        }
        if accountInfoModel.isSuffixRequired{
            if suffixtextField.text == ""{
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "plesefillsuffix")
            }
        }
        if accountInfoModel.isMobileNumberRequired{
            if mobileNumbertextFeild.text == ""{
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "pleasefillmobilenumber")
            }
        }
        if accountInfoModel.isDobRequired{
            if dobTextFeild.text == ""{
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "plesefilldob")
            }
        }
        if accountInfoModel.isTaxRequired{
            if taxValuetextField.text == ""{
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "plesefilltaxvat")
            }
        }
        if accountInfoModel.isGenderRequired{
            if genderTextFeild.text == ""{
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "plesefillgender")
            }
        }
        
        if isValid == 0{
            GlobalData.sharedInstance.showErrorSnackBar(msg:errorMessage)
        }else{
            whichApiToProcess = "customerEditPost"
            self.callingHttppApi()
        }
    }
}
