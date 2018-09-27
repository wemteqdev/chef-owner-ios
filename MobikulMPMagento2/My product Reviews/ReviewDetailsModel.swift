//
//  ReviewDetailsModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 24/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class ReviewDetailsModel: NSObject {
    var imageUrl:String!
    var name:String!
    var reviewData:String!
    var reviewDetails:String!
    var avgRatingValue:Float!
    var ratingData:Array<Any>!
    
    init(data:JSON){
      self.imageUrl = data["image"].stringValue
      self.name = data["name"].stringValue
      self.reviewData = data["reviewDate"].stringValue
      self.reviewDetails = data["reviewDetail"].stringValue
      self.avgRatingValue = data["rating"].floatValue
      self.ratingData = data["ratingData"].arrayObject
        
    }
    
    

}
