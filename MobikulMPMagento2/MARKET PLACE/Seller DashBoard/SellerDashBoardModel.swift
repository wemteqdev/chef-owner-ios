//
//  SellerDashBoardModel.swift
//  MobikulMPMagento2
//
//  Created by kunal on 25/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation











struct TopSellingProductData{
    var id:String = ""
    var name:String = ""
    var openable:Int!
    var qty:String = ""
    
    init(data:JSON){
        self.id = data["id"].stringValue
        self.name = data["name"].stringValue
        self.openable = data["openable"].intValue
        self.qty = data["qty"].stringValue
     }
    
}


struct SellerReviewList{
    var comment:String = ""
    var date:String = ""
    var name:String = ""
    var pricerating:Int!
    var qualityrating:Int!
    var valuerating:Int!
    
    init(data:JSON) {
        self.comment = data["comment"].stringValue
        self.date = data["date"].stringValue
        self.name = data["name"].stringValue
        self.pricerating = data["priceRating"].intValue/20
        self.qualityrating = data["priceRating"].intValue/20
        self.valuerating = data["valueRating"].intValue/20
 
    }
    
}


struct ExtraSaleDashBoardData{
    var totalSale:String = ""
    var remainingAmount:String = ""
    var lifeTimesales:String = ""
    var categoryChart:String = ""
    var dailySalesLocationReport:String!
    var dailySalesStats:String!
    var monthlySalesLocationReport:String!
    var monthlySalesStats:String!
    var weeklySalesLocationReport:String!
    var weeklySalesStats:String!
    var yearlySalesLocationReport:String!
    var yearlySalesStats:String!
    
    
    
    
    init(data:JSON) {
        self.totalSale = data["totalPayout"].stringValue
        self.lifeTimesales = data["lifetimeSale"].stringValue
        self.remainingAmount = data["remainingAmount"].stringValue
        self.categoryChart = data["categoryChart"].stringValue
        self.dailySalesLocationReport = data["dailySalesLocationReport"].stringValue
        self.dailySalesStats = data["dailySalesStats"].stringValue
        self.monthlySalesLocationReport = data["monthlySalesLocationReport"].stringValue
        self.monthlySalesStats = data["monthlySalesStats"].stringValue
        self.weeklySalesLocationReport = data["weeklySalesLocationReport"].stringValue
        self.weeklySalesStats = data["weeklySalesStats"].stringValue
        self.yearlySalesLocationReport = data["yearlySalesLocationReport"].stringValue
        self.yearlySalesStats = data["yearlySalesStats"].stringValue
        
        
        
    }
    

}




struct SellerRecentOrderData{
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



struct SellerProducts{
    var name:String = ""
    var productId:String = ""
    var qty:String = ""
    
    init(data:JSON) {
        self.name = data["name"].stringValue
        self.productId = data["productId"].stringValue
        self.qty = data["qty"].stringValue
     }

}











class SellerDashBoardViewModel: NSObject {
    var extraSaleDashBoardData:ExtraSaleDashBoardData!
    var topSellingProductData = [TopSellingProductData]()
    var sellerReviewList = [SellerReviewList]()
    var sellerRecentOrderData = [SellerRecentOrderData]()
    
    init(data:JSON){
        extraSaleDashBoardData = ExtraSaleDashBoardData(data: data)
        
        if let arrayData = data["topSellingProducts"].arrayObject{
        topSellingProductData =  arrayData.map({(value) -> TopSellingProductData in
            return  TopSellingProductData(data:JSON(value))
        })
        }
        if let arrayData = data["reviewList"].arrayObject{
            sellerReviewList =  arrayData.map({(value) -> SellerReviewList in
                return  SellerReviewList(data:JSON(value))
            })
        }
        if let arrayData = data["recentOrderList"].arrayObject{
            sellerRecentOrderData =  arrayData.map({(value) -> SellerRecentOrderData in
                return  SellerRecentOrderData(data:JSON(value))
            })
        }
        
        
    }
    
    
    
    
}









