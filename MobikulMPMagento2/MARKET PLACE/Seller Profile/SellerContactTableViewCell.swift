//
//  SellerContactTableViewCell.swift
//  OpenCartMpV3
//
//  Created by kunal on 08/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//





@objc protocol SellerContactControllerHandlerDelegate: class {
    func contactViewClick(value:Int)
}






import UIKit

class SellerContactTableViewCell: UITableViewCell {
    
@IBOutlet weak var aboutStoreView: UIView!

@IBOutlet weak var reviewsView: UIView!

    
@IBOutlet weak var policyView: UIView!
    
@IBOutlet weak var locationView: UIView!
@IBOutlet weak var contactUsView: UIView!
    
@IBOutlet weak var shippingPolicyView: UIView!
@IBOutlet weak var image1: UIImageView!
@IBOutlet weak var aboutStoreLabel: UILabel!
@IBOutlet weak var image2: UIImageView!
@IBOutlet weak var shippingPolicyLabel: UILabel!
    
@IBOutlet weak var image3: UIImageView!
@IBOutlet weak var reviewsLabel: UILabel!
@IBOutlet weak var image4: UIImageView!

    
@IBOutlet weak var policyLabel: UILabel!
    
    
@IBOutlet weak var image5: UIImageView!
@IBOutlet weak var locationLabel: UILabel!
@IBOutlet weak var image6: UIImageView!
@IBOutlet weak var contactLabel: UILabel!
var delegate:SellerContactControllerHandlerDelegate!
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        image1.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        image2.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        image3.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        image4.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        image5.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        image6.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        
        
        image1?.layer.cornerRadius = 20
        image1?.clipsToBounds = true
        image2?.layer.cornerRadius = 20
        image2?.clipsToBounds = true
        image3?.layer.cornerRadius = 20
        image3?.clipsToBounds = true
        image4?.layer.cornerRadius = 20
        image4?.clipsToBounds = true
        image5?.layer.cornerRadius = 20
        image5?.clipsToBounds = true
        image6?.layer.cornerRadius = 20
        image6?.clipsToBounds = true
        
        aboutStoreLabel.text = GlobalData.sharedInstance.language(key: "aboutstore")
        
        reviewsLabel.text = GlobalData.sharedInstance.language(key: "reviews")
    
        locationLabel.text = GlobalData.sharedInstance.language(key: "location")
        contactLabel.text = GlobalData.sharedInstance.language(key: "contactus")
        shippingPolicyLabel.text = GlobalData.sharedInstance.language(key: "shippingpolicy")
        policyLabel.text = GlobalData.sharedInstance.language(key: "returnpolicy")
        
        
        
    
        let aboutStoreTap = UITapGestureRecognizer(target: self, action: #selector(self.aboutStoreClick))
        aboutStoreTap.numberOfTapsRequired = 1
        aboutStoreView.addGestureRecognizer(aboutStoreTap)
        
        let recentfeedbackTap = UITapGestureRecognizer(target: self, action: #selector(self.shippingPolicy))
        recentfeedbackTap.numberOfTapsRequired = 1
        shippingPolicyView.addGestureRecognizer(recentfeedbackTap)
        
        let contactTap = UITapGestureRecognizer(target: self, action: #selector(self.contactClick))
        contactTap.numberOfTapsRequired = 1
        contactUsView.addGestureRecognizer(contactTap)

        let reviewsTap = UITapGestureRecognizer(target: self, action: #selector(self.reviewsClick))
        reviewsTap.numberOfTapsRequired = 1
        reviewsView.addGestureRecognizer(reviewsTap)
        
        let policyTap = UITapGestureRecognizer(target: self, action: #selector(self.policyClick))
        policyTap.numberOfTapsRequired = 1
        policyView.addGestureRecognizer(policyTap)
        
        
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(self.locationClick))
        locationTap.numberOfTapsRequired = 1
        locationView.addGestureRecognizer(locationTap)
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    
    @objc func aboutStoreClick(_ recognizer: UITapGestureRecognizer) {
        delegate.contactViewClick(value: 1)
    }
 
    
   @objc func contactClick(_ recognizer: UITapGestureRecognizer) {
        delegate.contactViewClick(value: 6)
    }
    
   @objc func reviewsClick(_ recognizer: UITapGestureRecognizer) {
        delegate.contactViewClick(value: 3)
    }
    
    @objc func shippingPolicy(_ recognizer: UITapGestureRecognizer) {
        delegate.contactViewClick(value: 2)
    }
    
   @objc func locationClick(_ recognizer: UITapGestureRecognizer) {
        delegate.contactViewClick(value: 5)
    }
    
    @objc func policyClick(_ recognizer: UITapGestureRecognizer) {
        delegate.contactViewClick(value: 4)
    }
    
    
    
    
}
