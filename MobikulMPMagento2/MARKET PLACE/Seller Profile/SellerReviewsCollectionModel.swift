//
//  SellerReviewsCollectionModel.swift
//  MobikulMPMagento2
//
//  Created by kunal on 01/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

struct SellerReviewCollectionModel{
    
    var description:String = ""
    var date:String = ""
    var name:String = ""
    var pricerating:Int!
    var qualityrating:Int!
    var valuerating:Int!
    var summary:String!
    
    init(data:JSON) {
        self.description = data["description"].stringValue
        self.date = data["date"].stringValue
        self.name = data["userName"].stringValue
        self.pricerating = data["feedPrice"].intValue/20
        self.qualityrating = data["feedQuality"].intValue/20
        self.valuerating = data["feedValue"].intValue/20
        self.summary = data["summary"].stringValue
    }

}


class SellerReviewViewModel: NSObject {
    var sellerReviewCollectionModel = [SellerReviewCollectionModel]()
    var totalCount:Int = 0
    init(data:JSON) {
        if let arrayData = data["reviewList"].arrayObject{
            sellerReviewCollectionModel =  arrayData.map({(value) -> SellerReviewCollectionModel in
                return  SellerReviewCollectionModel(data:JSON(value))
            })
        }
        totalCount = data["totalCount"].intValue
    }
    
    
    
    func setsellerreviewCollectionData(data:JSON){
        for i in 0..<data["reviewList"].count{
            let dict = data["reviewList"][i];
            sellerReviewCollectionModel.append(SellerReviewCollectionModel(data: dict))
        }
    }
    
    
}










