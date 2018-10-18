//
//  Productcategory.swift
//  OpenCartApplication
//
//  Created by Webkul on 30/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit
import SwiftMessages

class SupplierProductcategory: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPickerViewDelegate,FilterItemsDelegate {
    
    var change:Bool = true
    var categoryName:String!
    var categoryId:String!
    var categoryType:String!
    var searchQuery:String = ""
    let defaults = UserDefaults.standard
    var filterCodeValue:NSMutableArray = []
    var filterIdValue:NSMutableArray = []
    var sortDir:String = ""
    var sortItem: String = ""
    var productCollectionViewModel:ProductCollectionViewModel!
    var loadPageRequestFlag: Bool = false
    var totalCount:Int = 0
    var indexPathValue:IndexPath!
    var filterCodeHeader:NSMutableArray = []
    var filterItemValue:NSMutableArray = []
    var pageNumber:Int = 1
    var ratingScrollView: UIScrollView!
    var sortingDictionary:NSArray = []
    var sortSignal:Int = 0
    var sortDirection: NSMutableArray = []
    var sortDataPicker: UIPickerView!
    var productID:String!
    var productName:String!
    var productImageURL:String!
    var whichApiToProcess:String = ""
    var mainCollection:JSON!
    var productCategoryData: NSArray = []
    var sendPopUpData:NSDictionary!
    public var queryString:NSMutableArray!
    var currentIndex:Int = 0
    var filteredItemArray :NSMutableArray = []
    var reloadPageData:Bool = false
    var productQty:String = ""
    var sellerId:String = ""
    var modelTag:Int = 0
    
    @IBOutlet weak var sortbyLabel: UILabel!
    @IBOutlet weak var filterbyLabel: UILabel!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var ic_grid_list_imageview: UIImageView!
    @IBOutlet weak var gridListbyLabel: UILabel!
    @IBOutlet weak var upArrow: UIImageView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var sortView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
       filterView.isHidden = true
         sortView.isHidden = true
        ic_grid_list_imageview.isHidden = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = categoryName
        whichApiToProcess = ""
        let nib = UINib(nibName: "Chef_ProductImageCell", bundle:nil)
        self.productCollectionView.register(nib, forCellWithReuseIdentifier: "chef_productimagecell")
        
