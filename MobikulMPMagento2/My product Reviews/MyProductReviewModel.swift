//
//  MyProductReviewModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 23/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class MyProductReviewModel: NSObject {
    
    var date:String!
    var details:String!
    var id:String!
    var productName:String!
    var productId:String!
    var ratingData:Array<Any>!
    var imageUrl:String!
    
    init(data:JSON){
        self.date = data["date"].stringValue
        self.details = data["details"].stringValue
        self.id = data["id"].stringValue
        self.productName = data["proName"].stringValue
        self.productId = data["productId"].stringValue
        self.ratingData = data["ratingData"].arrayObject
        self.imageUrl = data["thumbNail"].stringValue
    }
}

class MyProductReviewViewModel: NSObject{
    var myProductReviewModel:[MyProductReviewModel] = []
    var myGG:Array<MyProductReviewModel>!
    
    
    var totalCout:Int = 0
    init(data:JSON) {
        let arrayData = data["reviewList"].arrayObject! as NSArray
        myProductReviewModel = arrayData.map({(value) -> MyProductReviewModel in
            return  MyProductReviewModel(data:JSON(value))
        })
        totalCout = data["totalCount"].intValue
    }
    
    var getMyProductReviewData:Array<MyProductReviewModel>{
        return myProductReviewModel
    }
    
    func  setMyProductReviewData(data:JSON){
        let arrayData = data["reviewList"].arrayObject! as NSArray
        myProductReviewModel = myProductReviewModel + arrayData.map({(value) -> MyProductReviewModel in
            return  MyProductReviewModel(data:JSON(value))
        })

    }
    


}



