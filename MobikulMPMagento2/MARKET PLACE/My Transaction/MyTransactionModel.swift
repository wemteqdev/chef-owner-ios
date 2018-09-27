//
//  MyTransactionModel.swift
//  MobikulMPMagento2
//
//  Created by kunal on 27/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation



struct MyTransactionModel{
    var amount:String = ""
    var comment:String = ""
    var date:String = ""
    var transactionId:String = ""
    var id:String!
    
    init(data:JSON) {
        self.amount = data["amount"].stringValue
        self.comment = data["comment"].stringValue
        self.date = data["date"].stringValue
        self.id = data["id"].stringValue
        self.transactionId = data["transactionId"].stringValue
    }
    
    
}




class MyTransactionListViewModel{
    var myTransactionModel = [MyTransactionModel]()
    var totalCount = 0
    var remainingTransactionAmount:String = ""
    
    init(data:JSON) {
        if let arrayData = data["transactionList"].arrayObject{
            myTransactionModel =  arrayData.map({(value) -> MyTransactionModel in
                return  MyTransactionModel(data:JSON(value))
            })
        }
        totalCount = data["totalCount"].intValue
        remainingTransactionAmount = data["remainingTransactionAmount"].stringValue
        
    }
    
    
    func setTransactionCollectionData(data:JSON){
        for i in 0..<data["transactionList"].count{
            let dict = data["transactionList"][i];
            myTransactionModel.append(MyTransactionModel(data: dict))
        }
    }
    
    
    
    
    
    
}


