//
//  MyWishList.swift
//  DummySwift
//
//  Created by Webkul on 23/11/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit

class MyWishList: UIViewController,UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate{
    
    @IBOutlet weak var myWishLIstTableView: UITableView!
    @IBOutlet weak var massUpdate: UIButton!
    
    var myWishlistModelData = [MyWishlistModel]()
    
    var totalCount : Int = 0
    var whichApiDataToprocess: String = ""
    var pageNumber:Int = 0
    var indexPathValue:IndexPath!
    var itemId:String!
    var imageCache = NSCache<AnyObject, AnyObject>()
    let defaults = UserDefaults.standard
    var massUpdateWhishList = [Any]()
    var qtyValue:String!
    var productId:String!
    var keyBoardFlag:Int = 1
    var emptyWishListView:UIView!
    var productImageUrl:String = ""
    var productName:String = ""
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = GlobalData.sharedInstance.language(key: "mywishlist")
        
        self.navigationController?.isNavigationBarHidden = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyWishList.dismissKeyboard))
        myWishLIstTableView.addGestureRecognizer(tap)
        
        myWishLIstTableView.rowHeight = UITableViewAutomaticDimension
        myWishLIstTableView.estimatedRowHeight = 200
        
        GlobalData.sharedInstance.dismissLoader()
        GlobalData.sharedInstance.removePreviousNetworkCall()
        whichApiDataToprocess = " "
        pageNumber = 1
        callingHttppApi()
        
        massUpdate.setTitle(GlobalData.sharedInstance.language(key: "massupdate"), for: .normal)
        massUpdate.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        massUpdate.isHidden = true
        
        emptyWishListView = UIView(frame: CGRect(x:0, y: SCREEN_HEIGHT/2 - 160 , width: SCREEN_WIDTH, height: 170))
        self.view.addSubview(emptyWishListView)
        let cartImage = UIImageView(frame: CGRect(x:SCREEN_WIDTH/2-60, y:0, width:120, height: 120))
        cartImage.image = UIImage(named: "empty_wishlist_view")
        emptyWishListView.addSubview(cartImage)
        let emptyLabel = UILabel(frame: CGRect(x:0, y: 120, width: SCREEN_WIDTH, height: 13))
        emptyLabel.textColor = UIColor.red
        emptyLabel.text = "nowishlist".localized
        emptyLabel.font = UIFont(name: "Helvetica-Bold", size: 13.0)
        emptyLabel.textAlignment = .center
        emptyWishListView.addSubview(emptyLabel)
        emptyWishListView.isHidden = true
        
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "refreshing".localized, attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            myWishLIstTableView.refreshControl = refreshControl
        }else {
            myWishLIstTableView.backgroundView = refreshControl
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK:- Pull to refresh
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        whichApiDataToprocess = " "
        pageNumber = 1
        callingHttppApi()
        refreshControl.endRefreshing()
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    @objc func openProduct(_ sender:UITapGestureRecognizer){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productImageUrl = myWishlistModelData[(sender.view?.tag)!].thumbNail
        vc.productId = myWishlistModelData[(sender.view?.tag)!].productId
        vc.productName = myWishlistModelData[(sender.view?.tag)!].name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Call API
    
    func callingHttppApi(){
        if whichApiDataToprocess == "massUpdateWishList"{
            self.view.isUserInteractionEnabled = false
            GlobalData.sharedInstance.showLoader()
            var requstParams = [String:Any]()
            do {
                let jsonSortData =  try JSONSerialization.data(withJSONObject:massUpdateWhishList , options: .prettyPrinted)
                let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["itemData"] = jsonSortString
            }catch {
                print(error.localizedDescription)
            }
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/updatewishList", currentView: self){success,responseObject in
                if success == 1{
                    
                    self.view.isUserInteractionEnabled = true
                    self.doFurtherProcessingWithResult(data: (responseObject as! NSDictionary))
                }else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }else if whichApiDataToprocess == "myWhishListAddToCart"{
            GlobalData.sharedInstance.showLoader()
            self.view.isUserInteractionEnabled = false
            var requstParams = [String:Any]()
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            requstParams["qty"] = qtyValue
            requstParams["productId"] = productId
            requstParams["itemId"] = itemId
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/wishlisttoCart", currentView: self){success,responseObject in
                if success == 1{
                    
                    self.view.isUserInteractionEnabled = true
                    self.doFurtherProcessingWithResult(data: (responseObject as! NSDictionary))
                }
                else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }else if whichApiDataToprocess == "removeDataWishList"{
            GlobalData.sharedInstance.showLoader()
            self.view.isUserInteractionEnabled = false
            var requstParams = [String:Any]()
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            requstParams["itemId"] = itemId
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/removefromWishlist", currentView: self){success,responseObject in
                if success == 1{
                    
                    print(responseObject)
                    self.view.isUserInteractionEnabled = true
                    self.doFurtherProcessingWithResult(data: (responseObject as! NSDictionary))
                }else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }else{
            if pageNumber == 1{
                self.view.isUserInteractionEnabled = false
                GlobalData.sharedInstance.showLoader()
            }
            
            var requstParams = [String:Any]()
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["pageNumber"] =  "\(pageNumber)"
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/wishList", currentView: self){success,responseObject in
                if success == 1{
                    print(responseObject)
                    self.view.isUserInteractionEnabled = true
                    self.doFurtherProcessingWithResult(data: (responseObject as! NSDictionary))
                }else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data :NSDictionary){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            GlobalData.sharedInstance.dismissLoader()
            if (self.whichApiDataToprocess == "massUpdateWishList"){
                let errorCode: Bool = data .object(forKey:"success") as! Bool
                if errorCode == true{
                    GlobalData.sharedInstance.showSuccessSnackBar(msg:"wishlistupdatedsuccessfully".localized)
                    self.pageNumber = 1
                    self.whichApiDataToprocess = ""
                    self.callingHttppApi()
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg:data .object(forKey:"message") as! String)
                }
            }else if(self.whichApiDataToprocess == "myWhishListAddToCart"){
                let jsonData = JSON(data)
                let errorCode: Bool = data .object(forKey:"success") as! Bool
                if errorCode == true{
                    let AC = UIAlertController(title: nil, message: (data.object(forKey: "message") as! String), preferredStyle: .alert)
                    let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    })
                    AC.addAction(noBtn)
                    self.present(AC, animated: true, completion: { })
                    
                    self.tabBarController!.tabBar.items?[3].badgeValue = "\(jsonData["cartCount"])"
                    self.pageNumber = 1
                    self.whichApiDataToprocess = ""
                    self.callingHttppApi()
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg:data .object(forKey:"message") as! String)
                }
            }else if(self.whichApiDataToprocess == "removeDataWishList"){
                let errorCode = data .object(forKey:"success") as! Bool
                if errorCode == true{
                    let AC = UIAlertController(title: nil, message: (data.object(forKey: "message") as! String), preferredStyle: .alert)
                    let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    })
                    AC.addAction(noBtn)
                    self.present(AC, animated: true, completion: { })
                    self.pageNumber = 1
                    self.whichApiDataToprocess = ""
                    self.callingHttppApi()
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg:data .object(forKey:"message") as! String)
                }
            }else{
                if self.pageNumber == 1{
                    self.myWishlistModelData = [MyWishlistModel]()
                }
                
                var wishlistData = [MyWishlistModel]()
                if let data = JSON(data.object(forKey: "wishList")!).arrayObject {
                    wishlistData = data.map({(val) -> MyWishlistModel in
                        return MyWishlistModel(data: JSON(val))
                    })
                }
                
                for i in 0..<wishlistData.count {
                    self.myWishlistModelData.append(wishlistData[i])
                }
                
                self.totalCount = (data .object(forKey: "totalCount") as? Int)!
                
                self.myWishLIstTableView.reloadData()
                
                if self.myWishlistModelData.count == 0{
                    self.emptyWishListView.isHidden = false
                }
            }
        }
    }
    
    //MARK:- UITableViewDataSource and UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if myWishlistModelData.count > 0 {
            massUpdate.isHidden = false
            self.view.backgroundColor = UIColor.groupTableViewBackground
        }else{
            massUpdate.isHidden = true
            self.view.backgroundColor = UIColor.white
        }
        
        return myWishlistModelData.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let addToCart = UITableViewRowAction(style: .normal, title: GlobalData.sharedInstance.language(key: "addtocart")) { action, index in
            self.itemId = self.myWishlistModelData[indexPath.row].id
            let qty:UITextField = self.view .viewWithTag(2000 + indexPath.row) as! UITextField
            self.qtyValue = qty.text
            self.productId = self.myWishlistModelData[indexPath.row].productId
            
            if self.myWishlistModelData[indexPath.row].typeId == "configurable" || self.myWishlistModelData[indexPath.row].typeId == "bundle" || self.myWishlistModelData[indexPath.row].typeId == "grouped" {
                //contains options
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
                vc.productImageUrl = self.myWishlistModelData[indexPath.row].thumbNail
                vc.productId = self.myWishlistModelData[indexPath.row].productId
                vc.productName = self.myWishlistModelData[indexPath.row].name
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.whichApiDataToprocess = "myWhishListAddToCart"
                self.callingHttppApi()
            }
        }
        addToCart.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        let delete = UITableViewRowAction(style: .normal, title: GlobalData.sharedInstance.language(key: "delete")) { action, index in
            
            self.itemId = self.myWishlistModelData[indexPath.row].id
            self.whichApiDataToprocess = "removeDataWishList"
            self.callingHttppApi()
        }
        delete.backgroundColor = UIColor.red
        
        return [delete, addToCart]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        myWishLIstTableView.register(UINib(nibName: "WishListTableViewCell", bundle: nil), forCellReuseIdentifier: "wishListCell")
        let cell:WishListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "wishListCell") as! WishListTableViewCell
        
        cell.productImageView.image = UIImage(named: "ic_placeholder.png")
        cell.productImageView.tag = indexPath.row
        cell.productImageView.isUserInteractionEnabled = true
        let image = (imageCache.object(forKey: NSURL(string:self.myWishlistModelData[indexPath.row].thumbNail)! as URL as AnyObject))
        if (image != nil) {
            cell.productImageView.image = image as! UIImage?
        }else{
            let url = NSURL(string:self.myWishlistModelData[indexPath.row].thumbNail)! as URL
            self.getDataFromUrl(url: url) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() { () -> Void in
                    cell.productImageView.image = UIImage(data: data)
                    self.imageCache.setObject(UIImage(data: data)!, forKey: NSURL(string:self.myWishlistModelData[indexPath.row].thumbNail)! as URL as AnyObject)
                }
            }
        }
        
        let viewProductGesture = UITapGestureRecognizer(target: self, action: #selector(self.openProduct))
        viewProductGesture.numberOfTapsRequired = 1
        cell.productImageView.addGestureRecognizer(viewProductGesture)
        
        cell.productName.textColor = UIColor().HexToColor(hexString: TEXTHEADING_COLOR)
        let ProductNameValue = self.myWishlistModelData[indexPath.row].name
        cell.productName.text = ProductNameValue
        
        let dateData = self.myWishlistModelData[indexPath.row].sku
        cell.skuLabel.text = GlobalData.sharedInstance.language(key: "sku")+" "+dateData
        
        cell.textView.layer.borderColor = UIColor.lightGray.cgColor
        cell.textView.layer.borderWidth = 0.5
        cell.textView.layer.cornerRadius = 6
        cell.textView.text = self.myWishlistModelData[indexPath.row].description
        cell.textView.tag = 1000 + indexPath.row
        
        cell.quantityLabel.text = GlobalData.sharedInstance.language(key: "qty")
        cell.qtyTextField.text = String(self.myWishlistModelData[indexPath.row].qty)
        cell.qtyTextField.tag = 2000 + indexPath.row
        cell.qtyTextField.textAlignment = .center
        
        cell.startRatings.value = CGFloat(self.myWishlistModelData[indexPath.row].rating)
        cell.startRatings.tintColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        cell.startRatings.allowsHalfStars = true
        
        let priceValue = self.myWishlistModelData[indexPath.row].price
        cell.priceLabel.text = GlobalData.sharedInstance.language(key: "price")+" "+priceValue
        
        if indexPath.row == myWishlistModelData.count - 1  && totalCount > myWishlistModelData.count {
            self.pagination()
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //for showing the activity loader
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            // print("this is the last cell")
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.myWishLIstTableView.tableFooterView = spinner
            self.myWishLIstTableView.tableFooterView?.isHidden = false
            
            if self.myWishlistModelData != nil    {
                if totalCount == self.myWishlistModelData.count  {
                    spinner.stopAnimating()
                    self.myWishLIstTableView.tableFooterView = nil
                    self.myWishLIstTableView.tableFooterView?.isHidden = true
                }
            }
        }
    }
    
    //MARK:- Pagination
    func pagination()   {
        whichApiDataToprocess = ""
        pageNumber += 1
        callingHttppApi()
    }
    
    @IBAction func massUpdate(_ sender: UIButton) {
        massUpdateWhishList = [Any]()
        
        for i in 0..<myWishlistModelData.count {
            
            var massUpdate = [String: AnyObject]()
            
            if let qty = self.view.viewWithTag(2000 + i) as? UITextField    {
                massUpdate["qty"] = qty.text as AnyObject?
            }else{
                massUpdate["qty"] = "1" as AnyObject
            }
            
            if let des = self.view .viewWithTag(1000 + i) as? UITextView    {
                if des.text == ""{
                    massUpdate["description"] = " " as AnyObject?
                }else{
                    massUpdate["description"] = des.text as AnyObject?
                }
            }else{
                massUpdate["description"] = " " as AnyObject
            }
            
            massUpdate["id"] = myWishlistModelData[i].id as AnyObject
            massUpdateWhishList.append(massUpdate)
        }
        
        whichApiDataToprocess = "massUpdateWishList"
        callingHttppApi()
    }
}
