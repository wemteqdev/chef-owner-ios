//
//  CreateCreditMemoModel.swift
//  MobikulMPMagento2
//
//  Created by kunal on 08/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation


struct CreateCreditMemoListModel{
    
    var productName:String!
    var price:String!
    var returnToStock:String = "0"
    var qty_To_Refund:String = "1"
    var subTotal:String!
    var totalTax:String!
    var discount:String!
    var rowTotal:String!
    var sellerQty = [SellerQty]()
    var itemId:String!
    
    
    init(data:JSON) {
        self.productName = data["productName"].stringValue
        self.price = data["price"].stringValue
        self.returnToStock = "0"
        self.qty_To_Refund = "1"
        self.subTotal = data["subTotal"].stringValue
        self.totalTax = data["totalTax"].stringValue
        self.discount = data["discount"].stringValue
        self.rowTotal = data["rowTotal"].stringValue
        self.itemId = data["itemId"].stringValue
        
        
        if let arrayData = data["qty"].arrayObject{
            sellerQty =  arrayData.map({(value) -> SellerQty in
                return  SellerQty(data:JSON(value))
            })
        }
    }
    

}






class CreateCreditMemoListViewModel: NSObject {
    var createCreditMemoListModel = [CreateCreditMemoListModel]()
    var billingAddress:String!
    var customerEmail:String!
    var customerName :String!
    var discount:String!
    var grandTotal:String!
    var invoiceId :String!
    var orderGrandTotal:String!
    var paidAmount:String!
    var refundAmount:String!
    var shippingAddress:String!
    var shippingAmount:String!
    var shippingRefund:String!
    var subTotal:String!
    var  totalTax :String!
    var paymentMethod:String!
    var shippingMethod:String!
    var refundOnlineEnableFlag:Int!
    
    
    init(data:JSON) {
    
        billingAddress = data["billingAddress"].stringValue.html2String
        customerEmail = data["customerEmail"].stringValue
        customerName =  data["customerName"].stringValue
        discount =  data["discount"].stringValue
        grandTotal =  data["grandTotal"].stringValue
        invoiceId  =  data["invoiceId"].stringValue
        orderGrandTotal =  data["orderGrandTotal"].stringValue
        paidAmount =  data["paidAmount"].stringValue
        refundAmount =  data["refundAmount"].stringValue
        shippingAddress =  data["shippingAddress"].stringValue.html2String
        shippingAmount =  data["shippingAmount"].stringValue
        shippingRefund =  data["customerEmail"].stringValue
        subTotal =  data["subTotal"].stringValue
        totalTax  =  data["totalTax"].stringValue
        self.paymentMethod = data["paymentMethod"].stringValue
        self.shippingMethod = data["shippingMethod"].stringValue
        self.refundOnlineEnableFlag = data["refundOnlineEnableFlag"].intValue
        
        if let arrayData = data["itemList"].arrayObject{
            createCreditMemoListModel =  arrayData.map({(value) -> CreateCreditMemoListModel in
                return  CreateCreditMemoListModel(data:JSON(value))
            })
        }
    }
    
    
    func setReturnToStockValue(data:String,pos:Int){
        createCreditMemoListModel[pos].returnToStock = data;
    }
    
    func setqty_To_RefundValue(data:String,pos:Int){
        createCreditMemoListModel[pos].qty_To_Refund = data;
    }
    
    
    
    
}




