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

class Chef_DashboardViewController: UIViewController {
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var detailBorder: UIView!
    @IBOutlet weak var reviewBorder: UIView!
    @IBOutlet weak var compareBorder: UIView!
    @IBOutlet weak var part1: UIView!
    @IBOutlet weak var part2: UIView!
    @IBOutlet weak var part3: UIView!
    @IBOutlet weak var compareView: UIView!
    @IBOutlet weak var addCartButton: UIButton!
    @IBOutlet weak var quantitytextField: UILabel!
    @IBOutlet weak var productnameLabel: UILabel!
    @IBOutlet weak var productpriceLabel: UILabel!
    @IBOutlet weak var addToCartIndicator: UIActivityIndicatorView!
    @IBOutlet weak var productImage: UIImageView!
    
    var catalogProductViewModel:CatalogProductViewModel!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = productName
        self.navigationController?.isNavigationBarHidden = false
        
       reviewBorder.isHidden = true
        compareBorder.isHidden = true
        hideReview(isHidden: true)
        compareView.isHidden = true
     GlobalData.sharedInstance.getImageFromUrl(imageUrl:productImageUrl , imageView: self.productImage)
        
        imageArrayUrl = [productImageUrl]
        productnameLabel.text = productName
        GlobalData.sharedInstance.removePreviousNetworkCall()
        GlobalData.sharedInstance.dismissLoader()
        callingHttppApi(apiName: CatalogProductAPI.catalogProduct)
        // Do any additional setup after loading the view.
    }
    func hideReview(isHidden : Bool){
        part1.isHidden = isHidden
        part2.isHidden = isHidden
        part3.isHidden = isHidden
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func detailButtonClick(_ sender: UIButton){
        reviewBorder.isHidden = true;
        compareBorder.isHidden = true;
        detailBorder.isHidden = false;
        hideReview(isHidden: true)
        compareView.isHidden = true
        addCartButton.isHidden = false
    }
    @IBAction func reviewsButtonClick(_ sender: UIButton){
        reviewBorder.isHidden = false;
        compareBorder.isHidden = true;
        detailBorder.isHidden = true;
        hideReview(isHidden: false)
        compareView.isHidden = true
        addCartButton.isHidden = true
    }
    @IBAction func compareButtonClick(_ sender: UIButton){
        addCartButton.isHidden = true
        reviewBorder.isHidden = true;
        compareBorder.isHidden = false;
        detailBorder.isHidden = true;
        hideReview(isHidden: true)
        compareView.isHidden = false
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
            
            requstParams["qty"] = quantitytextField.text
            GlobalData.sharedInstance.showLoader()
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/addtoWishlist", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    
                    if errorCode == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg: GlobalData.sharedInstance.language(key:"movedtowishlist".localized))
                        self.catalogProductViewModel.catalogProductModel.isInWishList = true
                        self.catalogProductViewModel.catalogProductModel.wishlistItemId = String(data.object(forKey:"itemId") as! Int)
                        
                        //self.wishlistBtn.setImage(#imageLiteral(resourceName: "ic_wishlist_fill"), for: .normal)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeView"), object: nil, userInfo: [:])
                        self.tabBarController?.tabBar.isHidden = true
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
                        GlobalData.sharedInstance.showSuccessSnackBar(msg:GlobalData.sharedInstance.language(key: "successwishlistremove"))
                        
                        self.catalogProductViewModel.catalogProductModel.isInWishList = false
                        self.catalogProductViewModel.catalogProductModel.wishlistItemId = "0"
                        
                        //self.wishlistBtn.setImage(#imageLiteral(resourceName: "ic_wishlist_empty"), for: .normal)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeView"), object: nil, userInfo: [:])
                        self.tabBarController?.tabBar.isHidden = true
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key: "errorwishlist"))
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
                    self.doFurtherProcessingWithResult()
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
                                                    //self.tabBarController!.tabBar.items?[3].badgeValue = dict["cartCount"].stringValue
                                                    
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
    
    func doFurtherProcessingWithResult()    {
        
        let ratingArr:JSON = JSON(catalogProductViewModel.getRatingsData)
        let ratingCount:Float = Float(catalogProductViewModel.getRatingsData.count)
        var ratingVal:Float = 0
        for i in 0..<catalogProductViewModel.getRatingsData.count {
            let dict = ratingArr[i]
            let val = dict["ratingValue"].floatValue
            ratingVal = ratingVal + val
            print("cccvv",ratingVal)
        }
        
//        productRating.value = CGFloat((ratingVal/ratingCount) as Float)
//        productRatingVal.text = "\(catalogProductViewModel.catalogProductModel.rating!)/5"
//        productRatingCountVal.text = "\(catalogProductViewModel.reviewList.count) " + "ratings".localized
//
//        totalReviews.text = ("\(catalogProductViewModel.reviewList.count) \n" + "review".localized)
//
//        //add gesture on total reviews
//        let addReviewGesture = UITapGestureRecognizer(target: self, action: #selector(CatalogProduct.totalReviewsClick(_:)))
//        totalReviews.addGestureRecognizer(addReviewGesture)
//
//        //add gesture on ratings view
//        let addRatingsGesture = UITapGestureRecognizer(target: self, action: #selector(CatalogProduct.ratingViewClick(_:)))
//        ratingView.addGestureRecognizer(addRatingsGesture)
//
//        imageArrayUrl = catalogProductViewModel.getBannerImageUrl
//        collectionView.reloadData()
        productpriceLabel.text = catalogProductViewModel.catalogProductModel.formatedFinalPrice
//        pageControl.numberOfPages = imageArrayUrl.count
//        activityIndicator.stopAnimating()
//        stockLabelValue.text = catalogProductViewModel.catalogProductModel.stockMessage
//        //        self.mainViewHeightConstarints.constant = 650 + SCREEN_HEIGHT/2
//
//        //wishlist icon
//        if self.catalogProductViewModel.catalogProductModel.isInWishList    {
//            wishlistBtn.setImage(#imageLiteral(resourceName: "ic_wishlist_fill"), for: .normal)
//        }else{
//            wishlistBtn.setImage(#imageLiteral(resourceName: "ic_wishlist_empty"), for: .normal)
//        }
//
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
//        if catalogProductViewModel.sellerInformationData.sellerID != "" && catalogProductViewModel.sellerInformationData.sellerID != "0"{
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
//        }
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
       
}
