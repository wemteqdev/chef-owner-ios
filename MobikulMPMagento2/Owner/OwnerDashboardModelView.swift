//
//  OwnerDashboardModelView.swift
//  MobikulMPMagento2
//
//  Created by andonina on 9/17/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

class RestaurantInfoModel: NSObject {
    var restaurantName: String = "";
    var restaurantId: Int!;
    var chefData = [ChefInfoModel]();
    
    init(data:JSON) {
        print("restaurantinfo: ", data);
        restaurantName = data["restaurantName"].stringValue;
        restaurantId = data["restaurantId"].intValue;
        if let chefArrayData = data["chefData"].arrayObject{
            if(chefArrayData.count != 0){
                chefData =  chefArrayData.map({(value) -> ChefInfoModel in
                    return  ChefInfoModel(data:JSON(value))
                })
            }
        }
    }
}

class ChefInfoModel: NSObject {
    var chefEmail: String = "";
    var chefId: Int = 0;
    var restaurantId: Int = 0;
    var restaurantName: String = "";
    var chefFirstName: String = "";
    var chefLastName: String = "";
    var chefGender: Int = 0;
    var chefIsActive: Int = 0;
    
    init(data:JSON) {
        chefEmail = data["email"].stringValue;
        chefId = data["entity_id"].intValue;
        restaurantId = data["group_id"].intValue;
        chefFirstName = data["firstname"].stringValue;
        chefLastName = data["lastname"].stringValue;
        chefGender = data["gender"].intValue;
        chefIsActive = data["is_active"].intValue;
        restaurantName = data["restaurantName"].stringValue;
    }
}

class AddChefInfoModel: NSObject {
    var isAddSuccess: Bool = false;
    var errorMessage: String = "";
    var chefInfo: ChefInfoModel!;
    
    init(data:JSON) {
        isAddSuccess = data["addChefSuccess"].boolValue;
        errorMessage = data["errorMessage"].stringValue;
        chefInfo = ChefInfoModel(data:data["chefInfo"]);
    }
}

class AddRestaurantInfoModel: NSObject {
    var isAddSuccess: Bool = false;
    var errorMessage: String = "";
    var restaurantInfo: RestaurantInfoModel!;
    
    init(data:JSON) {
        isAddSuccess = data["addRestaurantSuccess"].boolValue;
        errorMessage = data["errorMessage"].stringValue;
        restaurantInfo = RestaurantInfoModel(data:data["restaurantInfo"]);
    }
}

class OwnerDashBoardViewModel: NSObject {
    //---for graph data-----
    var orderDailyTotal:[Double] = [];
    var orderWeeklyTotal:[Double] = [];
    var orderMonthlyTotal:[Double] = [];
    var orderYearlyTotal:[Double] = [];
    var orderYearlyIndexString:[String] = [];
    var orderMonthlyIndexString:[String] = [];
    var orderWeeklyIndexString:[String] = [];
    var orderDailyIndexString:[String] = [];
    //---for diagram data-------
    var diagramDailyTotal: DiagramTotalData!;
    var diagramWeeklyTotal: DiagramTotalData!;
    var diagramMonthlyTotal: DiagramTotalData!;
    var diagramYearlyTotal: DiagramTotalData!;
    //---for chef/restaurant info------
    var restaurantInfos = [RestaurantInfoModel]();
    
