//
//  ProductCollectionModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 09/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class ProductCollectionModel: NSObject {
    var productName:String = ""
    var productImage:String = ""
    var descriptionData:String = ""
    var id:String = ""
    var price:String = ""
    var rating:CGFloat!
    var isInWishlist:Bool!
    var isInRange:Bool!
    var formatedPrice:String = ""
    var specialPrice:Double = 0
    var normalprice:Double = 0
    var formatedSpecialPrice:String = ""
    var qty:String!
    var hasOption:Int = 0
    var typeID:String!
    var groupedPrice:String!
    var formatedMinPrice:String!
    var formatedMaxPrice:String!
    var wishlistItemId:String!

    init(data: JSON) {
        self.productImage = data["thumbNail"].stringValue
        self.descriptionData = data["shortDescription"].stringValue.html2String
        self.id = data["entityId"].stringValue
        self.price = data["formatedFinalPrice"].stringValue
        self.productName = data["name"].stringValue
        self.rating = CGFloat(data["rating"].floatValue)
        self.isInWishlist = data["isInWishlist"].boolValue
        self.isInRange = data["isInRange"].boolValue
        self.formatedPrice = data["formatedPrice"].stringValue
        self.specialPrice = data["finalPrice"].doubleValue
        self.normalprice = data["price"].doubleValue
        self.formatedSpecialPrice = data["formatedFinalPrice"].stringValue
        self.qty = "1";
        self.hasOption = data["hasOptions"].intValue
        self.groupedPrice = data["groupedPrice"].stringValue
        self.formatedMaxPrice = data["formatedMaxPrice"].stringValue
        self.formatedMinPrice = data["formatedMinPrice"].stringValue
        self.typeID = data["typeId"].stringValue
        self.wishlistItemId = data["wishlistItemId"].stringValue

    }

}

class SortCollectionData: NSObject{
    
    var code:String = ""
    var label:String = ""
    
    init(data: JSON) {
        self.code = data["code"].stringValue
        self.label = data["label"].stringValue
    }

}

class ExtraData:NSObject{
    var totalCount:Int = 0
    
     init(data: JSON) {
        totalCount = data["totalCount"].intValue
    }
    
}


class LayeredData:NSObject{
    var code:String!
    var label:String!
    var option:Array<Any>!
    
    init(data:JSON){
        self.code = data["code"].stringValue
        self.label = data["label"].stringValue
        self.option = data["options"].arrayObject
    }
 
}





class ProductCollectionViewModel {
    var productCollectionModel = [ProductCollectionModel]()
    var sortCollectionModel = [SortCollectionData]();
    var extraData:ExtraData!
    var layeredData = [LayeredData]()
    var productCategoryData: NSArray = []
    var allLayeredData :NSArray = []

    
    init(data:JSON) {
        let arrayData = data["productList"].arrayObject! as NSArray
        productCollectionModel =  arrayData.map({(value) -> ProductCollectionModel in
            return  ProductCollectionModel(data:JSON(value))
        })
        
        if data["layeredData"].arrayObject != nil{
        let arrayData = data["layeredData"].arrayObject! as NSArray
        layeredData =  arrayData.map({(value) -> LayeredData in
            return  LayeredData(data:JSON(value))
        })
        }
        
        
        for i in 0..<data["sortingData"].count{
            let dict = data["sortingData"][i];
            sortCollectionModel.append(SortCollectionData(data: dict))
        }
        extraData = ExtraData(data: data)
        
        productCategoryData = arrayData
        
        if data["layeredData"].arrayObject != nil{
            allLayeredData = data["layeredData"].arrayObject! as NSArray
        }

    }
    
    var getProductCollectionData:Array<ProductCollectionModel>{
        return productCollectionModel
    }
    
    var getProductCollectionSortData:Array<SortCollectionData>{
        return sortCollectionModel
    }
    
    func setProductCollectionData(data:JSON){
        let arrayData = data["productList"].arrayObject! as NSArray
        productCollectionModel = productCollectionModel + arrayData.map({(value) -> ProductCollectionModel in
            return  ProductCollectionModel(data:JSON(value))
        })
    }
    
    var getLayeredData:Array<LayeredData>{
        return layeredData;
    }
    
    func setLayeredData(data:JSON){
        layeredData.removeAll()
        let arrayData = data["layeredData"].arrayObject! as NSArray
        layeredData = arrayData.map({(value) -> LayeredData in
            return  LayeredData(data:JSON(value))
        })
    }
    
    var totalCount:Int{
        return extraData.totalCount
    }
    
    var getSortCollectionData:Array<SortCollectionData>{
        return sortCollectionModel;
    }
    
    var getProductCollectionJsonData:NSArray{
        return productCategoryData
    }
    
    var getAllLayerData:NSArray{
        return allLayeredData
    }

    
    func setProductCollectionJsonData(data:JSON){
        let arrayData = data["productList"].arrayObject! as NSArray
        productCategoryData = self.productCategoryData.addingObjects(from: arrayData as! [Any]) as NSArray
    
    }
    
    func setQtyDataToProductCategoryModel(data:String,pos:Int){
        productCollectionModel[pos].qty = data;
    }
    
    func setWishListFlagToProductCategoryModel(data:Bool,pos:Int){
        productCollectionModel[pos].isInWishlist = data;
    }
    
    func setWishListItemIdToProductCategoryModel(data:String,pos:Int){
        productCollectionModel[pos].wishlistItemId = data;
    }


    
}



