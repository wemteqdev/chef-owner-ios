//
//  Chef_DashboardViewController.swift
//  MobikulMPMagento2
//
//  Created by Othello on 20/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices
import Alamofire

class Chef_DashboardViewController: UIViewController, Chef_DetailReviewHandlerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var isOwnerDetailPage:Bool = false;
    var addShow:Bool = false
    func reviewSubmit(title: String, contentText: String, rating: String) {
        print("REVIEW FROM DETAIL REVIEW COLLECTION CELL !",title,contentText,rating)
        self.reviewTitle = title
        self.reviewContent = contentText
        self.reviewRating = rating
        callingHttppApi(apiName: CatalogProductAPI.addreview)
    }
    func reloadPage() {
        callingHttppApi(apiName: CatalogProductAPI.catalogProduct)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "detail_maintableviewcell") as! MainTableViewCell
        cell.parentController = self
        var gesture = UITapGestureRecognizer(target: self, action:  #selector (self.detailViewClk (_:)))
        cell.detailView.addGestureRecognizer(gesture)
        
        gesture = UITapGestureRecognizer(target: self, action:  #selector (self.reviewViewClk (_:)))
        cell.reviewView.addGestureRecognizer(gesture)
        
        gesture = UITapGestureRecognizer(target: self, action:  #selector (self.compareViewClk (_:)))
        cell.compareView.addGestureRecognizer(gesture)
        if(self.isOwnerDetailPage || compareProductCollectionModel.count == 0){
            cell.compareView.isHidden = true
        }
        else {
            cell.compareView.isHidden = false
        }
        cell.baseCompareView.backgroundColor = UIColor.white
        cell.baseDetailView.backgroundColor = UIColor.white
        cell.baseReviewView.backgroundColor = UIColor.white

        switch currentMainView {
        case 0:
            cell.baseDetailView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
            cell.productDetailCollectionView.register(UINib(nibName: "Chef_DetailCell", bundle: nil), forCellWithReuseIdentifier: "chef_detailcell")
            break
        case 1:
            cell.baseReviewView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
            cell.productDetailCollectionView.register(UINib(nibName: "Chef_ReviewCell", bundle: nil), forCellWithReuseIdentifier: "chef_reviewcell")
            cell.delegate = self
            break
        default:
            cell.baseCompareView.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
            cell.productDetailCollectionView.register(UINib(nibName: "Chef_DetailCompareCell", bundle: nil), forCellWithReuseIdentifier: "chef_dcomparecell")
            break
        }
        cell.currentMainView = currentMainView
        cell.catalogProductViewModel = self.catalogProductViewModel
        cell.compareProductCollectionModel = self.compareProductCollectionModel
        cell.productDetailCollectionView.reloadData()
        cell.productCollectionViewHeight.constant = 100
        print(cell.productCollectionViewHeight.constant)
        print("TABLEVIEWCELL ~~~~~~~~~~~~~~")
        return cell
    }
    @objc func detailViewClk(_ sender:UITapGestureRecognizer){
        currentMainView = 0
        productDetailTableView.reloadData()
    }
    @objc func reviewViewClk(_ sender:UITapGestureRecognizer){
        currentMainView = 1
        productDetailTableView.reloadData()
    }
    @objc func compareViewClk(_ sender:UITapGestureRecognizer){
        currentMainView = 2
        productDetailTableView.reloadData()
    }
    var currentMainView: Int = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var supplierName: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var addCartButton: UIButton!
    @IBOutlet weak var productRate: UILabel!
    @IBOutlet weak var quantitytextField: UILabel!
    @IBOutlet weak var productnameLabel: UILabel!
    @IBOutlet weak var productpriceLabel: UILabel!
    @IBOutlet weak var wishlistBtn: UIButton!
   // @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productRateCount: UILabel!
    @IBOutlet weak var productDetailTableView: UITableView!
    @IBOutlet weak var productStarRating: HCSStarRatingView!
    
    var supplierNameText:String!
    var catalogProductViewModel:CatalogProductViewModel!
    var compareProductCollectionModel = [Products]()
    var productId:String = ""
    var productName:String = ""
    var productImageUrl:String = ""
    let defaults = UserDefaults.standard
    var imageArrayUrl:Array = [String]()
    var configjson:JSON!
    var groupjson:JSON!
    var linkJson:JSON!
    var bundleJson:JSON!
    var customeJson:JSON!
    var mainContainerY :CGFloat = 0
    var bundleCount:Int = 0
    var selectedDownloadableProduct = [String:String]()
    var selectedGroupedProduct = [String:String]()
    var bundlePickerIndex :Int!
    var bundleDisplayData = [Int:NSMutableArray]()
    var bundleSelectedDataWishList = [String:String]()
    var selectedBundleProductQuantity = [String:String]()
    var bundleSelectedData = [String:AnyObject]()
    var customeCollectionDisplayData = [Int:NSMutableArray]()
    var customePickerIndex:Int!
    var selectedCustomeOption = [String:AnyObject]()
    var selectedCustomeOptionWishList = [String:String]()
    var customePickerKeyValue = [Int:NSMutableArray]()
    var timeDict = [String:String]()
    var dateTimeDict = [String:String]()
    var dateDict = [String:String]()
    var childZoomingScrollView, parentZoomingScrollView :UIScrollView!
    var imageview,imageZoom : UIImageView!
    var currentTag:NSInteger = 0
    var pager:UIPageControl!
    var addToCartFrameY:CGFloat = 0
    var customOptionFileDict = [String:Data]()
    var customOptionFileEntry = [String:Bool]()
    var MIMETYPE = [String:String]()
    var keyBoardFlag:Int = 1
    var configurableSelectedData = [String:String]()
    var configurableRelatedProducts = [Int:NSArray]()
    var configurableData = [Int:NSMutableArray]()
    var pickerIndex:Int = 0
    var defaultLaunch:Bool = true
    var goToBagFlag:Bool = false
    var headers: HTTPHeaders = [:]
    var configurableDataImages = [String:Any]()
    var configurableDataIndex : AnyObject!
    var reviewTitle:String!
    var reviewContent:String!
    var reviewRating:String!
    
    func jsonSerializationData(jsonObj : Any) -> String   {
        do {
            let jsonData =  try JSONSerialization.data(withJSONObject: jsonObj, options: .prettyPrinted)
            let jsonString:String = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            return jsonString
        }catch {
            print(error.localizedDescription)
        }
        return ""
    }
    func loadNavgiationButtons() {
        
        let btnCart = SSBadgeButton()
        btnCart.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btnCart.setImage(UIImage(named: "Action 4")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnCart.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 10)
        btnCart.badge = badge
        print("Load Navigation Button Function Badge Value")
        print(badge)
        
        btnCart.addTarget(self, action: #selector(cartButtonClick(sender:)), for: .touchUpInside)
        
        var origImage = UIImage(named: "Action 2")
        var tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        var btnSearch:UIBarButtonItem = UIBarButtonItem(image: tintedImage , style: .plain, target: self, action: #selector(searchButtonClick(sender:)))
        
        btnCart.tintColor = .white
        btnSearch.tintColor = .white
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: btnCart), btnSearch], animated: true)
        
        self.navigationController?.navigationBar.tintColor = .white
 
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productDetailTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "detail_maintableviewcell")
        productDetailTableView.delegate = self
        productDetailTableView.dataSource = self
        self.navigationItem.title = productName
        self.navigationController?.isNavigationBarHidden = false
        loadNavgiationButtons()
        self.collectionView.register(CatalogProductImage.nib, forCellWithReuseIdentifier: CatalogProductImage.identifier)
        scrollView.delegate = self
        collectionViewHeightConstarints.constant = SCREEN_HEIGHT/3
        collectionView.reloadData()
        //GlobalData.sharedInstance.getImageFromUrl(imageUrl:productImageUrl , imageView: self.productImage)
        
        //self.scrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        
        imageArrayUrl = [productImageUrl]
        productnameLabel.text = productName
        GlobalData.sharedInstance.removePreviousNetworkCall()
        GlobalData.sharedInstance.dismissLoader()
        callingHttppApi(apiName: CatalogProductAPI.catalogProduct)
        if addShow {
            addCartButton.isHidden = true
        }
        if(isOwnerDetailPage){
            addCartButton.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func callingHttppApi(apiName : CatalogProductAPI)  {
        
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]()
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        let customerId = defaults.object(forKey: "customerId")
        let quoteId = defaults.object(forKey: "quoteId")
        requstParams["productId"] = productId
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        if quoteId != nil{
            requstParams["quoteId"] = quoteId
        }
        if defaults.object(forKey: "currency") != nil{
            requstParams["currency"] = defaults.object(forKey: "currency") as! String
        }
        
        switch apiName {
        case .addToCart :
            
            var params = [String: AnyObject]()
            
            if(self.configjson["configurableData"]["attributes"].count > 0){
                params["super_attribute"] = configurableSelectedData as AnyObject?
                requstParams["params"] = jsonSerializationData(jsonObj: params)
            }
            
            if(self.groupjson["groupedData"].count > 0){
                params["super_group"] = selectedGroupedProduct as AnyObject?
                requstParams["params"] = jsonSerializationData(jsonObj: params)
            }
            
            if (self.linkJson["links"]["linksPurchasedSeparately"].string == "1") {
                params["links"] = selectedDownloadableProduct as AnyObject?
                requstParams["params"] = jsonSerializationData(jsonObj: params)
            }
            
            if(self.bundleJson["bundleOptions"].count > 0){
                params["bundle_option"] = bundleSelectedData as AnyObject?
                params["bundle_option_qty"] = selectedBundleProductQuantity as AnyObject?
                requstParams["params"] = jsonSerializationData(jsonObj: params)
            }
            
            if(self.customeJson["customOptions"].count > 0){
                params["options"] = selectedCustomeOption as AnyObject
                requstParams["params"] = jsonSerializationData(jsonObj: params)
            }
            
            requstParams["qty"] = quantitytextField.text
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/checkout/addtoCart", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    //self.addToCartIndicator.stopAnimating()
                    GlobalData.sharedInstance.dismissLoader()
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    
                    if data.object(forKey: "quoteId") != nil{
                        let quoteId:String = String(format: "%@", data.object(forKey: "quoteId") as! CVarArg)
                        if quoteId != "0"{
                            self.defaults .set(quoteId, forKey: "quoteId")
                        }
                    }
                    
                    if errorCode == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg:data .object(forKey:"message") as! String )
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chef_supercartview") as! Chef_SuperCart
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        if badge == nil {
                            badge = "1"
                        }
                        else{
                            badge = String(Int(badge!)! + 1)
                        }
                        print("BADGE")
                        print(badge)
//                        self.tabBarController!.tabBar.items?[3].badgeValue = String(data.object(forKey: "cartCount") as! Int)
                        //self.navigationItem.prompt = String(data.object(forKey: "cartCount") as! Int)+" "+GlobalData.sharedInstance.language(key: "itemsincart")
                        
                        
                        
                        if self.goToBagFlag == true{
                            self.tabBarController!.selectedIndex = 3
                        }
                    }
                    else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: data.object(forKey: "message") as! String)
                    }
                    
                    
                    
                    print(data)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi(apiName: apiName)
                }
            }
            
        case .addToCompare:
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/addtocompare", currentView: self){success,responseObject in
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
                        GlobalData.sharedInstance.showSuccessSnackBar(msg:data.object(forKey: "message") as! String)
                    }
                    else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg:data.object(forKey: "message") as! String)
                    }
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi(apiName: apiName)
                }
            }
            
        case .addToWishlist:
            //add to wish list
            if(self.groupjson["groupedData"].count > 0){
                do {
                    let jsonData =  try JSONSerialization.data(withJSONObject: selectedGroupedProduct, options: .prettyPrinted)
                    let jsonString:String = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                    requstParams["super_group"] = jsonString
                    
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            // download data
            if (self.linkJson["links"]["linksPurchasedSeparately"].string == "1") {
                let data = NSMutableArray()
                for value in selectedDownloadableProduct{
                    if(value.value   != ""){
                        data.add(value.value)
                    }
                }
                if(data.count>0){
                    do {
                        let jsonData =  try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        let jsonString:String = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                        requstParams["links"] = jsonString
                        
                    }
                    catch {
                        print(error.localizedDescription)
                    }}
            }
            
            /////// custome data
            if(self.customeJson["customOptions"].count > 0){
                do {
                    let jsonData =  try JSONSerialization.data(withJSONObject: selectedCustomeOption, options: .prettyPrinted)
                    let jsonString:String = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                    
                    requstParams["options"] = jsonString
                    
                }
                catch {
                    print(error.localizedDescription)
                }
                
            }
            /// bunlde option
            if(self.bundleJson["bundleOptions"].count > 0){
                do {
                    let jsonData1 =  try JSONSerialization.data(withJSONObject: bundleSelectedDataWishList, options: .prettyPrinted)
                    let jsonString1:String = NSString(data: jsonData1, encoding: String.Encoding.utf8.rawValue)! as String
                    requstParams["bundle_option"] = jsonString1
                    
                    let jsonData2 =  try JSONSerialization.data(withJSONObject: selectedBundleProductQuantity, options: .prettyPrinted)
                    let jsonString2:String = NSString(data: jsonData2, encoding: String.Encoding.utf8.rawValue)! as String
                    requstParams["bundle_option_qty"] = jsonString2
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            //requstParams["qty"] = quantitytextField.text
            requstParams["qty"] = 1
            GlobalData.sharedInstance.showLoader()
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/addtoWishlist", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    
                    if errorCode == true{
                        //GlobalData.sharedInstance.showSuccessSnackBar(msg: GlobalData.sharedInstance.language(key:"movedtowishlist".localized))
                        GlobalData.sharedInstance.showSuccessSnackBar(msg:"You added product \(self.productName) to you wishlist")
                        self.catalogProductViewModel.catalogProductModel.isInWishList = true
                        self.catalogProductViewModel.catalogProductModel.wishlistItemId = String(data.object(forKey:"itemId") as! Int)
                        
                        self.wishlistBtn.setImage(#imageLiteral(resourceName: "ic_wishlist_fill"), for: .normal)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeView"), object: nil, userInfo: [:])
                        //self.tabBarController?.tabBar.isHidden = true
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key:"notmovedtowishlist".localized))
                    }
                    
                    print(responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi(apiName: apiName)
                }
            }
            
        case .removeFromWishList:
            GlobalData.sharedInstance.showLoader()
            self.view.isUserInteractionEnabled = false
            var requstParams = [String:Any]()
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            requstParams["itemId"] = self.catalogProductViewModel.catalogProductModel.wishlistItemId
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/removefromWishlist", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    print(responseObject!)
                    self.view.isUserInteractionEnabled = true
                    
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    
                    if errorCode == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg:"You removed product \(self.productName) from your wishlist")
                        
                        self.catalogProductViewModel.catalogProductModel.isInWishList = false
                        self.catalogProductViewModel.catalogProductModel.wishlistItemId = "0"
                        
                        self.wishlistBtn.setImage(#imageLiteral(resourceName: "ic_wishlist_empty"), for: .normal)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeView"), object: nil, userInfo: [:])
                        //self.tabBarController?.tabBar.isHidden = true
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key: "errorwishlist"))
                    }
                }else if success == 2{
                    self.callingHttppApi(apiName: apiName)
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        case .addreview:
            GlobalData.sharedInstance.showLoader()
            self.view.isUserInteractionEnabled = false
            var requstParams = [String:Any]()
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            requstParams["productId"] = self.productId
            requstParams["reviewContent"] = self.reviewContent
            requstParams["reviewTitle"] = self.reviewTitle
            requstParams["reviewRating"] = self.reviewRating
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/catalog/addreview", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    print(responseObject!)
                    self.view.isUserInteractionEnabled = true
                    
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    
                    if errorCode == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg:"Your Review Successfully Added")
                        
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: "Error occured while uploading review")
                    }
                }else if success == 2{
                    self.callingHttppApi(apiName: apiName)
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
            
        case .catalogProduct:
            GlobalData.sharedInstance.showLoader()
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            let apiName1 = "mobikulhttp/catalog/productPageData" + "/productId=" + productId
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/productPageData", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    print("ppp = ",apiName1)
                    
                    let data = JSON(responseObject as! NSDictionary)
                    var ProductDict = [String: Any]()
                    ProductDict["name"] = data["name"].stringValue
                    ProductDict["ProductID"] = data["id"].stringValue
                    ProductDict["image"] = data["imageGallery"].arrayValue.count>0 ? data["imageGallery"].arrayValue[0]["largeImage"].stringValue:"a.jpeg"
                    ProductDict["price"] = data["price"].stringValue
                    ProductDict["DateTime"] = String(describing: Date())
                    ProductDict["isInWishlist"] = data["isInWishlist"].stringValue
                    ProductDict["isInRange"] = data["isInRange"].stringValue
                    ProductDict["specialPrice"] = data["specialPrice"].stringValue
                    ProductDict["originalPrice"] = data["price"].stringValue
                    ProductDict["showSpecialPrice"] = data["formatedFinalPrice"].stringValue
                    ProductDict["formatedPrice"] = data["formatedPrice"].stringValue
                    
                    if let bundleOptions = data["bundleOptions"].arrayObject, bundleOptions.count > 0   {
                        ProductDict["formatedMinPrice"] = data["formatedMinPrice"].stringValue
                        ProductDict["formatedMaxPrice"] = data["formatedMaxPrice"].stringValue
                        ProductDict["isBundle"] = "1"
                    }else{
                        ProductDict["formatedMinPrice"] = "0"
                        ProductDict["formatedMaxPrice"] = "0"
                        ProductDict["isBundle"] = "0"
                    }
                    
                    let productModel = ProductViewModel(data: JSON(ProductDict))
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshRecentView"), object: nil)
                    print(productModel.getProductDataFromDB())
                    
                    
                    self.catalogProductViewModel = CatalogProductViewModel(data:JSON(responseObject as! NSDictionary))
                    print(responseObject as! NSDictionary)
                    requstParams["customerToken"] = self.defaults.object(forKey:"customerId") as! String
                    requstParams["customerType"] = "1"
                    requstParams["storeId"] = self.defaults.object(forKey:"storeId") as! String
                    requstParams["currentproductid"] = self.productId
                    requstParams["currentproductname"] = self.productName
                    GlobalData.sharedInstance.showLoader()
                    GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/catalog/detailcompareproducts", currentView: self){success,responseObject in
                        if success == 1{
                            print("compare products COMPARE")
                            print(responseObject as! NSDictionary)
                            let data = JSON(responseObject as! NSDictionary)
                            let arrayData8 = data["allProducts"].arrayObject! as NSArray
                            self.compareProductCollectionModel =  arrayData8.map({(value) -> Products in
                                return  Products(data:JSON(value))
                            })
                            print("COMPARE PRODUCTS")
                            self.doFurtherProcessingWithResult()
                            
                        }else if success == 2{
                            GlobalData.sharedInstance.dismissLoader()
                            self.callingHttppApi(apiName: apiName)
                        }
                    }
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi(apiName: apiName)
                }
            }
            
        default:
            print()
        }
    }
    func addToCart()    {
        
        if defaults.object(forKey: "authKey") == nil{
            headers = [
                "apiKey": API_USER_NAME,
                "apiPassword": API_KEY,
                "authKey":""
            ]
        }else{
            headers = [
                "apiKey": API_USER_NAME,
                "apiPassword": API_KEY,
                "authKey":defaults.object(forKey: "authKey") as! String
            ]
        }
        
        DispatchQueue.main.async {
            Alamofire.upload(multipartFormData: { multipartFormData in
                var requstParams = [String:AnyObject]()
                requstParams["storeId"] = self.defaults.object(forKey:"storeId") as! String as AnyObject
                let customerId = self.defaults.object(forKey: "customerId")
                let quoteId = self.defaults.object(forKey: "quoteId")
                requstParams["productId"] = self.productId as AnyObject
                if customerId != nil{
                    requstParams["customerToken"] = customerId as AnyObject
                }
                if quoteId != nil{
                    requstParams["quoteId"] = quoteId as AnyObject
                }
                
                var params = [String: AnyObject]()
                
                if(self.configjson["configurableData"]["attributes"].count > 0){
                    params["super_attribute"] = self.configurableSelectedData as AnyObject?
                    requstParams["params"] = self.jsonSerializationData(jsonObj: params) as AnyObject
                }
                
                if(self.groupjson["groupedData"].count > 0){
                    params["super_group"] = self.selectedGroupedProduct as AnyObject?
                    requstParams["params"] = self.jsonSerializationData(jsonObj: params) as AnyObject
                }
                
                if (self.linkJson["links"]["linksPurchasedSeparately"].string == "1") {
                    params["links"] = self.selectedDownloadableProduct as AnyObject?
                    requstParams["params"] = self.jsonSerializationData(jsonObj: params) as AnyObject
                }
                
                if(self.bundleJson["bundleOptions"].count > 0){
                    params["bundle_option"] = self.bundleSelectedData as AnyObject?
                    params["bundle_option_qty"] = self.selectedBundleProductQuantity as AnyObject?
                    requstParams["params"] = self.jsonSerializationData(jsonObj: params) as AnyObject
                }
                
                if(self.customeJson["customOptions"].count > 0){
                    params["options"] = self.selectedCustomeOption as AnyObject?
                    requstParams["params"] = self.jsonSerializationData(jsonObj: params) as AnyObject
                }
                
                //requstParams["qty"] = self.quantitytextField.text as AnyObject
                requstParams["qty"] = "1" as AnyObject;
                for (key, value) in requstParams {
                    if let data = value.data(using: String.Encoding.utf8.rawValue) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                
                for (key,value) in self.customOptionFileEntry{
                    if value == true{
                        let type:String = self.MIMETYPE[key]!
                        let weatherData = self.customOptionFileDict[key]
                        let fileName = "options_"+key+"_file"
                        multipartFormData.append(weatherData!, withName: fileName, fileName: "file."+type, mimeType: type)
                    }
                }
                
                print("aaa", requstParams)
            },
                             to: HOST_NAME+"mobikulhttp/checkout/addtoCart",method:HTTPMethod.post,
                             headers:self.headers, encodingCompletion: { encodingResult in
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    upload
                                        .validate()
                                        .responseJSON { response in
                                            switch response.result {
                                            case .success(let value):
                                                print("responseObject: \(value)")
                                                var dict = JSON(value)
                                                self.view.isUserInteractionEnabled = true
                                                
                                                //self.addToCartIndicator.stopAnimating()
                                                GlobalData.sharedInstance.dismissLoader()
                                                let errorCode: Bool = dict["success"].boolValue
                                                
                                                if dict["quoteId"].stringValue != ""{
                                                    let quoteId:String = String(format: "%@", dict["quoteId"].stringValue)
                                                    if quoteId != "0"{
                                                        self.defaults .set(quoteId, forKey: "quoteId")
                                                    }
                                                }
                                                
                                                if errorCode == true{
                                                    GlobalData.sharedInstance.showSuccessSnackBar(msg:dict["message"].stringValue)
                                                    if badge == nil {
                                                        badge = "1"
                                                    }
                                                    else{
                                                        badge = String(Int(badge!)! + 1)
                                                    }
                                                    print("BADGE")
                                                    print(badge)
                                                    //self.tabBarController!.tabBar.items?[3].badgeValue = dict["cartCount"].stringValue
                                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "chef_supercartview") as! Chef_SuperCart
                                                    
                                                    self.navigationController?.pushViewController(vc, animated: true)
                                                    
                                                    if self.goToBagFlag == true{
                                                        self.tabBarController!.selectedIndex = 3
                                                    }
                                                }
                                                else{
                                                    GlobalData.sharedInstance.showErrorSnackBar(msg:dict["message"].stringValue)
                                                }
                                                
                                                
                                                
                                                
                                            case .failure(let responseError):
                                                GlobalData.sharedInstance.showErrorSnackBar(msg: "Not updated")
                                                GlobalData.sharedInstance.dismissLoader()
                                                print("responseError: \(responseError)")
                                            }
                                    }
                                case .failure(let encodingError):
                                    print("encodingError: \(encodingError)")
                                }
            })
        }
    }
    
    
    @IBAction func addToCart(_ sender: UIButton) {
        var isValid:Int = 1
        var errorMessage:String = GlobalData.sharedInstance.language(key:"pleaseselect")
        let multipleBundleData:NSMutableArray = []
        
        ///////////////////////////////////// downloadble Data  ////////// ////////////////////////////////////////
        
        
        if (self.linkJson["links"]["linksPurchasedSeparately"].string == "1") {
            var isSwitchOn = 0
            //let downloadOptionUIView = dynamicView.viewWithTag(6000)!
            for i in 0..<self.linkJson["links"]["linkData"].count {
                var linksOption = self.linkJson["links"]["linkData"][i]
                //let switchValue:UISwitch = downloadOptionUIView.viewWithTag(i + 1)! as! UISwitch
//                if switchValue.isOn {
//                    isSwitchOn = 1
//                    selectedDownloadableProduct[linksOption["id"].string!] = linksOption["id"].string
//                }
            }
            if isSwitchOn == 0 {
                isValid = 0
                goToBagFlag = false
                errorMessage = "Select at Least One Option"
                GlobalData.sharedInstance.showErrorSnackBar(msg: errorMessage)
            }
        }
        
        
        /////////////////////////////////////////// grouped data //////////////////////////////////////////////////
        
        
        if self.groupjson["groupedData"].count > 0{
            var oneGroupdProductSelected:Int = 0
            //let groupedUIView = dynamicView.viewWithTag(5000)! as UIView
            for i in 0..<(self.groupjson["groupedData"].count){
                var groupedDataDict = self.groupjson["groupedData"][i]
                //let textField : UITextField = groupedUIView .viewWithTag(i + 1) as! UITextField
                
//                if (groupedDataDict["isAvailable"].int == 1) {
//                    if(textField .text == "0"  || textField.text == ""){}
//                    else{
//                        oneGroupdProductSelected = 1
//                        selectedGroupedProduct[groupedDataDict["id"].string!] = textField.text
//                    }
 //               }
            }
            if oneGroupdProductSelected == 0{
                isValid = 0
                goToBagFlag = false
                errorMessage = "Please enter quantity greater than zero to add to cart"
                GlobalData.sharedInstance.showErrorSnackBar(msg: errorMessage)
            }
        }
        
        ///////////////////////////////////// bundle Data //////////////////////////////////////////////////////////
        
        if(self.bundleJson["bundleOptions"].count > 0){
            let containerView:UIView = self.view.viewWithTag(9000)!
            for i in 0..<self.bundleJson["bundleOptions"].count {
                var bundleCollection = self.bundleJson["bundleOptions"][i]
                if bundleCollection["type"] == "select" || bundleCollection["type"] == "radio" {
                    let textField:UITextField = containerView.viewWithTag(i + 100) as! UITextField
                    
                    if self.bundleSelectedData[bundleCollection["option_id"].string!] == ("0" as AnyObject as! _OptionalNilComparisonType){
                        isValid = 0
                        var title:String =  bundleCollection["title"].string!
                        title += " is Required Field"
                        GlobalData.sharedInstance.showErrorSnackBar(msg: title)
                        
                    }
                    if(textField.text == "0" || textField.text == ""){
                        isValid = 0
                        errorMessage = "Please Fill the QTY"
                        GlobalData.sharedInstance.showErrorSnackBar(msg: errorMessage)
                        
                    }
                    if(isValid == 1){
                        selectedBundleProductQuantity[bundleCollection["option_id"].string!] = textField.text
                    }
                }else{
                    for k in 0..<bundleCollection["optionValues"].count{
                        let switchValue:UISwitch = containerView.viewWithTag(k) as! UISwitch
                        
                        if switchValue.isOn{
                            let optionValue:String = bundleCollection["optionValues"][k]["optionValueId"].stringValue
                            multipleBundleData.add(optionValue)
                        }
                    }
                    if multipleBundleData.count > 0{
                        isValid = 1
                        self.bundleSelectedData[bundleCollection["option_id"].string!] = multipleBundleData
                        
                    }
                    else{
                        isValid = 0
                        goToBagFlag = false
                        errorMessage = "Please Select at Least one Option"
                        GlobalData.sharedInstance.showErrorSnackBar(msg: errorMessage)
                    }
                    
                }
            }
        }
        
        ///////////////////////////////// custom product //////////////////////////////////////////////////////////////////////////
        
//        if(self.customeJson["customOptions"].count > 0){
//            //let customOptionUIView = dynamicView.viewWithTag(4000)!
//            for i in 0..<customeJson["customOptions"].count {
//                var customOptionDict = customeJson["customOptions"][i]
//                if  customOptionDict["is_require"].intValue == 1 {
//                    if (customOptionDict["type"].string == "field") {
////                        let tempField:UITextField = customOptionUIView.viewWithTag(i + 1)! as! UITextField
////                        if tempField.text == "" {
////                            isValid = 0
////                            errorMessage = "\(customOptionDict["title"].stringValue) is a required field"
////                            tempField.backgroundColor = UIColor.red
////                        }
////                        else {
////                            selectedCustomeOption[customOptionDict["option_id"].stringValue] = tempField.text as AnyObject?
////                        }
//                    }
//                    else if (customOptionDict["type"] == "area") {
////                        let tempArea:UITextView = customOptionUIView.viewWithTag(i + 1)! as! UITextView
////                        if tempArea.text == "" {
////                            isValid = 0
////                            if (errorMessage == "") {
////                                errorMessage = "\(customOptionDict["title"].stringValue) is a required field"
////                            }
////                            tempArea.backgroundColor = UIColor.red
////                        }
////                        else {
////                            selectedCustomeOption[customOptionDict["option_id"].stringValue] = tempArea.text as AnyObject?
////                        }
//                    }
//                    else if (customOptionDict["type"].string == "checkbox") || (customOptionDict["type"].string == "multiple") {
//                        //let tempSwitchArea:UIView = customOptionUIView.viewWithTag(i + 1)!
//                        var isSwitchOn = 0
//                        let selectedOption = NSMutableArray()
//                        for i in 0..<customOptionDict["optionValues"].arrayValue.count {
//
////                            let checkBoxTag = i
////                            let tempSwitch:UISwitch = tempSwitchArea.viewWithTag(checkBoxTag) as! UISwitch
////                            if tempSwitch.isOn {
////                                isSwitchOn = 1
////                                selectedOption.add(((customOptionDict["optionValues"].arrayValue)[i].dictionaryObject!["option_type_id"] as! String))
////                            }
//                        }
//                        if isSwitchOn == 0 {
//                            isValid = 0
//                            if (errorMessage == "") {
//                                errorMessage =  customOptionDict["title"].stringValue +  " is a required field"
//                            }
//                        }
//                        else {
//                            selectedCustomeOption[customOptionDict["option_id"].stringValue] = selectedOption
//                        }
//                    }else if customOptionDict["type"].stringValue == "file" {
//                        if customOptionFileEntry[customOptionDict["option_id"].stringValue] == false{
//                            isValid = 0
//                            errorMessage = "Please upload the"+" "+customOptionDict["title"].stringValue
//                        }
//                    }
//                }else{
//                    if (customOptionDict["type"].string == "field") {
////                        let tempField:UITextField = customOptionUIView.viewWithTag(i + 1)! as! UITextField
////                        selectedCustomeOption[customOptionDict["option_id"].stringValue] = tempField.text as AnyObject?
//                    }
//                    if (customOptionDict["type"].string == "area") {
////                        let tempArea:UITextView = customOptionUIView.viewWithTag(i + 1)! as! UITextView
////                        selectedCustomeOption[customOptionDict["option_id"].stringValue] = tempArea.text as AnyObject?
//                    }
//                    if (customOptionDict["type"].string == "checkbox") || (customOptionDict["type"].string == "multiple") {
//                        let tempSwitchArea:UIView = customOptionUIView.viewWithTag(i + 1)!
//                        let selectedOption = NSMutableArray()
//                        for (key,_):(String, JSON) in customOptionDict["optionValues"].dictionaryValue {
//                            let checkBoxTag = Int(key)
//                            let tempSwitch:UISwitch = tempSwitchArea.viewWithTag(checkBoxTag!) as! UISwitch
//                            if tempSwitch.isOn {
//                                selectedOption.add(key)
//                            }
//                        }
//                        selectedCustomeOption[customOptionDict["option_id"].stringValue] = selectedOption
//                    }
//                }
//                if (customOptionDict["type"].string == "radio") || (customOptionDict["type"].string == "drop_down") {
//                    let tempPicker:UILabel = customOptionUIView.viewWithTag(i + 1)! as! UILabel
//
//                    if(tempPicker.text == GlobalData.sharedInstance.language(key: "chooseaselection"))  {
//                        isValid = 0
//                        errorMessage = GlobalData.sharedInstance.language(key: "chooseaselection")
//                    }
//                }
//                if (customOptionDict["type"].string == "date") || (customOptionDict["type"].string == "date_time") || (customOptionDict["type"].string == "time") {
//                    let tempDatePicker:UILabel = customOptionUIView.viewWithTag(i + 1)! as! UILabel
//                    if (customOptionDict["type"].string == "date") {
//                        if (tempDatePicker.text == GlobalData.sharedInstance.language(key: "selectdate")) {
//                            isValid = 0
//                            errorMessage = GlobalData.sharedInstance.language(key: "selectdate")
//                        }
//                    }
//                    if (customOptionDict["type"].string == "date_time") {
//                        if (tempDatePicker.text == GlobalData.sharedInstance.language(key: "selectdateandtime")) {
//                            isValid = 0
//                            errorMessage = GlobalData.sharedInstance.language(key: "selectdateandtime")
//                        }
//                    }
//                    if (customOptionDict["type"].string == "time") {
//                        if (tempDatePicker.text == GlobalData.sharedInstance.language(key: "selecttime")) {
//                            isValid = 0
//                            errorMessage = GlobalData.sharedInstance.language(key: "selecttime")
//                        }
//                    }
//                }
//            }
            
//            if(isValid == 0){
//                goToBagFlag = false
//                GlobalData.sharedInstance.showErrorSnackBar(msg: errorMessage)
//            }
//        }
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////Configurable ////////////////////////////////////////////////////////////////////////
        
        if self.configjson["configurableData"]["attributes"].count > 0 {
            for i in 0..<self.configjson["configurableData"]["attributes"].count {
                var attributesvalues  = self.configjson["configurableData"]["attributes"][i]
                if configurableSelectedData[attributesvalues["id"].stringValue] == "0"{
                    errorMessage = errorMessage+attributesvalues["label"].stringValue
                    isValid = 0
                    break
                }
            }
            
            if isValid == 0{
                goToBagFlag = false
                GlobalData.sharedInstance.showErrorSnackBar(msg: errorMessage)
            }
        }
        
        if(isValid == 1){
            if catalogProductViewModel.catalogProductModel.isAvailable == true{
                //addToCartIndicator.startAnimating()
                GlobalData.sharedInstance.showLoader()
                self.addToCart()
            }else{
                GlobalData.sharedInstance.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key: "outofstock"))
            }
        }
    }
    func AddToWishList() {
        let customerId = defaults.object(forKey: "customerId")
        if(customerId == nil){
            let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "warning"), message: GlobalData.sharedInstance.language(key: "loginrequired"), preferredStyle: .alert)
            let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
            })
            
            AC.addAction(okBtn)
            self.present(AC, animated: true, completion: { })
        }else{
            
            if self.catalogProductViewModel.catalogProductModel.isInWishList {
                //remove from wish list
                
                callingHttppApi(apiName: CatalogProductAPI.removeFromWishList)
                
            }else{
                //add to wish list
                
                // grouped product
                
                
                callingHttppApi(apiName: CatalogProductAPI.addToWishlist)
            }
        }
    }
    func zoomRect(forScale scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var zoomRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let scroll = parentZoomingScrollView.viewWithTag(888888) as! UIScrollView
        let childScroll = scroll.viewWithTag(90000 + currentTag) as! UIScrollView
        zoomRect.size.height = childScroll.frame.size.height / scale
        zoomRect.size.width = childScroll.frame.size.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    func shareProduct() {
        let productUrl = catalogProductViewModel.catalogProductModel.shareUrl
        let activityItems = [productUrl]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            self.present(activityController, animated: true, completion: {  })
        }
        else {
            let popup = UIPopoverController(contentViewController: activityController)
            popup.present(from: CGRect(x: CGFloat(self.view.frame.size.width / 2), y: CGFloat(self.view.frame.size.height / 4), width: CGFloat(0), height: CGFloat(0)), in: self.view, permittedArrowDirections: .any, animated: true)
        }
    }
    @objc func closeZoomTap(_ gestureRecognizer: UIGestureRecognizer) {
        let currentWindow = UIApplication.shared.keyWindow!
        currentWindow.viewWithTag(888)!.removeFromSuperview()
    }
    @IBAction func wishlistBtnClicked(_ sender: UIButton) {
        self.AddToWishList()
    }
    
    @IBAction func shareBtnClicked(_ sender: UIButton) {
        self.shareProduct()
    }
    func zoomAction(tappedIndex: Int){
        let homeDimView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT)))
        homeDimView.backgroundColor = UIColor.white
        let currentWindow = UIApplication.shared.keyWindow
        homeDimView.tag = 888
        homeDimView.frame = (currentWindow?.bounds)!
        let cancel = UIImageView(frame: CGRect(x: CGFloat(SCREEN_WIDTH - 40), y: CGFloat(30), width: CGFloat(20), height: CGFloat(20)))
        cancel.image = UIImage(named: "ic_close")
        cancel.isUserInteractionEnabled = true
        homeDimView.addSubview(cancel)
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(self.closeZoomTap))
        cancelTap.numberOfTapsRequired = 1
        cancel.addGestureRecognizer(cancelTap)
        
        var X:CGFloat = 0
        
        parentZoomingScrollView = UIScrollView(frame: CGRect(x: CGFloat(0), y: CGFloat(70), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120)))
        parentZoomingScrollView.isUserInteractionEnabled = true
        parentZoomingScrollView.tag = 888888
        parentZoomingScrollView.delegate = self
        homeDimView.addSubview(parentZoomingScrollView)
        
        for i in 0..<imageArrayUrl.count {
            childZoomingScrollView = UIScrollView(frame: CGRect(x: CGFloat(X), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120)))
            childZoomingScrollView.isUserInteractionEnabled = true
            childZoomingScrollView.tag = 90000 + i
            childZoomingScrollView.delegate = self
            parentZoomingScrollView.addSubview(childZoomingScrollView)
            imageZoom = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120)))
            imageZoom.image = UIImage(named: "ic_placeholder.png")
            imageZoom.contentMode = .scaleAspectFit
            GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageArrayUrl[i], imageView: imageZoom)
            
            imageZoom.isUserInteractionEnabled = true
            imageZoom.tag = 10
            childZoomingScrollView.addSubview(imageZoom)
            childZoomingScrollView.maximumZoomScale = 5.0
            childZoomingScrollView.clipsToBounds = true
            childZoomingScrollView.contentSize = CGSize(width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120))
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap))
            doubleTap.numberOfTapsRequired = 2
            imageZoom.addGestureRecognizer(doubleTap)
            X += SCREEN_WIDTH
        }
        
        parentZoomingScrollView.contentSize = CGSize(width: CGFloat(X), height: CGFloat(SCREEN_WIDTH))
        parentZoomingScrollView.isPagingEnabled = true
        let Y: CGFloat = 70 + SCREEN_HEIGHT - 120 + 5
        pager = UIPageControl(frame: CGRect(x: CGFloat(0), y: CGFloat(Y), width: CGFloat(SCREEN_WIDTH), height: CGFloat(50)))
        //SET a property of UIPageControl
        pager.backgroundColor = UIColor.clear
        pager.numberOfPages = imageArrayUrl.count
        //as we added 3 diff views
        parentZoomingScrollView.setContentOffset(CGPoint(x: Int(SCREEN_WIDTH)*tappedIndex, y: 0), animated: false)
        pager.currentPage = tappedIndex
        pager.isHighlighted = true
        pager.pageIndicatorTintColor = UIColor.black
        pager.currentPageIndicatorTintColor = UIColor.red
        homeDimView.addSubview(pager)
        currentWindow?.addSubview(homeDimView)
        
        let newPosition = SCREEN_WIDTH * CGFloat(self.pageControl.currentPage)
        let toVisible = CGRect(x: CGFloat(newPosition), y: CGFloat(70), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120))
        self.parentZoomingScrollView.scrollRectToVisible(toVisible, animated: true)
    }
    @objc func handleDoubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let scroll = parentZoomingScrollView.viewWithTag(888888) as! UIScrollView
        let childScroll = scroll.viewWithTag(90000 + currentTag) as! UIScrollView
        let newScale: CGFloat = scroll.zoomScale * 1.5
        let zoomRect = self.zoomRect(forScale: newScale, withCenter: gestureRecognizer.location(in: gestureRecognizer.view))
        childScroll.zoom(to: zoomRect, animated: true)
    }
    @objc func openImage(_ sender : UITapGestureRecognizer){
        self.zoomAction(tappedIndex:Int(sender.accessibilityHint!)!)
        
        //        let homeDimSuperView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT)))
        //        let homeDimView = UIView(frame: CGRect(x: CGFloat(40), y: CGFloat(80), width: CGFloat(SCREEN_WIDTH - 80), height: CGFloat(SCREEN_HEIGHT - 160)))
        //        homeDimView.backgroundColor = UIColor.white
        //        let currentWindow = UIApplication.shared.keyWindow
        //        homeDimView.tag = 888
        //        homeDimView.frame = (currentWindow?.bounds)!
        //        homeDimView.layer.cornerRadius = 30
        //        zoomImgVC = self.storyboard?.instantiateViewController(withIdentifier: "ZoomImageViewController") as! ZoomImageViewController
        //        self.addChildViewController(zoomImgVC)
        //        zoomImgVC.currentTag = Int(sender.accessibilityHint!)!
        //        zoomImgVC.imageArrayUrl = imageArrayUrl
        //        zoomImgVC.view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT))
        //        homeDimView.addSubview(zoomImgVC.view)
        //        homeDimSuperView.addSubview(homeDimView)
        //        self.view.addSubview(homeDimSuperView)
    }
    func doFurtherProcessingWithResult()    {
        print(compareProductCollectionModel)
        let ratingArr:JSON = JSON(catalogProductViewModel.getRatingsData)
        let ratingCount:Float = Float(catalogProductViewModel.getRatingsData.count)
        var ratingVal:Float = 0
        for i in 0..<catalogProductViewModel.getRatingsData.count {
            let dict = ratingArr[i]
            let val = dict["ratingValue"].floatValue
            ratingVal = ratingVal + val
            print("cccvv",ratingVal)
        }
        supplierName.text = supplierNameText
        productStarRating.value = CGFloat((ratingVal/ratingCount) as Float)
//        productRating.value = CGFloat((ratingVal/ratingCount) as Float)
        productRate.text = catalogProductViewModel.catalogProductModel.rating!
//        productRatingCountVal.text = "\(catalogProductViewModel.reviewList.count) " + "ratings".localized
//
        productRateCount.text = ("\(catalogProductViewModel.reviewList.count)" + " " + "review".localized)
        self.productDetailTableView.reloadData()
//
//        //add gesture on total reviews
//        let addReviewGesture = UITapGestureRecognizer(target: self, action: #selector(CatalogProduct.totalReviewsClick(_:)))
//        totalReviews.addGestureRecognizer(addReviewGesture)
//
//        //add gesture on ratings view
//        let addRatingsGesture = UITapGestureRecognizer(target: self, action: #selector(CatalogProduct.ratingViewClick(_:)))
//        ratingView.addGestureRecognizer(addRatingsGesture)
//
        imageArrayUrl = catalogProductViewModel.getBannerImageUrl
        collectionView.delegate = self
        collectionView.dataSource = self
      
        collectionView.reloadData()
        productpriceLabel.text = catalogProductViewModel.catalogProductModel.formatedFinalPrice
        pageControl.numberOfPages = imageArrayUrl.count
//        activityIndicator.stopAnimating()
//        stockLabelValue.text = catalogProductViewModel.catalogProductModel.stockMessage
//        //        self.mainViewHeightConstarints.constant = 650 + SCREEN_HEIGHT/2
//
        //wishlist icon
        if self.catalogProductViewModel.catalogProductModel.isInWishList    {
            wishlistBtn.setImage(#imageLiteral(resourceName: "ic_wishlist_fill"), for: .normal)
        }else{
            wishlistBtn.setImage(#imageLiteral(resourceName: "ic_wishlist_empty"), for: .normal)
        }

        self.groupjson = catalogProductViewModel.catalogProductModel.groupedData
        self.linkJson = catalogProductViewModel.catalogProductModel.links
        self.bundleJson = catalogProductViewModel.catalogProductModel.bundleData
        self.customeJson = catalogProductViewModel.catalogProductModel.customeOptionData
        self.configjson = catalogProductViewModel.catalogProductModel.configurableData
//
//
//        if catalogProductViewModel.catalogProductModel.typeID == "grouped"{
//            self.productpriceLabel.text =  catalogProductViewModel.catalogProductModel.groupedPrice
//
//        }else if catalogProductViewModel.catalogProductModel.typeID == "bundle"{
//            self.productpriceLabel.text =  catalogProductViewModel.catalogProductModel.formatedMinPrice+"-"+catalogProductViewModel.catalogProductModel.formatedMaxPrice
//        }else{
//            if catalogProductViewModel.catalogProductModel.isInRange == true{
//
//                if catalogProductViewModel.catalogProductModel.specialPrice < catalogProductViewModel.catalogProductModel.price{
//                    self.productpriceLabel.text = catalogProductViewModel.catalogProductModel.formatedSpecialprice
//                    let attributeString = NSMutableAttributedString(string: catalogProductViewModel.catalogProductModel.formatedPrice)
//                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
//                    specialPrice.attributedText = attributeString
//                    specialPrice.isHidden = false
//                }
//            }
//        }
//        self.addToCartFrameY = self.addToCartView.frame.origin.y
//
//        /////////////////// Market Place ///////////////////
//
        if catalogProductViewModel.sellerInformationData.sellerID != "" && catalogProductViewModel.sellerInformationData.sellerID != "0"{
            //supplierName.text = catalogProductViewModel.sellerInformationData.sellerShopTitle;
//            contactUsButton.setTitle("contactus".localized, for: .normal)
//            contactUsButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
//            sellerNameButton.setTitle(catalogProductViewModel.sellerInformationData.sellerShopTitle, for: .normal)
//            sellerNameButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
//            ratingValue.text = " "+catalogProductViewModel.sellerInformationData.sellerAverageRating+"/5"+" "
//            ratingValue.textColor = UIColor.white
//            ratingValue.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
//            message.text = catalogProductViewModel.sellerInformationData.sellerReviewDescription
//            for i in 0..<catalogProductViewModel.sellerRatingData.count{
//                if i == 0{
//                    label1.text = catalogProductViewModel.sellerRatingData[i].label
//                    rating1.value = CGFloat(catalogProductViewModel.sellerRatingData[i].value)
//                }else if i == 1{
//                    label2.text = catalogProductViewModel.sellerRatingData[i].label
//                    rating2.value = CGFloat(catalogProductViewModel.sellerRatingData[i].value)
//                }else if i == 2{
//                    label3.text = catalogProductViewModel.sellerRatingData[i].label
//                    rating3.value = CGFloat(catalogProductViewModel.sellerRatingData[i].value)
//                }
//            }
//
//            marketPlaceView.layer.borderWidth = 0.5
//            marketPlaceView.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
//            marketPlaceView.backgroundColor = UIColor.white
//            marketPlaceView.isHidden = false
//        }else{
//            marketplaceHeightConstarints.constant = 0
//            marketPlaceView.backgroundColor = UIColor.white
        }
//
//        ////////////////// grouped products //////////////////
//
//        self.mainContainerY += 10
//
//        setUpGroupProducts()
//
//        ///////////////// downloadble products ///////////////
//
//        print("asasas",self.linkJson)
//
//        setUpDownloadableProducts()
//
//        ///////////////// Bundle product /////////////////////
//
//        setUpBundleProducts()
//
//        //////////////// custom option ///////////////////////
//
//        setUpCustomOptionsProducts()
//
//        dynamicViewHeightCOnstarints.constant = self.mainContainerY
//        //        self.mainViewHeightConstarints.constant += dynamicViewHeightCOnstarints.constant
//
//        //////////////// Configurable Data  //////////////////
//
//        if self.configjson["configurableData"]["attributes"].count > 0{
//            self.createConfigurableView()
//        }
        
        GlobalData.sharedInstance.dismissLoader()
   }
    
    @objc func cartButtonClick(sender: UIButton){
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "chef_cartexview") as! Chef_exMyCart
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chef_supercartview") as! Chef_SuperCart
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func searchButtonClick(sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chef_searchview") as! SearchSuggestion
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
}

extension Chef_DashboardViewController: UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout    {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ view: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArrayUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:SCREEN_WIDTH , height:SCREEN_HEIGHT/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogProductImage.identifier, for: indexPath) as! CatalogProductImage
        print("ImageCollectionCell", imageArrayUrl[indexPath.row])
        
        cell.imageView.image = UIImage(named: "ic_placeholder.png")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openImage))
        tapGesture.accessibilityHint = "\(indexPath.row)"
        cell.imageView.addGestureRecognizer(tapGesture)
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:imageArrayUrl[indexPath.row] , imageView: cell.imageView)
        cell.imageView.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat   {
        return 0.0
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ZoomImageViewController") as! ZoomImageViewController
    //        vc.currentTag = indexPath.row
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
}
extension Chef_DashboardViewController {

