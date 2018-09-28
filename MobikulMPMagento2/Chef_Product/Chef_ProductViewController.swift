//
//  Chef_ProductViewController.swift
//  MobikulMPMagento2
//
//  Created by Othello on 16/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit
import SwiftMessages
var badge:String? = nil
class Chef_ProductViewController: UIViewController,chef_productViewControllerHandlerDelegate,bannerViewControllerHandlerDelegate,CategoryViewControllerHandlerDelegate,hotDealProductViewControllerHandlerDelegate,UISearchBarDelegate,RecentProductViewControllerHandlerDelegate, UITabBarControllerDelegate {
    func hotDealProductClick(name: String, image: String, id: String) {
        
    }
    
    func hotDealAddToWishList(productID: String) {
        
    }
    
    func hotDealAddToCompare(productID: String) {
        
    }
    
    func hotDealViewAllClick() {
        
    }
    
    func recentProductClick(name: String, image: String, id: String) {
        
    }
    
    func recentAddToWishList(productID: String) {
        
    }
    
    func recentAddToCompare(productID: String) {
        
    }
    
    func recentViewAllClick() {
        
    }
    
    func productClick(name: String, image: String, id: String) {
        /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productName = name
        vc.productImageUrl = image
        vc.productId = id*/
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chef_productdetail") as! Chef_DashboardViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func newAndFeartureAddToWishList(productID: String) {
        
    }
    
    func newAndFeartureAddToCompare(productID: String) {
        self.productId = productID;
        self.showSuccessMessgae(data: "Successfully added to compare list")
        //whichApiToProcess = "addtocompare"
        //callingExtraHttpApi()
    }
    
    func viewAllClick(type: String) {
        if type == "new"{
            categoryType = "newproduct"
            categoryName = "New Product"
            categoryId = ""
        }else{
            categoryType = "featureproduct"
            categoryName = "Feature Product"
            categoryId = ""
        }
        //self.performSegue(withIdentifier: "productcategory", sender: self)
    }
    
    func bannerProductClick(type: String, image: String, id: String, title: String) {
        
    }
    
    func categoryProductClick(name: String, ID: String) {
        
    }
    var change:Bool = true
    var responseObject : AnyObject!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var changeViewButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var BannerView: UIView!
    @IBOutlet weak var filterView: UIView!
    
    
    var homeViewModel : Chef_HomeViewModel!
    var productName:String = ""
    var productId:String = ""
    var productImage:String = ""
    var categoryId:String = ""
    var categoryName:String = ""
    var categoryType:String = ""
    var whichApiToProcess:String = ""

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden = true
        super.viewDidAppear(animated)
        BannerView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        
        let btnCart = SSBadgeButton()
        btnCart.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btnCart.setImage(UIImage(named: "Action 4")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnCart.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 10)
        btnCart.badge = "3"
        
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
        filterView.isHidden = true
 
        // Do any additional setup after loading the view.
        let origImage = UIImage(named: "ic_filter")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        filterButton.setImage(tintedImage, for: .normal)
        if change == false{
            let origImage = UIImage(named: "ic_list")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            changeViewButton.setImage(tintedImage, for: .normal)
        }else{
            let origImage = UIImage(named: "ic_grid")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            changeViewButton.setImage(tintedImage, for: .normal)
        }
        
        changeViewButton.tintColor = .black
       
        filterButton.tintColor = .black
        
        homeViewModel = Chef_HomeViewModel()
        productTableView?.register(BannerTableViewCell.nib, forCellReuseIdentifier: BannerTableViewCell.identifier)
        productTableView?.register(TopCategoryTableViewCell.nib, forCellReuseIdentifier: TopCategoryTableViewCell.identifier)
        productTableView?.register(Chef_ProductTableViewCell.nib, forCellReuseIdentifier: Chef_ProductTableViewCell.identifier)
        productTableView?.register(HotdealsTableViewCell.nib, forCellReuseIdentifier: HotdealsTableViewCell.identifier)
        productTableView?.register(RecentViewTableViewCell.nib, forCellReuseIdentifier: RecentViewTableViewCell.identifier)
        var navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.white
   
       
        
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "product")

        self.navigationController?.navigationBar.backItem?.title = ""
        
        self.productTableView?.dataSource = homeViewModel
        self.productTableView?.delegate = homeViewModel
        GlobalVariables.hometableView = productTableView
        self.homeViewModel.homeViewController = self;
        self.productTableView.separatorColor = UIColor.clear
        print("View Didload")
        callingHttppApi();
        self.productTableView.reloadDataWithAutoSizingCellWorkAround()
        //ThemeManager.applyTheme(bar:(self.navigationController?.navigationBar)!)
    }

    func callingHttppApi(){
        DispatchQueue.main.async {
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
                                GlobalData.sharedInstance.dismissLoader(); self.productTableView.reloadDataWithAutoSizingCellWorkAround()
                                //self.navigationController?.isNavigationBarHidden = true
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
                            //self.refreshControl.endRefreshing()
                            GlobalData.sharedInstance.dismissLoader()
                            defaults.removeObject(forKey: "customerId")
                            self.callingHttppApi()
                        }
                    }
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "productcategory") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryName = self.categoryName
            viewController.categoryId = self.categoryId
            viewController.categoryType = self.categoryType
        }
    }
    @IBAction func changeView(_ sender: UIButton)
    {
        if change == false{
            
            change = true
        }else{
            
            change = false
        }
        print("ChangeView Button Clicked")
        self.productTableView.reloadDataWithAutoSizingCellWorkAround()
        if change == false{
            let origImage = UIImage(named: "ic_list")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            changeViewButton.setImage(tintedImage, for: .normal)
        }else{
            let origImage = UIImage(named: "ic_grid")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            changeViewButton.setImage(tintedImage, for: .normal)
        }
        
    }
    @IBAction func filtered(_ sender: UIButton)
    {
        UIView.animate(withDuration: 0.3, delay: 0, options: .layoutSubviews, animations: {
            self.filterView.isHidden = !self.filterView.isHidden
            self.BannerView.isHidden = !self.BannerView.isHidden
        })
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

    @objc func cartButtonClick(sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chef_cartexview") as! Chef_exMyCart
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func searchButtonClick(sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chef_searchview") as! SearchSuggestion
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
