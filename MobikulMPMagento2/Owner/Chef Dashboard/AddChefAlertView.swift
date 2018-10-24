//
//  CustomAlertView.swift
//  CustomAlertView
//
//  Created by Daniel Luque Quintana on 16/3/17.
//  Copyright © 2017 dluque. All rights reserved.
//

import UIKit
import Alamofire
import SearchTextField

class AddChefAlertView: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chefEmailTextField: SearchTextField!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var restaurantTextField: SkyFloatingLabelTextField!
    
    var customerEmails = [String]();
    var callingApiSucceed:Bool = false;
    var restaurantDashboardModelView:RestaurantDashboardModelView!;
    var delegate: AddChefAlertViewDelegate?
    var restaurantId:Int = -1;
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //chefEmailTextField.becomeFirstResponder()
        okButton.layer.cornerRadius = 20
        chefEmailTextField.filterStrings(customerEmails)
        chefEmailTextField.startSuggestingInmediately = true
        
        self.callingHttppApi()
    }
    
    func callingHttppApi(){
        var requstParams = [String:Any]();
        
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        requstParams = [String:Any]();
        requstParams["websiteId"] = DEFAULT_WEBSITE_ID
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
            requstParams["customerId"] = customerId
        }
        requstParams["customerType"] =  1; //owner
        self.callingApiSucceed = false;
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/owner/getrestaurantinfos", currentView: self){success,responseObject in
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
                    self.restaurantDashboardModelView = RestaurantDashboardModelView(data:dict);
                    self.callingApiSucceed = true;
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    @IBAction func restaurantTextFieldClick(_ sender: Any) {
        let thePicker = UIPickerView()
        thePicker.tag = 2000;
        restaurantTextField.inputView = thePicker
        thePicker.delegate = self;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 2000){
            if(self.callingApiSucceed){
                //return ChefsDashboardController.chefDashboardModelView.restaurantInfos.count
                return self.restaurantDashboardModelView.restaurantInfos.count
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 2000){
            if(self.callingApiSucceed){
                return self.restaurantDashboardModelView.restaurantInfos[row].restaurantName
            }
        }
        return "";
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.tag == 2000){
            if(self.callingApiSucceed){
                restaurantTextField.text = self.restaurantDashboardModelView.restaurantInfos.count > 0 ? self.restaurantDashboardModelView.restaurantInfos[row].restaurantName : ""
                self.restaurantId = self.restaurantDashboardModelView.restaurantInfos.count > 0 ? self.restaurantDashboardModelView.restaurantInfos[row].restaurantId : 0
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    @IBAction func onTapCancelButton(_ sender: Any) {
        chefEmailTextField.resignFirstResponder()
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapOkButton(_ sender: Any) {
        chefEmailTextField.resignFirstResponder()
        delegate?.okButtonTapped(textFieldValue: chefEmailTextField.text!, restaurantIdValue: self.restaurantId)
        self.dismiss(animated: true, completion: nil)
    }
}
