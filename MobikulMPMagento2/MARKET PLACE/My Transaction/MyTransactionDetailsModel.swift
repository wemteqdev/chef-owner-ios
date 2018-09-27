//
//  MyTransactionDetailsModel.swift
//  MobikulMPMagento2
//
//  Created by kunal on 28/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

struct TransactionDetailsCollectionModel{
    var commision:String = ""
    var incrementId:String!
    var price:String!
    var productName:String!
    var qty:String!
    var shipping:String!
    var subTotal:String!
    var totalPrice:String!
    var totalTax:String!
    
    
    
    init(data:JSON) {
        self.commision = data["commission"].stringValue
        self.incrementId = data["incrementId"].stringValue
        self.price = data["price"].stringValue
        self.productName = data["productName"].stringValue
        self.qty = data["qty"].stringValue
        self.shipping = data["shipping"].stringValue
        self.subTotal = data["subTotal"].stringValue
        self.totalPrice = data["totalPrice"].stringValue
        self.totalTax = data["totalTax"].stringValue
        
    }
 
}







class TransactionDetailsCollectionViewModel: NSObject {
    
    var transactionDetailsCollectionModel = [TransactionDetailsCollectionModel]()
    var date:String = ""
    var amount:String = ""
    var comment:String = ""
    var method:String = ""
    var transactionId:String = ""
    var type:String = ""
    
    
    init(data:JSON) {
        if let arrayData = data["orderList"].arrayObject{
            transactionDetailsCollectionModel =  arrayData.map({(value) -> TransactionDetailsCollectionModel in
                return  TransactionDetailsCollectionModel(data:JSON(value))
            })
        }
        
        self.date = data["date"].stringValue
        self.amount = data["amount"].stringValue
        self.comment = data["comment"].stringValue
        self.method = data["method"].stringValue
        self.transactionId = data["transactionId"].stringValue
        self.type = data["type"].stringValue
        
    }
    
    
    
    
}




