//
//  ViewController.swift
//  Magento2V4Theme
//
//  Created by kunal on 07/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit
import SwiftMessages

class ViewController: UIViewController,productViewControllerHandlerDelegate,bannerViewControllerHandlerDelegate,CategoryViewControllerHandlerDelegate,hotDealProductViewControllerHandlerDelegate,UISearchBarDelegate,RecentProductViewControllerHandlerDelegate, UITabBarControllerDelegate {
    
    @IBOutlet weak var homeTableView: UITableView!
    var homeViewModel : HomeViewModel!
    var productName:String = ""
    var productId:String = ""
    var productImage:String = ""
    var categoryId:String = ""
    var categoryName:String = ""
    var categoryType:String = ""
    var whichApiToProcess:String = ""
    @IBOutlet weak var searchBar: UISearchBar!
    var launchView:UIViewController!
    var refreshControl:UIRefreshControl!
    var responseObject : AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        /*let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil)
        launchView = launchScreen.instantiateInitialViewController()
        self.view.addSubview(launchView!.view)*/
        homeViewModel = HomeViewModel()
        homeTableView?.register(BannerTableViewCell.nib, forCellReuseIdentifier: BannerTableViewCell.identifier)
        homeTableView?.register(TopCategoryTableViewCell.nib, forCellReuseIdentifier: TopCategoryTableViewCell.identifier)
        homeTableView?.register(ProductTableViewCell.nib, forCellReuseIdentifier: ProductTableViewCell.identifier)
        homeTableView?.register(HotdealsTableViewCell.nib, forCellReuseIdentifier: HotdealsTableViewCell.identifier)
        homeTableView?.register(RecentViewTableViewCell.nib, forCellReuseIdentifier: RecentViewTableViewCell.identifier)
        
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "applicationname")
        self.homeTableView?.dataSource = homeViewModel
        self.homeTableView?.delegate = homeViewModel
        GlobalVariables.hometableView = homeTableView
        self.homeViewModel.homeViewController = self;
        self.homeTableView.separatorColor = UIColor.clear
        searchBar.delegate = self
        callingHttppApi();
        searchBar.placeholder = GlobalData.sharedInstance.language(key: "searchentirestore")
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedCategoryTap), name: NSNotification.Name(rawValue: "pushNotificationforCategoryOnTap"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedProductTap), name: NSNotification.Name(rawValue: "pushNotificationforProductOnTap"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedCustomCollectionTap), name: NSNotification.Name(rawValue: "pushNotificationforCustomCollectionOnTap"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationforChatTap), name: NSNotification.Name(rawValue: "pushNotificationforChat"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedOtherTap), name: NSNotification.Name(rawValue: "pushNotificationforOtherOnTap"), object: nil)
        
        
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText =  GlobalData.sharedInstance.language(key:"done")
        //IQKeyboardManager.sharedManager().disabledDistanceHandlingClasses.append(ChatMessaging.self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshPageRecentView), name: NSNotification.Name(rawValue: "refreshRecentView"), object: nil)
        
        self.tabBarController?.delegate = self
        
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: GlobalData.sharedInstance.language(key: "refreshing"), attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            homeTableView.refreshControl = refreshControl
        } else {
            homeTableView.backgroundView = refreshControl
        }
        
        ThemeManager.applyTheme(bar:(self.navigationController?.navigationBar)!)

    }
    
    //Refresh page for Recent View
    @objc func refreshPageRecentView()    {
        print(homeTableView.numberOfSections)
        let productModel = ProductViewModel()
        print(productModel.getProductDataFromDB())
        
        if responseObject != nil {
            self.homeViewModel.getData(data: responseObject!, recentViewData : productModel.getProductDataFromDB()) {
                (data : Bool) in
                if data {
                    self.homeTableView.reloadData()
                }
            }
        }
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        callingHttppApi()
        refreshControl.endRefreshing()
    }
    
    @objc func pushNotificationReceivedCategoryTap(_ note: Notification) {
        var root  = note.userInfo
        categoryId = root?["categoryId"] as! String
        categoryName = root?["categoryName"] as! String
        categoryType = ""
        self.performSegue(withIdentifier: "productcategory", sender: self)
    }
    
    @objc func pushNotificationReceivedProductTap(_ note: Notification) {
        var root = note.userInfo
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productName = root?["productName"] as! String
        vc.productImageUrl = ""
        vc.productId = root?["productId"] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pushNotificationReceivedCustomCollectionTap(_ note: Notification) {
        var root = note.userInfo;
        categoryId = root?["id"] as! String
        categoryName = root?["title"] as! String
        categoryType = "custom"
        self.performSegue(withIdentifier: "productcategory", sender: self)
    }
    
    @objc func pushNotificationforChatTap(_ note: Notification) {
        self.tabBarController?.selectedIndex = 4
    }
    
    
    @objc func pushNotificationReceivedOtherTap(_ note: Notification) {
        var root = note.userInfo;
        let title = root?["title"] as! String
        let content = root?["message"] as! String
        let AC = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.callingHttppApi();
        })
        AC.addAction(okBtn)
        self.parent!.present(AC, animated: true, completion: { })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
        self.performSegue(withIdentifier: "search", sender: self)
    }
    
    
    @IBAction func showNotificationClick(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "notification", sender: self)
    }
    
    
    
    
    func callingHttppApi(){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            var requstParams = [String:Any]();
            if defaults.object(forKey: "storeId") != nil{
                requstParams["storeId"] = defaults.object(forKey: "storeId") as! String
            }
            let customerId = defaults.object(forKey:"customerId");
            if customerId != nil{
                requstParams["customerToken"] = customerId
            }
            
            if defaults.object(forKey: "currency") != nil{
                requstParams["currency"] = defaults.object(forKey: "currency") as! String
            }
            requstParams["websiteId"] = "1"
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            let apiName = "mobikulhttp/catalog/homePageData"
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:apiName, currentView: self){success,responseObject in
                if success == 1 {
                    
                    print(responseObject as! NSDictionary)
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    if responseObject?.object(forKey: "defaultCurrency") != nil{
                        if defaults.object(forKey: "currency") == nil{
                            defaults .set(responseObject!.object(forKey: "defaultCurrency") as! String, forKey: "currency")
                        }
                    }
                    
                    let dict =  JSON(responseObject as! NSDictionary)
                    self.view.isUserInteractionEnabled = true
                    
                    if dict["success"].boolValue == true{
                        self.responseObject = responseObject!
                        
                        let productModel = ProductViewModel()
                        print(productModel.getProductDataFromDB())
                        
                        self.homeViewModel.getData(data: responseObject!, recentViewData : productModel.getProductDataFromDB()) {
                            (data : Bool) in
                            if data {
                                self.homeTableView.reloadDataWithAutoSizingCellWorkAround()
                                self.navigationController?.isNavigationBarHidden = false
                                self.tabBarController?.tabBar.isHidden = false
                                /*UIView.animate(withDuration: 0.5, animations: {
                                    self.launchView?.view.alpha = 0.0
                                }) { _ in
                                    self.launchView!.view.removeFromSuperview()
                                }*/
                            }
                        }
                    }
                }else if success == 2   {
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }else if success == 0   {
                    if let data = responseObject as? NSDictionary   {
                        if let otherError = data.object(forKey: "otherError") as? String  , otherError == "customerNotExist"  {
                            print("customerNotExist call")
                            self.refreshControl.endRefreshing()
                            GlobalData.sharedInstance.dismissLoader()
                            defaults.removeObject(forKey: "customerId")
                            self.callingHttppApi()
                        }
                    }
                }
            }
        }
    }
    
    func productClick(name:String,image:String,id:String){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productName = name
        vc.productImageUrl = image
        vc.productId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func bannerProductClick(type:String,image:String,id:String,title:String){
        if type == "category"{
            categoryId = id
            categoryName = title
            categoryType = ""
            self.performSegue(withIdentifier: "productcategory", sender: self)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
            vc.productName = title
            vc.productImageUrl = image
            vc.productId = id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func categoryProductClick(name:String,ID:String){
        categoryId = ID
        categoryName = name
        categoryType = ""
        self.performSegue(withIdentifier: "productcategory", sender: self)
    }
    
    
    
    
    func newAndFeartureAddToWishList(productID:String){
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            self.productId = productID;
            whichApiToProcess = "addtowishlist"
            callingExtraHttpApi()
        }else{
            GlobalData.sharedInstance.showWarningSnackBar(msg:GlobalData.sharedInstance.language(key:"loginrequired"))
        }
    }
    func newAndFeartureAddToCompare(productID:String){
        self.productId = productID;
        whichApiToProcess = "addtocompare"
        callingExtraHttpApi()
        
    }
    
    
    
    func viewAllClick(type:String){
        if type == "new"{
            categoryType = "newproduct"
            categoryName = "New Product"
            categoryId = ""
        }else{
            categoryType = "featureproduct"
            categoryName = "Feature Product"
            categoryId = ""
        }
        self.performSegue(withIdentifier: "productcategory", sender: self)
    }
    
    
    func hotDealProductClick(name:String,image:String,id:String){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productName = name
        vc.productImageUrl = image
        vc.productId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func hotDealAddToWishList(productID:String){
        
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            self.productId = productID;
            whichApiToProcess = "addtowishlist"
            callingExtraHttpApi()
        }else{
            GlobalData.sharedInstance.showWarningSnackBar(msg:GlobalData.sharedInstance.language(key:"loginrequired"))
        }
        
    }
    func hotDealAddToCompare(productID:String){
        self.productId = productID;
        whichApiToProcess = "addtocompare"
        callingExtraHttpApi()
        
    }
    
    
    func hotDealViewAllClick(){
        categoryType = "hotdeal"
        categoryName = "HotDeal Product"
        categoryId = ""
        self.performSegue(withIdentifier: "productcategory", sender: self)
    }
    
    
    
    
    
    
    
    
    
    func callingExtraHttpApi(){
        self.view.isUserInteractionEnabled = false
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]();
        if defaults.object(forKey: "storeId") != nil{
            requstParams["storeId"] = defaults.object(forKey: "storeId") as! String
        }
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        let quoteId = defaults.object(forKey:"quoteId");
        if(quoteId != nil){
            requstParams["quoteId"] = quoteId
        }
        
        
        if whichApiToProcess == "addtowishlist"{
            requstParams["productId"] = productId
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/addtoWishlist", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    
                    if errorCode == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg:GlobalData.sharedInstance.language(key: "successwishlist"))
                    }
                    else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key: "errorwishlist"))
                    }
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingExtraHttpApi()
                }
            }
        }else if whichApiToProcess == "addtocompare"{
            requstParams["productId"] = productId
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/addtocompare", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    
                    if errorCode == true{
                        self.showSuccessMessgae(data:data.object(forKey: "message") as! String)
                    }
                    else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg:data.object(forKey: "message") as! String)
                    }
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingExtraHttpApi()
                }
            }
        }
    }
    
    
    func showSuccessMessgae(data:String){
        
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.success)
        info.button?.isHidden = false
        info.configureContent(title: GlobalData.sharedInstance.language(key: "success"), body: data, iconImage: nil, iconText: "👍", buttonImage: nil, buttonTitle: GlobalData.sharedInstance.language(key: "seelist")) { _ in
            SwiftMessages.hide()
            self.performSegue(withIdentifier: "comparelist", sender: self)
        }
        
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        infoConfig.presentationStyle = .bottom
        infoConfig.dimMode = .blur(style: UIBlurEffectStyle.light, alpha: 0.4, interactive: true)
        infoConfig.duration = .forever
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    //MARK:- Recent Views Delegate func
    func recentProductClick(name: String, image: String, id: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productName = name
        vc.productImageUrl = image
        vc.productId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func recentAddToWishList(productID: String) {
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            self.productId = productID;
            whichApiToProcess = "addtowishlist"
            callingExtraHttpApi()
        }else{
            GlobalData.sharedInstance.showWarningSnackBar(msg: "Login Required")
        }
    }
    
    func recentAddToCompare(productID: String) {
        self.productId = productID;
        whichApiToProcess = "addtocompare"
        callingExtraHttpApi()
    }
    
    func recentViewAllClick() {
        //do nothing
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "productcategory") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryName = self.categoryName
            viewController.categoryId = self.categoryId
            viewController.categoryType = self.categoryType
        }
    }
}

