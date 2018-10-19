//
//  CompareListViewController.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 25/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CompareListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard
    var compareListViewModel:CompareListViewModel!
    var storedOffsets = [Int: CGFloat]()
    var compareHomeDataArray:NSMutableArray = []
    var maxLayout:CGFloat = 50
    var productId:String = ""
    var whichApiToProcess:String = ""
    var productName:String = ""
    var imageUrl:String = ""
    var productstoadd:[String] = []
    var qtys:[String] = []
    //@IBOutlet weak var promotioncode: UITextField!
    @IBOutlet weak var emptyCompareLabel: UILabel!
    @IBOutlet weak var table_height: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GlobalData.sharedInstance.removePreviousNetworkCall()
        GlobalData.sharedInstance.dismissLoader()
        tableView.register(UINib(nibName: "Chef_CompareCell", bundle: nil), forCellReuseIdentifier: "chef_compare")
        callingHttppApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.isMovingToParentViewController{
        }else{
            print("clear all previous")
            GlobalData.sharedInstance.removePreviousNetworkCall()
            GlobalData.sharedInstance.dismissLoader()
        }
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "comparelist")
    }
    
    func callingHttppApi(){
        var requstParams = [String:Any]()
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        if defaults.object(forKey:"storeId") != nil{
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        }
        if defaults.object(forKey: "customerId") != nil{
            requstParams["customerToken"] = defaults.object(forKey: "customerId") as! String
        }
        if defaults.object(forKey: "currency") != nil{
            requstParams["currency"] = defaults.object(forKey: "currency") as! String
        }
        
        if whichApiToProcess == "remove"{
            requstParams["productId"] = self.productId
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/removefromcompare", currentView: self){success,responseObject in
                if success == 1{
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let dict = responseObject as! NSDictionary
                    let error:Bool = dict.object(forKey: "success") as! Bool
                    if error == true{
                        let AC = UIAlertController(title: nil, message: (dict.object(forKey: "message") as! String), preferredStyle: .alert)
                        let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        })
                        AC.addAction(noBtn)
                        self.present(AC, animated: true, completion: { })
                        self.whichApiToProcess = ""
                        self.callingHttppApi()
                    }
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else if whichApiToProcess == "wishlist"{
            requstParams["productId"] = productId
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/addtoWishlist", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    if errorCode == true{
                        let AC = UIAlertController(title: nil, message: GlobalData.sharedInstance.language(key: "movedtowishlist"), preferredStyle: .alert)
                        let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        })
                        AC.addAction(noBtn)
                        self.present(AC, animated: true, completion: {  })
                    }
                    else{
                        let AC = UIAlertController(title: nil, message: GlobalData.sharedInstance.language(key: "notmovedtowishlist"), preferredStyle: .alert)
                        let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        })
                        AC.addAction(noBtn)
                        self.present(AC, animated: true, completion: {  })
                    }
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else if whichApiToProcess == "addtocart"{
            requstParams["qty"] = "1"
            requstParams["productId"] = productId
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/checkout/massaddtoCart", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    if responseObject?.object(forKey: "defaultCurrency") != nil{
                        self.defaults .set(responseObject!.object(forKey: "defaultCurrency") as! String, forKey: "currency")
                    }
                    
                    
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    GlobalData.sharedInstance.dismissLoader()
                    if data.object(forKey: "quoteId") != nil{
                        let quoteId:String = String(format: "%@", data.object(forKey: "quoteId") as! CVarArg)
                        if quoteId != "0"{
                            self.defaults .set(quoteId, forKey: "quoteId")
                        }
                    }
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    if errorCode == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg:data .object(forKey:"message") as! String )
                        self.tabBarController!.tabBar.items?[3].badgeValue = String(data.object(forKey: "cartCount") as! Int)
                    }
                    else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: data .object(forKey:"message") as! String)
                    }
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else{
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/catalog/comparelist", currentView: self){success,responseObject in
                if success == 1{
                    GlobalData.sharedInstance.dismissLoader()
                    self.compareListViewModel = CompareListViewModel(data:JSON(responseObject as! NSDictionary))
                    print(responseObject)
                    self.view.isUserInteractionEnabled = true
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
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            self.compareHomeDataArray = [self.compareListViewModel.getProductList]
            print("ssss",self.compareHomeDataArray.count)
            print("pppp",self.compareListViewModel.getProductList.count)
            
            if self.compareListViewModel.getProductList.count > 0 {
                self.tableView.isHidden = false
                //self.emptyCompareLabel.isHidden = true
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }else {
                self.tableView.isHidden = true
//                self.emptyCompareLabel.isHidden = false
//                self.emptyCompareLabel.text = GlobalData.sharedInstance.language(key: "emptycomparelist")
            }
        }
    }

    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1// + self.compareListViewModel.getAttributesValue.count
        //return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.compareListViewModel.getProductList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //if section == 0{
            return GlobalData.sharedInstance.language(key: "product")
        //}else{
        //    return compareListViewModel.getAttributsName[section - 1].attributesName
        //}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let CellIdentifier: String = "cell"
