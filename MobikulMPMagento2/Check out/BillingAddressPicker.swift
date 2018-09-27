//
//  BillingAddressPicker.swift
//  OpenCartMpV3
//
//  Created by kunal on 21/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import UIKit

class BillingAddressPicker: UIViewController,UITableViewDelegate, UITableViewDataSource,NewAddressAddHandlerDelegate {
    
    @IBOutlet weak var addNewAddressButton: UIButton!
    @IBOutlet weak var addressTableView: UITableView!
    
    var addressID:String = ""
    var billingViewModel:BillingAndShipingViewModel!
    var delegate:BillingAddressPickerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        addressTableView.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentTableViewCell")
        addressTableView.rowHeight = UITableViewAutomaticDimension
        self.addressTableView.estimatedRowHeight = 50
        addressTableView.separatorColor = UIColor.clear
        addressTableView.dataSource = self
        addressTableView.delegate = self
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
                        self.addressTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return billingViewModel.addressData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PaymentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell") as! PaymentTableViewCell
        cell.methodDescription.text = billingViewModel.addressData[indexPath.row].value
        
        if addressID == billingViewModel.addressData[indexPath.row].id{
            cell.roundImageView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        }else{
            cell.roundImageView.backgroundColor = UIColor.white
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return GlobalData.sharedInstance.language(key: "ShippingAddress")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addressID = billingViewModel.addressData[indexPath.row].id
        let address = billingViewModel.addressData[indexPath.row].value
        delegate.selectBillingAddress(data: true, addressId:addressID , address: address!)
        self.navigationController?.popViewController(animated: true)
    }
    
    func newAddAddreressSuccess(data:Bool){
        callingHttppApi()
    }
    
    @IBAction func addNewAddressButtonClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "newaddress", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "newaddress") {
            let viewController:AddEditAddress = segue.destination as UIViewController as! AddEditAddress
            viewController.addOrEdit = "0"
            viewController.addressId = "0"
            viewController.currentClass = "shipping"
            viewController.delegate = self
        }
    }
}
