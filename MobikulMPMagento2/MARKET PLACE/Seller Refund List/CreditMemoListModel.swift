//
//  CreditMemoListModel.swift
//  MobikulMPMagento2
//
//  Created by kunal on 07/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation



struct CreditMemoList {
    var amount:String!
    var billToName:String!
    var createdAt :String!
    var entityId:String!
    var status:String!
    var incrementId:String!
    
    init(data:JSON) {
        self.amount = data["amount"].stringValue
        self.billToName = data["amount"].stringValue
        self.createdAt = data["createdAt"].stringValue
        self.entityId = data["entityId"].stringValue
        self.status = data["status"].stringValue
        self.incrementId = data["incrementId"].stringValue
    }

}






class CreditMemoListViewModel: NSObject {
    var creditMemoList = [CreditMemoList]()
    
    init(data:JSON) {
     
    if let arrayData = data["creditMemoList"].arrayObject{
        creditMemoList =  arrayData.map({(value) -> CreditMemoList in
            return  CreditMemoList(data:JSON(value))
        })
    }
    
    }
}








