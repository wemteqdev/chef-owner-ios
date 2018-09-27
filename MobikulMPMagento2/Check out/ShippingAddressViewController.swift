//
//  ShippingAddressViewController.swift
//  Magento2V4Theme
//
//  Created by kunal on 19/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//




@objc protocol BillingAddressPickerDelegate: class {
    func selectBillingAddress(data:Bool,addressId:String,address:String)
    
}






import UIKit

class ShippingAddressViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,BillingAddressPickerDelegate {
    
    
    @IBOutlet weak var addressImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var shipmentImageView: UIImageView!
    @IBOutlet weak var paymantImageView: UIImageView!
    @IBOutlet weak var summaryImageView: UIImageView!
    
    
    
    @IBOutlet weak var shippingAddressLabel: UILabel!
    @IBOutlet weak var signinAddress: UILabel!
    @IBOutlet weak var changeAddressButton: UIButton!
    @IBOutlet weak var signinView: UIView!
    @IBOutlet weak var sinInViewHeight: NSLayoutConstraint!
    var whichApiToProcess:String = ""
    var billingViewModel:BillingAndShipingViewModel!
    var billingId:String!
    @IBOutlet weak var signoutView: UIView!
    @IBOutlet weak var signoutViewHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var prefixtextField: SkyFloatingLabelTextField!
    @IBOutlet weak var prefixTextFieldConstaints: NSLayoutConstraint!
    @IBOutlet weak var firstNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var middleNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var middleNameHeightConstaints: NSLayoutConstraint!
    @IBOutlet weak var lastNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var suffixtextFiled: SkyFloatingLabelTextField!
    @IBOutlet weak var suffixTextFieldHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var genderTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var genderFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var dobtextField: SkyFloatingLabelTextField!
    @IBOutlet weak var dobTextFieldheight: NSLayoutConstraint!
    @IBOutlet weak var taxVatField: SkyFloatingLabelTextField!
    @IBOutlet weak var taxVatFieldheight: NSLayoutConstraint!
    @IBOutlet weak var comanyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailtextField: SkyFloatingLabelTextField!
    @IBOutlet weak var street1Address: SkyFloatingLabelTextField!
    @IBOutlet weak var street2Address: SkyFloatingLabelTextField!
    @IBOutlet weak var street2AddressFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var street3textField: SkyFloatingLabelTextField!
    @IBOutlet weak var street3textFieldheight: NSLayoutConstraint!
    @IBOutlet weak var street4textField: SkyFloatingLabelTextField!
    @IBOutlet weak var street4textFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var citytextField: SkyFloatingLabelTextField!
    @IBOutlet weak var telephonetextField: SkyFloatingLabelTextField!
    @IBOutlet weak var faxField: SkyFloatingLabelTextField!
    @IBOutlet weak var countryTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var stateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var postCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var continueButton: UIButton!
    var currentCountryRow:Int = 0
    var countryId:String = ""
    var regionId:String = ""
    var genderValueArray:NSMutableArray = []
    var streetArray:NSArray = [];
    var newAddressFlag:Int = 0
    var genderValue:String = ""
    var shipmentPaymentMethodViewModel:ShipmentAndPaymentViewModel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        addressImageView.layer.cornerRadius = 15;
        addressImageView.layer.masksToBounds = true
        
        shipmentImageView.layer.cornerRadius = 15;
        shipmentImageView.layer.masksToBounds = true
        
        paymantImageView.layer.cornerRadius = 15;
        paymantImageView.layer.masksToBounds = true
        
        summaryImageView.layer.cornerRadius = 15;
        summaryImageView.layer.masksToBounds = true
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController!.isNavigationBarHidden = false
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        whichApiToProcess = "steponetwo"
        signinView.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
        signinView.layer.borderWidth = 1.0;
        self.callingHttppApi()
        
        prefixtextField.isHidden = true;
        prefixTextFieldConstaints.constant = 0
        suffixtextFiled.isHidden = true;
        suffixTextFieldHeightConstarints.constant = 0
        middleNameField.isHidden = true;
        middleNameHeightConstaints.constant = 0
        genderTextField.isHidden = true;
        genderFieldHeight.constant = 0
        dobtextField.isHidden = true;
        dobTextFieldheight.constant = 0
        
