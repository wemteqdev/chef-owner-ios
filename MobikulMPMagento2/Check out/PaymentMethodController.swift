//
//  PaymentMethodController.swift
//  Magento2V4Theme
//
//  Created by kunal on 20/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class PaymentMethodController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    
@IBOutlet weak var addressImageView: UIImageView!
@IBOutlet weak var addressLabel: UILabel!
@IBOutlet weak var shipmentImageView: UIImageView!
@IBOutlet weak var shippingLabel: UILabel!
@IBOutlet weak var paymentImageView: UIImageView!
@IBOutlet weak var paymentLabel: UILabel!
@IBOutlet weak var summaryImageView: UIImageView!
@IBOutlet weak var summaryLabel: UILabel!
    
    
    
    
    
    
    
    
    
    
    
    
@IBOutlet weak var continueButton: UIButton!
@IBOutlet weak var paymentTableView: UITableView!
var shipmentPaymentMethodViewModel:ShipmentAndPaymentViewModel!
var paymentId:String = ""
 var shippingId:String = ""
var orderReviewModel: OrderReviewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        continueButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        continueButton.setTitle(GlobalData.sharedInstance.language(key: "continue"), for: .normal)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        paymentTableView.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentTableViewCell")
        paymentTableView.rowHeight = UITableViewAutomaticDimension
        self.paymentTableView.estimatedRowHeight = 50
        paymentTableView.separatorColor = UIColor.clear
        
        
        addressImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        addressImageView.layer.cornerRadius = 15;
        addressImageView.layer.masksToBounds = true
        
        shipmentImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        paymentImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        shipmentImageView.layer.cornerRadius = 15;
        shipmentImageView.layer.masksToBounds = true
        
        paymentImageView.layer.cornerRadius = 15;
        paymentImageView.layer.masksToBounds = true
        
        summaryImageView.layer.cornerRadius = 15;
        summaryImageView.layer.masksToBounds = true
       
    }

    
    override func viewWillAppear(_ animated: Bool) {
        let billingNavigationController = self.tabBarController?.viewControllers?[0]
        let nav = billingNavigationController as! UINavigationController;
        let billingViewController = nav.viewControllers[0] as! ShippingAddressViewController
        self.shipmentPaymentMethodViewModel = billingViewController.shipmentPaymentMethodViewModel
        
        let shippingMethodNavigationController = self.tabBarController?.viewControllers?[1]
        let nav1 = shippingMethodNavigationController as! UINavigationController;
        let shippingMethodViewController = nav1.viewControllers[0] as! ShippingMethodController
        shippingId = shippingMethodViewController.shippingId;
        
        
        if GlobalVariables.CurrentIndex == 3{
            self.paymentTableView.dataSource = self
            self.paymentTableView.delegate = self
        }
    }
    
    
    
    
    
    @IBAction func goToshippingAddress(_ sender: Any) {
        self.tabBarController!.selectedIndex = 0
    }
    
    
    @IBAction func goToShippingMethod(_ sender: UITapGestureRecognizer) {
        if defaults.object(forKey: "isVirtual") as! String == "false"{
        self.tabBarController!.selectedIndex = 1
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.shipmentPaymentMethodViewModel.paymentData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PaymentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell") as! PaymentTableViewCell
        cell.methodDescription.text = self.shipmentPaymentMethodViewModel.paymentData[indexPath.row].title
        
        if paymentId == self.shipmentPaymentMethodViewModel.paymentData[indexPath.row].code{
            cell.roundImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        }else{
            cell.roundImageView.backgroundColor = UIColor.white
        }
        cell.selectionStyle = .none
        return cell;
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.shipmentPaymentMethodViewModel.paymentData[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        paymentId = self.shipmentPaymentMethodViewModel.paymentData[indexPath.row].code
        self.paymentTableView.reloadData()
    }
    
    
    @IBAction func continueClick(_ sender: Any) {
        if paymentId == ""{
            GlobalData.sharedInstance.showErrorSnackBar(msg: "Please select Payment Method")
        }else {
            callingHttppApi()
        }
    }
    
    
    
    
    func callingHttppApi(){
        self.view.isUserInteractionEnabled = false;
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]();
        let customerId = defaults.object(forKey: "customerId")
        let storeId = defaults.object(forKey: "storeId")
        let quoteId = defaults.object(forKey: "quoteId")
        if(customerId != nil){
            requstParams["customerToken"] = customerId
            requstParams["checkoutMethod"] = "customer"
            
        }
        if(quoteId != nil ){
            requstParams["quoteId"] = quoteId
            requstParams["checkoutMethod"] = "guest"
        }
        requstParams["method"] = paymentId
        requstParams["shippingMethod"] = shippingId
        requstParams["storeId"] = storeId
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/checkout/orderreviewInfo", currentView: self){success,responseObject in
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        defaults .set(storeId, forKey: "storeId")
                    }
                }
                
                self.view.isUserInteractionEnabled = true;
                GlobalData.sharedInstance.dismissLoader()
                let dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    self.orderReviewModel =  OrderReviewViewModel(data: dict)
                    GlobalVariables.CurrentIndex = 4
                    self.tabBarController!.selectedIndex = 3
                    print("sss", dict)
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
