//
//  ShipmentDetailsModel.swift
//  MobikulMPMagento2
//
//  Created by kunal on 07/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation



struct TrackingCarrier{
    var label:String!
    var value:String!
    
    init(data:JSON) {
        self.label = data["label"].stringValue
        self.value = data["value"].stringValue
    }

}


struct TrackingCarrierDetails{
    var carrier:String!
    var id:String!
    var title:String!
    var trackingNumber:String!
    
    init(data:JSON) {
        self.carrier = data["carrier"].stringValue
        self.id = data["id"].stringValue
        self.title = data["title"].stringValue
        self.trackingNumber = data["trackingNumber"].stringValue
    }
    
}







class SellerShipmentDetailsViewModel{
    var adminBaseCommission:String!
    var adminCommission:String!
    var billingAddress:String!
    var buyerEmail:String!
    var buyerName:String!
    var cancelButton:Int!
    var creditMemoButton:Int!
    var date:String!
    var discount:String!
    var incrementId:String!
    var invoiceButton:Int!
    var invoiceId:String!
    var orderStatus:String!
    var orderTotal:String!
    var paymentMethod:String!
    var sendEmailButton:Int!
    var shipmentButton:Int!
    var shipmentId:String!
    var shipping:String!
    var shippingAddress:String!
    var shippingMethod:String!
    var subTotal:String!
    var tax:String!
    var vendorBaseTotal:String!
    var vendorTotal:String!
    var creditMemoTab:Int!
    var sellerOrderItemList = [SellerOrderItemList]()
    var trackingCarrier = [TrackingCarrier]()
    var trackingCarrierDetails = [TrackingCarrierDetails]()
        
        
    
    init(data:JSON) {
        adminBaseCommission = data["adminBaseCommission"].stringValue
        adminCommission = data["adminCommission"].stringValue
        billingAddress = data["billingAddress"].stringValue.html2String
        buyerEmail = data["customerEmail"].stringValue
        buyerName = data["customerName"].stringValue
        date = data["date"].stringValue
        discount = data["discount"].stringValue
        incrementId = data["incrementId"].stringValue
        orderStatus = data["orderStatus"].stringValue
        orderTotal = data["orderTotal"].stringValue
        paymentMethod = data["paymentMethod"].stringValue
        shipping = data["shipping"].stringValue
        shippingAddress = data["shippingAddress"].stringValue.html2String
        shippingMethod = data["shippingMethod"].stringValue
        subTotal = data["subTotal"].stringValue
        tax = data["tax"].stringValue
        vendorBaseTotal = data["vendorBaseTotal"].stringValue
        vendorTotal = data["vendorTotal"].stringValue
        self.creditMemoTab = data["creditMemoTab"].intValue
        
        
        if let arrayData = data["itemList"].arrayObject{
            sellerOrderItemList =  arrayData.map({(value) -> SellerOrderItemList in
                return  SellerOrderItemList(data:JSON(value))
            })
        }
        if let arrayData = data["trackingCarrier"].arrayObject{
            trackingCarrier =  arrayData.map({(value) -> TrackingCarrier in
                return  TrackingCarrier(data:JSON(value))
            })
        }
        if let arrayData = data["trackingDetails"].arrayObject{
            trackingCarrierDetails =  arrayData.map({(value) -> TrackingCarrierDetails in
                return  TrackingCarrierDetails(data:JSON(value))
            })
        }
        
    }
    
    
    
    
}
