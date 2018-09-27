//
//  SellerOrderDataModel.swift
//  MobikulMPMagento2
//
//  Created by kunal on 27/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation


struct SellerOrderData{
    var date:String = ""
    var orderID:String = ""
    var incrementID:String = ""
    var customerName:String = ""
    var ordertotalBase:String = ""
    var ordertotalPurchase:String = ""
    var status:String = ""
    var sellerProducts = [SellerProducts]()
    
    
    
    init(data:JSON) {
        self.date = data["customerDetails"]["date"].stringValue
        self.orderID = data["orderId"].stringValue
        self.incrementID = data["incrementId"].stringValue
        self.customerName = data["customerDetails"]["name"].stringValue
        self.ordertotalBase = data["customerDetails"]["baseTotal"].stringValue
        self.ordertotalPurchase  = data["customerDetails"]["purchaseTotal"].stringValue
        self.status = data["status"].stringValue
        
        if let arrayData = data["productNames"].arrayObject{
            sellerProducts =  arrayData.map({(value) -> SellerProducts in
                return  SellerProducts(data:JSON(value))
            })
        }
    }
    
}








struct OrderStatus{
    var label:String = ""
    var status:String = ""
    
    init(data:JSON) {
        self.label = data["label"].stringValue
        self.status = data["status"].stringValue
    }
    
    
    
    
}




class SellerOrderViewModel{
    var sellerOrderData = [SellerOrderData]()
    var orderStatus = [OrderStatus]()
    var totalCount:Int = 0
    
    
    init(data:JSON) {
        if let arrayData = data["orderStatus"].arrayObject{
            orderStatus =  arrayData.map({(value) -> OrderStatus in
                return  OrderStatus(data:JSON(value))
            })
        }
        if let arrayData = data["orderList"].arrayObject{
            sellerOrderData =  arrayData.map({(value) -> SellerOrderData in
                return  SellerOrderData(data:JSON(value))
            })
        }
        
        totalCount = data["totalCount"].intValue
        
    }
    
    
    
    
    
    
    func setSellerOrderCollectionData(data:JSON){
        for i in 0..<data["orderList"].count{
            let dict = data["orderList"][i];
            sellerOrderData.append(SellerOrderData(data: dict))
        }
    }
    
    
    
    
    
    
    
}




