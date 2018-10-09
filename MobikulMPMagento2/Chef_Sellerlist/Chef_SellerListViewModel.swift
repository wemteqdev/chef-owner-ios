//
//  Chef_SellerListViewModel.swift
//  MobikulMPMagento2
//
//  Created by Othello on 19/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit
import Foundation


struct Chef_SellerListModel{
    var logo:String!
    var productCount:String!
    var sellerId:String!
    var shopTitle:String!
    var cartItemCount:Int = 0
    var cartItemIndex: [Int] = []
    init(data:JSON) {
        self.logo = data["logo"].stringValue
        self.productCount = data["productCount"].stringValue
        self.sellerId = data["sellerId"].stringValue
        self.shopTitle = data["shoptitle"].stringValue
    }
    
    
    
}

class Chef_SellerListViewModel: NSObject {
    var sellerListModel = [Chef_SellerListModel]()
    
    init(data:JSON) {
        
        
        if let arrayData = data["sellersData"].arrayObject{
            sellerListModel =  arrayData.map({(value) -> Chef_SellerListModel in
                return  Chef_SellerListModel(data:JSON(value))
            })
        }
    }
}
