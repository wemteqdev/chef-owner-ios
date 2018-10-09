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
    static fileprivate let kTableViewCellReuseIdentifier = "Cell"
    @IBOutlet fileprivate weak var tableView: FZAccordionTableView!
    let defaults = UserDefaults.standard
    var myCartViewModel:Chef_MyCartViewModel!
    var emptyView:EmptyNewAddressView!
    var whichApiToProcess = ""
    var sellerListViewModel:Chef_SellerListViewModel!
    var cartSellerIndex: [Int] = []
    var curSection:Int!
    
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
        callingHttppApi()
    }
    @objc func browseCategory(sender: UIButton){
        //self.tabBarController!.selectedIndex = 1
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
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/sellerlist", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        self.sellerListViewModel = Chef_SellerListViewModel(data:dict)
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                        self.whichApiToProcess = ""
                        self.callingHttppApi()
                        
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                    
                    GlobalData.sharedInstance.dismissLoader()
                    print("dsd", responseObject)
                    
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
            
            if self.myCartViewModel.getCartItems.count > 0 {
                for i in 0...self.sellerListViewModel.sellerListModel.count - 1 {
                    for j in 0...self.myCartViewModel.getCartItems.count - 1 {
                        if self.sellerListViewModel.sellerListModel[i].sellerId == self.myCartViewModel.myCartModel[j].supplierId  {
                            self.sellerListViewModel.sellerListModel[i].cartItemCount = self.sellerListViewModel.sellerListModel[i].cartItemCount + 1
                            self.sellerListViewModel.sellerListModel[i].cartItemIndex.append(j)
                        }
                    }
                    if self.sellerListViewModel.sellerListModel[i].cartItemCount > 0 {
                        self.cartSellerIndex.append(i)
                    }
                }
                
                self.emptyView.isHidden = true
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                self.tableView.isHidden = false
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
        print(self.sellerListViewModel.sellerListModel[section].cartItemCount)
        return self.sellerListViewModel.sellerListModel[section].cartItemCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("Number of section")
        print(cartSellerIndex.count)
        return cartSellerIndex.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Chef_SuperCart.kTableViewCellReuseIdentifier, for: indexPath) as! Chef_SuperCartCell
        print(Chef_SuperCart.kTableViewCellReuseIdentifier)
        print("row numbers in section")
        print(indexPath.row)
        cell.titleLabel.text = self.myCartViewModel.myCartModel[self.sellerListViewModel.sellerListModel[curSection].cartItemIndex[indexPath.row]].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AccordionHeaderView.kAccordionHeaderViewReuseIdentifier)! as! AccordionHeaderView
            print("Section")
            print(section)
        headerView.supplierName.setTitle(self.sellerListViewModel.sellerListModel[cartSellerIndex[section]].shopTitle, for: .normal)

        GlobalData.sharedInstance.getImageFromUrl(imageUrl: self.sellerListViewModel.sellerListModel[cartSellerIndex[section]].logo, imageView: headerView.supplierImage)
        return headerView
    }
}

// MARK: - <FZAccordionTableViewDelegate> -

extension Chef_SuperCart : FZAccordionTableViewDelegate {
    
    func tableView(_ tableView: FZAccordionTableView, willOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        print("Selected Section Num:")
        print(section)
        self.curSection = section
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
