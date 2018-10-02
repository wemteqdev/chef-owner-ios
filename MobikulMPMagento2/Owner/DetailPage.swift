//
//  Detail.swift
//  MobikulMPMagento2
//
//  Created by andonina on 9/13/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation
//
//  SignInOrNew.swift
//  MobikulMPMagento2
//
//  Created by Othello on 12/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class DetailPage: UIViewController{
    @IBOutlet weak var showTypeController: UISegmentedControl!
    @IBOutlet weak var diagramTotalView: UIStackView!
    @IBOutlet weak var barChartView: UIStackView!
    @IBOutlet weak var indexChartView: UIStackView!
    @IBOutlet weak var ordersTotalView: UIStackView!
    @IBOutlet weak var salesInsightView: UIView!
    
    var mainCollection:JSON!
    var showType = 0;
    var orderTotal:NSMutableArray = []
    var callingApiSucceed: Bool = false;
    var pageType = 1;
    var customerId = -1;
    var detailPageModelView:DetailPageModelView!;
    
    @IBAction func SegmentValueChanged(_ sender: Any) {
        if showTypeController.selectedSegmentIndex == 0{
            showType = 0;
        } else if showTypeController.selectedSegmentIndex == 1{
            showType = 1;
        } else if showTypeController.selectedSegmentIndex == 2{
            showType = 2;
        } else if showTypeController.selectedSegmentIndex == 3{
            showType = 3;
        }
        if (callingApiSucceed){
            var chartData: [BarChartData] = self.createChartDataCollection();
            print("chartData", chartData)
            barChartView.removeAllArrangedSubviews();
            indexChartView.removeAllArrangedSubviews();
            diagramTotalView.removeAllArrangedSubviews();
            for data in chartData {
                self.addIndexElement(timeGraphData: data);
                self.addGraphElement(timeGraphData: data);
            }
            if(self.showType == 0)
            {
                self.addDiagramTotalElement(diagramData: detailPageModelView.diagramDailyTotal);
            }
            else if(self.showType == 1)
            {
                self.addDiagramTotalElement(diagramData: detailPageModelView.diagramWeeklyTotal);
            }
            else if(self.showType == 2)
            {
                self.addDiagramTotalElement(diagramData: detailPageModelView.diagramMonthlyTotal);
            }
            else if(self.showType == 3)
            {
                self.addDiagramTotalElement(diagramData: detailPageModelView.diagramYearlyTotal);
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "back_color"), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage();
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //self.salesInsightView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        if (pageType == 1){
            self.navigationItem.title = GlobalData.sharedInstance.language(key: "Chef")
        } else if (pageType == 2){
            self.navigationItem.title = GlobalData.sharedInstance.language(key: "Restaurant")
        } else if (pageType == 3){
            self.navigationItem.title = GlobalData.sharedInstance.language(key: "Supplier")
        }
        
        queue.maxConcurrentOperationCount = 20;
        
        self.callingHttppApi();
    }
    
    func callingHttppApi(){
        var requstParams = [String:Any]();
        
        requstParams = [String:Any]();
        requstParams["websiteId"] = DEFAULT_WEBSITE_ID
        if customerId != -1{
            requstParams["customerToken"] = customerId
            requstParams["customerId"] = customerId
            requstParams["customerType"] = pageType + 1;
        }
        
        self.view.isUserInteractionEnabled = false
        self.callingApiSucceed = false;
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/order/cheforders", currentView: self){success,responseObject in
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        defaults .set(storeId, forKey: "storeId")
                    }
                }
                GlobalData.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
                self.callingApiSucceed = true
                var dict = JSON(responseObject as! NSDictionary)
                print("jsonData:", responseObject);
                if dict["success"].boolValue == true{
                    self.detailPageModelView = DetailPageModelView(data:dict)
                    var chartData: [BarChartData] = self.createChartDataCollection();
                    print("chartData", chartData)
                    
                    self.barChartView.removeAllArrangedSubviews();
                    self.indexChartView.removeAllArrangedSubviews();
                    self.diagramTotalView.removeAllArrangedSubviews();
                    self.ordersTotalView.removeAllArrangedSubviews();
                    
                    for data in chartData {
                        self.addIndexElement(timeGraphData: data)
                        self.addGraphElement(timeGraphData: data);
                    }
                    if(self.showType == 0)
                    {
                        self.addDiagramTotalElement(diagramData: self.detailPageModelView.diagramDailyTotal);
                        print("diagram:", self.detailPageModelView.diagramDailyTotal)
                    }
                    else if(self.showType == 1)
                    {
                        self.addDiagramTotalElement(diagramData: self.detailPageModelView.diagramWeeklyTotal);
                    }
                    else if(self.showType == 2)
                    {
                        self.addDiagramTotalElement(diagramData: self.detailPageModelView.diagramMonthlyTotal);
                    }
                    else if(self.showType == 3)
                    {
                        self.addDiagramTotalElement(diagramData: self.detailPageModelView.diagramYearlyTotal);
                    }
                    self.addOrderTotalView();
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
        GlobalData.sharedInstance.showLoader()
    }
    
    private func createChartDataCollection () -> [BarChartData] {
        
        var chatDataArray = [BarChartData]();
        
        var orderTotal = self.detailPageModelView.orderYearlyTotal;
        var orderString = self.detailPageModelView.orderYearlyIndexString;
        if (showType == 0)
        {
            orderTotal = self.detailPageModelView.orderDailyTotal;
            orderString = self.detailPageModelView.orderDailyIndexString;
        }
        else if(showType == 1)
        {
            orderTotal = self.detailPageModelView.orderWeeklyTotal;
            orderString = self.detailPageModelView.orderWeeklyIndexString;
        }
        else if(showType == 2)
        {
            orderTotal = self.detailPageModelView.orderMonthlyTotal;
            orderString = self.detailPageModelView.orderMonthlyIndexString;
        }
        print("orderTotal:", orderTotal)
        print("orderString:", orderString)
        /*
         var orderTotal = [
         [32.1, 35.5, 95.4, 67.0, 53.5, 87.0, 72.2],
         [52.1, 25.5, 105.4, 37.0, 53.5, 47.0, 92.2],
         [182.1, 165.5, 145.4, 147.0, 193.5, 127.0, 152.2],
         [232.1, 185.5, 165.4, 267.0, 153.5, 117.0, 192.2]
         ];
         var orderString = ["09-14", "09-15", "09-16", "09-17", "09-18", "09-19", "09-20"];
         */
        
        let maxData = orderTotal.max()
        for ind in 0...orderTotal.count-1 {
            var percent:Double = 0.0;
            if(maxData != 0){
                percent = orderTotal[ind] / maxData! * 100
            }
            let chartData = BarChartData.init(order: 0, amount: String(format:"%.1f", orderTotal[ind]), indexData: orderString[ind], percentage: percent)
            chatDataArray.append(chartData);
        }
        /*
         let maxData = orderTotal[showType].max()
         for ind in 0...orderTotal[showType].count-1 {
         let percent = orderTotal[showType][ind] / maxData! * 100
         let chartData = BarChartData.init(order: 0, amount: String(format:"%.1f", orderTotal[showType][ind]), indexData: orderString[ind], percentage: percent)
         chatDataArray.append(chartData);
         }
         */
        return chatDataArray
    }
    
    private func heightPixelsDependOfPercentage (percentage: Double) -> CGFloat {
        let maxHeight: CGFloat = 120.0
        return (CGFloat(percentage) * maxHeight) / 100
    }
    
    private func addGraphElement (timeGraphData: BarChartData) {
        let amountLabelFontSize: CGFloat = 9.0
        let amountLabelPadding: CGFloat = 15.0
        let height = heightPixelsDependOfPercentage(percentage: timeGraphData.percentage)
        let totalHeight = height + amountLabelPadding
        let graphColor: UIColor = UIColor(red: 51/255, green: 196/255, blue: 255/255, alpha: 1.0)
        
        let verticalStackView: UIStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 8.0
        
        let amountLabel = UILabel()
        amountLabel.text = timeGraphData.amount
        amountLabel.font = UIFont.systemFont(ofSize: amountLabelFontSize)
        amountLabel.textAlignment = .center
        amountLabel.textColor = UIColor.darkText
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.heightAnchor.constraint(equalToConstant: amountLabelFontSize).isActive = true
        
        let view = UIView()
        view.backgroundColor = graphColor
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        verticalStackView.addArrangedSubview(amountLabel)
        verticalStackView.addArrangedSubview(view)
        
        verticalStackView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false;
        
        barChartView.addArrangedSubview(verticalStackView)
        barChartView.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    private func addIndexElement (timeGraphData: BarChartData) {
        let monthLabelHeight: CGFloat = 13.0
        
        let monthLabel = UILabel()
        monthLabel.text = timeGraphData.indexData
        monthLabel.font = UIFont.systemFont(ofSize: monthLabelHeight)
        monthLabel.textAlignment = .center
        
        monthLabel.heightAnchor.constraint(equalToConstant: monthLabelHeight).isActive = true
        
        indexChartView.addArrangedSubview(monthLabel)
        indexChartView.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    private func addDiagramTotalElement (diagramData: DiagramTotalData) {
        let purchaseLabelHeight: CGFloat = 20.0
        
        let purchaseLabel = UILabel()
        let purchaseStringLabel = UILabel()
        
        let verticalStackView: UIStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 8.0
        
        purchaseLabel.textColor = UIColor(red: 255/255, green: 138/255, blue: 0/255, alpha: 1.0);
        purchaseLabel.text = "$ " + diagramData.ordersTotal;
        purchaseLabel.font = UIFont.boldSystemFont(ofSize: purchaseLabelHeight)
        purchaseLabel.textAlignment = .center
        
        purchaseLabel.heightAnchor.constraint(equalToConstant: purchaseLabelHeight).isActive = true
        
        purchaseStringLabel.textColor = UIColor.darkText;
        purchaseStringLabel.text = "Purchases";
        purchaseStringLabel.font = UIFont.boldSystemFont(ofSize: 13)
        purchaseStringLabel.textAlignment = .center
        
        purchaseStringLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
        
        verticalStackView.addArrangedSubview(purchaseLabel)
        verticalStackView.addArrangedSubview(purchaseStringLabel)
        
        verticalStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false;
        //---change---
        let verticalStackViewChange: UIStackView = UIStackView()
        verticalStackViewChange.axis = .vertical
        verticalStackViewChange.alignment = .fill
        verticalStackViewChange.distribution = .fill
        verticalStackViewChange.spacing = 8.0
        
        let changeLabel = UILabel()
        let changeStringLabel = UILabel()
        changeLabel.textColor = UIColor(red: 39/255, green: 183/255, blue: 100/255, alpha: 1.0);
        //changeLabel.text = String(format: "%d",diagramData.ordersCount);
        if(diagramData.percentage >= 0) {
            changeLabel.text = String(format: "↑%0.1f%%", diagramData.percentage);
        } else {
            changeLabel.text = String(format: "↓%0.1f%%", diagramData.percentage);
        }
        print("diagram percent:", changeLabel.text);
        changeLabel.font = UIFont.boldSystemFont(ofSize: 15)
        changeLabel.textAlignment = .center
        
        changeLabel.heightAnchor.constraint(equalToConstant: purchaseLabelHeight).isActive = true
        
        changeStringLabel.textColor = UIColor.darkText;
        changeStringLabel.text = "Changes";
        changeStringLabel.font = UIFont.boldSystemFont(ofSize: 13)
        changeStringLabel.textAlignment = .center
        
        changeStringLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        verticalStackViewChange.addArrangedSubview(changeLabel)
        verticalStackViewChange.addArrangedSubview(changeStringLabel)
        
        verticalStackViewChange.heightAnchor.constraint(equalToConstant: 60).isActive = true
        verticalStackViewChange.translatesAutoresizingMaskIntoConstraints = false;
        //----orders----
        let verticalStackViewOrder: UIStackView = UIStackView()
        verticalStackViewOrder.axis = .vertical
        verticalStackViewOrder.alignment = .fill
        verticalStackViewOrder.distribution = .fill
        verticalStackViewOrder.spacing = 8.0
        
        let orderCountLabel = UILabel()
        let orderCountStringLabel = UILabel()
        orderCountLabel.textColor = UIColor(red: 165/255, green: 96/255, blue: 245/255, alpha: 1.0);
        orderCountLabel.text = String(format: "%d",diagramData.ordersCount);
        orderCountLabel.font = UIFont.boldSystemFont(ofSize: purchaseLabelHeight)
        orderCountLabel.textAlignment = .center
        
        orderCountLabel.heightAnchor.constraint(equalToConstant: purchaseLabelHeight).isActive = true
        
        orderCountStringLabel.textColor = UIColor.darkText;
        orderCountStringLabel.text = "Orders";
        orderCountStringLabel.font = UIFont.boldSystemFont(ofSize: 13)
        orderCountStringLabel.textAlignment = .center
        
        orderCountStringLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
        
        verticalStackViewOrder.addArrangedSubview(orderCountLabel)
        verticalStackViewOrder.addArrangedSubview(orderCountStringLabel)
        
        verticalStackViewOrder.heightAnchor.constraint(equalToConstant: 60).isActive = true
        verticalStackViewOrder.translatesAutoresizingMaskIntoConstraints = false;
        //---suppliers---
        let verticalStackViewSuppliers: UIStackView = UIStackView()
        verticalStackViewSuppliers.axis = .vertical
        verticalStackViewSuppliers.alignment = .fill
        verticalStackViewSuppliers.distribution = .fill
        verticalStackViewSuppliers.spacing = 8.0
        
        let suppliersLabel = UILabel()
        let suppliersStringLabel = UILabel()
        suppliersLabel.textColor = UIColor(red: 165/255, green: 96/255, blue: 245/255, alpha: 1.0);
        //changeLabel.text = String(format: "%d",diagramData.ordersCount);
        suppliersLabel.text = String(format: "16");
        suppliersLabel.font = UIFont.boldSystemFont(ofSize: purchaseLabelHeight)
        suppliersLabel.textAlignment = .center
        
        suppliersLabel.heightAnchor.constraint(equalToConstant: purchaseLabelHeight).isActive = true
        
        suppliersStringLabel.textColor = UIColor.darkText;
        suppliersStringLabel.text = "Suppliers";
        suppliersStringLabel.font = UIFont.boldSystemFont(ofSize: 13)
        suppliersStringLabel.textAlignment = .center
        
        suppliersStringLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        verticalStackViewSuppliers.addArrangedSubview(suppliersLabel)
        verticalStackViewSuppliers.addArrangedSubview(suppliersStringLabel)
        
        verticalStackViewSuppliers.heightAnchor.constraint(equalToConstant: 60).isActive = true
        verticalStackViewSuppliers.translatesAutoresizingMaskIntoConstraints = false;
        diagramTotalView.addArrangedSubview(verticalStackView)
        diagramTotalView.addArrangedSubview(verticalStackViewChange)
        diagramTotalView.addArrangedSubview(verticalStackViewOrder)
        diagramTotalView.addArrangedSubview(verticalStackViewSuppliers)
        diagramTotalView.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    private func addOrderTotalView () {
        
        let horizontalStackView1: UIStackView = UIStackView()
        horizontalStackView1.axis = .horizontal
        horizontalStackView1.alignment = .fill
        horizontalStackView1.distribution = .fillEqually
        //horizontalStackView1.spacing = 8.0
        
        let yearlyOrderView = Bundle.main.loadNibNamed("OrderViewCell", owner: self, options: nil)?.first as! OrderViewCell
        let monthlyOrderView = Bundle.main.loadNibNamed("OrderViewCell", owner: self, options: nil)?.first as! OrderViewCell
       
        yearlyOrderView.orderDescription.text = "This year " + self.detailPageModelView.orderYearlyIndexString[self.detailPageModelView.orderYearlyIndexString.count - 2] + "-" + self.detailPageModelView.orderYearlyIndexString[self.detailPageModelView.orderYearlyIndexString.count - 1];
        yearlyOrderView.ordersCount.text = String(format: "%d", self.detailPageModelView.diagramYearlyTotal.ordersCount);
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        
        monthlyOrderView.orderDescription.text = "This Month - " + nameOfMonth;
        monthlyOrderView.orderDescription.textColor = UIColor.red;
        monthlyOrderView.ordersCount.text = String(format: "%d", self.detailPageModelView.diagramMonthlyTotal.ordersCount);
        monthlyOrderView.ordersCount.textColor = UIColor.red;
        
        horizontalStackView1.addArrangedSubview(yearlyOrderView)
        horizontalStackView1.addArrangedSubview(monthlyOrderView)
        //horizontalStackView1.heightAnchor.constraint(equalToConstant: 100).isActive = true
        //horizontalStackView1.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //horizontalStackView1.translatesAutoresizingMaskIntoConstraints = false;
        
        let horizontalStackView2: UIStackView = UIStackView()
        horizontalStackView2.axis = .horizontal
        horizontalStackView2.alignment = .fill
        horizontalStackView2.distribution = .fillEqually
        //horizontalStackView2.spacing = 8.0
        
        let creditNotesView = Bundle.main.loadNibNamed("OrderViewCell", owner: self, options: nil)?.first as! OrderViewCell
        let totalOrderView = Bundle.main.loadNibNamed("OrderViewCell", owner: self, options: nil)?.first as! OrderViewCell
        creditNotesView.orderName.text = "Credit notes"
        creditNotesView.orderDescription.text = "This Month - " + nameOfMonth;
        creditNotesView.orderDescription.textColor = UIColor.red;
        creditNotesView.ordersCount.textColor = UIColor.red;
        creditNotesView.ordersCount.text = String(format:"%d", self.detailPageModelView.monthlyCreditMemosCount);
        
        totalOrderView.orderName.text = "Total Orders"
        totalOrderView.orderDescription.text = "This Month - " + nameOfMonth;
        totalOrderView.ordersCount.text = "$ " + self.detailPageModelView.diagramMonthlyTotal.ordersTotal;
        
        horizontalStackView2.addArrangedSubview(creditNotesView)
        horizontalStackView2.addArrangedSubview(totalOrderView)
 
        let horizontalStackView3: UIStackView = UIStackView()
        horizontalStackView3.axis = .horizontal
        horizontalStackView3.alignment = .fill
        horizontalStackView3.distribution = .fillEqually
        //horizontalStackView2.spacing = 8.0
        
        let deliveryView = Bundle.main.loadNibNamed("OrderViewCell", owner: self, options: nil)?.first as! OrderViewCell
        let pendingView = Bundle.main.loadNibNamed("OrderViewCell", owner: self, options: nil)?.first as! OrderViewCell
        deliveryView.orderName.text = "Delivered"
        deliveryView.orderDescription.text = "This Month - " + nameOfMonth;
        deliveryView.ordersCount.text = String(format:"%d", self.detailPageModelView.monthlyCompleteOrdersCount);
        
        pendingView.orderName.text = "Pending Delivery"
        pendingView.orderDescription.text = "This Month - " + nameOfMonth;
        pendingView.orderDescription.textColor = UIColor.red;
        pendingView.ordersCount.textColor = UIColor.red;
        pendingView.ordersCount.text = String(format:"%d", self.detailPageModelView.monthlyPendingOrdersCount);
        
        horizontalStackView3.addArrangedSubview(deliveryView)
        horizontalStackView3.addArrangedSubview(pendingView)
        
        ordersTotalView.addArrangedSubview(horizontalStackView1)
        ordersTotalView.addArrangedSubview(horizontalStackView2)
        ordersTotalView.addArrangedSubview(horizontalStackView3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (callingApiSucceed) {
            var chartData: [BarChartData] = self.createChartDataCollection();
            print("chartData", chartData)
            
            self.barChartView.removeAllArrangedSubviews();
            self.indexChartView.removeAllArrangedSubviews();
            self.diagramTotalView.removeAllArrangedSubviews();
            self.ordersTotalView.removeAllArrangedSubviews();
            
            for data in chartData {
                self.addIndexElement(timeGraphData: data)
                self.addGraphElement(timeGraphData: data);
            }
            
            if(self.showType == 0)
            {
                self.addDiagramTotalElement(diagramData: self.detailPageModelView.diagramDailyTotal);
            }
            else if(self.showType == 1)
            {
                self.addDiagramTotalElement(diagramData: self.detailPageModelView.diagramWeeklyTotal);
            }
            else if(self.showType == 2)
            {
                self.addDiagramTotalElement(diagramData: self.detailPageModelView.diagramMonthlyTotal);
            }
            else if(self.showType == 3)
            {
                self.addDiagramTotalElement(diagramData: self.detailPageModelView.diagramYearlyTotal);
            }
            self.addOrderTotalView();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
}
