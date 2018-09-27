//
//  ChatSellerListModel.swift
//  MobikulMPMagento2
//
//  Created by yogesh on 13/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation



struct ChatSellerListModel {
    var customerID:String!
    var name:String!
    var profileImage:String!
    var token:String!
    
    init(data:JSON) {
        self.customerID = data["customerId"].stringValue
        self.name = data["name"].stringValue
        self.profileImage = data["profileImage"].stringValue
        self.token = data["token"].stringValue
    }
    
}


class ChatSellerListViewModel{
    var apiKey:String!
    var chatSellerListModel = [ChatSellerListModel]()
    
    
    
    init(data:JSON) {
        if let arrayData = data["sellerList"].arrayObject{
            chatSellerListModel =  arrayData.map({(value) -> ChatSellerListModel in
                return  ChatSellerListModel(data:JSON(value))
            })
        }
        
        apiKey = data["apiKey"].stringValue
        
    }
 
}

