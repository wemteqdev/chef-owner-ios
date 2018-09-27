//
//  CrossSellProductModel.swift
//  ShangMarket
//
//  Created by kunal on 26/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import Foundation

//
//  UpSellProductModel.swift
//  ShangMarket
//
//  Created by kunal on 26/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import Foundation



//
//  AddRelatedProductModel.swift
//  ShangMarket
//
//  Created by kunal on 26/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import Foundation


struct CrosssellProductModel{
    var attrinuteSet:String!
    var entity_id:String!
    var name:String!
    var price:String!
    var selected:Int!
    var sku:String!
    var status:String!
    var thumbnail:String!
    var type:String!
    
    
    init(data:JSON) {
        self.attrinuteSet = data["attrinuteSet"].stringValue
        self.entity_id = data["entity_id"].stringValue
        self.name = data["name"].stringValue
        self.price = data["price"].stringValue
        self.selected = data["selected"].intValue
        self.sku = data["sku"].stringValue
        self.status = data["status"].stringValue
        self.thumbnail = data["thumbnail"].stringValue
        self.type = data["type"].stringValue
        
    }
    
    
    
    
}



class CrosssellProductViewModel{
    var crosssellProductModel = [CrosssellProductModel]()
    var totalCount:Int = 0
    
    init(data:JSON) {
        if let arrayData = data["productCollectionData"].arrayObject{
            crosssellProductModel =  arrayData.map({(value) -> CrosssellProductModel in
                return  CrosssellProductModel(data:JSON(value))
            })
        }
        
        totalCount = data["totalCount"].intValue
        
    }
    
    func setProductCollectionData(data:JSON){
        let arrayData = data["productCollectionData"].arrayObject! as NSArray
        crosssellProductModel = crosssellProductModel + arrayData.map({(value) -> CrosssellProductModel in
            return  CrosssellProductModel(data:JSON(value))
        })
    }
    
    func setDataToRelatedModel(data:Int,pos:Int){
        crosssellProductModel[pos].selected = data;
    }
    
    
    
}







