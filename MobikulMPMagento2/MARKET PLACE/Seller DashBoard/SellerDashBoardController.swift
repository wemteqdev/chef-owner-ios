//
//  SellerDashBoardController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 25/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//




@objc protocol sellerProductHandlerDelegate: class {
    func productClick(name:String,id:String)
    
}

import UIKit

class SellerDashBoardController: UIViewController ,UITableViewDelegate, UITableViewDataSource,sellerProductHandlerDelegate{
    
    @IBOutlet weak var sellerTableView: UITableView!
    
    var sellerDashBoardViewModel:SellerDashBoardViewModel!
    var incrementId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "sellerdashboard")
        sellerTableView.register(UINib(nibName: "SellerTopDataCell", bundle: nil), forCellReuseIdentifier: "SellerTopDataCell")
        sellerTableView.register(UINib(nibName: "TopSellingProduct", bundle: nil), forCellReuseIdentifier: "TopSellingProduct")
        sellerTableView.register(UINib(nibName: "SellerReviewsCell", bundle: nil), forCellReuseIdentifier: "SellerReviewsCell")
        sellerTableView.register(UINib(nibName: "SellerOrdersDataCell", bundle: nil), forCellReuseIdentifier: "SellerOrdersDataCell")
        sellerTableView.register(UINib(nibName: "SellerDashBoardReportCell", bundle: nil), forCellReuseIdentifier: "SellerDashBoardReportCell")
        
        sellerTableView.rowHeight = UITableViewAutomaticDimension
        self.sellerTableView.estimatedRowHeight = 100
        self.sellerTableView.separatorColor = UIColor.clear
        self.callingHttppApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
    }
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        requstParams["websiteId"] = DEFAULT_WEBSITE_ID
        let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        let storeId = defaults.object(forKey: "storeId")
        requstParams["width"] = width
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/Dashboard", currentView: self){success,responseObject in
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        defaults .set(storeId, forKey: "storeId")
                    }
                }
                GlobalData.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
                var dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    self.sellerDashBoardViewModel = SellerDashBoardViewModel(data:dict)
                    DispatchQueue.main.async {
                        self.sellerTableView.delegate = self
                        self.sellerTableView.dataSource = self
                        self.sellerTableView.reloadDataWithAutoSizingCellWorkAround()
                    }
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                print("sss", responseObject)
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 || section == 1{
            return 1
        }else if section == 2{
            return self.sellerDashBoardViewModel.topSellingProductData.count
        }else if section == 3{
            return self.sellerDashBoardViewModel.sellerRecentOrderData.count
        }else if section == 4{
            return self.sellerDashBoardViewModel.sellerReviewList.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return  ""
        }else if section == 1{
            return GlobalData.sharedInstance.language(key: "marketplacereport")
        }else if section == 2{
            return self.sellerDashBoardViewModel.topSellingProductData.count > 0 ? GlobalData.sharedInstance.language(key: "topsellingproduct") : ""
        }else if section == 3{
            return self.sellerDashBoardViewModel.sellerRecentOrderData.count > 0 ? GlobalData.sharedInstance.language(key: "recentorder") : ""
        }else{
            return self.sellerDashBoardViewModel.sellerReviewList.count > 0 ? GlobalData.sharedInstance.language(key: "commentsandreviews") : ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerTopDataCell", for: indexPath) as! SellerTopDataCell
            cell.lifetimeSaleLabelValue.text = self.sellerDashBoardViewModel.extraSaleDashBoardData.lifeTimesales
            cell.totalPayoutLabelValue.text = self.sellerDashBoardViewModel.extraSaleDashBoardData.totalSale
            cell.remainingAmountLabelValue.text = self.sellerDashBoardViewModel.extraSaleDashBoardData.remainingAmount
            
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerDashBoardReportCell", for: indexPath) as! SellerDashBoardReportCell
            cell.sellerDashBoardViewModel = self.sellerDashBoardViewModel
            cell.item = self.sellerDashBoardViewModel
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopSellingProduct", for: indexPath) as! TopSellingProduct
            cell.productName.setTitle(self.sellerDashBoardViewModel.topSellingProductData[indexPath.row].name, for: .normal)
            cell.totalproducts.text = self.sellerDashBoardViewModel.topSellingProductData[indexPath.row].qty+" "+GlobalData.sharedInstance.language(key: "sales")
            cell.productName.addTarget(self, action: #selector(showAllProduct(sender:)), for: .touchUpInside)
            cell.productName.tag = indexPath.row
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerOrdersDataCell", for: indexPath) as! SellerOrdersDataCell
            cell.delegate = self
            cell.orderLabelValue.text = self.sellerDashBoardViewModel.sellerRecentOrderData[indexPath.row].incrementID
            cell.customerNameValue.text = self.sellerDashBoardViewModel.sellerRecentOrderData[indexPath.row].customerName
            cell.orderDateValue.text = self.sellerDashBoardViewModel.sellerRecentOrderData[indexPath.row].date
            cell.orderTotalBaseLabelValue.text = self.sellerDashBoardViewModel.sellerRecentOrderData[indexPath.row].ordertotalBase
            cell.orderTotalPurchaseValue.text = self.sellerDashBoardViewModel.sellerRecentOrderData[indexPath.row].ordertotalPurchase
            cell.statusMessage.text = " "+self.sellerDashBoardViewModel.sellerRecentOrderData[indexPath.row].status+" "
            
            
            if self.sellerDashBoardViewModel.sellerRecentOrderData[indexPath.row].status.lowercased() == "pending"{
                cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: ORANGECOLOR)
                cell.statusMessage.textColor = UIColor.white
            }else if self.sellerDashBoardViewModel.sellerRecentOrderData[indexPath.row].status.lowercased() == "complete"{
                cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: GREEN_COLOR)
                cell.statusMessage.textColor = UIColor.white
            }else if self.sellerDashBoardViewModel.sellerRecentOrderData[indexPath.row].status.lowercased() == "processing"{
                cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: GREEN_COLOR)
                cell.statusMessage.textColor = UIColor.white
            }else if self.sellerDashBoardViewModel.sellerRecentOrderData[indexPath.row].status.lowercased() == "cancel"{
                cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: REDCOLOR)
                cell.statusMessage.textColor = UIColor.white
            }else if self.sellerDashBoardViewModel.sellerRecentOrderData[indexPath.row].status.lowercased() == "closed"{
                cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: REDCOLOR)
                cell.statusMessage.textColor = UIColor.white
            }
            
            cell.seeDetailsButton.addTarget(self, action: #selector(seeOrderDetails(sender:)), for: .touchUpInside)
            cell.seeDetailsButton.tag = indexPath.row
            
            cell.sellerProducts = self.sellerDashBoardViewModel.sellerRecentOrderData[indexPath.row].sellerProducts
            cell.productCollectionViewHeight.constant = CGFloat((self.sellerDashBoardViewModel.sellerRecentOrderData[indexPath.row].sellerProducts.count)*32)
            cell.productCollectionView.reloadData()
            
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerReviewsCell", for: indexPath) as! SellerReviewsCell
            cell.heading.text = "by"+" "+self.sellerDashBoardViewModel.sellerReviewList[indexPath.row].name+"  "+"on"+" "+self.sellerDashBoardViewModel.sellerReviewList[indexPath.row].date
            cell.message.text = self.sellerDashBoardViewModel.sellerReviewList[indexPath.row].comment
            cell.valueRating.text = String(format:"%d",self.sellerDashBoardViewModel.sellerReviewList[indexPath.row].valuerating)
            cell.priceRating.text = String(format:"%d",self.sellerDashBoardViewModel.sellerReviewList[indexPath.row].pricerating)
            cell.qualityRating.text = String(format:"%d",self.sellerDashBoardViewModel.sellerReviewList[indexPath.row].qualityrating)
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3   {
            incrementId = self.sellerDashBoardViewModel.sellerRecentOrderData[indexPath.row].incrementID
            self.performSegue(withIdentifier: "orderdetails", sender: self)
        }
    }
    
    @objc func showAllProduct(sender: UIButton){
        let isOpen = self.sellerDashBoardViewModel.topSellingProductData[sender.tag].openable
        if  isOpen == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
            vc.productName = self.sellerDashBoardViewModel.topSellingProductData[sender.tag].name
            vc.productId = self.sellerDashBoardViewModel.topSellingProductData[sender.tag].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func productClick(name:String,id:String){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productName = name
        vc.productId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func seeOrderDetails(sender: UIButton){
        incrementId = self.sellerDashBoardViewModel.sellerRecentOrderData[sender.tag].incrementID
        self.performSegue(withIdentifier: "orderdetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "orderdetails") {
            let viewController:SellerOrderDetailsController = segue.destination as UIViewController as! SellerOrderDetailsController
            viewController.incrementId = self.incrementId
        }
    }
}