//        let cell:CompareListTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! CompareListTableViewCell
        let cell:Chef_CompareCell = tableView.dequeueReusableCell(withIdentifier: "chef_compare") as! Chef_CompareCell
        cell.price.text = self.compareListViewModel.getProductList[indexPath.row].price
        cell.productname.text = self.compareListViewModel.getProductList[indexPath.row].productName
        cell.starRating.value = self.compareListViewModel.getProductList[indexPath.row].rating
        cell.rating.setTitle(String(format:"%f",self.compareListViewModel.getProductList[indexPath.row].rating), for: .normal)
        cell.supplierName.text = self.compareListViewModel.getProductList[indexPath.row].supplierName
        cell.reviewCount.text = "\(String(self.compareListViewModel.getProductList[indexPath.row].reviewCount)) reviews"
        
        cell.checkBtn.addTarget(self, action: #selector(addToCart(sender:)), for: .touchUpInside)
        
        //cell.Totalprice.text = self.compareListViewModel.getProductList[indexPath.row].price *
        cell.price.text = self.compareListViewModel.getProductList[indexPath.row].price
        cell.pricevat.text = "\(String(self.compareListViewModel.getProductList[indexPath.row].price)) - \(String(self.compareListViewModel.getProductList[indexPath.row].taxClass))"
//        cell.plusButton.addTarget(self, action: #selector(plusButtonClick(sender:)), for: .touchUpInside)
//        cell.minusButton.addTarget(self, action: #selector(minusButtonClick(sender:)), for: .touchUpInside)
        
        //if indexPath.section == 0{
            /*cell.collectionView.register(UINib(nibName: "CompareProductCollectionView", bundle: nil), forCellWithReuseIdentifier: "compareproduct")
            
            cell.collectionView.tag = (1 * indexPath.section) + 1
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
            cell.collectionViewOffset = storedOffsets[indexPath.section] ?? 0*/
        /*}else{
            cell.collectionView.register(UINib(nibName: "CompareProductAttributeValueCollectionView", bundle: nil), forCellWithReuseIdentifier: "compareproductValue")
            cell.collectionView.tag = (1 * indexPath.section) + 1
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
            cell.collectionViewOffset = storedOffsets[indexPath.section] ?? 0
        }*/
        
        //self.table_height.constant = self.tableView.contentSize.height
        //cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //if indexPath.section == 0{
            //return CGFloat(self.compareListViewModel.getProductList.count) * SCREEN_WIDTH/2.5 + 100
        return 120

        /*}else{
            let dd  = compareListViewModel.getAttributesValue[indexPath.section - 1].attributesValueArray
            maxLayout = 50
            for i in 0  ..< Int((dd?.count)!){
                let actualString:String = dd?[i] as! String
                let actualHeight = actualString.height(withConstrainedWidth:SCREEN_WIDTH/2.5 + 10 , font: UIFont.systemFont(ofSize: 12.0))
                if actualHeight > maxLayout{
                    maxLayout = actualHeight
                }
            }
            return maxLayout + 20
        }*/
        
    }
    
    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for i in 0..<(compareHomeDataArray.count + self.compareListViewModel.getAttributesValue.count) {
            let cell2 = self.view.viewWithTag((1 * i) + 1) as? UICollectionView
            
            if cell2 != nil {
                if scrollView.contentOffset.y == 0{
                    cell2!.contentOffset = scrollView.contentOffset
                }
            }
        }
    }*/
