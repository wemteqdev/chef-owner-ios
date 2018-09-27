//
//  AddproductModel.swift
//  ShangMarket
//
//  Created by kunal on 23/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import Foundation


struct AllowedAttributesData {
    var label:String = ""
    var value:String = ""
    
    init(data:JSON) {
        self.label = data["label"].stringValue
        self.value = data["value"].stringValue
    }
    
}


struct AllowedTypes{
    var label:String = ""
    var value:String = ""
    
    init(data:JSON) {
        self.label = data["label"].stringValue
        self.value = data["value"].stringValue
    }

    
}

struct InventoryAvailabilityOptions{
    var label:String = ""
    var value:Int = 0
    
    init(data:JSON) {
        self.label = data["label"].stringValue
        self.value = data["value"].intValue
    }
    
    
}


struct TaxOptions{
    var label:String = ""
    var value:String = ""
    
    init(data:JSON) {
        self.label = data["label"].stringValue
        self.value = data["value"].stringValue
    }
    
    
}


struct VisibilityOptions{
    var label:String = ""
    var value:String = ""
    
    init(data:JSON) {
        self.label = data["label"].stringValue
        self.value = data["value"].stringValue
    }
    
    
}



struct ExtraAddProductData{
    var skutype:String!
    var addProductLimitStatus:Int!
    var addCrosssellProductStatus:Int!
    var addRelatedProductStatus:Int!
    var addUpsellProductStatus:Int!
    
    
    
    init(data:JSON) {
        self.skutype = data["skuType"].stringValue
        self.addProductLimitStatus = data["addProductLimitStatus"].intValue
        self.addCrosssellProductStatus = data["addCrosssellProductStatus"].intValue
        self.addRelatedProductStatus = data["addRelatedProductStatus"].intValue
        self.addUpsellProductStatus = data["addUpsellProductStatus"].intValue
    }
    
    
    
}











class AddproductViewModel{
    var allowedAttributesData = [AllowedAttributesData]()
    var allowedTypes = [AllowedTypes]()
    var inventoryAvailabilityOptions = [InventoryAvailabilityOptions]()
    var taxOptions = [TaxOptions]()
    var visibilityOptions = [VisibilityOptions]()
    var extraAddProductData:ExtraAddProductData!
    
    
    
    
    init(data:JSON) {
        if let arrayData = data["allowedAttributes"].arrayObject{
            allowedAttributesData =  arrayData.map({(value) -> AllowedAttributesData in
                return  AllowedAttributesData(data:JSON(value))
            })
        }
        
        if let arrayData = data["allowedTypes"].arrayObject{
            allowedTypes =  arrayData.map({(value) -> AllowedTypes in
                return  AllowedTypes(data:JSON(value))
            })
        }
        
        if let arrayData = data["inventoryAvailabilityOptions"].arrayObject{
            inventoryAvailabilityOptions =  arrayData.map({(value) -> InventoryAvailabilityOptions in
                return  InventoryAvailabilityOptions(data:JSON(value))
            })
        }
        
        if let arrayData = data["taxOptions"].arrayObject{
            taxOptions =  arrayData.map({(value) -> TaxOptions in
                return  TaxOptions(data:JSON(value))
            })
        }
        
        if let arrayData = data["visibilityOptions"].arrayObject{
            visibilityOptions =  arrayData.map({(value) -> VisibilityOptions in
                return  VisibilityOptions(data:JSON(value))
            })
        }
        
        extraAddProductData = ExtraAddProductData(data:data)
        
        
        
    }
    
    
    
    
    
    
    
    
}







