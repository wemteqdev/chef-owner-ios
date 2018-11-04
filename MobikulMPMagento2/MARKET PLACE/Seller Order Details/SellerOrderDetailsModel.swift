//
//  SellerOrderDetailsModel.swift
//  MobikulMPMagento2
//
//  Created by kunal on 06/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation


struct SellerOrderItemList{
    var  adminCommission:String!
    var price:String!
    var productName:String!
    var SKU:String!
    var subtotal:String!
    var totalPrice:String!
    var vendorTotal:String!
    var sellerQty = [SellerQty]()
    var taxClass:String!
    var packSize:Double!
    init(data:JSON) {
        self.adminCommission = data["adminCommission"].stringValue
        self.price = data["price"].stringValue
        self.productName = data["productName"].stringValue
        self.SKU = data["sku"].stringValue
        self.subtotal = data["subTotal"].stringValue
        self.totalPrice = data["totalPrice"].stringValue
        self.vendorTotal = data["vendorTotal"].stringValue
        
        self.packSize = data["packSize"].doubleValue
        self.taxClass = data["tax_class"].stringValue
        
        if let arrayData = data["qty"].arrayObject{
            sellerQty =  arrayData.map({(value) -> SellerQty in
                return  SellerQty(data:JSON(value))
            })
        }
        
    }
    
    
}


struct SellerQty{
    var label:String!
    var value:String!
    
    init(data:JSON) {
       self.label = data["label"].stringValue
        self.value = data["value"].stringValue
    }
    
    
}



class SellerOrderDetailsViewModelData: NSObject {
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
    
    init(data:JSON) {
        adminBaseCommission = data["adminBaseCommission"].stringValue
        adminCommission = data["adminCommission"].stringValue
        billingAddress = data["billingAddress"].stringValue.html2String
        buyerEmail = data["buyerEmail"].stringValue
        buyerName = data["buyerName"].stringValue
        cancelButton = data["cancelButton"].intValue
        creditMemoButton = data["creditMemoButton"].intValue
        date = data["date"].stringValue
        discount = data["discount"].stringValue
        incrementId = data["incrementId"].stringValue
        invoiceButton  = data["invoiceButton"].intValue
        invoiceId = data["invoiceId"].stringValue
        orderStatus = data["orderStatus"].stringValue
        orderTotal = data["orderTotal"].stringValue
        paymentMethod = data["paymentMethod"].stringValue
        sendEmailButton = data["sendEmailButton"].intValue
        shipmentButton = data["shipmentButton"].intValue
        shipmentId = data["shipmentId"].stringValue
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
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}



