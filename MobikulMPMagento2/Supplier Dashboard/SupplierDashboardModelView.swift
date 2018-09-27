//
//  OwnerDashboardModelView.swift
//  MobikulMPMagento2
//
//  Created by andonina on 9/17/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

class SupplierDashBoardViewModel: NSObject {
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
    var chefInfos = [ChefInfoModel]();
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
        diagramDailyTotal = DiagramTotalData.init(ordersCount: data["dailyOrdersCount"].intValue, ordersTotal: String(format:"%.1f",orderDailyTotal[orderDailyTotal.count-1]), supplierCounts: 0, percentage: 0);
        diagramWeeklyTotal = DiagramTotalData.init(ordersCount: data["weeklyOrdersCount"].intValue, ordersTotal: String(format:"%.1f",orderWeeklyTotal[orderWeeklyTotal.count-1]), supplierCounts: 0, percentage: 0);
        diagramMonthlyTotal = DiagramTotalData.init(ordersCount: data["monthlyOrdersCount"].intValue, ordersTotal: String(format:"%.1f",orderMonthlyTotal[orderMonthlyTotal.count-1]), supplierCounts: 0, percentage: 0);
        diagramYearlyTotal = DiagramTotalData.init(ordersCount: data["yearlyOrdersCount"].intValue, ordersTotal: String(format:"%.1f",orderYearlyTotal[orderYearlyTotal.count-1]), supplierCounts: 0, percentage: 0);
        //-------------Get Chef Info--------------------------
        if let chefArrayData = data["chefsInfo"].arrayObject{
            chefInfos =  chefArrayData.map({(value) -> ChefInfoModel in
                return  ChefInfoModel(data:JSON(value))
            })
        }
        print("chefCount:" + String(format: "%d", chefInfos.count));
        //-------------Get Restaurant Info------------------------
        if let restaurantArrayData = data["restaurantsInfo"].arrayObject{
            restaurantInfos =  restaurantArrayData.map({(value) -> RestaurantInfoModel in
                return  RestaurantInfoModel(data:JSON(value))
            })
        }
        print("restaurantCount:" + String(format: "%d", restaurantInfos.count));
    }
}
