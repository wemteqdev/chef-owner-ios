//
//  RestaurantDashboardModelView.swift
//  MobikulMPMagento2
//
//  Created by andonina on 10/9/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

class RestaurantDashboardModelView: NSObject {
    //---for chef/restaurant info------
    var restaurantInfos = [RestaurantInfoModel]();
    
    init(data:JSON) {        
        //-------------Get Restaurant Info------------------------
        if let restaurantArrayData = data["restaurantsInfo"].arrayObject{
            restaurantInfos =  restaurantArrayData.map({(value) -> RestaurantInfoModel in
                return  RestaurantInfoModel(data:JSON(value))
            })
        }
        print("restaurantCount:" + String(format: "%d", restaurantInfos.count));
    }
}
