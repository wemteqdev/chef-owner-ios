//
//  SellerListModel.swift
//  MobikulMPMagento2
//
//  Created by kunal on 01/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation


struct SellerListModel{
    var logo:String!
    var productCount:String!
    var sellerId:String!
    var shopTitle:String!
    
    init(data:JSON) {
        self.logo = data["logo"].stringValue
        self.productCount = data["productCount"].stringValue
        self.sellerId = data["sellerId"].stringValue
        self.shopTitle = data["shoptitle"].stringValue
    }
    

    
}








class SellerListViewModel: NSObject {
    var sellerListModel = [SellerListModel]()
    
    init(data:JSON) {
    
    
    if let arrayData = data["sellersData"].arrayObject{
        sellerListModel =  arrayData.map({(value) -> SellerListModel in
            return  SellerListModel(data:JSON(value))
        })
    }
    }
    
}






