//
//  Chef_MyCart.swift
//  MobikulMPMagento2
//
//  Created by Othello on 20/09/2018.       
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class Chef_MyCart: UIViewController ,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    let defaults = UserDefaults.standard
    var myCartViewModel:Chef_MyCartViewModel!
    var extraHeight:CGFloat = 0
    var whichApiToProcess = ""
    var itemId:String = ""
    var toUpdateItemQtys = NSMutableArray()
    var toUpdateItemId = NSMutableArray()
    var coupontextField:UITextField!
    var keyBoardshownFlag:Int = 0
    var proceedToCheckout:Bool = true
    var emptyView:EmptyNewAddressView!
    @IBOutlet weak var proceedToCheckOutButton:UIButton!
    
    @IBOutlet weak var cartTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        whichApiToProcess = ""
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "mycart")
        cartTableView.separatorColor = UIColor.clear
        cartTableView.rowHeight = UITableViewAutomaticDimension
        self.cartTableView.estimatedRowHeight = 50
        emptyView = EmptyNewAddressView(frame: self.view.frame)
        self.view.addSubview(emptyView)
        emptyView.isHidden = true
        emptyView.emptyImages.image = UIImage(named: "empty_cart")!
        emptyView.addressButton.setTitle(GlobalData.sharedInstance.language(key: "browsecategory"), for: .normal)
        emptyView.labelMessage.text = GlobalData.sharedInstance.language(key: "emptycartmessage")
        emptyView.addressButton.addTarget(self, action: #selector(browseCategory(sender:)), for: .touchUpInside)
        //navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    @objc func browseCategory(sender: UIButton){
        self.tabBarController!.selectedIndex = 2
    }
    
    @IBAction func dismissKeyBoard(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.view.isUserInteractionEnabled = true
        callingHttppApi()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callingHttppApi(){
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        if self.defaults.object(forKey: "storeId") != nil{
            requstParams["storeId"] = self.defaults.object(forKey: "storeId") as! String
        }
        let quoteId = self.defaults.object(forKey:"quoteId")
        let customerId = self.defaults.object(forKey:"customerId")
        if(quoteId != nil){
            requstParams["quoteId"] = quoteId
        }
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        if self.whichApiToProcess == "removeitem"{
            GlobalData.sharedInstance.showLoader()
            requstParams["itemId"] = self.itemId
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/checkout/removecartItem", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    self.whichApiToProcess = ""
                    self.callingHttppApi()
                }else if success == 2{
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        }else if self.whichApiToProcess == "movetowishlist"{
            GlobalData.sharedInstance.showLoader()
            requstParams["itemId"] = self.itemId
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/checkout/wishlistfromCart", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    print("sssss",responseObject as! NSDictionary)
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    let AC = UIAlertController(title: nil, message: GlobalData.sharedInstance.language(key: "successmovetowishlist"), preferredStyle: .alert)
                    let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    })
                    AC.addAction(noBtn)
                    self.present(AC, animated: true, completion: {})
                    self.whichApiToProcess = ""
                    self.callingHttppApi()
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        }else if self.whichApiToProcess == "emptycart"{
            GlobalData.sharedInstance.showLoader()
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/checkout/emptyCart", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    self.whichApiToProcess = ""
                    self.callingHttppApi()
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else if self.whichApiToProcess == "updatecart"{
            GlobalData.sharedInstance.showLoader()
            
            do {
                let jsonData1 =  try JSONSerialization.data(withJSONObject: self.toUpdateItemId, options: .prettyPrinted)
                let jsonString1:String = NSString(data: jsonData1, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["itemIds"] = jsonString1
                let jsonData2 =  try JSONSerialization.data(withJSONObject: self.toUpdateItemQtys, options: .prettyPrinted)
                let jsonString2:String = NSString(data: jsonData2, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["itemQtys"] = jsonString2
                
            }
            catch {
                print(error.localizedDescription)
            }
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/checkout/updateCart", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    print(responseObject!)
                    let dict = responseObject as! NSDictionary
                    if dict.object(forKey: "success") as! Bool == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg: GlobalData.sharedInstance.language(key: "cartupdated"))
                    }
                    
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    self.whichApiToProcess = ""
                    self.callingHttppApi()
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        } else if self.whichApiToProcess == "applycouponcode"{
            GlobalData.sharedInstance.showLoader()
            requstParams["couponCode"] = self.coupontextField.text
            requstParams["removeCoupon"] = "0"
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/checkout/applyCoupon", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    let dict = responseObject as! NSDictionary
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    
                    if dict.object(forKey: "success") as! Bool == true{
                        self.whichApiToProcess = ""
                        self.callingHttppApi()
                    }else{
                        self.whichApiToProcess = ""
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict.object(forKey: "message") as! String)
                    }
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        }else if self.whichApiToProcess == "cancelcoupon"{
            GlobalData.sharedInstance.showLoader()
            requstParams["couponCode"] = self.coupontextField.text
            requstParams["removeCoupon"] = "1"
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/checkout/applyCoupon", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    let dict = responseObject as! NSDictionary
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    
                    if dict.object(forKey: "success") as! Bool == true{
                        self.whichApiToProcess = ""
                        self.callingHttppApi()
                    }else{
                        self.whichApiToProcess = ""
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict.object(forKey: "message") as! String)
                    }
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
        else{
            if self.defaults.object(forKey: "currency") != nil{
                requstParams["currency"] = self.defaults.object(forKey: "currency") as! String
            }
            GlobalData.sharedInstance.showLoader()
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/checkout/cartDetails", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    print(responseObject)
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    self.myCartViewModel = Chef_MyCartViewModel(data: JSON(responseObject as! NSDictionary))
                    self.doFurtherProcessingWithResult()
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            if self.myCartViewModel.getCartItems.count > 0{
                self.emptyView.isHidden = true
                self.cartTableView.delegate = self
                self.cartTableView.dataSource = self
                self.cartTableView.reloadData()
                self.cartTableView.isHidden = false
                badge = String(self.myCartViewModel.getExtraCartData.cartCount)
                //self.tabBarController!.tabBar.items?[3].badgeValue = String(self.myCartViewModel.getExtraCartData.cartCount)
            }else{
                self.cartTableView.isHidden = true
                //self.tabBarController!.tabBar.items?[3].badgeValue = nil
                badge = nil
                self.emptyView.isHidden = false
            }
            
            if self.myCartViewModel.getExtraCartData.isVirtual == 1{
                self.defaults.set("true", forKey: "isVirtual")
            }else{
                self.defaults.set("false", forKey: "isVirtual")
            }
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return self.myCartViewModel.getCartItems.count
        }else{
            return 1;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            cartTableView.register(UINib(nibName: "Chef_MyCartTableViewCell", bundle: nil), forCellReuseIdentifier: "chef_mycartcell")
            let cell:Chef_MyCartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "chef_mycartcell") as! Chef_MyCartTableViewCell
            cell.productNameLabelValue.text = myCartViewModel.getCartItems[indexPath.row].name
            cell.qtyValue.setTitle(myCartViewModel.getCartItems[indexPath.row].qty, for: .normal)
            
            cell.priceLabelValue.text = myCartViewModel.getCartItems[indexPath.row].price
            cell.subtotalLabelValue.text  = "Total " + myCartViewModel.getCartItems[indexPath.row].subtotal
            GlobalData.sharedInstance.getImageFromUrl(imageUrl: myCartViewModel.getCartItems[indexPath.row].imageUrl, imageView: cell.productImageView)
            var optionArray = myCartViewModel.getCartItems[indexPath.row].options
            
            if myCartViewModel.getCartItems[indexPath.row].message.count > 0{
                var dict:JSON = myCartViewModel.getCartItems[indexPath.row].message;
                if dict["type"].stringValue == "error"{
                    cell.errorMessage.isHidden = false;
                    proceedToCheckout = false;
                    cell.errorMessage.text = dict["text"].stringValue
                }
            }else{
                cell.errorMessage.isHidden = true
            }
            