        let refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: GlobalData.sharedInstance.language(key: "pulltorefresh"), attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            productCollectionView.refreshControl = refreshControl
        } else {
            productCollectionView.backgroundView = refreshControl
        }
        
        sortbyLabel.text = GlobalData.sharedInstance.language(key: "sort")
        filterbyLabel.text = GlobalData.sharedInstance.language(key: "filter")
        callingHttppApi()
        
        upArrow.image = UIImage(named: "ic_ScrollUp")
        upArrow.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.scorllUp))
        upArrow.addGestureRecognizer(tapGesture)
        upArrow.isHidden = true
        
        gridListbyLabel.text = GlobalData.sharedInstance.language(key: "list")
        ic_grid_list_imageview.image = UIImage(named: "ic_list")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        if self.isMovingToParentViewController{
        }else{
            GlobalData.sharedInstance.removePreviousNetworkCall()
            GlobalData.sharedInstance.dismissLoader()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func scorllUp(_sender : UITapGestureRecognizer){
        let indexPath = IndexPath(row: 0, section: 0)
        productCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y>0) {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }, completion: nil)
        }
    }
    
    @IBAction func changeView(_ sender: UITapGestureRecognizer) {
        if change == false{
            ic_grid_list_imageview.image = UIImage(named: "ic_list")
            change = true
            let nib = UINib(nibName: "ProductImageCell", bundle:nil)
            self.productCollectionView.register(nib, forCellWithReuseIdentifier: "productimagecell")
            productCollectionView.reloadData()
            gridListbyLabel.text = GlobalData.sharedInstance.language(key: "list")
        }else{
            ic_grid_list_imageview.image = UIImage(named: "ic_grid")
            change = false
            let nib = UINib(nibName: "Chef_ListCollectionViewCell", bundle:nil)
            self.productCollectionView.register(nib, forCellWithReuseIdentifier: "chef_listcollectionview")
            productCollectionView.reloadData()
            gridListbyLabel.text = GlobalData.sharedInstance.language(key: "grid")
        }
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        GlobalData.sharedInstance.dismissLoader()
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController!.tabBar.isHidden = false
    }
    
    func callingHttppApi(){
        
        if categoryType == "newproduct"{
            var requstParams = [String:Any]()
            let storeId = defaults.object(forKey:"storeId")
            let quoteId = defaults.object(forKey: "quoteId")
            let customerId = defaults.object(forKey: "customerId")
            
            if storeId != nil{
                requstParams["storeId"] = storeId as! String
            }
            if(quoteId != nil){
                requstParams["quoteId"] = quoteId as! String
            }
            if(customerId != nil){
                requstParams["customerToken"] = customerId as! String
            }
            if defaults.object(forKey: "currency") != nil{
                requstParams["currency"] = defaults.object(forKey: "currency") as! String
            }
            let sortData:NSArray = [sortItem, sortDir]
            let filterData : NSArray = [filterIdValue, filterCodeValue]
            do {
                let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
                let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["sortData"] = jsonSortString
                let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
                let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["filterData"] = jsonFilterString
            }
            catch {
                print(error.localizedDescription)
            }
            requstParams["pageNumber"] = "\(pageNumber)"
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            if pageNumber == 1{
                self.view.isUserInteractionEnabled = false
                GlobalData.sharedInstance.showLoader()
            }
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/newProductList", currentView: self){success,responseObject in
                if success == 1{
                    
                    self.view.isUserInteractionEnabled = true
                    print(responseObject as! NSDictionary)
                    if self.pageNumber == 1{
                        self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                    }else{
                        self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                    }
                    self.doFurtherProcessingWithResult()
                }else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }else if categoryType == "featureproduct"{
            var requstParams = [String:Any]()
            let storeId = defaults.object(forKey:"storeId")
            let quoteId = defaults.object(forKey: "quoteId")
            let customerId = defaults.object(forKey: "customerId")
            
            if storeId != nil{
                requstParams["storeId"] = storeId as! String
            }
            if(quoteId != nil){
                requstParams["quoteId"] = quoteId as! String
            }
            if(customerId != nil){
                requstParams["customerToken"] = customerId as! String
            }
            if defaults.object(forKey: "currency") != nil{
                requstParams["currency"] = defaults.object(forKey: "currency") as! String
            }
            let sortData:NSArray = [sortItem, sortDir]
            let filterData : NSArray = [filterIdValue, filterCodeValue]
            do {
                let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
                let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["sortData"] = jsonSortString
                let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
                let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["filterData"] = jsonFilterString
            }
            catch {
                print(error.localizedDescription)
            }
            requstParams["pageNumber"] = "\(pageNumber)"
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            if pageNumber == 1{
                self.view.isUserInteractionEnabled = false
                GlobalData.sharedInstance.showLoader()
            }
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/featuredProductList", currentView: self){success,responseObject in
                if success == 1{
                    
                    self.view.isUserInteractionEnabled = true
                    if self.pageNumber == 1{
                        self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                    }else{
                        self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                    }
                    self.doFurtherProcessingWithResult()
                }else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }else if categoryType == "hotdeal"{
            var requstParams = [String:Any]()
            let storeId = defaults.object(forKey:"storeId")
            let quoteId = defaults.object(forKey: "quoteId")
            let customerId = defaults.object(forKey: "customerId")
            
            if storeId != nil{
                requstParams["storeId"] = storeId as! String
            }
            if(quoteId != nil){
                requstParams["quoteId"] = quoteId as! String
            }
            if(customerId != nil){
                requstParams["customerToken"] = customerId as! String
            }
            if defaults.object(forKey: "currency") != nil{
                requstParams["currency"] = defaults.object(forKey: "currency") as! String
            }
            let sortData:NSArray = [sortItem, sortDir]
            let filterData : NSArray = [filterIdValue, filterCodeValue]
            do {
                let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
                let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["sortData"] = jsonSortString
                let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
                let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["filterData"] = jsonFilterString
            }
            catch {
                print(error.localizedDescription)
            }
            requstParams["pageNumber"] = "\(pageNumber)"
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            if pageNumber == 1{
                self.view.isUserInteractionEnabled = false
                GlobalData.sharedInstance.showLoader()
            }
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/hotDealList", currentView: self){success,responseObject in
                if success == 1{
                    print(responseObject)
                    self.view.isUserInteractionEnabled = true
                    if self.pageNumber == 1{
                        self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                    }else{
                        self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                    }
                    self.doFurtherProcessingWithResult()
                }else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }else if categoryType == "searchquery"{
            var requstParams = [String:Any]()
            let storeId = defaults.object(forKey:"storeId")
            let quoteId = defaults.object(forKey: "quoteId")
            let customerId = defaults.object(forKey: "customerId")
            
            if storeId != nil{
                requstParams["storeId"] = storeId as! String
            }
            if(quoteId != nil){
                requstParams["quoteId"] = quoteId as! String
            }
            if(customerId != nil){
                requstParams["customerToken"] = customerId as! String
            }
            if defaults.object(forKey: "currency") != nil{
                requstParams["currency"] = defaults.object(forKey: "currency") as! String
            }
            let sortData:NSArray = [sortItem, sortDir]
            let filterData : NSArray = [filterIdValue, filterCodeValue]
            do {
                let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
                let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["sortData"] = jsonSortString
                let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
                let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["filterData"] = jsonFilterString
            }
            catch {
                print(error.localizedDescription)
            }
            requstParams["pageNumber"] = "\(pageNumber)"
            requstParams["searchQuery"] = searchQuery
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            if pageNumber == 1{
                self.view.isUserInteractionEnabled = false
                GlobalData.sharedInstance.showLoader()
            }
            
            if self.defaults.object(forKey: "currency") != nil{
                requstParams["currency"] = self.defaults.object(forKey: "currency") as! String
            }
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/searchResult", currentView: self){success,responseObject in
                if success == 1{
                    
                    print(responseObject)
                    self.view.isUserInteractionEnabled = true
                    if self.pageNumber == 1{
                        self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                    }else{
                        self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                    }
                    self.doFurtherProcessingWithResult()
                }else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }else if categoryType == "advancesearch"{
            var requstParams = [String:Any]()
            let storeId = defaults.object(forKey:"storeId")
            let quoteId = defaults.object(forKey: "quoteId")
            let customerId = defaults.object(forKey: "customerId")
            
            if storeId != nil{
                requstParams["storeId"] = storeId as! String
            }
            if(quoteId != nil){
                requstParams["quoteId"] = quoteId as! String
            }
            if(customerId != nil){
                requstParams["customerToken"] = customerId as! String
            }
            if defaults.object(forKey: "currency") != nil{
                requstParams["currency"] = defaults.object(forKey: "currency") as! String
            }
            let sortData:NSArray = [sortItem, sortDir]
            let filterData : NSArray = [filterIdValue, filterCodeValue]
            do {
                let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
                let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["sortData"] = jsonSortString
                
                let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
                let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["filterData"] = jsonFilterString
                
                let jsonQueyrFilterData =  try JSONSerialization.data(withJSONObject: queryString, options: .prettyPrinted)
                let jsonQueryFilterString:String = NSString(data: jsonQueyrFilterData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["queryString"] = jsonQueryFilterString
            }
            catch {
                print(error.localizedDescription)
            }
            requstParams["pageNumber"] = "\(pageNumber)"
            
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            if pageNumber == 1{
                self.view.isUserInteractionEnabled = false
                GlobalData.sharedInstance.showLoader()
            }
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/advancedsearchresult", currentView: self){success,responseObject in
                if success == 1{
                    
                    print(responseObject)
                    self.view.isUserInteractionEnabled = true
                    if self.pageNumber == 1{
                        self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                    }else{
                        self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                    }
                    self.doFurtherProcessingWithResult()
                }else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }else if categoryType == "custom"{
            var requstParams = [String:Any]()
            let storeId = defaults.object(forKey:"storeId")
            let quoteId = defaults.object(forKey: "quoteId")
            let customerId = defaults.object(forKey: "customerId")
            
            if storeId != nil{
                requstParams["storeId"] = storeId as! String
            }
            if(quoteId != nil){
                requstParams["quoteId"] = quoteId as! String
            }
            if(customerId != nil){
                requstParams["customerToken"] = customerId as! String
            }
            if defaults.object(forKey: "currency") != nil{
                requstParams["currency"] = defaults.object(forKey: "currency") as! String
            }
            let sortData:NSArray = [sortItem, sortDir]
            let filterData : NSArray = [filterIdValue, filterCodeValue]
            do {
                let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
                let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["sortData"] = jsonSortString
                
                let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
                let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["filterData"] = jsonFilterString
            }
            catch {
                print(error.localizedDescription)
            }
            requstParams["pageNumber"] = "\(pageNumber)"
            requstParams["notificationId"] = categoryId
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            if pageNumber == 1{
                self.view.isUserInteractionEnabled = false
                GlobalData.sharedInstance.showLoader()
            }
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/extra/customcollection", currentView: self){success,responseObject in
                if success == 1{
                    print(responseObject)
                    self.view.isUserInteractionEnabled = true
                    if self.pageNumber == 1{
                        self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                    }else{
                        self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                    }
                    self.doFurtherProcessingWithResult()
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else if categoryType == "marketplace"{
            var requstParams = [String:Any]()
            let storeId = defaults.object(forKey:"storeId")
            let quoteId = defaults.object(forKey: "quoteId")
            let customerId = defaults.object(forKey: "customerId")
            
            if storeId != nil{
                requstParams["storeId"] = storeId as! String
            }
            if(quoteId != nil){
                requstParams["quoteId"] = quoteId as! String
            }
            if(customerId != nil){
                requstParams["customerToken"] = customerId as! String
            }
            if defaults.object(forKey: "currency") != nil{
                requstParams["currency"] = defaults.object(forKey: "currency") as! String
            }
            
            let sortData:NSArray = [sortItem, sortDir]
            let filterData : NSArray = [filterIdValue, filterCodeValue]
            do {
                let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
                let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["sortData"] = jsonSortString
                let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
                let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["filterData"] = jsonFilterString
            }
            catch {
                print(error.localizedDescription)
            }
            
            requstParams["categoryId"] = "0" 
            requstParams["pageNumber"] = "\(pageNumber)"
            requstParams["sellerId"] = sellerId
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            if pageNumber == 1{
                self.view.isUserInteractionEnabled = false
                GlobalData.sharedInstance.showLoader()
            }
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/SellerCollection", currentView: self){success,responseObject in
                if success == 1{
                    print(responseObject)
                    self.view.isUserInteractionEnabled = true
                    if self.pageNumber == 1{
                        self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                    }else{
                        self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                    }
                    self.doFurtherProcessingWithResult()
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else{
            var requstParams = [String:Any]()
            let storeId = defaults.object(forKey:"storeId")
            let quoteId = defaults.object(forKey: "quoteId")
            let customerId = defaults.object(forKey: "customerId")
            
            if storeId != nil{
                requstParams["storeId"] = storeId as! String
            }
            if(quoteId != nil){
                requstParams["quoteId"] = quoteId as! String
            }
            if(customerId != nil){
                requstParams["customerToken"] = customerId as! String
            }
            if defaults.object(forKey: "currency") != nil{
                requstParams["currency"] = defaults.object(forKey: "currency") as! String
            }
            let sortData:NSArray = [sortItem, sortDir]
            let filterData : NSArray = [filterIdValue, filterCodeValue]
            do {
                let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
                let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["sortData"] = jsonSortString
                let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
                let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["filterData"] = jsonFilterString
            }
            catch {
                print(error.localizedDescription)
            }
            requstParams["pageNumber"] = "\(pageNumber)"
            requstParams["categoryId"] = categoryId
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            if pageNumber == 1{
                self.view.isUserInteractionEnabled = false
                GlobalData.sharedInstance.showLoader()
            }
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/catalog/categoryProductList", currentView: self){success,responseObject in
                
                if success == 1{
                    print(responseObject)
                    self.view.isUserInteractionEnabled = true
                    if self.pageNumber == 1{
                        self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                    }else{
                        self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                    }
                    self.doFurtherProcessingWithResult()
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(){
        if pageNumber == 1{
            GlobalData.sharedInstance.dismissLoader()
        }
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.reloadData()
        totalCount = productCollectionViewModel.totalCount
        self.navigationItem.prompt = "\(productCollectionViewModel.totalCount)"+" "+GlobalData.sharedInstance.language(key: "items")
        loadPageRequestFlag = true
        
        if totalCount == 0  {
            GlobalData.sharedInstance.showWarningSnackBar(msg: "searchproductsnotavailable".localized)
        }
        
        if self.sortSignal == 0 {
            for i in 0..<self.productCollectionViewModel.getSortCollectionData.count {
                if i == 0 {
                    self.sortDirection.add("1")
                }else {
                    self.sortDirection.add("0")
                }
            }
            self.sortSignal += 1
        }
    }
    
    func collectionView(_ view: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return productCollectionViewModel.getProductCollectionData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if change == true{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chef_productimagecell", for: indexPath) as! Chef_ProductImageCell
            cell.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
            cell.layer.borderWidth = 0.5
            cell.productImage.image = UIImage(named: "ic_placeholder.png")
            cell.productName.text = productCollectionViewModel.getProductCollectionData[indexPath.row].productName
            cell.productPrice.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].price
            cell.productDescription.text = productCollectionViewModel.getProductCollectionData[indexPath.row].descriptionData
            cell.productDescription.isHidden = false;
            if(cell.productDescription.text == ""){
                cell.productDescription.text = "No Descriptions";
            }
            cell.addButton.isHidden = true;
            //cell.addButton.tag = indexPath.row
            //cell.addButton.addTarget(self, action: #selector(addButtonClick(sender:)), for: .touchUpInside)
            GlobalData.sharedInstance.getImageFromUrl(imageUrl:productCollectionViewModel.getProductCollectionData[indexPath.row].productImage , imageView: cell.productImage)
            cell.specialPrice.isHidden = true
            if productCollectionViewModel.getProductCollectionData[indexPath.row].isInWishlist == true{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
                
            }else{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
            }
            //cell = productCollectionViewModel.getProductCollectionData[indexPath.row].descriptionData
            
            cell.wishListButton.tag = indexPath.row
            cell.wishListButton.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
            cell.wishListButton.isUserInteractionEnabled = true
            cell.addToCompareButton.isHidden = true;
            
            //cell.addToCompareButton.tag = indexPath.row
            //cell.addToCompareButton.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
            //cell.addToCompareButton.isUserInteractionEnabled = true
            
            
            if productCollectionViewModel.getProductCollectionData[indexPath.row].typeID == "grouped"{
                cell.productPrice.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].groupedPrice
                
            }else if productCollectionViewModel.getProductCollectionData[indexPath.row].typeID == "bundle"{
                cell.productPrice.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].formatedMinPrice
                
            }else{
                if productCollectionViewModel.getProductCollectionData[indexPath.row].isInRange == true{
                    if productCollectionViewModel.getProductCollectionData[indexPath.row].specialPrice < productCollectionViewModel.getProductCollectionData[indexPath.row].normalprice{
                        cell.productPrice.text = productCollectionViewModel.getProductCollectionData[indexPath.row].formatedSpecialPrice
                        let attributeString = NSMutableAttributedString(string: productCollectionViewModel.getProductCollectionData[indexPath.row].formatedPrice)
                        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                        cell.specialPrice.attributedText = attributeString
                        cell.specialPrice.isHidden = false
                    }else{
                        cell.productPrice.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].price
                        cell.specialPrice.isHidden = true
                    }
                }
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chef_listcollectionview", for: indexPath) as! Chef_ListCollectionViewCell
            cell.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
            cell.layer.borderWidth = 0.5
            cell.imageView.image = UIImage(named: "ic_placeholder.png")
            cell.name.text = productCollectionViewModel.getProductCollectionData[indexPath.row].productName
            cell.price.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].price
            cell.descriptionData.text = productCollectionViewModel.getProductCollectionData[indexPath.row].descriptionData
            cell.addButton.isHidden = true;
            //cell.addButton.tag = indexPath.row
            //cell.addButton.addTarget(self, action: #selector(addButtonClick(sender:)), for: .touchUpInside)
            GlobalData.sharedInstance.getImageFromUrl(imageUrl:productCollectionViewModel.getProductCollectionData[indexPath.row].productImage , imageView: cell.imageView)
            cell.wishList_Button.tag = indexPath.row
            cell.compare_Button.tag = indexPath.row
            
            cell.specialPrice.isHidden = true
            
            
            if productCollectionViewModel.getProductCollectionData[indexPath.row].isInWishlist == true{
                cell.wishList_Button.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
            }else{
                cell.wishList_Button.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
            }
            
            cell.wishList_Button.tag = indexPath.row
            cell.wishList_Button.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
            cell.wishList_Button.isUserInteractionEnabled = true
            
            cell.compare_Button.tag = indexPath.row
            cell.compare_Button.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
            cell.compare_Button.isUserInteractionEnabled = true
            
            if productCollectionViewModel.getProductCollectionData[indexPath.row].isInRange == true{
                if productCollectionViewModel.getProductCollectionData[indexPath.row].specialPrice < productCollectionViewModel.getProductCollectionData[indexPath.row].normalprice{
                    cell.price.text = productCollectionViewModel.getProductCollectionData[indexPath.row].formatedSpecialPrice
                    let attributeString = NSMutableAttributedString(string: productCollectionViewModel.getProductCollectionData[indexPath.row].formatedPrice)
                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                    cell.specialPrice.attributedText = attributeString
                    cell.specialPrice.isHidden = false
                }else{
                    cell.price.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].price
                    cell.specialPrice.isHidden = true
                }
            }
            return cell
        }
    }
    @objc func addButtonClick(sender: UIButton){
        /*
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chef_productdetail") as! Chef_DashboardViewController
        vc.productImageUrl = productCollectionViewModel.getProductCollectionData[sender.tag].productImage
        vc.productName = productCollectionViewModel.getProductCollectionData[sender.tag].productName
        vc.productId = productCollectionViewModel.getProductCollectionData[sender.tag].id
        self.navigationController?.pushViewController(vc, animated: true)
        */
    }
    
    @objc func addToWishList(sender: UIButton){
        let customerId = defaults.object(forKey: "customerId")
        if customerId != nil{
            
            let wishListFlag = productCollectionViewModel.getProductCollectionData[sender.tag].isInWishlist
            
            if !wishListFlag!{
                productID = productCollectionViewModel.getProductCollectionData[sender.tag].id
                whichApiToProcess = "addtowishlist"
                sender.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
                modelTag = sender.tag
                
                
                callingExtraHttpApi()
            }else{
                productID = productCollectionViewModel.getProductCollectionData[sender.tag].wishlistItemId
                whichApiToProcess = "removewishlist"
                sender.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
                modelTag = sender.tag
                productCollectionViewModel.setWishListFlagToProductCategoryModel(data:false , pos: sender.tag)
                callingExtraHttpApi()
            }
        }else{
            GlobalData.sharedInstance.showWarningSnackBar(msg: GlobalData.sharedInstance.language(key: "loginrequired"))
        }
    }
    
    @objc func addToCompare(sender: UIButton){
        productID = productCollectionViewModel.getProductCollectionData[sender.tag].id
        whichApiToProcess = "addtocompare"
        callingExtraHttpApi()
    }
    
    func callingExtraHttpApi(){
        self.view.isUserInteractionEnabled = false
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]()
        if defaults.object(forKey: "storeId") != nil{
            requstParams["storeId"] = defaults.object(forKey: "storeId") as! String
        }
        let customerId = defaults.object(forKey:"customerId")
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        let quoteId = defaults.object(forKey:"quoteId")
        if(quoteId != nil){
            requstParams["quoteId"] = quoteId
        }
        
        if whichApiToProcess == "addtowishlist"{
            requstParams["productId"] = productID
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
                    let data = JSON(responseObject as! NSDictionary)
                    
                    if data["success"].boolValue == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg:GlobalData.sharedInstance.language(key: "successwishlist"))
                        self.productCollectionViewModel.setWishListFlagToProductCategoryModel(data:true , pos: self.modelTag)
                        self.productCollectionViewModel.setWishListItemIdToProductCategoryModel(data:data["itemId"].stringValue , pos: self.modelTag)
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key: "errorwishlist"))
                    }
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingExtraHttpApi()
                }
            }
        }else if whichApiToProcess == "addtocompare"{
            requstParams["productId"] = productID
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
        }else if whichApiToProcess == "removewishlist"{
            
            GlobalData.sharedInstance.showLoader()
            self.view.isUserInteractionEnabled = false
            var requstParams = [String:Any]()
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            requstParams["itemId"] = productID
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/removefromWishlist", currentView: self){success,responseObject in
                if success == 1{
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                        self.productCollectionViewModel.setWishListFlagToProductCategoryModel(data:false , pos: self.modelTag)
                    }
                    
                    
                }else if success == 2{
                    self.callingExtraHttpApi()
                    GlobalData.sharedInstance.dismissLoader()
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if change == false{
            return CGSize(width: collectionView.frame.size.width, height:SCREEN_WIDTH/2 + 50 )
        }else{
            return CGSize(width: collectionView.frame.size.width/2, height:SCREEN_WIDTH/2.5 + 120)
        }
    }
    
    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chef_productdetail") as! Chef_DashboardViewController
        vc.productImageUrl = productCollectionViewModel.getProductCollectionData[indexPath.row].productImage
        vc.productName = productCollectionViewModel.getProductCollectionData[indexPath.row].productName
        vc.productId = productCollectionViewModel.getProductCollectionData[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func filterBY(_ sender: UITapGestureRecognizer) {
        if productCollectionViewModel.layeredData.count > 0{
            let myVC = storyboard?.instantiateViewController(withIdentifier: "FilterListViewController") as! FilterListViewController
            myVC.layeredDataForFilter = productCollectionViewModel.getAllLayerData
            myVC.delegate = self
            myVC.filteredItemArray2 = filteredItemArray
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController!.present(myVC, animated: true, completion: nil)
        }else{
            if(filteredItemArray.count>0){
                let myVC = storyboard?.instantiateViewController(withIdentifier: "FilterListViewController") as! FilterListViewController
                myVC.layeredDataForFilter = productCollectionViewModel.layeredData as NSArray
                myVC.delegate = self
                myVC.filteredItemArray2 = filteredItemArray
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController!.present(myVC, animated: true, completion: nil)
            }else{
                GlobalData.sharedInstance.showWarningSnackBar(msg: GlobalData.sharedInstance.language(key: "nofilteroption"))
            }
        }
    }
    
    @IBAction func sortBy(_ sender: UITapGestureRecognizer) {
        if self.productCollectionViewModel.getSortCollectionData.count == 0{
            GlobalData.sharedInstance.showWarningSnackBar(msg:GlobalData.sharedInstance.language(key: "nosortingdata"))
        }else{
            let alert = UIAlertController(title: GlobalData.sharedInstance.language(key: "chooseyoursortselection"), message: nil, preferredStyle: .actionSheet)
            for i in 0..<self.productCollectionViewModel.getSortCollectionData.count {
                var image:UIImage!
                if (sortDirection[i] as AnyObject).isEqual("0") {
                    image = UIImage(named: "ic_up")
                }else{
                    image = UIImage(named: "ic_down")
                }
                
                let str : String = productCollectionViewModel.getSortCollectionData[i].label
                let action = UIAlertAction(title: str, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    self.selectSortData(data:i)
                })
                action.setValue(image, forKey: "image")
                alert.addAction(action)
            }
            
            let cancel = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            })
            alert.addAction(cancel)
            
            // Support display in iPad
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func selectSortData(data:Int){
        if (sortDirection[data] as AnyObject).isEqual("0") {
            sortDirection[data] = "1"
            sortDir = "1"
        }
        else {
            sortDirection[data] = "0"
            sortDir = "0"
        }
        sortItem = self.productCollectionViewModel.getSortCollectionData[data].code
        pageNumber = 1
        whichApiToProcess = ""
        callingHttppApi()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellCount = self.productCollectionView.numberOfItems(inSection: 0)
        for cell: UICollectionViewCell in self.productCollectionView.visibleCells {
            indexPathValue = self.productCollectionView.indexPath(for: cell)!
            if indexPathValue.row == self.productCollectionView.numberOfItems(inSection: 0) - 1 {
                if (totalCount > currentCellCount) && loadPageRequestFlag{
                    loadPageRequestFlag = false
                    pageNumber += 1
                    callingHttppApi()
                }
            }
            
            if cell.frame.origin.y > SCREEN_HEIGHT - 50{
                upArrow.isHidden = false
            }else{
                upArrow.isHidden = true
            }
        }
    }
    
    func updateArray(dictArray: NSDictionary, code: String){
        filteredItemArray.add(dictArray)
        dismiss(animated: true, completion: nil)
        filterCodeValue.add(code)
        filterIdValue.add(dictArray["id"] as! String)
        pageNumber = 1
        self.callingHttppApi()
    }
    
    func removeFromArray(postion: Int){
        filteredItemArray.removeObject(at: postion)
        filterCodeValue.removeObject(at: postion)
        filterIdValue.removeObject(at: postion)
        dismiss(animated: true, completion: nil)
        pageNumber = 1
        self.callingHttppApi()
    }
    
    func removeAllObjFromArray(){
        filteredItemArray.removeAllObjects()
        filterCodeValue.removeAllObjects()
        filterIdValue.removeAllObjects()
        
        dismiss(animated: true, completion: nil)
        pageNumber = 1
        self.callingHttppApi()
    }
}
