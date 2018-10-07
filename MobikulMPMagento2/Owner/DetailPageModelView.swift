//
//  OwnerDashboardModelView.swift
//  MobikulMPMagento2
//
//  Created by andonina on 9/17/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

class DetailPageModelView: NSObject {
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
    var monthlyCreditMemosCount: Int!;
    var monthlyCompleteOrdersCount: Int!;
    var monthlyPendingOrdersCount: Int!;
    
    init(data:JSON){
        monthlyCreditMemosCount = data["monthlyCreditMemosCount"].intValue;
        monthlyCompleteOrdersCount = data["monthlyCompleteOrdersCount"].intValue;
        monthlyPendingOrdersCount = data["monthlyPendingOrdersCount"].intValue;
        //----------Get Graph Data(For daily, weekly, monthly, yearly)--------------
        if let arrayData = data["orderYearlyTotal"].arrayObject{
            orderYearlyTotal = arrayData as! [Double];
            print("orderYearlyTotal:", orderYearlyTotal);
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
        
    }
}