//    @objc func plusButtonClick(sender: UIButton){
//        
//    }
//    @objc func minusButtonClick(sender: UIButton){
//        
//    }
    @objc func deleteCompare(sender: UIButton){
        let dd:[ComapreListModel] = compareHomeDataArray[0] as! [ComapreListModel]
        whichApiToProcess = "remove"
        self.productId = dd[sender.tag].productId
        self.callingHttppApi()
    }
    
    @objc func addToWishList(sender: UIButton){
        let customerId = defaults.object(forKey: "customerId")
        if(customerId == nil){
            let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "warning"), message: GlobalData.sharedInstance.language(key: "loginrequired"), preferredStyle: .alert)
            let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
            })
            
            AC.addAction(okBtn)
            self.present(AC, animated: true, completion: {  })
        }else{
            
            let dd:[ComapreListModel] = compareHomeDataArray[0] as! [ComapreListModel]
            whichApiToProcess = "wishlist"
            self.productId = dd[sender.tag].productId
            self.callingHttppApi()
        }
    }
    @IBAction func proceedToCheckOut(_ sender: UIButton)
    {
        for i in 0..<self.compareListViewModel.getProductList.count{
            if self.compareListViewModel.getProductList[i].checked == true {
                self.productstoadd.append(self.compareListViewModel.getProductList[i].productId)
                self.qtys.append(self.compareListViewModel.getProductList[i].qty)
                print("------COMPARED PRODUCTS TO MASS ADD TO CART------")
                print(self.productstoadd)
                print(self.qtys)
                print("------COMPARED PRODUCTS TO MASS ADD TO CART------")
            }
        }
    }
    @objc func addToCart(sender: UIButton){
        let dd:[ComapreListModel] = compareHomeDataArray[0] as! [ComapreListModel]
        if UIImage(named: "ic_unchecked") == sender.image(for: .normal) {
            sender.setImage(UIImage(named: "ic_checked"), for: .normal)
        self.compareListViewModel.setCheck(checked:true,pos:sender.tag)
        }
        else {
            sender.setImage(UIImage(named: "ic_unchecked"), for: .normal)
            self.compareListViewModel.setCheck(checked:false,pos:sender.tag)
        }
        
      
    }
}

extension CompareListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //if collectionView.tag == 1{
        return 0
//            let dd:[ComapreListModel] = compareHomeDataArray[collectionView.tag - 1] as! [ComapreListModel]
//            return dd.count
        //return 1
       /* }else {
            let dd  = compareListViewModel.getAttributesValue[collectionView.tag - 2].attributesValueArray
            return (dd?.count)!
        }*/
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
       // if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "compareproduct", for: indexPath) as! CompareProductCollectionView
            /*let dd:[ComapreListModel] = compareHomeDataArray[collectionView.tag - 1] as! [ComapreListModel]
            cell.productName.text = dd[indexPath.row].productName
            cell.priceValue.text = dd[indexPath.row].price
            cell.ratingValue.value = dd[indexPath.row].rating
            
            if dd[indexPath.row].isInWishlist == true{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill"), for: .normal)
            }else{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_empty"), for: .normal)
            }
            
            
            GlobalData.sharedInstance.getImageFromUrl(imageUrl: dd[indexPath.row].imageUrl, imageView: cell.imageViewData)
            cell.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
            cell.layer.borderWidth = 0.5
            cell.backgroundColor = UIColor.white
            
            cell.deleteButton.addTarget(self, action: #selector(CompareListViewController.deleteCompare(sender:)), for: .touchUpInside)
            cell.deleteButton.isUserInteractionEnabled = true
            cell.deleteButton.tag = indexPath.row
            
            cell.wishListButton.addTarget(self, action: #selector(CompareListViewController.addToWishList(sender:)), for: .touchUpInside)
            cell.wishListButton.isUserInteractionEnabled = true
            cell.wishListButton.tag = indexPath.row
            
            
            cell.addToCartButton.addTarget(self, action: #selector(CompareListViewController.addToCart(sender:)), for: .touchUpInside)
            cell.addToCartButton.isUserInteractionEnabled = true
            cell.addToCartButton.tag = indexPath.row
            
            if dd[indexPath.row].hasOption == 1{
                cell.addToCartButton.isHidden = true
            }
            cell.layoutIfNeeded()*/
        
            return cell
        /*}else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "compareproductValue", for: indexPath) as! CompareProductAttributeValueCollectionView
            cell.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
            cell.layer.borderWidth = 0.5
            let dd:Array  = compareListViewModel.getAttributesValue[collectionView.tag - 2].attributesValueArray
            cell.value.text = (dd[indexPath.row] as? String)?.html2String
            return cell
        }*/
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dd:[ComapreListModel] = compareHomeDataArray[0] as! [ComapreListModel]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chef_productdetail") as! Chef_DashboardViewController
        vc.productImageUrl = dd[indexPath.row].imageUrl
        vc.productName = dd[indexPath.row].productName
        vc.productId = dd[indexPath.row].productId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CompareListViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //if collectionView.tag == 1{
            return CGSize(width: SCREEN_WIDTH - 50, height:SCREEN_WIDTH/2.5)
        /*}else{
            return CGSize(width: SCREEN_WIDTH/2.5 + 10, height:maxLayout)
        }*/
    }
    
    
    /*func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }*/
}
