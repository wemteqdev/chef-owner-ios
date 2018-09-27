//
//  ReviewDetails.swift
//  DummySwift
//
//  Created by kunal prasad on 28/12/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit

class ReviewDetails: UIViewController,UIScrollViewDelegate {
@IBOutlet weak var mainView: UIView!
@IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
public var reviewId:String = ""
var reviewDetailsJson:JSON!
let defaults = UserDefaults.standard;
@IBOutlet weak var imageView: UIImageView!
@IBOutlet weak var imageViewHeightConstraints: NSLayoutConstraint!
@IBOutlet weak var scrollView: UIScrollView!
@IBOutlet weak var productName: UILabel!
@IBOutlet weak var reviewData: UILabel!
@IBOutlet weak var reviewDetails: UILabel!
@IBOutlet weak var dynamicView: UIView!
@IBOutlet weak var dynamicViewHeightConstarints: NSLayoutConstraint!
    
   
let globalObjectReviewsdetails = GlobalData();
var reviewDetailsModel:ReviewDetailsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "reviewdetails")
        self.navigationController?.isNavigationBarHidden = false
        imageViewHeightConstraints.constant = SCREEN_WIDTH
        scrollView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        mainViewHeightConstarints.constant = 200;
        callingHttppApi()
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let imageHeight = imageView.frame.height
        
        let newOrigin = CGPoint(x: 0, y: -imageHeight)
        
        scrollView.contentOffset = newOrigin
        scrollView.contentInset = UIEdgeInsets(top: imageHeight, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0{
            imageView.frame.size.height = -offsetY
        }
        else{
            imageView.frame.size.height = imageView.frame.height
        }
    }

    
    
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]();
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        requstParams["reviewId"] = reviewId
        let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        requstParams["width"] = width
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/reviewDetails", currentView: self){success,responseObject in
            if success == 1{
                
            self.reviewDetailsModel = ReviewDetailsModel(data:JSON(responseObject as! NSDictionary))
            print(responseObject)
            self.doFurtherProcessingWithResult()
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
        
    }

    
    func doFurtherProcessingWithResult(){
        GlobalData.sharedInstance.dismissLoader()
        GlobalData.sharedInstance.getImageFromUrl(imageUrl: reviewDetailsModel.imageUrl, imageView: imageView)
        productName.text = reviewDetailsModel.name
        reviewData.text = reviewDetailsModel.reviewData
        reviewDetails.text = reviewDetailsModel.reviewDetails
        
        var Y:CGFloat = 0
        var ratingDict = JSON(reviewDetailsModel.ratingData)
        for i in 0..<ratingDict.count{
            var reviewDict = ratingDict[i];
            
            let reviewLabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(Y), width: 110, height: CGFloat(25)))
            reviewLabel.textColor =  UIColor.black
            reviewLabel.backgroundColor = UIColor.clear
            reviewLabel.font = UIFont(name: REGULARFONT, size: CGFloat(14))!
            reviewLabel.text =  reviewDict["ratingCode"].string
            dynamicView.addSubview(reviewLabel)
            
            Y += 30

            let starRatingView = HCSStarRatingView(frame: CGRect(x: 10, y: Y, width: 100, height: 20))
            starRatingView.maximumValue = 5
            starRatingView.minimumValue = 0
            starRatingView.allowsHalfStars = true
            starRatingView.value = CGFloat(reviewDict["ratingValue"].floatValue / 20)
            starRatingView.isUserInteractionEnabled = false;
            starRatingView.tintColor = UIColor.blue
            dynamicView.addSubview(starRatingView);
            Y += 30;
            
        }
        
        let averageRating = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(Y), width: CGFloat(self.dynamicView.frame.size.width - 10), height: CGFloat(20)))
        averageRating.textColor =  UIColor.black
        averageRating.backgroundColor = UIColor.clear
        averageRating.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
        averageRating.text = GlobalData.sharedInstance.language(key:"youravgreviewdetails" )
        self.dynamicView.addSubview(averageRating)
        Y += 30;
        
        let starRatingView = HCSStarRatingView(frame: CGRect(x: 10, y: Y, width: 100, height: 24))
        starRatingView.maximumValue = 5
        starRatingView.minimumValue = 0
        starRatingView.allowsHalfStars = true
        starRatingView.value = CGFloat(reviewDetailsModel.avgRatingValue)
        starRatingView.isUserInteractionEnabled = false;
        starRatingView.tintColor = UIColor.blue
        self.dynamicView.addSubview(starRatingView);
        
        Y += 30;
        
        dynamicViewHeightConstarints.constant += Y + 50;
        mainViewHeightConstarints.constant += dynamicViewHeightConstarints.constant
    }


    

   
}
