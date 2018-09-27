//
//  AddEditAddress.swift
//  DummySwift
//
//  Created by kunal prasad on 05/12/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

@objc protocol NewAddressAddHandlerDelegate: class {
    func newAddAddreressSuccess(data:Bool)
}



import UIKit
import CoreLocation

class AddEditAddress: UIViewController,UIPickerViewDelegate,UITextFieldDelegate,UIPickerViewDataSource{
    var addOrEdit:String = "";
    var addressId:String = "";
    @IBOutlet weak var mainViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var stateFieldHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var stateField: UITextField!
    var whichApiDataToProcess:String!
    @IBOutlet weak var countryPicker: UIPickerView!
    var countryPickerData:NSArray = []
    var statePickerData:NSArray = []
    var countryIndex:Int = 0
    var regionId:String = ""
    @IBOutlet weak var firstNameTextField: UIFloatLabelTextField!
    @IBOutlet weak var lastNameTextField: UIFloatLabelTextField!
    @IBOutlet weak var companyNameTextField: UIFloatLabelTextField!
    @IBOutlet weak var mobileNumberTextField: UIFloatLabelTextField!
    @IBOutlet weak var faxNumberTextField: UIFloatLabelTextField!
    @IBOutlet weak var streetAddress1TextField: UIFloatLabelTextField!
    @IBOutlet weak var streetAddress2TextField: UIFloatLabelTextField!
    @IBOutlet weak var cityNameTextField: UIFloatLabelTextField!
    @IBOutlet weak var stateNameTextField: UIFloatLabelTextField!
    @IBOutlet weak var postalCodeTextField: UIFloatLabelTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var countryValue:String!
    var firstNameValue, lastNameValue,companyValue,telephoneValue,faxValue,street1Value,street2Value,street3Value,street4Value,cityValue,regionValue,zipValue,default_shipping,default_billing :String!
    @IBOutlet weak var defaultBillingAddressSwitch: UISwitch!
    @IBOutlet weak var defaultShippingAddressSwitch: UISwitch!
    @IBOutlet weak var useasmydefaultbillingaddressLabel: UILabel!
    @IBOutlet weak var useasmydefaultshippingaddressLabel: UILabel!
    @IBOutlet weak var saveAddressButton: UIButton!
    @IBOutlet weak var prefixTextField: UIFloatLabelTextField!
    @IBOutlet weak var prefixTextFieldHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var middleNameTextField: UIFloatLabelTextField!
    @IBOutlet weak var middleNameTextFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var suffixTextField: UIFloatLabelTextField!
    @IBOutlet weak var suffixtextFieldHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var streetAddress3TextField: UIFloatLabelTextField!
    @IBOutlet weak var streetAddress3TextFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var streetAddress4TextField: UIFloatLabelTextField!
    @IBOutlet weak var streetAddress4TextFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var streetAddress2TextFeildHeight: NSLayoutConstraint!
    var delegate:NewAddressAddHandlerDelegate!
    
    
    var expandHeight:CGFloat = 0
    var locationManager:CLLocationManager!
    var addEditAddressModel:AddeditAddressModel!
    var prefixValueArray:NSArray = [];
    var suffixValueArray:NSArray = [];
    var streetArray:NSArray = [];
    var streetCount:Int = 1
    var currentClass:String = ""
    
    @IBOutlet weak var stateLebel: UILabel!
    
