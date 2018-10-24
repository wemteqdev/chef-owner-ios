//
//  CreateChef.swift
//  MobikulMPMagento2
//
//  Created by Othello on 14/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class CreateChef: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    var createAccountModel:CreateAccountModel!
    let defaults = UserDefaults.standard;
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1000){
            return self.createAccountModel.countryData.count;
        }
        else if pickerView.tag == 2000{
            return self.createAccountModel.countryData[currentCountryRow].stateData.count
        }
        else{
            return 0
        }
    }
    var currentCountryRow:Int = 0
    var countryId:String = ""
    var regionId:String = ""
    var regionType:Int = 0;

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var baselineView: UIView!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var secondnameTextField: UITextField!
    @IBOutlet weak var companynameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phonenumTextField: UITextField!
    @IBOutlet weak var addrTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmpasswordTextField: UITextField!
    var whichApiToProcess:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.backgroundColor = UIColor.white
        
        submitButton.layer.cornerRadius = 25
        submitButton.layer.masksToBounds = true
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.white.cgColor
        submitButton.setTitle("Register", for: .normal)
        
        submitButton.setTitleColor(UIColor().HexToColor(hexString: "4265A0"), for: .normal)
        baselineView.layer.cornerRadius = 2.5
        //self.defaults.set("0", forKey: "storeId")

        self.callingHttppApi()
        
        // Do any additional setup after loading the view.
    }
    
    
    // Call with....
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    func callingHttppApi(){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            GlobalData.sharedInstance.showLoader()
            var requstParams = [String:Any]();
            
            
            if self.whichApiToProcess == "createaccount"{
                var requstParams = [String:Any]();
                let quoteId = self.defaults.object(forKey:"quoteId");
                let deviceToken = self.defaults.object(forKey:"deviceToken");
                print(self.defaults.object(forKey:"storeId") as! String)
                requstParams["storeId"] = self.defaults.object(forKey:"storeId") as! String
                requstParams["websiteId"] = DEFAULT_WEBSITE_ID
                if quoteId != nil{
                    requstParams["quoteId"] = quoteId;
                }
                if deviceToken != nil{
                    requstParams["token"] = deviceToken
                }
                requstParams["firstName"] = self.firstnameTextField.text
                requstParams["lastName"] = self.secondnameTextField.text
                requstParams["email"] = self.emailTextField.text


                requstParams["mobile"] = self.phonenumTextField.text
                requstParams["companyName"] = self.phonenumTextField.text
                requstParams["address"] = self.addrTextField.text
                requstParams["city"] = self.cityTextField.text
                if(self.regionType == 1){
                    requstParams["state"] = self.regionId
                } else {
                    requstParams["state"] = self.stateTextField.text
                }
                requstParams["postcode"] = self.postcodeTextField.text
                requstParams["country"] = self.countryId
                if (self.defaults.object(forKey:"Ownerup") as! String) == "t" {
                    requstParams["customerType"] = "4"
                }
                requstParams["isSocial"] = "0"
                requstParams["pictureURL"] = ""
                requstParams["password"] = self.passwordTextField.text
                GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/customer/createaccount", currentView: self){success,responseObject in
                    if success == 1{
                        print(responseObject)
                        GlobalData.sharedInstance.dismissLoader()
                        self.view.isUserInteractionEnabled = true
                        let dict = JSON(responseObject as! NSDictionary)
                        if dict["success"].boolValue == true{
                            self.defaults.set(dict["customerEmail"].stringValue, forKey: "customerEmail")
                            self.defaults.set(dict["customerToken"].stringValue, forKey: "customerId")
                            self.defaults.set(dict["customerName"].stringValue, forKey: "customerName")
                            self.defaults.set(requstParams["companyName"], forKey: "companyName")
                            
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
                            
                            self.performSegue(withIdentifier: "dashboard", sender: self)
                            
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
                if self.defaults.object(forKey: "storeId") != nil{
                    requstParams["storeId"] = self.defaults.object(forKey: "storeId") as! String
                }
                else{
                    requstParams["storeId"] = "0"
                    
                }
                //requstParams["storeId"] = self.defaults.object(forKey:"storeId") as! String
                GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/directory/countrylist", currentView: self){success,responseObject in
                    if success == 1{
                        print(responseObject)
                        self.createAccountModel = CreateAccountModel(data:JSON(responseObject as! NSDictionary))
                        self.doFurtherData()
                        self.view.isUserInteractionEnabled = true
                        GlobalData.sharedInstance.dismissLoader()
                    }else if success == 2{
                        GlobalData.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }
        }
    }
    func doFurtherData(){

            self.countryTextField.text = self.createAccountModel.countryData[0].name
            self.currentCountryRow = 0;
            self.countryId = self.createAccountModel.countryData[0].countryId

    }
    @IBAction func submitClick(_ sender: Any) {
        var errorMessage = "";
        var isValid:Int = 1;
        print("calling")
        
        if firstnameTextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillfirstname");
        }else if secondnameTextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefilllastname");
        }else if !GlobalData.sharedInstance.checkValidEmail(data: emailTextField.text!){
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefilllvalidemail");
        }else if passwordTextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillpassword");
        }else if confirmpasswordTextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillconfirmnewpassword");
        }
        
   
        if phonenumTextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillmobilenumber")
        }
        if companynameTextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillcompanyname")
        }
        if stateTextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillstatename")
        }
        if cityTextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "entercityname")
        }
        if postcodeTextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillzipcode")
        }
        if addrTextField.text == ""{
            isValid = 0;
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefilltheaddress")
        }
        if createAccountModel.isDobRequired{
            
        }
        if createAccountModel.isTaxRequired{
            
        }
        if createAccountModel.isGenderRequired{
            
        }

        
        if isValid == 0{
            GlobalData.sharedInstance.showErrorSnackBar(msg: errorMessage)
        }else{
            
            if passwordTextField.text != confirmpasswordTextField.text{
                GlobalData.sharedInstance.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key: "passwordnotmatch"))
            }
            else if (passwordTextField.text?.characters.count)! < 6{
                GlobalData.sharedInstance.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key: "passwordlength"))
            }
            else{
                self.whichApiToProcess = "createaccount"
                callingHttppApi()
                
            }
        }
    }
    @IBAction func countryClick(_ sender: UITextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 1000;
        countryTextField.inputView = thePicker
        thePicker.delegate = self
    }
    @IBAction func stateClick(_ sender: UITextField) {
        if self.createAccountModel.countryData[currentCountryRow].stateData.count > 0{
            let thePicker = UIPickerView()
            thePicker.tag = 2000;
            stateTextField.inputView = thePicker
            thePicker.delegate = self
            regionType = 1;
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1000){
            return self.createAccountModel.countryData[row].name
        }
        else  if pickerView.tag == 2000{
            return self.createAccountModel.countryData[currentCountryRow].stateData[row].name
        }
        else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.tag == 1000){
            self.countryTextField.text =  self.createAccountModel.countryData[row].name;
            self.countryId = self.createAccountModel.countryData[row].countryId
            currentCountryRow = row
            if self.createAccountModel.countryData[row].stateData.count > 0{
                self.regionId = self.createAccountModel.countryData[row].stateData[0].regionId
                self.stateTextField.text = self.createAccountModel.countryData[row].stateData[0].name
            }else{
                self.stateTextField.text = ""
                self.regionId = "0"
            }
            
        }else if pickerView.tag == 2000{
            self.stateTextField.text = self.createAccountModel.countryData[currentCountryRow].stateData[row].name;
            self.regionId = self.createAccountModel.countryData[currentCountryRow].stateData[row].regionId;
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