    init(data:JSON){
        //----------Get Graph Data(For daily, weekly, monthly, yearly)--------------
        if let arrayData = data["orderYearlyTotal"].arrayObject{
            orderYearlyTotal = arrayData as! [Double];
        }
        if let arrayData = data["orderMonthlyTotal"].arrayObject{
            orderMonthlyTotal = arrayData as! [Double];
        }
        if let arrayData = data["orderWeeklyTotal"].arrayObject{
            orderWeeklyTotal = arrayData as! [Double];
        }
        if let arrayData = data["orderDailyTotal"].arrayObject{
            orderDailyTotal = arrayData as! [Double];
        }
        if let arrayData = data["orderYearlyIndexString"].arrayObject{
            orderYearlyIndexString = arrayData as! [String];
        }
        if let arrayData = data["orderMonthlyIndexString"].arrayObject{
            orderMonthlyIndexString = arrayData as! [String];
        }
        if let arrayData = data["orderWeeklyIndexString"].arrayObject{
            orderWeeklyIndexString = arrayData as! [String];
        }
        if let arrayData = data["orderDailyIndexString"].arrayObject{
            orderDailyIndexString = arrayData as! [String];
        }
        //--------------Get Diagram Total Data(Total Purchase, order counts)------------------
        var percent:Double = 0.0;
        if(orderDailyTotal[orderDailyTotal.count - 2] != 0){
            percent = (Double)(orderDailyTotal[orderDailyTotal.count-1] - orderDailyTotal[orderDailyTotal.count-2])*100/orderDailyTotal[orderDailyTotal.count-2];
        } else {
            percent = orderDailyTotal[orderDailyTotal.count-1] * 100;
        }
        diagramDailyTotal = DiagramTotalData.init(ordersCount: data["dailyOrdersCount"].intValue, ordersTotal: String(format:"%.1f",orderDailyTotal[orderDailyTotal.count-1]), supplierCounts: 0, percentage: percent);
        
        percent = 0.0;
        if(orderWeeklyTotal[orderWeeklyTotal.count - 2] != 0){
            percent = (Double)(orderWeeklyTotal[orderWeeklyTotal.count-1] - orderWeeklyTotal[orderWeeklyTotal.count-2])*100/orderWeeklyTotal[orderWeeklyTotal.count-2];
        } else {
            percent = orderWeeklyTotal[orderWeeklyTotal.count-1] * 100;
        }
        diagramWeeklyTotal = DiagramTotalData.init(ordersCount: data["weeklyOrdersCount"].intValue, ordersTotal: String(format:"%.1f",orderWeeklyTotal[orderWeeklyTotal.count-1]), supplierCounts: 0, percentage: percent);
        
        percent = 0.0;
        if(orderMonthlyTotal[orderMonthlyTotal.count - 2] != 0){
            percent = (Double)(orderMonthlyTotal[orderMonthlyTotal.count-1] - orderMonthlyTotal[orderMonthlyTotal.count-2])*100/orderMonthlyTotal[orderMonthlyTotal.count-2];
        } else {
            percent = orderMonthlyTotal[orderMonthlyTotal.count-1] * 100;
        }
        diagramMonthlyTotal = DiagramTotalData.init(ordersCount: data["monthlyOrdersCount"].intValue, ordersTotal: String(format:"%.1f",orderMonthlyTotal[orderMonthlyTotal.count-1]), supplierCounts: 0, percentage: percent);
        
        percent = 0.0;
        if(orderYearlyTotal[orderYearlyTotal.count - 2] != 0){
            percent = (Double)(orderYearlyTotal[orderYearlyTotal.count-1] - orderYearlyTotal[orderYearlyTotal.count-2])*100/orderYearlyTotal[orderYearlyTotal.count-2];
        } else {
            percent = orderYearlyTotal[orderYearlyTotal.count-1] * 100;
        }
        diagramYearlyTotal = DiagramTotalData.init(ordersCount: data["yearlyOrdersCount"].intValue, ordersTotal: String(format:"%.1f",orderYearlyTotal[orderYearlyTotal.count-1]), supplierCounts: 0, percentage: percent);
        
        //-------------Get Restaurant Info------------------------
        if let restaurantArrayData = data["restaurantsInfo"].arrayObject{
            restaurantInfos =  restaurantArrayData.map({(value) -> RestaurantInfoModel in
                return  RestaurantInfoModel(data:JSON(value))
            })
        }
        print("restaurantCount:" + String(format: "%d", restaurantInfos.count));
    }
}
