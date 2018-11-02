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
extension UIView {
    func setHeightConstraint(constant: CGFloat) {
        setConstraint(value: constant, attribute: .height)
    }
    
    func setWidthConstraint(constant: CGFloat) {
        setConstraint(value: constant, attribute: .width)
    }
    
    private func removeConstraint(attribute: NSLayoutAttribute) {
        constraints.forEach {
            if $0.firstAttribute == attribute {
                removeConstraint($0)
            }
        }
    }
    
    private func setConstraint(value: CGFloat, attribute: NSLayoutAttribute) {
        removeConstraint(attribute: attribute)
        let constraint =
            NSLayoutConstraint(item: self,
                               attribute: attribute,
                               relatedBy: NSLayoutRelation.equal,
                               toItem: nil,
                               attribute: NSLayoutAttribute.notAnAttribute,
                               multiplier: 1,
                               constant: value)
        self.addConstraint(constraint)
    }
}
class PurchaseProductDetailPage: UIViewController{
    @IBOutlet weak var showTypeController: UISegmentedControl!
    @IBOutlet weak var diagramTotalView: UIStackView!
    @IBOutlet weak var barChartView: UIStackView!
    @IBOutlet weak var indexChartView: UIStackView!
    @IBOutlet weak var ordersTotalView: UIStackView!
    @IBOutlet weak var salesInsightView: UIView!
    @IBOutlet weak var productsTotalView: UIStackView!
    @IBOutlet weak var productsDetailView: UIStackView!
    @IBOutlet weak var productsSalesLabel: UILabel!
    
    var mainCollection:JSON!
    var showType = 0;
    var orderTotal:NSMutableArray = []
    var ownerDashboardModelView: OwnerDashBoardViewModel!;
    var callingApiSucceed = false;

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
        
        if (self.callingApiSucceed){
            var chartData: [BarChartData] = self.createChartDataCollection();
            print("chartData", chartData)
            barChartView.removeAllArrangedSubviews();
            indexChartView.removeAllArrangedSubviews();
            diagramTotalView.removeAllArrangedSubviews();
            ordersTotalView.removeAllArrangedSubviews();
            for data in chartData {
                self.addIndexElement(timeGraphData: data);
                self.addGraphElement(timeGraphData: data);
            }
            if(self.showType == 0)
            {
                self.addDiagramTotalElement(diagramData: self.ownerDashboardModelView.diagramDailyTotal);
            }
            else if(self.showType == 1)
            {
                self.addDiagramTotalElement(diagramData: self.ownerDashboardModelView.diagramWeeklyTotal);
            }
            else if(self.showType == 2)
            {
                self.addDiagramTotalElement(diagramData: self.ownerDashboardModelView.diagramMonthlyTotal);
            }
            else if(self.showType == 3)
            {
                self.addDiagramTotalElement(diagramData: self.ownerDashboardModelView.diagramYearlyTotal);
            }
            self.addOrderTotalView();
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "back_color"), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage();
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        self.navigationItem.title = "Purchases Insight"
        
        //self.salesInsightView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        queue.maxConcurrentOperationCount = 20;

