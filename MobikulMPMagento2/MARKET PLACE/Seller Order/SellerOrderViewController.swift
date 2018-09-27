//
//  SellerOrderViewController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 26/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

@objc protocol SellerOrderFilterDataHandle: class {
    func sellerOrderFilterData(data:Bool,orderid:String,fromDate:String,toDate:String,status:String)
    
}

class SellerOrderViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,SellerOrderFilterDataHandle ,sellerProductHandlerDelegate{
    
    @IBOutlet weak var sellerOrderTableView: UITableView!
    @IBOutlet weak var downloadAllInvoiceSlipButton: UIButton!
    @IBOutlet weak var downloadAllShippingSlipButton: UIButton!
    
    var pageNumber:Int = 0
    var loadPageRequestFlag: Bool = false
    var indexPathValue:IndexPath!
    var sellerOrderViewModel:SellerOrderViewModel!
    var totalCount:Int = 0
    var incrementID:String = ""
    var fromDate:String = ""
    var toDate:String = ""
    var status:String = ""
    var incrementId:String = ""
    var productId:String = ""
    var productName:String = ""
    var currentdownload:String = ""
    var emptyView:EmptyNewAddressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "sellerorder")
        pageNumber = 1;
        loadPageRequestFlag = true;
        sellerOrderTableView.register(UINib(nibName: "SellerOrdersDataCell", bundle: nil), forCellReuseIdentifier: "SellerOrdersDataCell")
        sellerOrderTableView.rowHeight = UITableViewAutomaticDimension
        self.sellerOrderTableView.estimatedRowHeight = 100
        self.sellerOrderTableView.separatorColor = UIColor.clear
        
        emptyView = EmptyNewAddressView(frame: self.view.frame)
        emptyView.frame.size.height -= 180
        emptyView.frame.origin.y += 100
        self.view.addSubview(emptyView)
        emptyView.isHidden = true;
        emptyView.emptyImages.image = UIImage(named: "empty_transaction")!
        emptyView.addressButton.setTitle(GlobalData.sharedInstance.language(key: "ok"), for: .normal)
        emptyView.labelMessage.text = GlobalData.sharedInstance.language(key: "emptyorder")
        emptyView.addressButton.isHidden = true
        
        self.callingHttppApi()
        
        downloadAllInvoiceSlipButton.setTitle(GlobalData.sharedInstance.language(key: "downloadallinvoiceslip"), for: .normal)
        downloadAllShippingSlipButton.setTitle(GlobalData.sharedInstance.language(key: "downloadallshippingslip"), for: .normal)
        
        downloadAllInvoiceSlipButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        downloadAllShippingSlipButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
    }
    
    func sellerOrderFilterData(data:Bool,orderid:String,fromDate:String,toDate:String,status:String){
        self.incrementID = orderid;
        self.fromDate  = fromDate
        self.toDate = toDate
        self.status = status;
        pageNumber = 1;
        loadPageRequestFlag = true;
        callingHttppApi()
    }
    
    @IBAction func downlaodAllInvoiceClick(_ sender: Any) {
        currentdownload = "invoice"
        self.performSegue(withIdentifier: "download", sender: self)
    }
    
    @IBAction func downloadAllshippingClick(_ sender: Any) {
        currentdownload = "shipping"
        self.performSegue(withIdentifier: "download", sender: self)
    }
    
    @IBAction func refreshClick(_ sender: UIBarButtonItem) {
        self.incrementID = ""
        self.fromDate  = ""
        self.toDate = ""
        self.status = ""
        pageNumber = 1;
        loadPageRequestFlag = true;
        callingHttppApi()
    }
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        let storeId = defaults.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        requstParams["pageNumber"] = "\(pageNumber)"
        requstParams["status"] = status
        requstParams["dateTo"] =  toDate
        requstParams["dateFrom"] = fromDate
        requstParams["incrementId"] = incrementID
        
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/OrderList", currentView: self){success,responseObject in
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
                    if self.pageNumber == 1{
                        self.sellerOrderViewModel = SellerOrderViewModel(data:dict)
                        DispatchQueue.main.async {
                            self.totalCount = self.sellerOrderViewModel.totalCount;
                            self.sellerOrderTableView.delegate = self
                            self.sellerOrderTableView.dataSource = self
                            self.sellerOrderTableView.reloadDataWithAutoSizingCellWorkAround()
                        }
                        
                        if self.sellerOrderViewModel.sellerOrderData.count > 0   {
                            self.emptyView.isHidden = true
                        }else{
                            self.emptyView.isHidden = false
                        }
                    }else{
                        self.loadPageRequestFlag = true
                        self.sellerOrderViewModel.setSellerOrderCollectionData(data: dict)
                        self.sellerOrderTableView.reloadDataWithAutoSizingCellWorkAround()
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
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if self.sellerOrderViewModel.sellerOrderData.count > 0   {
            self.emptyView.isHidden = true
        }else{
            self.emptyView.isHidden = false
        }
        
        return self.sellerOrderViewModel.sellerOrderData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellerOrdersDataCell", for: indexPath) as! SellerOrdersDataCell
        cell.orderLabelValue.text = self.sellerOrderViewModel.sellerOrderData[indexPath.row].incrementID
        
        cell.customerNameValue.text = self.sellerOrderViewModel.sellerOrderData[indexPath.row].customerName
        cell.orderDateValue.text = self.sellerOrderViewModel.sellerOrderData[indexPath.row].date
        cell.orderTotalBaseLabelValue.text = self.sellerOrderViewModel.sellerOrderData[indexPath.row].ordertotalBase
        cell.orderTotalPurchaseValue.text = self.sellerOrderViewModel.sellerOrderData[indexPath.row].ordertotalPurchase
        cell.statusMessage.text = " "+self.sellerOrderViewModel.sellerOrderData[indexPath.row].status+" "
        
        
        if self.sellerOrderViewModel.sellerOrderData[indexPath.row].status.lowercased() == "pending"{
            cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: ORANGECOLOR)
            cell.statusMessage.textColor = UIColor.white
        }else if self.sellerOrderViewModel.sellerOrderData[indexPath.row].status.lowercased() == "complete"{
            cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: GREEN_COLOR)
            cell.statusMessage.textColor = UIColor.white
        }else if self.sellerOrderViewModel.sellerOrderData[indexPath.row].status.lowercased() == "processing"{
            cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: GREEN_COLOR)
            cell.statusMessage.textColor = UIColor.white
        }else if self.sellerOrderViewModel.sellerOrderData[indexPath.row].status.lowercased() == "cancel"{
            cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: REDCOLOR)
            cell.statusMessage.textColor = UIColor.white
        }else if self.sellerOrderViewModel.sellerOrderData[indexPath.row].status.lowercased() == "closed"{
            cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: REDCOLOR)
            cell.statusMessage.textColor = UIColor.white
        }
        
        cell.sellerProducts = self.sellerOrderViewModel.sellerOrderData[indexPath.row].sellerProducts
        cell.productCollectionViewHeight.constant = CGFloat((self.sellerOrderViewModel.sellerOrderData[indexPath.row].sellerProducts.count)*32)
        cell.productCollectionView.reloadData()
        cell.delegate = self
        cell.seeDetailsButton.tag = indexPath.row
        cell.seeDetailsButton.addTarget(self, action: #selector(seeOrderDetails(sender:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        incrementId = self.sellerOrderViewModel.sellerOrderData[indexPath.row].incrementID
        self.performSegue(withIdentifier: "orderdetails", sender: self)
    }
    
    func productClick(name:String,id:String){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productName = name
        vc.productId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellCount = self.sellerOrderTableView.numberOfRows(inSection: 0);
        for cell: UITableViewCell in self.sellerOrderTableView.visibleCells {
            
            if self.sellerOrderTableView != nil {
                indexPathValue = self.sellerOrderTableView.indexPath(for: cell)!
                if indexPathValue.row == self.sellerOrderTableView.numberOfRows(inSection: 0) - 1 {
                    if (totalCount > currentCellCount) && loadPageRequestFlag{
                        pageNumber += 1;
                        loadPageRequestFlag = false
                        callingHttppApi();
                    }
                }
            }
        }
    }
    
    @IBAction func filterClick(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "filter", sender: self)
    }
    
    @objc func seeOrderDetails(sender: UIButton){
        incrementId = self.sellerOrderViewModel.sellerOrderData[sender.tag].incrementID
        self.performSegue(withIdentifier: "orderdetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "filter") {
            let viewController:SellerOrderFilterController = segue.destination as UIViewController as! SellerOrderFilterController
            viewController.sellerOrderViewModel = self.sellerOrderViewModel
            viewController.delegate = self
        }else if (segue.identifier! == "orderdetails") {
            let viewController:SellerOrderDetailsController = segue.destination as UIViewController as! SellerOrderDetailsController
            viewController.incrementId = self.incrementId
            
        }else if (segue.identifier! == "download") {
            let viewController:SellerInvoiceShippingDownloadController = segue.destination as UIViewController as! SellerInvoiceShippingDownloadController
            viewController.currentdownload = self.currentdownload
        }
    }
}
