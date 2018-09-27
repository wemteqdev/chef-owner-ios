//
//  BarChartStructure.swift
//  MobikulMPMagento2
//
//  Created by andonina on 9/17/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

struct BarChartData {
    var order: Int
    var amount: String
    var indexData: String
    var percentage: Double
    
    init (order: Int, amount: String, indexData: String, percentage: Double) {
        self.order = order
        self.amount = amount
        self.indexData = indexData
        self.percentage = percentage
    }
}

struct DiagramTotalData {
    var ordersCount: Int
    var ordersTotal: String
    var supplierCounts: Int
    var percentage: Double
    
    init (ordersCount: Int, ordersTotal: String, supplierCounts: Int, percentage: Double) {
        self.ordersCount = ordersCount
        self.ordersTotal = ordersTotal
        self.supplierCounts = supplierCounts
        self.percentage = percentage
    }
}