        if(defaults.object(forKey: "isOwner") as! String == "t") {//owner
            self.ownerDashboardModelView = Owner.ownerDashboardModelView;
            self.callingApiSucceed = Owner.callingApiSucceed;
        } else { //chef
            self.ownerDashboardModelView = Chef_DashboardView.ownerDashboardModelView;
            self.callingApiSucceed = Chef_DashboardView.callingApiSucceed;
        }
    }
    
    private func createChartDataCollection () -> [BarChartData] {
        
        var chatDataArray = [BarChartData]();
        
        var orderTotal = self.ownerDashboardModelView.orderYearlyTotal;
        var orderString = self.ownerDashboardModelView.orderYearlyIndexString;
        if (showType == 0)
        {
            orderTotal = self.ownerDashboardModelView.orderDailyTotal;
            orderString = self.ownerDashboardModelView.orderDailyIndexString;
        }
        else if(showType == 1)
        {
            orderTotal = self.ownerDashboardModelView.orderWeeklyTotal;
            orderString = self.ownerDashboardModelView.orderWeeklyIndexString;
        }
        else if(showType == 2)
        {
            orderTotal = self.ownerDashboardModelView.orderMonthlyTotal;
            orderString = self.ownerDashboardModelView.orderMonthlyIndexString;
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
        purchaseLabel.text = self.ownerDashboardModelView.currencySymbol + diagramData.ordersTotal;
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
        
        //changeLabel.text = String(format: "%d",diagramData.ordersCount);
        if(diagramData.percentage >= 0) {
            changeLabel.textColor = UIColor(red: 39/255, green: 183/255, blue: 100/255, alpha: 1.0);
            changeLabel.text = String(format: "%0.1f%%", diagramData.percentage);
        } else {
            changeLabel.textColor = UIColor(red: 230/255, green: 0/255, blue: 0/255, alpha: 1.0);
            changeLabel.text = String(format: "%0.1f%%", diagramData.percentage);
        }
        changeLabel.font = UIFont.boldSystemFont(ofSize: purchaseLabelHeight)
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
        suppliersLabel.textColor = UIColor(red: 0/255, green: 0/255, blue: 230/255, alpha: 1.0);
        suppliersLabel.text = String(format: "%d",diagramData.supplierCounts);
        //suppliersLabel.text = String(format: "16");
        suppliersLabel.font = UIFont.boldSystemFont(ofSize: purchaseLabelHeight)
        suppliersLabel.textAlignment = .center
        
        suppliersLabel.heightAnchor.constraint(equalToConstant: purchaseLabelHeight).isActive = true
        
        suppliersStringLabel.textColor = UIColor.darkText;
        suppliersStringLabel.text = "Customers";
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
    
    private func addDiagramTotalElementTemp () {
        let purchaseLabelHeight: CGFloat = 20.0
        
        let purchaseLabel = UILabel()
        let purchaseStringLabel = UILabel()
        
        let verticalStackView: UIStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 8.0
        
        purchaseLabel.textColor = UIColor(red: 255/255, green: 138/255, blue: 0/255, alpha: 1.0);
        purchaseLabel.text = "$ 32,584";
        //purchaseLabel.text = "$ " + diagramData.ordersTotal;
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
        changeLabel.text = String(format: "↑90%%");
        changeLabel.font = UIFont.boldSystemFont(ofSize: purchaseLabelHeight)
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
        //orderCountLabel.text = String(format: "%d",diagramData.ordersCount);
        orderCountLabel.text = "34";
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
        
        let salesTodayView = Bundle.main.loadNibNamed("PurchaseProductDetailPageCell", owner: self, options: nil)?.first as! PurchaseProductDetailPageCell
        let salesWeekView = Bundle.main.loadNibNamed("PurchaseProductDetailPageCell", owner: self, options: nil)?.first as! PurchaseProductDetailPageCell
        
        salesTodayView.orderName.text = "PURCHASES TODAY"
        salesTodayView.ordersCount.text = self.ownerDashboardModelView.currencySymbol +  self.ownerDashboardModelView.diagramDailyTotal.ordersTotal;
        
        salesWeekView.orderName.text = "PURCHASES THIS WEEK"
        salesWeekView.ordersCount.text = self.ownerDashboardModelView.currencySymbol +  self.ownerDashboardModelView.diagramWeeklyTotal.ordersTotal;
        
        horizontalStackView1.addArrangedSubview(salesTodayView)
        horizontalStackView1.addArrangedSubview(salesWeekView)
        
        let horizontalStackView2: UIStackView = UIStackView()
        horizontalStackView2.axis = .horizontal
        horizontalStackView2.alignment = .fill
        horizontalStackView2.distribution = .fillEqually
        //horizontalStackView2.spacing = 8.0
        
        let ordersTodayView = Bundle.main.loadNibNamed("PurchaseProductDetailPageCell", owner: self, options: nil)?.first as! PurchaseProductDetailPageCell
        let ordersWeekView = Bundle.main.loadNibNamed("PurchaseProductDetailPageCell", owner: self, options: nil)?.first as! PurchaseProductDetailPageCell
        ordersTodayView.orderName.text = "ORDERS TODAY"
        ordersTodayView.ordersCount.text = String(format: "%d", self.ownerDashboardModelView.diagramDailyTotal.ordersCount);
        
        ordersWeekView.orderName.text = "ORDERS THIS WEEK"
        ordersWeekView.ordersCount.text = String(format: "%d", self.ownerDashboardModelView.diagramWeeklyTotal.ordersCount);
        
        horizontalStackView2.addArrangedSubview(ordersTodayView)
        horizontalStackView2.addArrangedSubview(ordersWeekView)
        
        ordersTotalView.addArrangedSubview(horizontalStackView1)
        ordersTotalView.addArrangedSubview(horizontalStackView2)
    }
    
    func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    private func addProductTotalView () {
        var totalProductCount = 0;
        let size = productsTotalView.frame.size
        
        var productCount = 0;
        for product in self.ownerDashboardModelView.topSellingProductData {
            totalProductCount += Int(product.qty)!;
            productCount += 1;
            if(productCount > 5){
                break;
            }
        }
        if(productCount >= 5) {
            productsSalesLabel.text = "Purchased Products(Top 5)"
        }
        if(productCount == 0) {
            productsSalesLabel.text = "Purchased Products(No Product)"
        }
        print("stack width:", productsTotalView.frame.size.width);
        print("total product count:", totalProductCount);
        let colorArray = [
            UIColor(red: 255/255, green: 138/255, blue: 0/255, alpha: 1.0),
            UIColor(red: 39/255, green: 183/255, blue: 100/255, alpha: 1.0),
            UIColor(red: 30/255, green: 161/255, blue: 243/255, alpha: 1.0),
            UIColor(red: 165/255, green: 96/255, blue: 245/255, alpha: 1.0),
            UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1.0)
        ];
        productCount = 0;
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        for product in self.ownerDashboardModelView.topSellingProductData {
            let width = Double(screenSize.width) * (Double)(Double(product.qty)! / Double(totalProductCount));
            print("cell width:", width);
            let view = UIView();
            let color = generateRandomColor();
            view.layer.backgroundColor = colorArray[productCount].cgColor;
            view.layer.borderColor = colorArray[productCount].cgColor;
            view.setWidthConstraint(constant: CGFloat(width))
            productsTotalView.addArrangedSubview(view)
            let descriptionView = Bundle.main.loadNibNamed("ProductSaleDetailCell", owner: self, options: nil)?.first as! ProductSaleDetailCell
            descriptionView.colorView.layer.backgroundColor = colorArray[productCount].cgColor;
            descriptionView.colorView.layer.borderColor = colorArray[productCount].cgColor;
            descriptionView.qtyLabel.text = product.qty + ":" + String(totalProductCount);
            descriptionView.productNameLabel.text = product.name;
            descriptionView.setHeightConstraint(constant: CGFloat(40));
            productsDetailView.addArrangedSubview(descriptionView);
            productCount += 1;
            if( productCount > 5 ){
                break;
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (self.callingApiSucceed) {
            var chartData: [BarChartData] = self.createChartDataCollection();
            print("reloadData")
            self.barChartView.removeAllArrangedSubviews();
            self.indexChartView.removeAllArrangedSubviews();
            self.diagramTotalView.removeAllArrangedSubviews();
            self.ordersTotalView.removeAllArrangedSubviews();
            self.productsTotalView.removeAllArrangedSubviews();
            
            for data in chartData {
                self.addIndexElement(timeGraphData: data)
                self.addGraphElement(timeGraphData: data);
            }
            
            if(self.showType == 0)
            {
                self.addDiagramTotalElement(diagramData: self.ownerDashboardModelView.diagramDailyTotal);
            }
            else if(self.showType == 1)
            {
                self.addDiagramTotalElement(diagramData: self.ownerDashboardModelView.diagramWeeklyTotal);
            }
            else if(self.showType == 2)
            {
                self.addDiagramTotalElement(diagramData: self.ownerDashboardModelView.diagramMonthlyTotal);
            }
            else if(self.showType == 3)
            {
                self.addDiagramTotalElement(diagramData: self.ownerDashboardModelView.diagramYearlyTotal);
            }
            self.addOrderTotalView();
            self.addProductTotalView();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
}
