//
//  SellerDetailsViewController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 28/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerDetailsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,sellerProductViewControllerHandlerDelegate,SellerContactControllerHandlerDelegate {
    var profileUrl:String!
    var sellerProfileDetailsViewModel:SellerProfileDetailsViewModel!
    @IBOutlet weak var tableView: UITableView!
    var message:String!
    var whichApiToProcess:String = ""
    var productId:String = ""
    var productName:String!
    var productImage:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "sellerdetails")
        tableView.register(UINib(nibName: "SellerProfileTopViewCell", bundle: nil), forCellReuseIdentifier: "SellerProfileTopViewCell")
        tableView.register(UINib(nibName: "SellerProductTableViewCell", bundle: nil), forCellReuseIdentifier: "SellerProductTableViewCell")
        tableView.register(UINib(nibName: "SellerRatingViewCell", bundle: nil), forCellReuseIdentifier: "SellerRatingViewCell")
        tableView.register(UINib(nibName: "SellerContactTableViewCell", bundle: nil), forCellReuseIdentifier: "SellerContactTableViewCell")
        tableView.register(UINib(nibName: "SellerReviewsCell", bundle: nil), forCellReuseIdentifier: "SellerReviewsCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorColor = UIColor.clear
        
        self.callingHttppApi()
        
    }
    
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        let storeId = defaults.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        requstParams["width"] = width
        requstParams["sellerId"] = profileUrl
        
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/SellerProfile", currentView: self){success,responseObject in
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        defaults .set(storeId, forKey: "storeId")
                    }
                }
                print("sss", responseObject)
                GlobalData.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
                var dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    self.sellerProfileDetailsViewModel = SellerProfileDetailsViewModel(data:dict)
                    self.tableView.delegate = self;
                    self.tableView.dataSource = self
                    self.tableView.reloadDataWithAutoSizingCellWorkAround()
                    
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 3{
            return self.sellerProfileDetailsViewModel.sellerFeedBackList.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerProfileTopViewCell", for: indexPath) as! SellerProfileTopViewCell
            GlobalData.sharedInstance.getImageFromUrl(imageUrl: self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.bannerImage, imageView: cell.bannerImage)
            GlobalData.sharedInstance.getImageFromUrl(imageUrl: self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.profileImage, imageView: cell.sellerProfileImage)
            cell.sellerName.text = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.shopTitle.uppercased()
            cell.ratingValue.text = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.averageRating
            cell.location.text  = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.location
            
            cell.faceBook.addTarget(self, action: #selector(openFacebook(_:)), for: .touchUpInside)
            cell.twitter.addTarget(self, action: #selector(openTwitter(_:)), for: .touchUpInside)
            cell.call.addTarget(self, action: #selector(callClick(_:)), for: .touchUpInside)
            cell.mail.addTarget(self, action: #selector(emailClick(_:)), for: .touchUpInside)
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1{
            
            let cell:SellerProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SellerProductTableViewCell") as! SellerProductTableViewCell
            cell.sellerproducts = self.sellerProfileDetailsViewModel.sellerRecentProduct
            cell.delegate = self
            cell.productCollectionView.reloadData()
            cell.viewAllButton.addTarget(self, action: #selector(viewAllProduct(sender:)), for: .touchUpInside)
            cell.viewAllButton.isUserInteractionEnabled = true;
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 2{
            let cell:SellerRatingViewCell = tableView.dequeueReusableCell(withIdentifier: "SellerRatingViewCell") as! SellerRatingViewCell
            
            cell.makeReviewButton.addTarget(self, action: #selector(makeReview(sender:)), for: .touchUpInside)
            cell.makeReviewButton.isUserInteractionEnabled = true;
            
            
            cell.avgRatingValue.text = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.averageRating
            cell.avgRatingLabel.text = "Average Rating"+"("+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.feedbackcount+")"
            cell.percentageValue.text = String (format:"%.1f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.averageRatingFloatValue/5*100)+" %"+"Positive feed backs";
            
            cell.priceRating1Label.text = "5 Star"+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price5Star)+")"
            cell.priceRating2Label.text = "4 Star"+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price4Star)+")"
            cell.priceRating3Label.text = "3 Star"+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price3Star)+")"
            cell.priceRating4Label.text = "2 Star"+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price2Star)+")"
            cell.priceRating5Label.text = "1 Star"+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price1Star)+")"
            
            let totalPriceValue:Float = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price5Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price4Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price3Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price2Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price1Star
            
            cell.priceRating1Value.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price5Star == 0.0 ? 0 : self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price5Star/totalPriceValue
            cell.priceRating2Value.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price4Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price4Star/totalPriceValue)
            cell.priceRating3Value.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price3Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price3Star/totalPriceValue)
            cell.priceRating4Value.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price2Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price2Star/totalPriceValue)
            cell.priceRating5Value.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price1Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price1Star/totalPriceValue)
            cell.avgPriceRatingValue.text = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.averagePriceRating
            cell.avgPriceRatingLabel.text = GlobalData.sharedInstance.language(key: "averagepricerating")
            
            
            cell.valueRating1Label.text = GlobalData.sharedInstance.language(key: "5Star")+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value5Star)+")"
            cell.valueRating2Label.text = GlobalData.sharedInstance.language(key: "4Star")+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value4Star)+")"
            cell.valueRating3Label.text = GlobalData.sharedInstance.language(key: "3Star")+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value3Star)+")"
            cell.valueRating4Label.text = GlobalData.sharedInstance.language(key: "2Star")+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value2Star)+")"
            cell.valueRating5Label.text = GlobalData.sharedInstance.language(key: "1star")+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value1Star)+")"
            
            let totalValue:Float = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value5Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value4Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value3Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value2Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value1Star
            
            
            cell.valueRating1LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value5Star == 0.0 ? 0 : self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value5Star/totalValue
            cell.valueRating2LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value4Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value4Star/totalValue)
            cell.valueRating3LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value3Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value3Star/totalValue)
            cell.valueRating4LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value2Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value2Star/totalValue)
            cell.valueRating5LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value1Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value1Star/totalValue)
            cell.avgValueRatingValue.text = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.averageValueRating
            cell.avgValueRatingLabel.text = GlobalData.sharedInstance.language(key: "averagevaluerating")
            
            
            
            cell.qualityRating1Label.text = GlobalData.sharedInstance.language(key: "5Star")+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality5Star)+")"
            cell.qualityRating2Label.text = GlobalData.sharedInstance.language(key: "4Star")+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality4Star)+")"
            cell.qualityRating3Label.text = GlobalData.sharedInstance.language(key: "3Star")+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality3Star)+")"
            cell.qualityRating4Label.text = GlobalData.sharedInstance.language(key: "2Star")+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality2Star)+")"
            cell.qualityRating5Label.text = GlobalData.sharedInstance.language(key: "1Star")+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality1Star)+")"
            
            let totalQualityValue:Float = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality5Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality4Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality3Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality2Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality1Star
            
            
            cell.qualityRating1LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality5Star == 0.0 ? 0 : self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality5Star/totalQualityValue
            cell.qualityRating2LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality4Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality4Star/totalQualityValue)
            cell.qualityRating3LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality3Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality3Star/totalQualityValue)
            cell.qualityRating4LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality2Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality2Star/totalQualityValue)
            cell.qualityRating5LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality1Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality1Star/totalQualityValue)
            cell.avgQaulityRatingValue.text = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.averageQualityRating
            cell.avgQualityRatingLabel.text = GlobalData.sharedInstance.language(key: "averagequalityrating")
            
            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerReviewsCell", for: indexPath) as! SellerReviewsCell
            cell.heading.text = "by"+" "+self.sellerProfileDetailsViewModel.sellerFeedBackList[indexPath.row].name+"  "+"on"+" "+self.sellerProfileDetailsViewModel.sellerFeedBackList[indexPath.row].date
            cell.message.text = self.sellerProfileDetailsViewModel.sellerFeedBackList[indexPath.row].description
            cell.valueRating.text = String(format:"%d",self.sellerProfileDetailsViewModel.sellerFeedBackList[indexPath.row].valuerating)
            cell.priceRating.text = String(format:"%d",self.sellerProfileDetailsViewModel.sellerFeedBackList[indexPath.row].pricerating)
            cell.qualityRating.text = String(format:"%d",self.sellerProfileDetailsViewModel.sellerFeedBackList[indexPath.row].qualityrating)
            
            cell.selectionStyle = .none
            return cell
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerContactTableViewCell", for: indexPath) as! SellerContactTableViewCell
            cell.delegate = self
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return SCREEN_WIDTH/2 + 50;
        }
            
        else{
            return UITableViewAutomaticDimension
        }
    }
    
    
    func contactViewClick(value:Int){
        if value == 1{
            message = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.description
            self.performSegue(withIdentifier: "webview", sender: self)
        }else if value == 2{
            message = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.shippingPolicy
            self.performSegue(withIdentifier: "webview", sender: self)
            
        }else if value == 4{
            message = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.returnPolicy
            self.performSegue(withIdentifier: "webview", sender: self)
        }
        else if value == 3{
            self.performSegue(withIdentifier: "sellerreviews", sender: self)
        }
        else if value == 6{
            self.performSegue(withIdentifier: "contactus", sender: self)
        }else if value == 5{
            self.performSegue(withIdentifier: "map", sender: self)
        }
        
        
        
    }
    
    @objc func makeReview(sender: UIButton){
        if defaults.object(forKey: "customerId") != nil {
            self.performSegue(withIdentifier: "makereview", sender: self)
        }else{
            GlobalData.sharedInstance.showWarningSnackBar(msg: "loginrequired".localized)
        }
    }
    
    @objc func viewAllProduct(sender: UIButton){
        self.performSegue(withIdentifier: "marketPlaceToProductCategory", sender: self)
    }
    
    
    
    
    func productClick(name:String,image:String,id:String){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productImageUrl = image
        vc.productName = name
        vc.productId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func addToWishList(productID:String){
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            self.productId = productID;
            whichApiToProcess = "addtowishlist"
            callingExtraHttpApi()
        }else{
            GlobalData.sharedInstance.showWarningSnackBar(msg:GlobalData.sharedInstance.language(key:"loginrequired"))
        }
        
    }
    func addToCompare(productID:String){
        self.productId = productID;
        whichApiToProcess = "addtocompare"
        callingExtraHttpApi()
        
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
                        GlobalData.sharedInstance.showSuccessSnackBar(msg:data.object(forKey: "message") as! String)
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
    
    //MARK:- Profile icons gestures
    @IBAction func openFacebook(_ sender: UIButton) {
        
        let url = URL(string: "http://www.facebook.com/" + self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.facebookId)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func openTwitter(_ sender: UIButton) {
        
        let url = URL(string: "https://twitter.com/" + self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.twitterId)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func emailClick(_ sender: UIButton) {
        
        let emailId = String("")
        
        if let url = URL(string: "mailto:\(String(describing: emailId))"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func callClick(_ sender: UIButton) {
        
        if let url = URL(string: "tel://\(123456)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "webview") {
            let viewController:SellerWebViewController = segue.destination as UIViewController as! SellerWebViewController
            viewController.message = self.message
        }else if (segue.identifier! == "sellerreviews") {
            let viewController:SellerReviewsController = segue.destination as UIViewController as! SellerReviewsController
            viewController.sellerId = self.profileUrl
        }else if (segue.identifier! == "contactus") {
            let viewController:ContactUs = segue.destination as UIViewController as! ContactUs
            viewController.sellerId = self.profileUrl
            viewController.productId = "0"
        }else if (segue.identifier! == "makereview") {
            let viewController:SellerMakeReviewController = segue.destination as UIViewController as! SellerMakeReviewController
            viewController.sellerId = self.profileUrl
            viewController.shopUrl = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.shopUrl
        }else if (segue.identifier! == "marketPlaceToProductCategory") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryName = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.shopTitle
            viewController.categoryType = "marketplace";
            viewController.sellerId = profileUrl
        }else if (segue.identifier! == "map") {
            let viewController:GoogleMap = segue.destination as UIViewController as! GoogleMap
            viewController.countryName = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.location
            
        }
    }
}
