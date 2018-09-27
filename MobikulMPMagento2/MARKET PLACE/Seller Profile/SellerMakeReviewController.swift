//
//  SellerMakeReviewController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 01/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerMakeReviewController: UIViewController {
    
    @IBOutlet weak var writeyourcommenthereLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var nametextField: SkyFloatingLabelTextField!
    @IBOutlet weak var summaryTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var commentTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var priceRating:CGFloat = 0
    var valueRating:CGFloat = 0
    var quantityRating:CGFloat = 0
    var sellerId:String = ""
    var shopUrl:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeyourcommenthereLabel.text = GlobalData.sharedInstance.language(key: "writeyoutcomment");
        priceLabel.text = GlobalData.sharedInstance.language(key: "price");
        valueLabel.text = GlobalData.sharedInstance.language(key: "value");
        quantityLabel.text = GlobalData.sharedInstance.language(key: "quantity");
        
        nametextField.placeholder = GlobalData.sharedInstance.language(key: "name");
        summaryTextField.placeholder = GlobalData.sharedInstance.language(key: "summary");
        commentTextField.placeholder = GlobalData.sharedInstance.language(key: "comment");
        submitButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        submitButton.setTitle(GlobalData.sharedInstance.language(key: "submitreview"), for: .normal)
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
        let customeremail = defaults.object(forKey:"customerEmail");
        if customerId != nil{
            requstParams["customerToken"] = customerId
            requstParams["customerEmail"] = customeremail
        }
        requstParams["shopUrl"] = shopUrl
        requstParams["nickName"] = nametextField.text
        requstParams["sellerId"] = sellerId
        requstParams["priceRating"] = (priceRating/5)*100
        requstParams["valueRating"] = (valueRating/5)*100
        requstParams["description"] = commentTextField.text
        requstParams["qualityRating"] = (quantityRating/5)*100
        requstParams["summary"] = summaryTextField.text
        
        
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/SaveReview", currentView: self){success,responseObject in
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
    
    
    
    
    
    
    
    
    @IBAction func PriceRatingClick(_ sender: HCSStarRatingView) {
        priceRating = sender.value
    }
    
    
    
    @IBAction func ValueRatingClick(_ sender: HCSStarRatingView) {
        valueRating = sender.value
        
    }
    
    
    @IBAction func QuantityRatingClick(_ sender: HCSStarRatingView) {
        quantityRating = sender.value
    }
    
    
    
    
    @IBAction func SubmitClick(_ sender: UIButton) {
        var isValid = 1
        var errorMessage:String = ""
        if priceRating == 0{
            isValid = 0
            errorMessage = "pleasefillthepricerating"
        }else if quantityRating == 0{
            isValid = 0
            errorMessage = "pleasefillthequantityrating"
        }else if valueRating == 0{
            isValid = 0
            errorMessage = "pleasefillthevaluerating"
        }else if nametextField.text == ""{
            isValid = 0
            errorMessage = "pleasefillthename".localized
        }else if summaryTextField.text == ""{
            isValid = 0
            errorMessage = "pleasefillthesummary".localized
        }else if commentTextField.text == ""{
            isValid = 0
            errorMessage = "pleasefillthecomment".localized
        }
        
        if isValid == 0{
            GlobalData.sharedInstance.showErrorSnackBar(msg: errorMessage)
        }else{
            callingHttppApi()
        }
    }
}