    func selectedConfigurImg()  {
        
        var count = 0
        var tmpArr = [String]()
        
        for j in 0..<configurableDataIndex.count  {
            count = 0
            tmpArr.removeAll()
            
            let d = JSON((configurableDataIndex as! NSArray)[j])
            
            for (key,val):(String,JSON) in d   {
                
                if (JSON(configurableSelectedData)[key] != nil) , JSON(configurableSelectedData)[key].stringValue == val.stringValue , key != "product" {
                    count += 1
                    tmpArr.append(d["product"].stringValue)
                }
                print(key)
            }
            
            if count == configurableSelectedData.count  {
                break
            }
        }
        
        print("Count array key -->>>> \(tmpArr)")
        
        setNewImages(productId:tmpArr[0])
    }

    func setNewImages(productId: String) {
        
        if let imageArr = configurableDataImages[productId] as? NSArray {
            self.imageArrayUrl.removeAll()
            pageControl.numberOfPages = 0
            
            for i in 0..<imageArr.count {
                
                if JSON(imageArr)[i]["img"].stringValue != ""  {
                    self.imageArrayUrl.append(JSON(imageArr)[i]["img"].stringValue)
                }
            }
            
            pageControl.numberOfPages = imageArrayUrl.count
            self.collectionView.reloadData()
        }
    }
}
 extension Chef_DashboardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 888888{
            let pageWidth: CGFloat = self.parentZoomingScrollView.frame.size.width
            let page = floor((self.parentZoomingScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
            self.currentTag = NSInteger(page)
            self.pager.currentPage = Int(page)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell: UICollectionViewCell in self.collectionView.visibleCells {
            let indexPathValue = self.collectionView.indexPath(for: cell)!
            print(indexPathValue.row)
            self.pageControl.currentPage = Int(indexPathValue.row)
            break
        }
    }
}


