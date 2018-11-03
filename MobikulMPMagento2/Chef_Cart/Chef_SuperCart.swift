//
//  Chef_SuperCart.swift
//  MobikulMPMagento2
//
//  Created by Othello on 08/10/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit
import FZAccordionTableView

class Chef_SuperCart: UIViewController {
    @IBOutlet weak var totalPrice: UILabel!
    
    static fileprivate let kTableViewCellReuseIdentifier = "Cell"
    @IBOutlet fileprivate weak var tableView: FZAccordionTableView!
    let defaults = UserDefaults.standard
    var myCartViewModel:Chef_MyCartViewModel!
    var emptyView:EmptyNewAddressView!
    var whichApiToProcess = ""
    var sellerListViewModel:Chef_SellerListViewModel!
    var cartSellerIndex: [Int] = []
    var curSection:Int!
    var proceedToCheckout:Bool = true
    var toUpdateItemQtys = NSMutableArray()
    var toUpdateItemId = NSMutableArray()
    var selectedSupplierId = "";
    var selectedSupplierName = "";
    var itemId:String!
    var totalPriceValue:Double = 0
    var isProceedtoCheckout:Bool = true
    override func viewDidAppear(_ animated: Bool) {
        whichApiToProcess = "sellerList"
        callingHttppApi()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowMultipleSectionsOpen = true
        tableView.register(UINib(nibName: "AccordionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: AccordionHeaderView.kAccordionHeaderViewReuseIdentifier)

        emptyView = EmptyNewAddressView(frame: self.view.frame)
        self.view.addSubview(emptyView)
        emptyView.isHidden = true
        emptyView.emptyImages.image = UIImage(named: "empty_cart")!
        emptyView.addressButton.setTitle(GlobalData.sharedInstance.language(key: "browsecategory"), for: .normal)
        emptyView.labelMessage.text = GlobalData.sharedInstance.language(key: "emptycartmessage")
        emptyView.addressButton.addTarget(self, action: #selector(browseCategory(sender:)), for: .touchUpInside)
        whichApiToProcess = "sellerList"
        self.tableView.separatorColor = UIColor.clear
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier! == "sellerprofile") {
//            let viewController:SellerDetailsViewController = segue.destination as UIViewController as! SellerDetailsViewController
            //viewController.profileUrl = sellerId;
        }else if (segue.identifier! == "productcategory") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryName = String(selectedSupplierName);
            viewController.categoryType = "marketplace";
            viewController.sellerId = String(selectedSupplierId);
        }
    }
    @objc func browseCategory(sender: UIButton){
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController!.selectedIndex = 1
    }
    @IBAction func updateCart(_ sender: UIButton){
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
    func callingHttppApi(){
        if whichApiToProcess == "sellerList" {
            GlobalData.sharedInstance.showLoader()
            self.view.isUserInteractionEnabled = false
            var requstParams = [String:Any]();
            let storeId = defaults.object(forKey: "storeId")
            if(storeId != nil){
                requstParams["storeId"] = storeId
            }
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
           print(defaults.object(forKey: "customerId"))
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/customer/sellerlist", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    print(responseObject)
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        self.sellerListViewModel = Chef_SellerListViewModel(data:dict)
                        print("--------seller List--------")
                        print(self.sellerListViewModel.sellerListModel.count)
//                        self.tableView.delegate = self
//                        self.tableView.dataSource = self
                        self.whichApiToProcess = ""
                        self.callingHttppApi()
                        
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                    
                    //GlobalData.sharedInstance.dismissLoader()
                    print("dsd", responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
        else if self.whichApiToProcess == "updatecart"{
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
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/checkout/updateCart", currentView: self){success,responseObject in
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
                    else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict.object(forKey: "message") as! String)
                    }
                    
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    self.whichApiToProcess = "sellerList"
                    self.callingHttppApi()
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        } else if self.whichApiToProcess == "removeitem"{
            GlobalData.sharedInstance.showLoader()
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
            if self.defaults.object(forKey: "currency") != nil{
                requstParams["currency"] = self.defaults.object(forKey: "currency") as! String
            }
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
                    self.whichApiToProcess = "sellerList"
                    self.callingHttppApi()
                }else if success == 2{
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        }
        else {
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
            if self.defaults.object(forKey: "currency") != nil{
                requstParams["currency"] = self.defaults.object(forKey: "currency") as! String
            }
            GlobalData.sharedInstance.showLoader()
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/checkout/cartDetails", currentView: self){success,responseObject in
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
            self.cartSellerIndex = []
            var minorderQty:Int = 0
            var tierSum:Double = 0.0
            var originalSum:Double = 0.0
            print("cart COUNT !!!!!!!!!!!", self.myCartViewModel.getCartItems.count)
            if self.myCartViewModel.getCartItems.count > 0 {

                for i in 0...self.sellerListViewModel.sellerListModel.count - 1 {
                    minorderQty = 0
                    tierSum = 0.0
                    originalSum = 0.0
                    for j in 0...self.myCartViewModel.getCartItems.count - 1 {
                        print("seller id~~~",self.sellerListViewModel.sellerListModel[i].sellerId)
                        
                        if self.sellerListViewModel.sellerListModel[i].sellerId == self.myCartViewModel.myCartModel[j].supplierId  {
                            print("supplier Id~~~~",self.myCartViewModel.myCartModel[j].supplierId)
                            self.sellerListViewModel.sellerListModel[i].cartItemCount = self.sellerListViewModel.sellerListModel[i].cartItemCount + 1
                            self.sellerListViewModel.sellerListModel[i].cartItemIndex.append(j)
                            if minorderQty < self.myCartViewModel.myCartModel[j].moq {
                                minorderQty = self.myCartViewModel.myCartModel[j].moq
                            }
                            if self.myCartViewModel.myCartModel[j].tier_price != 0 {
                            tierSum = tierSum + self.myCartViewModel.myCartModel[j].tier_price
                            originalSum = originalSum + self.myCartViewModel.myCartModel[j].priceint
                            }
                        }
                    }
                    if self.sellerListViewModel.sellerListModel[i].cartItemCount > 0 {
                        print("sellerList CartItem Count~~~~",self.sellerListViewModel.sellerListModel[i].cartItemCount)
                        if tierSum > 0 { self.sellerListViewModel.sellerListModel[i].discountLevel = tierSum/originalSum
                        
                        }
                        else
                        {
                            self.sellerListViewModel.sellerListModel[i].discountLevel = 0
                        }
                       print("DISCOUNT LEVEL", self.sellerListViewModel.sellerListModel[i].discountLevel)
                        self.sellerListViewModel.sellerListModel[i].minorderQty = String(minorderQty)
                        self.cartSellerIndex.append(i)
                    }
                }
                
                self.emptyView.isHidden = true
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.totalPrice.text = "Total : \(String(self.myCartViewModel.getExtraCartData.grandValue))"
                badge = String(self.myCartViewModel.getExtraCartData.cartCount)
                //self.tabBarController!.tabBar.items?[3].badgeValue = String(self.myCartViewModel.getExtraCartData.cartCount)
            }else{
                self.tableView.isHidden = true
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
    @IBAction func proceedToCheckOut(_ sender: UIButton){
        
        //check for minimum order
        badge = nil;
        if myCartViewModel.myCartExtraData.grandUnformatedValue < myCartViewModel.myCartExtraData.minimumAmount || !isProceedtoCheckout {
            GlobalData.sharedInstance.showWarningSnackBar(msg: "Please Order over minimum order amonut")
        }else{
            let customerId = defaults.object(forKey:"customerId")
            if customerId != nil{
                self.performSegue(withIdentifier: "proceedtocheckout", sender: self)
            }else{
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//                let Create = UIAlertAction(title: GlobalData.sharedInstance.language(key: "checkoutasguest"), style: .default, handler: checkOutAsGuest)
//                let guest = UIAlertAction(title: GlobalData.sharedInstance.language(key: "registerandcheckout"), style: .default, handler: registerAndCheckOut)
//                let Existing = UIAlertAction(title: GlobalData.sharedInstance.language(key: "checkoutasexistingcustomer"), style: .default, handler: existingUser)
//                let cancel = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .cancel, handler: cancelDeletePlanet)
                
                if self.myCartViewModel.getExtraCartData.isVirtual == 0 && myCartViewModel.myCartExtraData.isAllowedGuestCheckout    {
                    //alert.addAction(Create)
                }
                
//                alert.addAction(guest)
//                alert.addAction(Existing)
//                alert.addAction(cancel)
                
                // Support display in iPad
                alert.popoverPresentationController?.sourceView = self.view
                alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}


// MARK: - Extra Overrides -

extension Chef_SuperCart {
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

// MARK: - Helpers

func randomString() -> String {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let numberOfLetters = UInt32(letters.length)
    let stringLength = arc4random_uniform(200)
    var randomString = ""
    for _ in 0 ..< stringLength {
        let rand = max(1, arc4random_uniform(numberOfLetters))
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
}

// MARK: - <UITableViewDataSource> / <UITableViewDelegate> -

extension Chef_SuperCart : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows in section")
        print(self.sellerListViewModel.sellerListModel[cartSellerIndex[section]].cartItemCount)
        return self.sellerListViewModel.sellerListModel[cartSellerIndex[section]].cartItemCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("Number of section")
        print(cartSellerIndex.count)
        return cartSellerIndex.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AccordionHeaderView.kDefaultAccordionHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.tableView(tableView, heightForHeaderInSection:section)
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
       
        let currentCell = tableView.cellForRow(at: indexPath) as! Chef_SuperCartCell
        UIView.animate(withDuration: 0.5, delay: 0, options: .layoutSubviews, animations: {
           currentCell.deleteButton.isHidden = !currentCell.deleteButton.isHidden
            currentCell.qtyView.isHidden = !currentCell.qtyView.isHidden
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Chef_SuperCart.kTableViewCellReuseIdentifier, for: indexPath) as! Chef_SuperCartCell
        print(Chef_SuperCart.kTableViewCellReuseIdentifier)
        print("row numbers in section")
        print(indexPath.row)
        cell.selectionStyle = .none
        let CartIndex = self.sellerListViewModel.sellerListModel[curSection].cartItemIndex[indexPath.row]
        var totalValue:Double = 0
        cell.titleLabel.text = self.myCartViewModel.myCartModel[CartIndex].name
        if self.myCartViewModel.myCartModel[CartIndex].tierSubtotal != ""{
            
            let attributedString = NSMutableAttributedString(string:( self.myCartViewModel.myCartModel[CartIndex].subtotal ))
            attributedString.addAttribute(NSAttributedStringKey.baselineOffset, value: 0, range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.styleThick.rawValue), range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSAttributedStringKey.strikethroughColor, value: UIColor.gray, range: NSMakeRange(0, attributedString.length))
            
            cell.pricewithsub.attributedText = attributedString
            //cell.pricewithsub.text = self.myCartViewModel.myCartModel[CartIndex].subtotal
            cell.subtotal.text = "Total \(self.myCartViewModel.myCartModel[CartIndex].subtotal.prefix(1))\(self.myCartViewModel.myCartModel[CartIndex].tierSubtotal)"
            totalValue = (self.myCartViewModel.myCartModel[CartIndex].qty as NSString).doubleValue * self.myCartViewModel.myCartModel[CartIndex].tier_price
        }
        else {
            cell.pricewithsub.isHidden = true
            cell.subtotal.text = "Total \(String(self.myCartViewModel.myCartModel[CartIndex].subtotal))"
            totalValue = (self.myCartViewModel.myCartModel[CartIndex].qty as NSString).doubleValue * self.myCartViewModel.myCartModel[CartIndex].priceint
        }
        var unit:String = ""
        if self.myCartViewModel.myCartModel[CartIndex].unitString != " " && self.myCartViewModel.myCartModel[CartIndex].unitString != ""{
            unit = "/\(String(self.myCartViewModel.myCartModel[CartIndex].unitString))"
        }
        
        cell.priceLabel.text = "\(String(self.myCartViewModel.myCartModel[CartIndex].price))\(String(unit)) - \(String(self.myCartViewModel.myCartModel[CartIndex].taxClass))"
        let moqValue:Double = self.myCartViewModel.myCartModel[CartIndex].priceint * Double(self.myCartViewModel.myCartModel[CartIndex].moq)
        if moqValue > totalValue {
            cell.moqbtn.setTitle("MOQ \(String(self.myCartViewModel.myCartModel[CartIndex].price.prefix(1)))\(String(moqValue))-Total Cost:\(String(self.myCartViewModel.myCartModel[CartIndex].price.prefix(1)))\(String(totalValue)) Please add more to basket", for: .normal)
            cell.moqbtn.setTitleColor(UIColor.red, for: .normal)
            cell.moqbtn.layer.borderColor = UIColor.red.cgColor
            proceedToCheckout = false
        }else {
            cell.moqbtn.setTitle(" MOQ \(String(self.myCartViewModel.myCartModel[CartIndex].price.prefix(1)))\(String(moqValue)) ", for: .normal)
        }
        cell.supplierName.text = self.sellerListViewModel.sellerListModel[curSection].shopTitle
        cell.qtyButton.setTitle(self.myCartViewModel.myCartModel[CartIndex].qty, for: .normal)
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: myCartViewModel.getCartItems[CartIndex].imageUrl, imageView: cell.productImage)
        print(self.myCartViewModel.myCartModel[CartIndex].name)
        cell.plusButton.tag = CartIndex
        cell.plusButton.addTarget(self, action: #selector(plusButtonClick(sender:)), for: .touchUpInside)
        cell.ratingStarView.value = CGFloat(self.myCartViewModel.myCartModel[CartIndex].rating)
        cell.reviewLabel.text = "\(String(self.myCartViewModel.myCartModel[CartIndex].reviewCount)) reviews"
        cell.ratingStar.setTitle("\(String(self.myCartViewModel.myCartModel[CartIndex].rating))", for: .normal)
        cell.minusButton.tag = CartIndex
        cell.minusButton.addTarget(self, action: #selector(minusButtonClick(sender:)), for: .touchUpInside)
        cell.deleteButton.tag = CartIndex
        cell.deleteButton.addTarget(self, action: #selector(removeCartItem(sender:)), for: .touchUpInside)
        if myCartViewModel.getCartItems[CartIndex].message.count > 0{
            var dict:JSON = myCartViewModel.getCartItems[CartIndex].message;
            if dict["type"].stringValue == "error"{
                cell.errorMsg.isHidden = false;
                proceedToCheckout = false;
                cell.errorMsg.text = dict["text"].stringValue
            }
        }else{
            cell.errorMsg.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AccordionHeaderView.kAccordionHeaderViewReuseIdentifier)! as! AccordionHeaderView
            print("Section")
            print(section)
        headerView.viewAllButton.tag = cartSellerIndex[section]
        headerView.supplierName.setTitle(self.sellerListViewModel.sellerListModel[cartSellerIndex[section]].shopTitle, for: .normal)
        headerView.viewAllButton.addTarget(self, action: #selector(browseCatalogBtnClk(sender:)), for: .touchUpInside)
        headerView.discountProgressView.progress = Float(self.sellerListViewModel.sellerListModel[cartSellerIndex[section]].discountLevel)
        headerView.discountPercent.text = "\(String(Double(round(100*self.sellerListViewModel.sellerListModel[cartSellerIndex[section]].discountLevel * 100)/100))) % Discount Level"
        Double(round(100*self.sellerListViewModel.sellerListModel[cartSellerIndex[section]].discountLevel * 100)/100)
        headerView.moqLabel.isHidden = true
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: self.sellerListViewModel.sellerListModel[cartSellerIndex[section]].logo, imageView: headerView.supplierImage)
        return headerView
    }
    @objc func browseCatalogBtnClk(sender: UIButton){
        self.selectedSupplierName = String(self.sellerListViewModel.sellerListModel[sender.tag].shopTitle);
        self.selectedSupplierId = self.sellerListViewModel.sellerListModel[sender.tag].sellerId;
        self.performSegue( withIdentifier: "productcategory", sender: self)
        
    }
    @objc func plusButtonClick(sender: UIButton){
        let qty:String = String(Int(self.myCartViewModel.myCartModel[sender.tag].qty)! + 1)
        self.myCartViewModel.setQtyDataToCartModel(data: qty,pos: sender.tag)
        self.tableView.reloadData()
    }
    @objc func removeCartItem(sender: UIButton){
        self.itemId = self.myCartViewModel.myCartModel[sender.tag].id
        whichApiToProcess = "removeitem"
        callingHttppApi()
        self.tableView.reloadData()
    }
    @objc func minusButtonClick(sender: UIButton){
        if Int(self.myCartViewModel.myCartModel[sender.tag].qty) == 0 {
            return
        }
        let qty:String = String(Int(self.myCartViewModel.myCartModel[sender.tag].qty)! - 1)
        self.myCartViewModel.setQtyDataToCartModel(data: qty,pos: sender.tag)
        self.tableView.reloadData()
    }
}


// MARK: - <FZAccordionTableViewDelegate> -

extension Chef_SuperCart : FZAccordionTableViewDelegate {
    
    func tableView(_ tableView: FZAccordionTableView, willOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        print("Selected Section Num:")
        print(section)
        self.curSection = cartSellerIndex[section]
        
    }
    
    func tableView(_ tableView: FZAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
    func tableView(_ tableView: FZAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
    func tableView(_ tableView: FZAccordionTableView, didCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
    func tableView(_ tableView: FZAccordionTableView, canInteractWithHeaderAtSection section: Int) -> Bool {
        return true
    }
}
