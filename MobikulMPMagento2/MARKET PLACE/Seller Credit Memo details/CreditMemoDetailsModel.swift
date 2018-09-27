//
//  CreditMemoDetailsModel.swift
//  MobikulMPMagento2
//
//  Created by kunal on 07/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation




struct SellerCreditMemoProductList{
    var discountTotal:String!
    var price:String!
    var productName:String!
    var qty:String!
    var subtotal:String!
    var totalTax:String!
    
    init(data:JSON) {
        self.discountTotal = data["discountTotal"].stringValue
        self.price = data["price"].stringValue
        self.productName = data["productName"].stringValue
        self.qty = data["qty"].stringValue
        self.discountTotal = data["discountTotal"].stringValue
        self.subtotal = data["subTotal"].stringValue
        self.totalTax = data["totalTax"].stringValue
    }
    
    
    
    
    
    
}





class SellerCreditMemoDetailsViewModel{
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
    var grandTotalAmount:String!
    var adjustmentFee:String!
    var adjustmentAmt:String!
    
    
    var sellerOrderItemList = [SellerCreditMemoProductList]()
    
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
        shipping = data["totalShipping"].stringValue
        shippingAddress = data["shippingAddress"].stringValue.html2String
        shippingMethod = data["shippingMethod"].stringValue
        subTotal = data["subTotal"].stringValue
        tax = data["totalTax"].stringValue
        vendorBaseTotal = data["vendorBaseTotal"].stringValue
        vendorTotal = data["vendorTotal"].stringValue
        self.grandTotalAmount = data["grandTotalAmt"].stringValue
        self.adjustmentFee = data["adjustmentFee"].stringValue
        self.adjustmentAmt = data["adjustmentAmt"].stringValue
        
        self.creditMemoTab = data["creditMemoTab"].intValue
        
        
        if let arrayData = data["itemList"].arrayObject{
            sellerOrderItemList =  arrayData.map({(value) -> SellerCreditMemoProductList in
                return  SellerCreditMemoProductList(data:JSON(value))
            })
        }
    }
    
    
    
    
}


