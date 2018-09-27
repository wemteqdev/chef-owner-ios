//
//  PaymentShipmentModel.swift
//  Magento2V4Theme
//
//  Created by kunal on 20/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation


struct ShipmentData{
    var title:String = ""
    var shipmentContentArray = [ShipmentContent]()
    
    
    init(data:JSON) {
        self.title = data["title"].stringValue
        if let arrayData = data["method"].arrayObject{
            shipmentContentArray = arrayData.map({(value) -> ShipmentContent in
                return ShipmentContent(data:JSON(value))
            })
        }
        
    }
    
    
}


struct ShipmentContent{
    var label:String = ""
    var price:String = ""
    var code:String = ""
    
    init(data:JSON) {
        self.label = data["label"].stringValue
        self.price = data["price"].stringValue
        self.code = data["code"].stringValue
    }
    
}



struct PaymentData{
    var title:String = ""
    var extraInformation:String = ""
    var code:String = ""
    
    init(data:JSON) {
        self.title = data["title"].stringValue
        self.extraInformation = data["extraInformation"].stringValue
        self.code = data["code"].stringValue
    }
    
}




class ShipmentAndPaymentViewModel:NSObject{
    var shipmentData = [ShipmentData]()
    var paymentData = [PaymentData]()
    
    
    init(data:JSON) {
    
    if let arrayData = data["shippingMethods"].arrayObject{
        shipmentData = arrayData.map({(value) -> ShipmentData in
            return ShipmentData(data:JSON(value))
        })
    }
    if let arrayData = data["paymentMethods"].arrayObject{
        paymentData = arrayData.map({(value) -> PaymentData in
            return PaymentData(data:JSON(value))
        })
    }
        
    }
    
    
}









