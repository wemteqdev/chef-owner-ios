//
//  ChefDashboardModelView.swift
//  MobikulMPMagento2
//
//  Created by andonina on 10/3/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

class RestaurantOnlyInfoModel: NSObject {
    var restaurantName: String = "";
    var restaurantId: Int!;
    var taxClassId: Int!;
    
    init(data:JSON) {
        restaurantName = data["customer_group_code"].stringValue;
        restaurantId = data["customer_group_id"].intValue;
        taxClassId = data["tax_class_id"].intValue;
    }
}
class ChefDashboardModelView: NSObject {
    var restaurantInfos:[RestaurantOnlyInfoModel] = [];
    
    init(data:JSON) {
        if let restaurantArrayData = data["getAllRestaurants"].arrayObject{
            restaurantInfos =  restaurantArrayData.map({(value) -> RestaurantOnlyInfoModel in
                return  RestaurantOnlyInfoModel(data:JSON(value))
            })
        }
    }
}