    var keyBoardFlag:Int = 1
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        mobileNumberTextField.delegate = self;
        self.navigationController?.isNavigationBarHidden = false
        if addOrEdit == "0"{
            self.navigationItem.title = GlobalData.sharedInstance.language(key: "addnewaddress")
        }
        else{
            self.navigationItem.title = GlobalData.sharedInstance.language(key: "editaddress")
        }
        mainViewHeightConstraints.constant = 1200;
        stateFieldHeightConstarints.constant = 50;
        statePicker.isHidden = true;
        statePicker.tag = 2000;
        countryPicker.tag = 1000;
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddEditAddress.dismissKeyboard))
        view.addGestureRecognizer(tap)
        UITextField().bottomBorder(texField: firstNameTextField)
        UITextField().bottomBorder(texField: lastNameTextField)
        UITextField().bottomBorder(texField: companyNameTextField)
        UITextField().bottomBorder(texField: mobileNumberTextField)
        UITextField().bottomBorder(texField: faxNumberTextField)
        UITextField().bottomBorder(texField: streetAddress1TextField)
        UITextField().bottomBorder(texField: streetAddress2TextField)
        UITextField().bottomBorder(texField: cityNameTextField)
        UITextField().bottomBorder(texField: stateNameTextField)
        UITextField().bottomBorder(texField: prefixTextField)
        UITextField().bottomBorder(texField: middleNameTextField)
        UITextField().bottomBorder(texField: suffixTextField)
        UITextField().bottomBorder(texField: streetAddress3TextField)
        UITextField().bottomBorder(texField: streetAddress4TextField)
        
        
        mobileNumberTextField.keyboardType = .numberPad
        faxNumberTextField.keyboardType = .numberPad
        
        default_shipping = "0";
        default_billing = "0";
        
        firstNameTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        lastNameTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        companyNameTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        mobileNumberTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        faxNumberTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        streetAddress1TextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        streetAddress2TextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        cityNameTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        stateNameTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        postalCodeTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        prefixTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        middleNameTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        suffixTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        streetAddress3TextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        streetAddress4TextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        
        
        firstNameTextField.placeholder = GlobalData.sharedInstance.language(key: "firstname")
        lastNameTextField.placeholder = GlobalData.sharedInstance.language(key:"lastname")
        companyNameTextField.placeholder = GlobalData.sharedInstance.language(key:"company")
        mobileNumberTextField.placeholder = GlobalData.sharedInstance.language(key:"mobileno")
        faxNumberTextField.placeholder = GlobalData.sharedInstance.language(key:"fax")
        streetAddress1TextField.placeholder = GlobalData.sharedInstance.language(key:"street1")
        streetAddress2TextField.placeholder = GlobalData.sharedInstance.language(key:"street2")
        streetAddress3TextField.placeholder = GlobalData.sharedInstance.language(key:"street3")
        streetAddress4TextField.placeholder = GlobalData.sharedInstance.language(key:"street4")
        cityNameTextField.placeholder = GlobalData.sharedInstance.language(key:"city")
        stateNameTextField.placeholder = GlobalData.sharedInstance.language(key:"state")
        postalCodeTextField.placeholder = GlobalData.sharedInstance.language(key:"zip")
        
        saveAddressButton.setTitle(GlobalData.sharedInstance.language(key:"save"), for: .normal)
        saveAddressButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR);
        saveAddressButton.setTitleColor(UIColor.white, for: .normal)
        
        useasmydefaultbillingaddressLabel.text = GlobalData.sharedInstance.language(key:"useasmydefaultbillingaddress")
        useasmydefaultshippingaddressLabel.text = GlobalData.sharedInstance.language(key:"useasmydefaultshippingaddress")
        stateLebel.text = GlobalData.sharedInstance.language(key:"state")
        
        mobileNumberTextField.pastingEnabled = false
        
        self.scrollView.isHidden = true;
        whichApiDataToProcess = "formData";
        callingHttppApi();
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
    }
    
    
    
    
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        if whichApiDataToProcess == "saveformdata"{
            var requstParams = [String:Any]();
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            var addressDataDictionary = [String: AnyObject]();
            addressDataDictionary["firstname"] = firstNameValue as AnyObject?;
            addressDataDictionary["lastname"] = lastNameValue as AnyObject?;
            addressDataDictionary["company"] = companyValue as AnyObject?;
            addressDataDictionary["telephone"] = telephoneValue as AnyObject?;
            addressDataDictionary["fax"] = faxValue as AnyObject?;
            addressDataDictionary["city"] = cityValue as AnyObject?;
            addressDataDictionary["postcode"] = zipValue as AnyObject?;
            addressDataDictionary["country_id"] = countryValue as AnyObject?;
            if((regionValue == "") == false){
                addressDataDictionary["region"] = regionValue as AnyObject?;
            }
            if(regionId != "0"){
                addressDataDictionary["region_id"] = regionId as AnyObject?;
            }
            addressDataDictionary["street"] = streetArray as AnyObject?;
            addressDataDictionary["default_billing"] = default_billing as AnyObject?;
            addressDataDictionary["default_shipping"] = default_shipping as AnyObject?;
            addressDataDictionary["prefix"] = prefixTextField.text as AnyObject?;
            addressDataDictionary["suffix"] = suffixTextField.text as AnyObject?;
            addressDataDictionary["middleName"] = middleNameTextField.text as AnyObject?;
            if(addOrEdit == "1"){
                requstParams["addressId"] = addressId
            }else{
                requstParams["addressId"] = "0"
            }
            
            do {
                let jsonAddressData =  try JSONSerialization.data(withJSONObject: addressDataDictionary, options: .prettyPrinted)
                let jsonaddressString:String = NSString(data: jsonAddressData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["addressData"] = jsonaddressString
            }
            catch {
                print(error.localizedDescription)
            }
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/saveAddress", currentView: self){success,responseObject in
                if success == 1{
                    
                    let dict = responseObject as! NSDictionary
                    GlobalData.sharedInstance.dismissLoader()
                    if dict.object(forKey: "success") as! Bool == true{
                        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "success"), message: dict.object(forKey: "message") as? String, preferredStyle: .alert)
                        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            self.navigationController?.popViewController(animated: true)
                            if self.currentClass == "shipping"{
                                self.delegate.newAddAddreressSuccess(data: true)
                            }
                        })
                        
                        AC.addAction(okBtn)
                        self.present(AC, animated: true, completion: {  })
                        
                        
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict.object(forKey: "message") as! String)
                    }
                    print(responseObject as! NSDictionary)
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        }else{
            var requstParams = [String:Any]();
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            if addOrEdit == "1"{
                requstParams["addressId"] = addressId
            }
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/addressformData", currentView: self){success,responseObject in
                if success == 1{
                    
                    self.addEditAddressModel = AddeditAddressModel(data:JSON(responseObject as! NSDictionary))
                    print(responseObject as! NSDictionary)
                    self.doFurtherProcessingWithResult()
                }
                else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
        
    }
    
    
    
    @IBAction func prefixTextFieldClicked(_ sender: UIFloatLabelTextField) {
        if addEditAddressModel.isPrefixHasOption{
            let thePicker = UIPickerView()
            thePicker.tag = 3;
            prefixTextField.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    
    @IBAction func SuffixTextFieldClick(_ sender: UIFloatLabelTextField) {
        if addEditAddressModel.isSuffixHasOption{
            let thePicker = UIPickerView()
            thePicker.tag = 4;
            suffixTextField.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    //    @IBAction func gpsButtonClick(_ sender: Any) {
    //        locationManager = CLLocationManager()
    //        if (CLLocationManager.locationServicesEnabled()) {
    //            locationManager.requestAlwaysAuthorization()
    //            locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //            locationManager.delegate = self
    //            locationManager.startUpdatingLocation()
    //        } else {
    //            print("Location services are not enabled");
    //        }
    //    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        let locationArray = locations as NSArray
    //        let locationObj = locationArray.lastObject as! CLLocation
    //        //var coordinator = locationObj.coordinate
    //        let geocoder = CLGeocoder()
    //
    //        geocoder.reverseGeocodeLocation(locationObj, completionHandler: {(placemarks, error)->Void in
    //            var placemark:CLPlacemark!
    //
    //            if error == nil && (placemarks?.count)! > 0 {
    //                placemark = placemarks?[0]
    //                let countryCode = placemark.isoCountryCode;
    //                for i in 0..<self.countryPickerData.count{
    //                    let countryDict:NSDictionary = self.countryPickerData .object(at: i) as! NSDictionary
    //                    let  countryID:String = countryDict.object(forKey: "country_id") as! String;
    //                    if(countryID == countryCode!){
    //                        self.countryIndex = i;
    //                        self.countryValue = countryID;
    //                        self.countryPicker.selectRow(i, inComponent: 0, animated: false)
    //                        self.pickerView(self.countryPicker, didSelectRow: i, inComponent: 0)
    //                        break
    //                    }
    //                }
    //
    //                self.cityNameTextField.text = placemark.locality
    //                self.streetAddress1TextField.text = placemark.subLocality
    //                self.stateField.text = placemark.administrativeArea
    //                self.postalCodeTextField.text = placemark.postalCode
    //
    //
    //
    //            }
    ////        })
    //
    //
    //        locationManager.stopUpdatingLocation()
    //
    //    }
    
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            GlobalData.sharedInstance.dismissLoader()
            self.view.isUserInteractionEnabled = true;
            if(self.whichApiDataToProcess == "formData"){
                
                if self.addEditAddressModel.countryData != nil {
                    self.countryPickerData = self.addEditAddressModel.countryData! as NSArray
                }
                
                self.countryPicker.delegate = self;
                
                
                self.prefixTextFieldHeightConstarints.constant = 0;
                self.middleNameTextFieldHeight.constant = 0;
                self.suffixtextFieldHeightConstarints.constant = 0;
                self.streetAddress3TextFieldHeight.constant = 0;
                self.streetAddress4TextFieldHeight.constant = 0;
                self.streetAddress2TextFeildHeight.constant = 0
                self.mainViewHeightConstraints.constant = 1400
                
                self.prefixTextField.isHidden = true;
                self.middleNameTextField.isHidden = true;
                self.suffixTextField.isHidden = true;
                self.streetAddress3TextField.isHidden = true;
                self.streetAddress4TextField.isHidden = true;
                self.streetAddress2TextField.isHidden = true
                
                
                
                self.prefixValueArray = self.addEditAddressModel.prefixValue! as NSArray
                self.suffixValueArray = self.addEditAddressModel.suffixValue! as NSArray
                if self.addEditAddressModel.isPrefixVisible{
                    self.prefixTextField.isHidden = false;
                    self.expandHeight += 50;
                    self.prefixTextFieldHeightConstarints.constant = 50;
                }
                
                if self.addEditAddressModel.isMiddleNameVisible{
                    self.middleNameTextField.isHidden = false;
                    self.expandHeight += 50;
                    self.middleNameTextFieldHeight.constant = 50;
                    
                }
                
                if self.addEditAddressModel.isSuffixVisible{
                    self.suffixTextField.isHidden = false;
                    self.expandHeight += 50;
                    self.suffixtextFieldHeightConstarints.constant = 50;
                    
                }
                self.streetCount = self.addEditAddressModel.receiveStreetCount;
                
                if self.streetCount == 2{
                    self.streetAddress2TextField.isHidden = false;
                    self.streetAddress2TextFeildHeight.constant = 50;
                    self.expandHeight += 50
                }
                
                if self.streetCount == 3{
                    self.streetAddress3TextField.isHidden = false
                    self.expandHeight += 50;
                    self.streetAddress3TextFieldHeight.constant = 50;
                }
                if self.streetCount == 4{
                    self.streetAddress4TextField.isHidden = false
                    self.streetAddress3TextField.isHidden = false
                    self.expandHeight += 100;
                    self.streetAddress3TextFieldHeight.constant = 50;
                    self.streetAddress4TextFieldHeight.constant = 50;
                }
                
                
                if(self.addOrEdit == "1"){
                    self.firstNameTextField.text = self.addEditAddressModel.receiveFirstName
                    self.lastNameTextField.text = self.addEditAddressModel.receiveLastName
                    self.companyNameTextField.text = self.addEditAddressModel.receiveCompanyName
                    self.mobileNumberTextField.text = self.addEditAddressModel.receiveTelephoneValue
                    self.faxNumberTextField.text = self.addEditAddressModel.faxValue
                    self.cityNameTextField.text = self.addEditAddressModel.receiveCity
                    self.postalCodeTextField.text = self.addEditAddressModel.receivePostCode
                    self.prefixTextField.text = self.addEditAddressModel.receivePrefixValue
                    self.middleNameTextField.text = self.addEditAddressModel.receiveMiddleName
                    self.suffixTextField.text = self.addEditAddressModel.receiveSuffixValue
                    
                    
                    let streetArray : NSArray = self.addEditAddressModel.receiveStreetData! as NSArray
                    self.streetAddress1TextField.text = streetArray.object(at: 0) as? String;
                    if(streetArray.count>1){
                        self.streetAddress2TextField.text = streetArray.object(at: 1) as? String;
                    }
                    if self.addEditAddressModel.receiveIsDefaultBilling == true{
                        self.default_billing = "1";
                        self.defaultBillingAddressSwitch.setOn(true, animated: false);
                    }
                    if self.addEditAddressModel.receiveIsDefaultShipping == true{
                        self.defaultShippingAddressSwitch.setOn(true, animated: false);
                    }
                    
                    
                    for i in 0..<self.countryPickerData.count{
                        let countryDict:NSDictionary = self.countryPickerData .object(at: i) as! NSDictionary
                        let  countryID:String = countryDict.object(forKey: "country_id") as! String;
                        
                        if countryID == self.addEditAddressModel.receiveCountryId{
                            self.countryIndex = i;
                            self.countryValue = countryID;
                            self.countryPicker.selectRow(i, inComponent: 0, animated: false)
                            self.pickerView(self.countryPicker, didSelectRow: i, inComponent: 0)
                            break
                        }
                    }
                    var flag:Int = 0
                    for i in 0..<self.countryPickerData.count{
                        let countryDict:NSDictionary = self.countryPickerData .object(at: i) as! NSDictionary
                        let  countryID:String = countryDict.object(forKey: "country_id") as! String;
                        if countryID == self.addEditAddressModel.receiveCountryId{
                            if(countryDict.object(forKey: "states") != nil){
                                let stateArray:NSArray = countryDict.object(forKey: "states") as! NSArray;
                                for j in 0..<stateArray.count{
                                    let stateDict:NSDictionary = stateArray .object(at: j) as! NSDictionary
                                    let  stateId:String = stateDict.object(forKey: "region_id") as! String;
                                    if(stateId == self.addEditAddressModel.receiveRegionId){
                                        self.mainViewHeightConstraints.constant = 1400;
                                        flag = 1;
                                        break;
                                    }}
                                
                                
                                
                            }
                            else{
                                self.stateNameTextField.text = self.addEditAddressModel.receiveRegion
                                self.mainViewHeightConstraints.constant = 1300;
                            }
                        }
                    }
                    
                    if(flag == 0){
                        self.stateNameTextField.text = self.addEditAddressModel.receiveRegion
                        self.mainViewHeightConstraints.constant = 1300;
                        
                    }
                    
                }else{
                    if self.countryPickerData.count > 0{
                        
                        for i in 0..<self.countryPickerData.count{
                            let countryDict:NSDictionary = self.countryPickerData .object(at: i) as! NSDictionary
                            let countryID:String = countryDict.object(forKey: "country_id") as! String
                            
                            if countryID == self.addEditAddressModel.defaultCountryCode {
                                self.countryIndex = i
                                self.countryPicker.selectRow(i, inComponent: 0, animated: false)
                                self.pickerView(self.countryPicker, didSelectRow: i, inComponent: 0)
                            }
                        }
                    }
                }
                
                self.mainViewHeightConstraints.constant = 1200 + self.expandHeight
            }
            self.scrollView.isHidden = false
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1000){
            return self.countryPickerData.count;
        }else if pickerView.tag == 2000{
            return self.statePickerData.count;
        }else if pickerView.tag == 3{
            return self.prefixValueArray.count
        }else if pickerView.tag == 4{
            return self.suffixValueArray.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1000){
            let countryDict:NSDictionary = countryPickerData .object(at: row) as! NSDictionary
            let  attributedString:String = countryDict.object(forKey: "name") as! String;
            return attributedString
        }else if pickerView.tag == 2000{
            let stateDict:NSDictionary = statePickerData .object(at: row) as! NSDictionary
            let  attributedString:String = stateDict.object(forKey: "name") as! String;
            return attributedString
        }else if pickerView.tag == 3{
            return prefixValueArray.object(at: row) as? String
            
        }else if pickerView.tag == 4{
            return suffixValueArray.object(at: row) as? String
            
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.tag == 1000){
            countryIndex = row;
            let countryDict:NSDictionary = countryPickerData .object(at: countryIndex) as! NSDictionary;
            if((countryDict.object(forKey: "states")) != nil){
                statePickerData = [];
                statePickerData = countryDict.object(forKey: "states") as! NSArray;
                if statePickerData.count > 0{
                    let stateDict: NSDictionary = statePickerData.object(at: 0) as! NSDictionary;
                    regionId = stateDict.object(forKey: "region_id") as! String;
                }
                statePicker.delegate = self;
                stateField.isHidden = true;
                stateFieldHeightConstarints.constant = 100;
                statePicker.isHidden = false;
            }else{
                regionId = "0";
                statePicker.isHidden = true;
                stateFieldHeightConstarints.constant = 50;
                stateField.isHidden = false;
            }
            countryValue = countryDict.object(forKey: "country_id") as! String ;
        }
        if(pickerView.tag == 2000){
            let countryDict:NSDictionary = countryPickerData .object(at: countryIndex) as! NSDictionary;
            let stateArray:NSArray = countryDict.object(forKey: "states") as! NSArray;
            let stateDict: NSDictionary = stateArray.object(at: row) as! NSDictionary;
            regionId = stateDict.object(forKey: "region_id") as! String;
        }
        
        if pickerView.tag == 3{
            prefixTextField.text = prefixValueArray.object(at: row) as? String
        }
        if pickerView.tag == 4{
            suffixTextField.text = suffixValueArray.object(at: row) as? String
        }
    }
    
    @IBAction func defaultBillingAddressswitch(_ sender: UISwitch) {
        let mySwitch = (sender )
        if mySwitch.isOn {
            default_billing = "1"
        }else{
            
            default_billing = "0"
        }
    }
    
    
    @IBAction func defaultShippingAddressswitch(_ sender: UISwitch) {
        let mySwitch = (sender )
        if mySwitch.isOn {
            default_shipping = "1";
        }else{
            
            default_shipping = "0";
        }
    }
    
    @IBAction func saveAddress(_ sender: Any) {
        firstNameValue = firstNameTextField.text;
        lastNameValue = lastNameTextField.text;
        companyValue = companyNameTextField.text;
        telephoneValue = mobileNumberTextField.text;
        faxValue = faxNumberTextField.text;
        street1Value = streetAddress1TextField.text;
        street2Value = streetAddress2TextField.text;
        street3Value = streetAddress3TextField.text;
        street4Value = streetAddress4TextField.text;
        
        cityValue = cityNameTextField.text;
        if(regionId == "0"){
            regionValue = stateNameTextField.text;
        }else{
            regionValue = "";
        }
        zipValue = postalCodeTextField.text;
        let countryDict:NSDictionary = countryPickerData .object(at: countryIndex) as! NSDictionary;
        countryValue = countryDict.object(forKey: "country_id") as! String ;
        
        var errorMessage = ""
        var isValid:Int = 0
        if firstNameValue == ""{
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillfirstname")
            isValid = 1
        }else if lastNameValue == ""{
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefilllastname")
            isValid = 1
        }else if telephoneValue == ""{
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillmobilenumber");
            isValid = 1
        }else if street1Value == ""{
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillstreetname");
            isValid = 1
        }else if cityValue == ""{
            errorMessage = GlobalData.sharedInstance.language(key: "entercityname");
            isValid = 1
        }else if zipValue == ""{
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillzipcode");
            isValid = 1
        }else if((countryDict.object(forKey: "states")) != nil){
            if(regionId  == "0" ){
                errorMessage = GlobalData.sharedInstance.language(key: "pleasefillregionname");
                isValid = 1
            }
        }
        if addEditAddressModel.isPrefixRequired{
            if prefixTextField.text == ""{
                isValid = 0;
                errorMessage =  GlobalData.sharedInstance.language(key: "plesefillprefix")
            }
        }
        if addEditAddressModel.isSuffixRequired{
            if suffixTextField.text == ""{
                isValid = 0;
                errorMessage =  GlobalData.sharedInstance.language(key: "plesefillsuffix")
            }
        }
        
        if(isValid == 1){
            GlobalData.sharedInstance.showErrorSnackBar(msg: errorMessage)
        }else{
            if self.streetCount == 1{
                streetArray = [street1Value];
            }
            if self.streetCount == 2{
                streetArray = [street1Value, street2Value];
            }
            if self.streetCount == 3{
                streetArray = [street1Value, street2Value, street3Value];
            }
            if self.streetCount == 4{
                streetArray = [street1Value, street2Value, street3Value, street4Value];
            }
            whichApiDataToProcess = "saveformdata"
            callingHttppApi()
        }
    }
}
