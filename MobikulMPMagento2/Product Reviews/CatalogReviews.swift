//
//  CatalogReviews.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 16/09/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CatalogReviews: UIViewController,UITableViewDelegate, UITableViewDataSource {

@IBOutlet weak var reviewsTableView: UITableView!
var catalogProductViewModel:CatalogProductViewModel!
var extraHeight:CGFloat = 0
@IBOutlet weak var noReviewsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviewsTableView.separatorColor = UIColor.clear
        
        if catalogProductViewModel.getReviewListData.count > 0{
        self.reviewsTableView.delegate = self
        self.reviewsTableView.dataSource = self
        self.reviewsTableView.reloadData()
        noReviewsLabel.isHidden = true;
        self.reviewsTableView.isHidden = false;
        }else{
            noReviewsLabel.text = GlobalData.sharedInstance.language(key:"noreview");
            noReviewsLabel.isHidden = false
            self.reviewsTableView.isHidden = true;
        }
      
        self.title = GlobalData.sharedInstance.language(key: "review")
        
       
    }

    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return catalogProductViewModel.getReviewListData.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier: String = "cell"
        tableView.register(UINib(nibName: "CatalogProductReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        let cell:CatalogProductReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! CatalogProductReviewTableViewCell
        cell.ReviewsHeading.text = catalogProductViewModel.getReviewListData[indexPath.row].title
        cell.ReviewsDate.text = catalogProductViewModel.getReviewListData[indexPath.row].reviewOn
        cell.reviewBy.text = catalogProductViewModel.getReviewListData[indexPath.row].reviewBy
        cell.reviewsDetails.text = catalogProductViewModel.getReviewListData[indexPath.row].details
        var ratingLabelMaxWidth: CGFloat = 0
        var Y:CGFloat = 0;
        var ratingOptions:Array = catalogProductViewModel.getReviewListData[indexPath.row].ratingsData
        for i in 0..<ratingOptions.count{
            var dict = ratingOptions[i];
            let ratingLabelAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(14))!]
            let ratingLabelStringSize = (dict["label"].stringValue).size(withAttributes: ratingLabelAttributes)
            let ratingLabelStringWidth: CGFloat = ratingLabelStringSize.width
            if ratingLabelStringWidth > ratingLabelMaxWidth {
                ratingLabelMaxWidth = ratingLabelStringWidth
            }
            
            
        }
       
        for j in 0..<ratingOptions.count{
            var dict = ratingOptions[j]
            let ratingLabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(Y), width: CGFloat(ratingLabelMaxWidth), height: CGFloat(25)))
            ratingLabel.textColor = UIColor().HexToColor(hexString: TEXTHEADING_COLOR)
            ratingLabel.font = UIFont(name: REGULARFONT, size: CGFloat(14))!
            ratingLabel.text = dict["label"].string
            ratingLabel.backgroundColor = UIColor.clear
            cell.dynamicView.addSubview(ratingLabel)
            
            
            let starRatingView = HCSStarRatingView(frame: CGRect(x: ratingLabelMaxWidth+10, y: Y, width: 90, height: 24))
            starRatingView.maximumValue = 5
            starRatingView.backgroundColor = UIColor.clear
            starRatingView.minimumValue = 0
            starRatingView.allowsHalfStars = true
            let data:String = dict["value"].string!;
            if let n = NumberFormatter().number(from: data) {
                starRatingView.value = CGFloat(n)
            }
            starRatingView.isUserInteractionEnabled = false;
            starRatingView.tintColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
            cell.dynamicView.addSubview(starRatingView);
            Y += 29;
        }
        cell.dynamicViewHeightConstarints.constant = Y;
        
        extraHeight = (catalogProductViewModel.getReviewListData[indexPath.row].details.height(withConstrainedWidth: SCREEN_WIDTH - 16, font: UIFont.systemFont(ofSize: 14)))
        extraHeight += Y;
        
        
        
        print(catalogProductViewModel.getReviewListData[indexPath.row].ratingsData,ratingLabelMaxWidth )
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130 + extraHeight;
    }

    
    
    
    
    

}
