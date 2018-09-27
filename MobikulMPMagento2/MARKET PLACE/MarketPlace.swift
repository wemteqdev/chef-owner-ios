//
//  MarketPlace.swift
//  MobikulMp
//
//  Created by kunal prasad on 13/01/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class MarketPlace: UIViewController,UIWebViewDelegate {
    
    
    var mainCollection:JSON!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
    var productId:String!
    var productName:String!
    var productType:String!
    var parentClass:String!
    var profileUrl:String!
    var sellerId:String!
    var sellerName:String!
    
    
    @IBOutlet weak var view2HeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var view2BannerImageView: UIImageView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var topSpaceBannerLabel: UILabel!
    @IBOutlet weak var topBannerButtonLabel: UIButton!
    @IBOutlet weak var heading1Label: UILabel!
    @IBOutlet weak var heading1Value: UILabel!
    @IBOutlet weak var heading2Label: UILabel!
    @IBOutlet weak var heading2Value: UILabel!
    @IBOutlet weak var heading3Lable: UILabel!
    @IBOutlet weak var heading3Value: UILabel!
    @IBOutlet weak var heading4Label: UILabel!
    @IBOutlet weak var heading4Value: UILabel!
    @IBOutlet weak var heading5Label: UILabel!
    @IBOutlet weak var heading5Value: UILabel!
    @IBOutlet weak var heading6Label: UILabel!
    @IBOutlet weak var heading6Value: UILabel!
    @IBOutlet weak var heading7Label: UILabel!
    @IBOutlet weak var heading7Value: UILabel!
    @IBOutlet weak var heading8Label: UILabel!
    @IBOutlet weak var heading8Value: UILabel!
    @IBOutlet weak var heading9Label: UILabel!
    @IBOutlet weak var heading9Value: UILabel!
    @IBOutlet weak var heading10Label: UILabel!
    @IBOutlet weak var heading10Value: UILabel!
    
    
    
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view3HeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var view3BannerImageView: UIImageView!
    @IBOutlet weak var view3BannerLabel: UILabel!
    @IBOutlet weak var view3heading1Label: UILabel!
    @IBOutlet weak var view3icon1: UIImageView!
    @IBOutlet weak var view3icon1LabelValue: UILabel!
    @IBOutlet weak var view3icon2: UIImageView!
    @IBOutlet weak var view3label2Value: UILabel!
    @IBOutlet weak var view3icon3: UIImageView!
    @IBOutlet weak var view3Label3Value: UILabel!
    @IBOutlet weak var view3icon4: UIImageView!
    @IBOutlet weak var view3Label4Value: UILabel!
    @IBOutlet weak var view3icon5: UIImageView!
    @IBOutlet weak var view3Label5Value: UILabel!
    @IBOutlet weak var view3heading2Label: UILabel!
    @IBOutlet weak var view3HugeLabel: UILabel!
    @IBOutlet weak var view3HugeLabelValue: UILabel!
    @IBOutlet weak var view3AskQuestionLabel: UILabel!
    @IBOutlet weak var view3AskQuestionLabelValue: UILabel!
    @IBOutlet weak var view3QuickPaymentLabel: UILabel!
    @IBOutlet weak var view3QuickPaymentLabelValue: UILabel!
    @IBOutlet weak var view3ManageOrderLabel: UILabel!
    @IBOutlet weak var view3ManageOrderLabelValue: UILabel!
    @IBOutlet weak var view3EarnBadgesLabel: UILabel!
    @IBOutlet weak var view3EarnbadgesLabelValue: UILabel!
    @IBOutlet weak var view3GetVerifiedLabel: UILabel!
    @IBOutlet weak var view3getVerifiedLabelValue: UILabel!
    @IBOutlet weak var view3CustomizeProfileLabel: UILabel!
    @IBOutlet weak var view3CustomizeProfileLabelValue: UILabel!
    @IBOutlet weak var view3AddMediaLabel: UILabel!
    @IBOutlet weak var view3AddmediaLabelValue: UILabel!
    @IBOutlet weak var view3heading3Label: UILabel!
    
    
    
    
    
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view1HeghtConsraints: NSLayoutConstraint!
    @IBOutlet weak var view1HeadingImageView: UIImageView!
    @IBOutlet weak var View1BannerHeading: UILabel!
    @IBOutlet weak var view1Heading1Label: UILabel!
    @IBOutlet weak var view1Icon: UIImageView!
    @IBOutlet weak var view1IconLabel1: UILabel!
    @IBOutlet weak var view1Icon2: UIImageView!
    @IBOutlet weak var view1IconLabel2: UILabel!
    @IBOutlet weak var view1Icon3: UIImageView!
    @IBOutlet weak var view1IconLabel3: UILabel!
    @IBOutlet weak var view1Icon4: UIImageView!
    @IBOutlet weak var view1IconLabel4: UILabel!
    @IBOutlet weak var view1HeadingLabel2: UILabel!
    @IBOutlet weak var view1SellerDataView: UIView!
    @IBOutlet weak var view1SellerDataViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var view1HeadingLabel3: UILabel!
    @IBOutlet weak var view1HeadingLabel4: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    
    @IBOutlet weak var webViewHeightConstarints: NSLayoutConstraint!
    
    
    
    
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "marketplace")
        
        
        queue.maxConcurrentOperationCount = 20;
        callingHttppApi();
        view2HeightConstarints.constant = 0;
        view2.isHidden = true;
        view3HeightConstarints.constant = 0;
        view3.isHidden = true;
        view1.isHidden = true
        
        view1.backgroundColor = UIColor.white
        view2.backgroundColor = UIColor.white
        view3.backgroundColor = UIColor.white
        self.mainView.backgroundColor = UIColor.white
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
    }
    
    
    
    
    
    
    
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        requstParams["websiteId"] = DEFAULT_WEBSITE_ID
        let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        let storeId = defaults.object(forKey: "storeId")
        requstParams["width"] = width
        if(storeId != nil){
            requstParams["storeId"] = storeId
            
        }
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/landingPageData", currentView: self){success,responseObject in
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        defaults .set(storeId, forKey: "storeId")
                    }
                }
                GlobalData.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
                print("sss", responseObject)
                self.doFurtherProcessingWithResult(data: responseObject as! NSDictionary)
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    @IBAction func View1OpenYourshopClick(_ sender: Any) {
        let customerId = defaults.object(forKey:"customerId")
        if customerId == nil{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BecomesPartnerController") as! BecomesPartnerController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            if defaults.object(forKey: "isSeller") as! String == "t" && defaults.object(forKey: "isPending") as! String == "f"  {
                GlobalData.sharedInstance.showSuccessSnackBar(msg: GlobalData.sharedInstance.language(key:"Youarealreadysellingwithus"))
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BecomesPartnerController") as! BecomesPartnerController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    @IBAction func view1ViewAll(_ sender: Any) {
        self.performSegue(withIdentifier: "marketPlaceToAllSellerList", sender: self)
        
    }
    
    
    
    
    
    
    func doFurtherProcessingWithResult(data :NSDictionary){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true;
            self.mainCollection = JSON(data);
            print(data)
            
            if self.mainCollection["pageLayout"].stringValue == "2"{
                self.view1HeghtConsraints.constant = 0;
                self.showLatout2View();
            }
            else if self.mainCollection["pageLayout"].stringValue == "3"{
                self.view1HeghtConsraints.constant = 0;
                self.showLatout3View();
            }
            else if self.mainCollection["pageLayout"].stringValue == "1"{
                self.showLatout1View();
            }
            
        }
    }
    
    
    func showLatout2View(){
        view2HeightConstarints.constant = 1500;
        mainViewHeightConstarints.constant = 1500;
        view2.isHidden = false;
        topBannerButtonLabel.setTitle(self.mainCollection["layout2"]["bannerContent"].string, for: .normal)
        topSpaceBannerLabel.text = self.mainCollection["layout2"]["buttonLabel"].stringValue
        let imageUrl = self.mainCollection["layout2"]["bannerImage"].stringValue
        
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:imageUrl , imageView: self.view2BannerImageView)
        heading1Value.text = GlobalData.sharedInstance.language(key:"hugebuyersmessage")
        heading2Value.text = GlobalData.sharedInstance.language(key: "askquestionmessage")
        heading3Value.text = GlobalData.sharedInstance.language(key: "quickpaymentmessage")
        heading4Value.text = GlobalData.sharedInstance.language(key:"manageyourordermessage")
        heading5Value.text = GlobalData.sharedInstance.language(key:"earnbadgesmessage")
        heading6Value.text = GlobalData.sharedInstance.language(key:"getyourselfverifiedmessage")
        heading7Value.text = GlobalData.sharedInstance.language(key:"customizeprofilemessage")
        heading8Value.text = GlobalData.sharedInstance.language(key:"createyourcollectionmessage")
        heading9Value.text = GlobalData.sharedInstance.language(key:"addmediamessage")
        heading10Value.text = GlobalData.sharedInstance.language(key:"addunlimitedproductsmessage")
    }
    
    func showLatout3View(){
        
        view3.isHidden = false
        view3HeightConstarints.constant = 1400;
        self.mainViewHeightConstarints.constant = 1500;
        view3HugeLabelValue.text = GlobalData.sharedInstance.language(key:"hugebuyersmessage")
        view3AskQuestionLabelValue.text = GlobalData.sharedInstance.language(key:"askquestionmessage")
        view3QuickPaymentLabelValue.text = GlobalData.sharedInstance.language(key:"quickpaymentmessage")
        view3ManageOrderLabelValue.text = GlobalData.sharedInstance.language(key:"manageyourordermessage")
        view3EarnbadgesLabelValue.text = GlobalData.sharedInstance.language(key:"earnbadgesmessage")
        view3getVerifiedLabelValue.text = GlobalData.sharedInstance.language(key:"getyourselfverifiedmessage")
        view3CustomizeProfileLabelValue.text = GlobalData.sharedInstance.language(key:"customizeprofilemessage")
        view3AddmediaLabelValue.text = GlobalData.sharedInstance.language(key:"addmediamessage")
        view3heading1Label.text = self.mainCollection["layout3"]["headingOne"].stringValue
        view3heading2Label.text = self.mainCollection["layout3"]["headingTwo"].stringValue
        view3heading3Label.text = self.mainCollection["layout3"]["headingThree"].stringValue
        
        view3icon1LabelValue.text = self.mainCollection["layout3"]["labelOne"].stringValue
        view3label2Value.text = self.mainCollection["layout3"]["labelTwo"].stringValue
        view3Label3Value.text = self.mainCollection["layout3"]["labelThree"].stringValue
        view3Label4Value.text = self.mainCollection["layout3"]["labelFour"].stringValue
        view3Label5Value.text = self.mainCollection["layout3"]["labelFive"].stringValue
        
        view3BannerLabel.text = self.mainCollection["layout3"]["bannerContent"].stringValue.html2String
        let imageUrl1 = self.mainCollection["layout3"]["bannerImage"].stringValue
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:imageUrl1 , imageView: self.view3BannerImageView)
        
        
        
        
        let imageUrl2 = self.mainCollection["layout3"]["iconOne"].stringValue
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:imageUrl2 , imageView: self.view3icon1)
        
        let imageUrl3 = self.mainCollection["layout3"]["iconTwo"].stringValue
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:imageUrl3 , imageView: self.view3icon2)
        
        let imageUrl4 = self.mainCollection["layout3"]["iconThree"].stringValue
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:imageUrl4 , imageView: self.view3icon3)
        
        let imageUrl5 = self.mainCollection["layout3"]["iconFour"].stringValue
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:imageUrl5 , imageView: self.view3icon4)
        
        let imageUrl6 = self.mainCollection["layout3"]["iconFive"].stringValue
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:imageUrl6 , imageView: self.view3icon5)
        
        
    }
    
    func showLatout1View(){
        view1.isHidden = false
        View1BannerHeading.text = self.mainCollection["layout1"]["bannerContent"].stringValue.html2String
        view1IconLabel1.text = self.mainCollection["layout1"]["labelOne"].stringValue
        view1IconLabel2.text = self.mainCollection["layout1"]["labelTwo"].stringValue
        view1IconLabel3.text = self.mainCollection["layout1"]["labelThree"].stringValue
        view1IconLabel4.text = self.mainCollection["layout1"]["labelFour"].stringValue
        view1Heading1Label.text = self.mainCollection["layout1"]["firstLabel"].stringValue
        view1HeadingLabel2.text = self.mainCollection["layout1"]["secondLabel"].stringValue
        view1HeadingLabel3.text = self.mainCollection["layout1"]["thirdLabel"].stringValue
        view1HeadingLabel4.text = self.mainCollection["layout1"]["fourthLabel"].stringValue
        let imageUrl1 = self.mainCollection["layout1"]["bannerImage"].stringValue
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageUrl1, imageView: self.view1HeadingImageView)
        let imageUrl2 = self.mainCollection["layout1"]["iconOne"].stringValue
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageUrl2, imageView: self.view1Icon)
        let imageUrl3 = self.mainCollection["layout1"]["iconTwo"].stringValue
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageUrl3, imageView: self.view1Icon2)
        let imageUrl4 = self.mainCollection["layout1"]["iconThree"].stringValue
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageUrl4, imageView: self.view1Icon3)
        let imageUrl5 = self.mainCollection["layout1"]["iconFour"].stringValue
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageUrl5, imageView: self.view1Icon4)
        
        
        var internalY:CGFloat = 0;
        var bannerX:CGFloat = 5;
        for i in 0..<self.mainCollection["layout1"]["sellersData"].count{
            var dict = self.mainCollection["layout1"]["sellersData"][i];
            
            let sellorImage = UIImageView(frame: CGRect(x: 10, y: internalY, width: 60, height:60))
            sellorImage.image = UIImage(named: "ic_placeholder.png")
            sellorImage.contentMode = .scaleAspectFit
            sellorImage.layer.cornerRadius = 25
            sellorImage.clipsToBounds = true
            let imageUrl5 = dict["logo"].stringValue
            GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageUrl5, imageView: sellorImage)
            
            self.view1SellerDataView.addSubview(sellorImage);
            
            let sellerName = UILabel(frame: CGRect(x: 80, y: Int(internalY), width: Int(self.view1SellerDataView.frame.size.width - 80), height: 25))
            sellerName.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
            sellerName.backgroundColor = UIColor.clear
            sellerName.textAlignment = .left
            sellerName.font = UIFont(name: REGULARFONT, size: 15.0)
            sellerName.text = dict["shoptitle"].stringValue
            sellerName.tag = i
            self.view1SellerDataView.addSubview(sellerName)
            let Gesture3 = UITapGestureRecognizer(target: self, action: #selector(self.sellerProfilePage))
            Gesture3.numberOfTapsRequired = 1
            sellerName.isUserInteractionEnabled = true;
            sellerName.addGestureRecognizer(Gesture3)
            
            
            
            
            internalY += 30;
            
            let sellerProductCount = UILabel(frame: CGRect(x: 80, y: Int(internalY), width: Int(self.view1SellerDataView.frame.size.width - 80), height: 25))
            sellerProductCount.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
            sellerProductCount.backgroundColor = UIColor.clear
            sellerProductCount.textAlignment = .left
            sellerProductCount.font = UIFont(name: REGULARFONT, size: 15.0)
            sellerProductCount.text = dict["productCount"].stringValue+" products";
            self.view1SellerDataView.addSubview(sellerProductCount)
            
            let viewallProduct = UILabel(frame: CGRect(x: Int(self.view1SellerDataView.frame.size.width - 100), y: Int(internalY), width:100, height: 25))
            viewallProduct.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
            viewallProduct.backgroundColor = UIColor.clear
            viewallProduct.font = UIFont(name: REGULARFONT, size: 15.0)
            viewallProduct.text = "View All";
            viewallProduct.tag = i;
            self.view1SellerDataView.addSubview(viewallProduct)
            let Gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.viewAllProduct))
            Gesture1.numberOfTapsRequired = 1
            viewallProduct.isUserInteractionEnabled = true;
            viewallProduct.addGestureRecognizer(Gesture1)
            
            
            internalY += 30;
            
            
            let sellerProductsScrollView = UIScrollView(frame: CGRect(x: 5, y: Int(internalY), width: Int(SCREEN_WIDTH - 10), height: Int(SCREEN_WIDTH/2.5 + 40)))
            sellerProductsScrollView.tag = i
            sellerProductsScrollView.isUserInteractionEnabled = true
            sellerProductsScrollView.showsHorizontalScrollIndicator = false
            self.view1SellerDataView.addSubview(sellerProductsScrollView)
            bannerX = 5;
            
            for j in 0..<dict["products"].count{
                var childDict = dict["products"][j];
                let productBlock = UIView(frame: CGRect(x: bannerX, y: 5, width: (SCREEN_WIDTH / 2.5), height: SCREEN_WIDTH/2.5 + 30))
                bannerX = bannerX + SCREEN_WIDTH / 2.5 + 10
                productBlock.backgroundColor = UIColor.white
                productBlock.layer.cornerRadius = 2
                productBlock.layer.shadowOffset = CGSize(width: 0, height: 0)
                productBlock.layer.shadowRadius = 3
                productBlock.tag = j;
                productBlock.layer.shadowOpacity = 0.5
                sellerProductsScrollView.addSubview(productBlock)
                
                let productImage = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH / 2.5, height: SCREEN_WIDTH / 2.5))
                productImage.image = UIImage(named: "ic_placeholder.png")
                productImage.isUserInteractionEnabled = true
                productImage.backgroundColor = UIColor().HexToColor(hexString: "f3f3f3");
                productImage.tag = i
                productBlock.addSubview(productImage)
                let imageUrl = childDict["thumbNail"].stringValue
                GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageUrl, imageView: productImage)
                
                productImage.contentMode = .scaleAspectFit
                productImage.contentScaleFactor = 1
                productImage.clipsToBounds = true
                
                let productName = UILabel(frame: CGRect(x: 10, y: SCREEN_WIDTH / 2.5, width: productBlock.frame.size.width - 20, height: 25))
                productName.textColor = UIColor().HexToColor(hexString: LIGHTGREY)
                productName.backgroundColor = UIColor.clear
                productName.font = UIFont(name: REGULARFONT, size: 15.0)
                productName.text = childDict["name"].stringValue
                productBlock.addSubview(productName)
                
                let Gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.viewProduct))
                Gesture2.numberOfTapsRequired = 1
                productBlock.isUserInteractionEnabled = true;
                productBlock.addGestureRecognizer(Gesture2)
                
                
                
            }
            
            sellerProductsScrollView.contentSize = CGSize(width: bannerX - 5, height: 100)
            internalY += SCREEN_WIDTH/2.5 + 60;
            
            
        }
        
        view1SellerDataViewHeightConstarints.constant = internalY;
        view1HeghtConsraints.constant += internalY;
        self.webView.loadHTMLString(self.mainCollection["layout1"]["aboutContent"].stringValue, baseURL: nil)
        self.webView.delegate = self;
        
        mainViewHeightConstarints.constant = view1HeghtConsraints.constant + 50;
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        let height = webView.scrollView.contentSize.height
        webViewHeightConstarints.constant = height
        view1HeghtConsraints.constant += height
        mainViewHeightConstarints.constant += height
    }
    
    @objc func sellerProfilePage(_ recognizer: UITapGestureRecognizer) {
        var dict = self.mainCollection["layout1"]["sellersData"][(recognizer.view?.tag)!];
        sellerId = dict["sellerId"].stringValue;
        self.performSegue(withIdentifier: "sellerprofile", sender: self)
    }
    
    @objc func viewAllProduct(_ recognizer: UITapGestureRecognizer) {
        var dict = self.mainCollection["layout1"]["sellersData"][(recognizer.view?.tag)!];
        sellerId = dict["sellerId"].stringValue;
        sellerName = dict["shopTitle"].stringValue;
        self.performSegue(withIdentifier: "marketPlaceToProductCategory", sender: self);
    }
    
    @objc func viewProduct(_ recognizer: UITapGestureRecognizer) {
        var dict = self.mainCollection["layout1"]["sellersData"][(recognizer.view?.superview?.tag)!];
        var childDict = dict["products"][(recognizer.view?.tag)!]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productImageUrl = ""
        vc.productName = childDict["name"].stringValue
        vc.productId = childDict["entityId"].stringValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "marketPlaceToProductCategory") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryName = sellerName
            viewController.categoryType = "marketplace";
            viewController.sellerId = sellerId
        }else if(segue.identifier! == "sellerprofile") {
            let viewController:SellerDetailsViewController = segue.destination as UIViewController as! SellerDetailsViewController
            viewController.profileUrl = sellerId;
        }
    }
    
}