//            var optionData:String = ""
//
//            for i in 0..<optionArray.count{
//                var dict = optionArray[i] ;
//                optionData = optionData+dict["label"].stringValue+":"
//                var childValue:String = ""
//                if dict["value"].arrayValue.count > 0{
//                    for j in 0..<dict["value"].count{
//                        childValue = childValue+dict["value"][j].stringValue+","
//                    }
//                }
//                optionData = optionData+childValue+"\n"
//            }
//            cell.stepperButton.value = Double(myCartViewModel.getCartItems[indexPath.row].qty)!
            cell.plusButton.tag = indexPath.row
            cell.minusButton.tag = indexPath.row
            print(cell.minusButton.tag)
            cell.myCartViewModel = self.myCartViewModel;
            cell.myCartView = self.cartTableView
//            cell.optionMessage.text = optionData
//            cell.moveToWishListButton.tag = indexPath.row
//            cell.moveToWishListButton.addTarget(self, action: #selector(moveToWishList(sender:)), for: .touchUpInside)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openProduct))
            cell.productImageView.addGestureRecognizer(tapGesture)
            cell.productImageView.tag = indexPath.row
            cell.productImageView.isUserInteractionEnabled = true
//            cell.removeButton.tag = indexPath.row
//            cell.removeButton.addTarget(self, action: #selector(removeItem(sender:)), for: .touchUpInside)
            
            let customerId = defaults.object(forKey:"customerId");
            if customerId != nil{
                //cell.moveToWishListButton.isHidden = false;
            }else{
                //cell.moveToWishListButton.isHidden = true;
            }
            cell.selectionStyle = .none
            
            if proceedToCheckout == false{
                self.proceedToCheckOutButton.isHidden = true;
            }else{
                self.proceedToCheckOutButton.isHidden = false;
            }
            
            return cell
        }else{
            cartTableView.register(UINib(nibName: "ExtraCartTableViewCell", bundle: nil), forCellReuseIdentifier: "extracell")
            let cell:ExtraCartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "extracell") as! ExtraCartTableViewCell
            cell.subTotalLabel.text = myCartViewModel.getExtraCartData.subTotalLabel
            cell.subTotalLabelValue.text = myCartViewModel.getExtraCartData.subTotalValue
            cell.taxLabel.text = myCartViewModel.getExtraCartData.taxLabel
            cell.taxLabelValue.text = myCartViewModel.getExtraCartData.taxValue
            cell.shippingHandlingLabel.text = myCartViewModel.getExtraCartData.shippingLabel
            cell.shippingHandlingLabelValue.text = myCartViewModel.getExtraCartData.shippingValue
            cell.grandTotalLabel.text = myCartViewModel.getExtraCartData.grandLabel
            cell.grandTotalLabelValue.text = myCartViewModel.getExtraCartData.grandValue
            cell.discountLabe.text = myCartViewModel.getExtraCartData.discountLabel
            cell.discountLabelValue.text = myCartViewModel.getExtraCartData.discountValue
            
            cell.emptyCartButton.addTarget(self, action: #selector(emptyCart(sender:)), for: .touchUpInside)
            cell.updateCartButton.addTarget(self, action: #selector(updateCart(sender:)), for: .touchUpInside)
            
            coupontextField = cell.couponCodeTextFeild
            coupontextField.placeholder = GlobalData.sharedInstance.language(key: "entercoupan")
            
            cell.couponCodeTextFeild.delegate = self
            if myCartViewModel.getExtraCartData.couponCode == ""{
                cell.cancelButton.isHidden = true
            }else{
                cell.cancelButton.isHidden = false
            }
            //cell.proceedToCheckOutButton.addTarget(self, action: #selector(proceedToCheckOut(sender:)), for: .touchUpInside)
            cell.applyButton.addTarget(self, action: #selector(applyCouponCode(sender:)), for: .touchUpInside)
            cell.cancelButton.addTarget(self, action: #selector(cancelCouponCode(sender:)), for: .touchUpInside)
                        
            if proceedToCheckout == false{
                cell.proceedToCheckOutButton.isHidden = true;
            }else{
                cell.proceedToCheckOutButton.isHidden = false;
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return self.view.bounds.size.width / 3
        }else{
            return 370;
        }
    }
    
    @objc func moveToWishList(sender: UIButton){
        itemId = myCartViewModel.getCartItems[sender.tag].id
        whichApiToProcess = "movetowishlist"
        self.proceedToCheckout = true
        callingHttppApi()
    }
    
    @objc func removeItem(sender: UIButton){
        self.itemId = self.myCartViewModel.getCartItems[sender.tag].id;
        self.whichApiToProcess = "removeitem"
        self.callingHttppApi()
    }
    
    @objc func editCartItem(sender: UIButton){
        itemId = myCartViewModel.getCartItems[sender.tag].id
    }
    
    @objc func emptyCart(sender: UIButton){
        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "pleaseconfirm"), message: GlobalData.sharedInstance.language(key: "cartemtyinfo"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "remove"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.whichApiToProcess = "emptycart"
            self.proceedToCheckout = true
            self.callingHttppApi()
        })
        let noBtn = UIAlertAction(title:GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: {  })
    }
    
    @objc func updateCart(sender: UIButton){
        toUpdateItemId = NSMutableArray();
        toUpdateItemQtys = NSMutableArray();
        
        for i in 0..<myCartViewModel.getCartItems.count{
            toUpdateItemId.add(myCartViewModel.getCartItems[i].id)
            toUpdateItemQtys.add(myCartViewModel.getCartItems[i].qty)
        }
        whichApiToProcess = "updatecart"
        proceedToCheckout = true
        callingHttppApi()
    }
    
    @objc func applyCouponCode(sender: UIButton){
        if coupontextField.text == ""{
            
            GlobalData.sharedInstance.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key: "entercoupan"));
        }else{
            whichApiToProcess = "applycouponcode";
            proceedToCheckout = true
            callingHttppApi()
        }
    }
    
    @objc func cancelCouponCode(sender: UIButton){
        if(coupontextField.text == ""){
            let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "warning"), message: GlobalData.sharedInstance.language(key: "entercoupan"), preferredStyle: .alert)
            let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
            })
            
            AC.addAction(okBtn)
            self.parent!.present(AC, animated: true, completion: {  })
        }else{
            whichApiToProcess = "cancelcoupon";
            proceedToCheckout = true
            callingHttppApi()
        }
    }
    
    func checkOutAsGuest(alertAction: UIAlertAction!) {
        self.performSegue(withIdentifier: "proceedtocheckout", sender: self)
    }
    
    func registerAndCheckOut(alertAction: UIAlertAction!) {
        self.performSegue(withIdentifier: "cartToCreateAccount", sender: self)
    }
    
    func existingUser(alertAction: UIAlertAction!) {
        self.performSegue(withIdentifier: "cartToCustomerLogin", sender: self)
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
    }
    
    @IBAction func proceedToCheckOut(_ sender: UIButton){
        
        //check for minimum order
        if myCartViewModel.myCartExtraData.grandUnformatedValue < myCartViewModel.myCartExtraData.minimumAmount {
            GlobalData.sharedInstance.showWarningSnackBar(msg: "minimumorderamountis".localized + " " + "\(myCartViewModel.myCartExtraData.minimumFormattedAmount!)")
        }else{
            let customerId = defaults.object(forKey:"customerId")
            if customerId != nil{
                self.performSegue(withIdentifier: "proceedtocheckout", sender: self)
            }else{
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let Create = UIAlertAction(title: GlobalData.sharedInstance.language(key: "checkoutasguest"), style: .default, handler: checkOutAsGuest)
                let guest = UIAlertAction(title: GlobalData.sharedInstance.language(key: "registerandcheckout"), style: .default, handler: registerAndCheckOut)
                let Existing = UIAlertAction(title: GlobalData.sharedInstance.language(key: "checkoutasexistingcustomer"), style: .default, handler: existingUser)
                let cancel = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .cancel, handler: cancelDeletePlanet)
                
                if self.myCartViewModel.getExtraCartData.isVirtual == 0 && myCartViewModel.myCartExtraData.isAllowedGuestCheckout    {
                    alert.addAction(Create)
                }
                
                alert.addAction(guest)
                alert.addAction(Existing)
                alert.addAction(cancel)
                
                // Support display in iPad
                alert.popoverPresentationController?.sourceView = self.view
                alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @objc func openProduct(_sender : UITapGestureRecognizer){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productImageUrl = myCartViewModel.getCartItems[(_sender.view?.tag)!].imageUrl
        vc.productName = myCartViewModel.getCartItems[(_sender.view?.tag)!].name
        vc.productId = myCartViewModel.getCartItems[(_sender.view?.tag)!].productId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {if (segue.identifier! == "cartToCreateAccount") {
        let viewController:CreateAccount = segue.destination as UIViewController as! CreateAccount
        viewController.movetoSignal = "cart";
    }else  if (segue.identifier! == "cartToCustomerLogin") {
        let viewController:CustomerLogin = segue.destination as UIViewController as! CustomerLogin
        viewController.moveToSignal = "cart";
        }
    }

}
