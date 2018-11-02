//
//  OrderReviewController.swift
//  Magento2V4Theme
//
//  Created by kunal on 21/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class OrderReviewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var addressImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var shipmentImageView: UIImageView!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var summaryImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    
    
    
    
    
    
    @IBOutlet weak var orderReviewTableView: UITableView!
    var orderReviewModel: OrderReviewViewModel!
    var incrementidValue:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        addressImageView.layer.cornerRadius = 15;
        addressImageView.layer.masksToBounds = true
        
        shipmentImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        paymentImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        summaryImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        shipmentImageView.layer.cornerRadius = 15;
        shipmentImageView.layer.masksToBounds = true
        
        paymentImageView.layer.cornerRadius = 15;
        paymentImageView.layer.masksToBounds = true
        
        summaryImageView.layer.cornerRadius = 15;
        summaryImageView.layer.masksToBounds = true
        
        self.navigationItem.title = "Order Review"
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let paymentMethodNavigationController = self.tabBarController?.viewControllers?[2]
        let nav1 = paymentMethodNavigationController as! UINavigationController;
        let paymentMethodViewController = nav1.viewControllers[0] as! PaymentMethodController
        self.orderReviewModel = paymentMethodViewController.orderReviewModel;
        orderReviewTableView.register(UINib(nibName: "AddressUITableViewCell", bundle: nil), forCellReuseIdentifier: "address")
        orderReviewTableView.register(UINib(nibName: "OrderReviewProductCell", bundle: nil), forCellReuseIdentifier: "OrderReviewProductCell")
        orderReviewTableView.register(UINib(nibName: "ContinueToBillTableViewCell", bundle: nil), forCellReuseIdentifier: "continueCell")
        
        
        self.orderReviewTableView.estimatedRowHeight = 250.0
        self.orderReviewTableView.rowHeight = UITableViewAutomaticDimension
        orderReviewTableView.separatorColor = UIColor.clear
        
        if GlobalVariables.CurrentIndex == 4{
            orderReviewTableView.dataSource = self
            orderReviewTableView.delegate = self
            
        }
        
    }
    
    
    
    @IBAction func goToShippingAddress(_ sender: UITapGestureRecognizer) {
        self.tabBarController!.selectedIndex = 0
    }
    
    @IBAction func goToshippingMethod(_ sender: UITapGestureRecognizer) {
        if defaults.object(forKey: "isVirtual") as! String == "false"{
            self.tabBarController!.selectedIndex = 1
        }
    }
    
    
    @IBAction func goToPaymentMethod(_ sender: UITapGestureRecognizer) {
        self.tabBarController!.selectedIndex = 2
    }
    
    
    
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(section == 1)    {
            if orderReviewModel.orderReviewExtraData.shippingAddress != ""{
                return 1
            }else{
                return 0
            }
        }else if(section == 3){
            if orderReviewModel.orderReviewExtraData.shippingMethod != ""{
                return 1
            }else{
                return 0
            }
        }else if section == 0 || section == 2 || section == 5{
            return 1
        }else if section == 4{
            return orderReviewModel.orderReviewProduct.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = orderReviewModel.orderReviewExtraData.billingAddress
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = orderReviewModel.orderReviewExtraData.shippingAddress
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 2{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = orderReviewModel.orderReviewExtraData.paymentMethod
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 3{
            let cell:AddressUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "address") as! AddressUITableViewCell
            cell.addressLabel.text = orderReviewModel.orderReviewExtraData.shippingMethod
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 4{
            let cell:OrderReviewProductCell = tableView.dequeueReusableCell(withIdentifier: "OrderReviewProductCell") as! OrderReviewProductCell
            cell.productName.text = orderReviewModel.orderReviewProduct[indexPath.row].productName
            cell.priceValue.text = orderReviewModel.orderReviewProduct[indexPath.row].price
            cell.qtyValue.text = orderReviewModel.orderReviewProduct[indexPath.row].qty
            cell.subtotalValue.text = orderReviewModel.orderReviewProduct[indexPath.row].subtotal
            
            var tempString = ""
            
            for  i in (0..<orderReviewModel.orderReviewProduct[indexPath.row].options.count){
                tempString = tempString+orderReviewModel.orderReviewProduct[indexPath.row].options[i]["label"].stringValue+": "+orderReviewModel.orderReviewProduct[indexPath.row].options[i]["value"].stringValue+"\n";
            }
            cell.optionValue.text = tempString
            GlobalData.sharedInstance.getImageFromUrl(imageUrl:orderReviewModel.orderReviewProduct[indexPath.row].imageUrl , imageView: cell.imageUrl)
            
            cell.selectionStyle = .none
            return cell
            
        }else{
            
            let cell:ContinueToBillTableViewCell = tableView.dequeueReusableCell(withIdentifier: "continueCell") as! ContinueToBillTableViewCell
            cell.subtotalTitleLabel.text = orderReviewModel.orderReviewExtraData.subtotalLabel
            cell.subTotalValue.text = orderReviewModel.orderReviewExtraData.subtotalValue
            cell.shippingTitleLabel.text = orderReviewModel.orderReviewExtraData.shippingChargeLabel
            cell.shippingValue.text = orderReviewModel.orderReviewExtraData.shippingChargeValue
            cell.grandTotalTitleLabel.text = orderReviewModel.orderReviewExtraData.grandTotalLabel
            cell.grandTotalValue.text = orderReviewModel.orderReviewExtraData.grandTotalValue
            cell.taxtitle.text = orderReviewModel.orderReviewExtraData.taxLabel
            cell.taxValue.text = orderReviewModel.orderReviewExtraData.taxValue
            cell.discountTitle.text = orderReviewModel.orderReviewExtraData.discountTitle
            cell.discountValue.text = orderReviewModel.orderReviewExtraData.discountValue
            
            cell.continueBtn.addTarget(self, action:#selector(handleRegister), for: .touchUpInside);
            
            cell.selectionStyle = .none
            return cell
            
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        if(section == 0){
            if orderReviewModel.orderReviewExtraData.billingAddress != ""{
                return "  "+GlobalData.sharedInstance.language(key:"billingaddress");
            }else{
                return ""
            }
        }else if(section == 1){
            if orderReviewModel.orderReviewExtraData.shippingAddress != ""{
                return "  "+GlobalData.sharedInstance.language(key:"shippingaddress");
            }else{
                return ""
            }
        }else if(section == 2){
            return "  "+GlobalData.sharedInstance.language(key:"billingmethod");
        }else if(section == 3){
            if orderReviewModel.orderReviewExtraData.shippingMethod != ""{
                return "  "+GlobalData.sharedInstance.language(key:"shipmentmethod");
            }else{
                return ""
            }
        }else if section == 4 {
            return GlobalData.sharedInstance.language(key:"products");
        }else{
            return ""
        }
        
    }
    
    
    @objc func handleRegister(){
        callingHttppApi()
    }
    
    
    
    
    func callingHttppApi(){
        self.view.isUserInteractionEnabled = false
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]();
        let customerId = defaults.object(forKey: "customerId")
        let quoteId = defaults.object(forKey: "quoteId")
        if(customerId != nil){
            requstParams["customerToken"] = customerId
        }
        if(quoteId != nil  ){
            requstParams["quoteId"] = quoteId
            
        }
        
        if defaults.object(forKey: "storeId") != nil{
            requstParams["storeId"] = defaults.object(forKey: "storeId") as! String
        }
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/checkout/saveOrder", currentView: self){success,responseObject in
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        defaults .set(storeId, forKey: "storeId")
                    }
                }
                
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                self.doFurtherProcessingWithResult(data:responseObject! as! NSDictionary)
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
        
    }
    
    func doFurtherProcessingWithResult(data :NSDictionary){
        DispatchQueue.main.async {
            let dict = JSON(data)
            if dict["success"].boolValue == true{
                self.incrementidValue = dict["incrementId"].stringValue
                self.performSegue(withIdentifier: "goToSuccessPage", sender: self)
            }
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "goToSuccessPage") {
            let viewController:OrderPlaced = segue.destination as UIViewController as! OrderPlaced
            viewController.incrementId = incrementidValue
        }
    }
    
    
    
    
    
    
}