        street2Address.isHidden = true;
        street2AddressFieldHeight.constant = 0
        street3textField.isHidden = true;
        street3textFieldheight.constant = 0
        street4textField.isHidden = true;
        street4textFieldHeight.constant = 0
        taxVatField.isHidden = true;
        taxVatFieldheight.constant = 0
        
        continueButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.setTitle(GlobalData.sharedInstance.language(key: "continue"), for: .normal)
        changeAddressButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        shippingAddressLabel.text = GlobalData.sharedInstance.language(key: "shippingaddress")
        
        
        if defaults.object(forKey: "isVirtual") as! String == "false"{
            shippingAddressLabel.isHidden = false;
        }else{
            shippingAddressLabel.isHidden = true;
        }
        
        
        
        
        
        
    }
    
    
    @IBAction func dismissController(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    
    
    
    
    
    func callingHttppApi(){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            GlobalData.sharedInstance.showLoader()
            var requstParams = [String:Any]();
            let customerId = defaults.object(forKey: "customerId")
            let storeId = defaults.object(forKey: "storeId")
            let quoteId = defaults.object(forKey: "quoteId")
            let currency =  defaults.object(forKey: "currency")
            if currency != nil{
                requstParams["currency"] = defaults.object(forKey: "currency") as! String
            }
            if(customerId != nil){
                requstParams["customerToken"] = customerId
                requstParams["checkoutMethod"] = "customer"
                requstParams["quoteId"] = "0"
            }
            if(quoteId != nil ){
                requstParams["quoteId"] = quoteId
                requstParams["checkoutMethod"] = "guest"
                requstParams["customerToken"] = "0"
                
            }
            
            if(self.whichApiToProcess == "steponetwo"){
                requstParams["storeId"] = storeId
                GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/checkout/billingShippingInfo", currentView: self){success,responseObject in
                    if success == 1{
                        GlobalData.sharedInstance.dismissLoader()
                        print(responseObject as! NSDictionary)
                        if responseObject?.object(forKey: "storeId") != nil{
                            let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                            if storeId != "0"{
                                defaults .set(storeId, forKey: "storeId")
                            }
                        }
                        
                        
                        
                        let dict =  JSON(responseObject as! NSDictionary)
                        self.view.isUserInteractionEnabled = true
                        if dict["success"].boolValue == true{
                            self.billingViewModel = BillingAndShipingViewModel(data: dict)
                            GlobalVariables.shippingAndBillingViewModel = self.billingViewModel;
                            self.doFurtherData()
                        }else{
                            GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                        }
                        
                        
                        
                        
                    }else if success == 2{
                        GlobalData.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                    
                }
            }else{
                var BDDict = [String:AnyObject]();
                var BDNewAddrDict = [String:AnyObject]();
                var SDDict = [String:AnyObject]();
                var SDNewAddrDict = [String:AnyObject]();
                
                if(self.newAddressFlag == 0){
                    BDDict["addressId"] = self.billingId as AnyObject
                }else{
                    BDDict["addressId"] = "0" as AnyObject?;
                    BDNewAddrDict["firstName"] = self.firstNameField.text as AnyObject?;
                    BDNewAddrDict["lastName"] = self.lastNameField.text as AnyObject?;
                    BDNewAddrDict["company"] = self.comanyTextField.text as AnyObject?;
                    BDNewAddrDict["street"] = self.streetArray as AnyObject?;
                    BDNewAddrDict["city"] = self.citytextField.text as AnyObject?;
                    BDNewAddrDict["email"] = self.emailtextField.text as AnyObject?;
                    BDNewAddrDict["postcode"] = self.postCodeTextField.text as AnyObject?;
                    BDNewAddrDict["telephone"] = self.telephonetextField.text as AnyObject?;
                    BDNewAddrDict["fax"] = self.faxField.text as AnyObject?;
                    BDNewAddrDict["prefix"] = self.prefixtextField.text as AnyObject?
                    BDNewAddrDict["middleName"] = self.middleNameField.text as AnyObject?
                    BDNewAddrDict["suffix"] = self.suffixtextFiled.text as AnyObject?
                    BDNewAddrDict["gender"] = self.genderValue as AnyObject?
                    BDNewAddrDict["dob"] = self.dobtextField.text as AnyObject?
                    BDNewAddrDict["taxvat"] = self.taxVatField.text as AnyObject?
                    BDNewAddrDict["saveInAddressBook"] = "1" as AnyObject
                    if(self.regionId == "0"){
                        BDNewAddrDict["region_id"] = "" as AnyObject?;
                        BDNewAddrDict["region"] = self.stateTextField.text as AnyObject?;
                    }else{
                        BDNewAddrDict["region_id"] = self.regionId as AnyObject?;
                        BDNewAddrDict["region"] = "" as AnyObject?;
                    }
                    BDNewAddrDict["country_id"] = self.countryId as AnyObject?;
                }
                
                if defaults.object(forKey: "isVirtual") as! String  == "false"{
                    BDDict["useForShipping"] = "1" as AnyObject?
                }else{
                    BDDict["useForShipping"] = "0" as AnyObject?
                }
                
                BDDict["newAddress"] = BDNewAddrDict as AnyObject?
                do {
                    let jsonBillingData =  try JSONSerialization.data(withJSONObject: BDDict, options: .prettyPrinted)
                    let jsonBillingString:String = NSString(data: jsonBillingData, encoding: String.Encoding.utf8.rawValue)! as String
                    requstParams["billingData"] = jsonBillingString
                    
                }
                catch {
                    print(error.localizedDescription)
                }
                
                if(defaults.object(forKey: "isVirtual") as! String == "false"){
                    
                    if(self.newAddressFlag == 0){
                        SDDict["addressId"] = self.billingId as AnyObject
                    }else{
                        SDDict["addressId"] = "0" as AnyObject?;
                        SDNewAddrDict["firstName"] = self.firstNameField.text as AnyObject?;
                        SDNewAddrDict["lastName"] = self.lastNameField.text as AnyObject?;
                        SDNewAddrDict["company"] = self.comanyTextField.text as AnyObject?;
                        SDNewAddrDict["street"] = self.streetArray as AnyObject?;
                        SDNewAddrDict["city"] = self.citytextField.text as AnyObject?;
                        SDNewAddrDict["email"] = self.emailtextField.text as AnyObject?;
                        SDNewAddrDict["postcode"] = self.postCodeTextField.text as AnyObject?;
                        SDNewAddrDict["telephone"] = self.telephonetextField.text as AnyObject?;
                        SDNewAddrDict["fax"] = self.faxField.text as AnyObject?;
                        SDNewAddrDict["prefix"] = self.prefixtextField.text as AnyObject?
                        SDNewAddrDict["middleName"] = self.middleNameField.text as AnyObject?
                        SDNewAddrDict["suffix"] = self.suffixtextFiled.text as AnyObject?
                        SDNewAddrDict["gender"] = self.genderValue as AnyObject?
                        SDNewAddrDict["dob"] = self.dobtextField.text as AnyObject?
                        SDNewAddrDict["taxvat"] = self.taxVatField.text as AnyObject?
                        SDNewAddrDict["saveInAddressBook"] = "1" as AnyObject
                        if(self.regionId == "0"){
                            SDNewAddrDict["region_id"] = "" as AnyObject?;
                            SDNewAddrDict["region"] = self.stateTextField.text as AnyObject?;
                        }else{
                            SDNewAddrDict["region_id"] = self.regionId as AnyObject?;
                            SDNewAddrDict["region"] = "" as AnyObject?;
                        }
                        SDNewAddrDict["country_id"] = self.countryId as AnyObject?;
                    }
                    
                    SDDict["sameAsBilling"] = "1" as AnyObject?
                    SDDict["newAddress"] = SDNewAddrDict as AnyObject?
                    do {
                        let jsonShippingData =  try JSONSerialization.data(withJSONObject: SDDict, options: .prettyPrinted)
                        let jsonShippingString:String = NSString(data: jsonShippingData, encoding: String.Encoding.utf8.rawValue)! as String
                        requstParams["shippingData"] = jsonShippingString
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                    
                    
                }
                requstParams["storeId"] = storeId
                GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/checkout/shippingPaymentMethodInfo", currentView: self){success,responseObject in
                    if success == 1{
                        if responseObject?.object(forKey: "storeId") != nil{
                            let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                            if storeId != "0"{
                                defaults .set(storeId, forKey: "storeId")
                            }
                        }
                        
                        self.view.isUserInteractionEnabled = true;
                        GlobalData.sharedInstance.dismissLoader()
                        let dict = JSON(responseObject! as! NSDictionary)
                        print("sss", dict)
                        if dict["success"].boolValue == true{
                            self.shipmentPaymentMethodViewModel = ShipmentAndPaymentViewModel(data: dict)
                            self.goToNextController()
                        }else{
                            GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                        }
                    }else if success == 2{
                        GlobalData.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
                
                
                
            }
        }
    }
    
    
    
    func selectBillingAddress(data:Bool,addressId:String,address:String){
        self.billingId = addressId
        self.signinAddress.text = address
        sinInViewHeight.constant = (signinAddress.text?.height(withConstrainedWidth: SCREEN_WIDTH - 40, font: UIFont.systemFont(ofSize: 15)))! + 70
    }
    
    
    func  goToNextController(){
        
        if defaults.object(forKey: "isVirtual") as! String == "false"{
            GlobalVariables.CurrentIndex = 2
            self.tabBarController!.selectedIndex = 1
        }else{
            GlobalVariables.CurrentIndex = 3
            self.tabBarController!.selectedIndex = 2
        }
    }
    
    
    
    
    func doFurtherData(){
        if self.billingViewModel.addressData.count > 0{
            self.signinAddress.text = self.billingViewModel.addressData[0].value
            self.billingId = self.billingViewModel.addressData[0].id
            sinInViewHeight.constant = (signinAddress.text?.height(withConstrainedWidth: SCREEN_WIDTH - 40, font: UIFont.systemFont(ofSize: 15)))! + 70
            signoutView.isHidden = true;
            newAddressFlag = 0
            mainViewHeightConstarints.constant = 600;
        }else{
            newAddressFlag = 1
            sinInViewHeight.constant = 0;
            signinView.isHidden = true;
            mainViewHeightConstarints.constant = 800;
            var Y:CGFloat = 0;
            
            self.countryTextField.text = self.billingViewModel.countryData[0].name
            self.currentCountryRow = 0;
            self.countryId = self.billingViewModel.countryData[0].countryId
            if self.billingViewModel.countryData[0].stateData.count > 0{
                regionId = self.billingViewModel.countryData[0].stateData[0].regionId
                stateTextField.text = self.billingViewModel.countryData[0].stateData[0].name
            }else{
                self.regionId = "0"
            }
            
            if billingViewModel.billingShippingModel.isPrifixVisible == true{
                self.prefixtextField.isHidden = false;
                prefixTextFieldConstaints.constant = 45
                Y += 50
            }
            if billingViewModel.billingShippingModel.isSuffixVisible == true{
                self.suffixtextFiled.isHidden = false;
                suffixTextFieldHeightConstarints.constant = 45
                Y += 50
            }
            if billingViewModel.billingShippingModel.isMiddleNameVisible == true{
                self.middleNameField.isHidden = false;
                middleNameHeightConstaints.constant = 45
                Y += 50
            }
            if billingViewModel.billingShippingModel.isGenderVisible == true{
                self.genderTextField.isHidden = false;
                genderFieldHeight.constant = 45
                Y += 50
            }
            if billingViewModel.billingShippingModel.isDobVisible == true{
                self.dobtextField.isHidden = false;
                dobTextFieldheight.constant = 45
                Y += 50
            }
            if billingViewModel.billingShippingModel.isTaxVisible == true{
                self.taxVatField.isHidden = false;
                taxVatFieldheight.constant = 45
                Y += 50
            }
            if billingViewModel.billingShippingModel.streetCount == 2{
                street2Address.isHidden = false;
                street2AddressFieldHeight.constant = 45
                Y += 50
            }
            if billingViewModel.billingShippingModel.streetCount == 3{
                street2Address.isHidden = false;
                street2AddressFieldHeight.constant = 45
                street3textField.isHidden = false;
                street3textFieldheight.constant = 45
                Y += 100
            }
            if billingViewModel.billingShippingModel.streetCount == 4{
                street2Address.isHidden = false;
                street2AddressFieldHeight.constant = 45
                street3textField.isHidden = false;
                street3textFieldheight.constant = 45
                street4textField.isHidden = false;
                street4textFieldHeight.constant = 45
                Y += 150
                
            }
            
            mainViewHeightConstarints.constant = 800 + Y
            
            if billingViewModel.billingShippingModel.isGenderRequired == true{
                self.genderValueArray = ["Female", "Male"];
            }
            else{
                self.genderValueArray = ["Female","Male"," "];
            }
            
            let customerId = defaults.object(forKey: "customerId")
            if(customerId != nil){
                emailtextField.text = defaults.object(forKey: "customerEmail") as? String
                emailtextField.isEnabled = true
            }
            
            
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func changeAddressClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addresspicker", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "addresspicker") {
            let viewController:BillingAddressPicker = segue.destination as UIViewController as! BillingAddressPicker
            viewController.billingViewModel = GlobalVariables.shippingAndBillingViewModel
            viewController.addressID = self.billingId
            viewController.delegate = self
            
        }
        
    }
    
    
    
    
    @IBAction func PrefixClick(_ sender: SkyFloatingLabelTextField) {
        if billingViewModel.billingShippingModel.isPrefixHasOption == true{
            let thePicker = UIPickerView()
            thePicker.tag = 3000;
            prefixtextField.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    @IBAction func SuffixClick(_ sender: SkyFloatingLabelTextField) {
        if billingViewModel.billingShippingModel.isSuffixHasOption == true{
            let thePicker = UIPickerView()
            thePicker.tag = 4000;
            suffixtextFiled.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    @IBAction func genderClick(_ sender: SkyFloatingLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 5000;
        genderTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    
    @IBAction func dobClick(_ sender: SkyFloatingLabelTextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        dobtextField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(ShippingAddressViewController.datePickerFromValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.billingViewModel.billingShippingModel.dobFormat
        dobtextField.text = dateFormatter.string(from: sender.date)
    }
    
    
    
    @IBAction func countryClick(_ sender: SkyFloatingLabelTextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 1000;
        countryTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    
    @IBAction func stateClick(_ sender: SkyFloatingLabelTextField) {
        if self.billingViewModel.countryData[currentCountryRow].stateData.count > 0{
            let thePicker = UIPickerView()
            thePicker.tag = 2000;
            stateTextField.inputView = thePicker
            thePicker.delegate = self
        }
        
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1000){
            return self.billingViewModel.countryData.count;
        }else if pickerView.tag == 2000{
            return self.billingViewModel.countryData[currentCountryRow].stateData.count
        }else if pickerView.tag == 3000{
            return self.billingViewModel.billingShippingModel.prefixOptions.count
        }
        else if pickerView.tag == 4000{
            return self.billingViewModel.billingShippingModel.suffixOptions.count
        }else if pickerView.tag == 5000{
            return genderValueArray.count
        }
        else{
            return 0
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1000){
            return self.billingViewModel.countryData[row].name
        }else  if pickerView.tag == 2000{
            return self.billingViewModel.countryData[currentCountryRow].stateData[row].name
        }else if pickerView.tag == 3000{
            return self.billingViewModel.billingShippingModel.prefixOptions[row] as? String
        }
        else if pickerView.tag == 4000{
            return self.billingViewModel.billingShippingModel.suffixOptions[row] as? String
        }else if pickerView.tag == 5000{
            return genderValueArray[row] as? String
        }
        else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.tag == 1000){
            self.countryTextField.text =  self.billingViewModel.countryData[row].name;
            self.countryId = self.billingViewModel.countryData[row].countryId
            currentCountryRow = row
            if self.billingViewModel.countryData[row].stateData.count > 0{
                self.regionId = self.billingViewModel.countryData[row].stateData[0].regionId
                self.stateTextField.text = self.billingViewModel.countryData[row].stateData[0].name
            }else{
                self.stateTextField.text = ""
                self.regionId = "0"
            }
            
        }else if pickerView.tag == 2000{
            self.stateTextField.text = self.billingViewModel.countryData[currentCountryRow].stateData[row].name;
            self.regionId = self.billingViewModel.countryData[currentCountryRow].stateData[row].regionId;
        }else if pickerView.tag == 3000{
            self.prefixtextField.text = self.billingViewModel.billingShippingModel.prefixOptions[row] as? String
        }
        else if pickerView.tag == 4000{
            self.suffixtextFiled.text = self.billingViewModel.billingShippingModel.suffixOptions[row] as? String
        }
        else if pickerView.tag == 5000{
            self.genderTextField.text = genderValueArray[row] as? String
        }
    }
    
    
    
    
    
    
    @IBAction func continueClick(_ sender: UIButton) {
        if self.billingViewModel.addressData.count > 0{
            whichApiToProcess = "stepthreefour"
            self.callingHttppApi()
        }else{
            var isValid:Int = 1;
            var errorMessage:String = "Please Fill"
            
            if(telephonetextField.text == ""){
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "pleasefillmobilenumber")
            }
            else if(postCodeTextField.text == ""){
                isValid = 0
                errorMessage = GlobalData.sharedInstance.language(key: "pleasefillpostalcode")
            }
            else if(citytextField.text == ""){
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "entercityname")
            }
            else if(street1Address.text == ""){
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key:"enteraddress1");
            }
            else if(emailtextField.text == ""){
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key:"pleasefillemailid");
            }
            else if !GlobalData.sharedInstance.checkValidEmail(data: emailtextField.text!){
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key: "pleasefilllvalidemail");
            }
                
            else if(lastNameField.text == ""){
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key:"pleasefilllastname");
            }
            else if(firstNameField.text == ""){
                isValid = 0;
                errorMessage = GlobalData.sharedInstance.language(key:"pleasefillfirstname");
            }
            
            if self.billingViewModel.billingShippingModel.isPrefixRequired == true{
                if prefixtextField.text == ""{
                    isValid = 0;
                    errorMessage = errorMessage+" "+"Fill prefix Value";
                }
            }
            if self.billingViewModel.billingShippingModel.isSuffixRequired == true{
                if suffixtextFiled.text == ""{
                    isValid = 0;
                    errorMessage = errorMessage+" "+"Fill Suffix Value";
                }
            }
            if self.billingViewModel.billingShippingModel.isGenderRequired == true{
                if genderTextField.text == ""{
                    isValid = 0;
                    errorMessage = errorMessage+" "+"Fill Gender Value";
                }
            }
            if self.billingViewModel.billingShippingModel.isDobRequired == true{
                if dobtextField.text == ""{
                    isValid = 0;
                    errorMessage = errorMessage+" "+"Fill DOB Value";
                }
            }
            if self.billingViewModel.billingShippingModel.isTaxRequired == true{
                if taxVatField.text == ""{
                    isValid = 0;
                    errorMessage = errorMessage+" "+"Fill Tax Vat Value";
                }
            }
            if self.billingViewModel.countryData[currentCountryRow].stateData.count > 0{
                if stateTextField.text == ""{
                    isValid = 0
                    errorMessage = errorMessage+" "+"Fill State Name"
                }
                
            }
            
            if isValid == 0{
                GlobalData.sharedInstance.showErrorSnackBar(msg: errorMessage)
            }else{
                if self.billingViewModel.billingShippingModel.streetCount == 1{
                    streetArray = [street1Address.text ?? ""];
                }else if self.billingViewModel.billingShippingModel.streetCount == 2{
                    streetArray = [street1Address.text!,street2Address.text!];
                }else if self.billingViewModel.billingShippingModel.streetCount == 3{
                    streetArray = [street1Address.text!,street2Address.text!,street3textField.text!];
                }else if self.billingViewModel.billingShippingModel.streetCount == 4{
                    streetArray = [street1Address.text!,street2Address.text!,street3textField.text!,street4textField.text!];
                }
                
                let data:String = genderTextField.text!
                if data == "Male"{
                    genderValue = "1"
                }
                else if data == "Female"{
                    genderValue = "0"
                }
                else{
                    genderValue = ""
                }                
                whichApiToProcess = "stepthreefour"
                self.callingHttppApi()
                
            }
        }
    }
}
