//
//  MyTransactionList.swift
//  MobikulMPMagento2
//
//  Created by kunal on 27/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit


@objc protocol SellerTransactionFilterDataHandle: class {
    func sellerTransactionFilterData(data:Bool,orderid:String,fromDate:String,toDate:String)
    
}





class MyTransactionList: UIViewController,UITableViewDelegate, UITableViewDataSource,SellerTransactionFilterDataHandle {
    
    var pageNumber:Int = 1
    var dateTo:String = ""
    var dateFrom :String = ""
    var transactionId:String = ""
    var totalCount:Int = 0
    var loadPageRequestFlag: Bool = false
    var myTransactionListViewModel:MyTransactionListViewModel!
    @IBOutlet weak var topMessageLabel: UILabel!
    @IBOutlet weak var transactionTableView: UITableView!
    var indexPathValue:IndexPath!
    var id:String = ""
    @IBOutlet weak var downloadCsvFileButton: UIButton!
    var emptyView:EmptyNewAddressView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "mytransaction")
        
        transactionTableView.register(UINib(nibName: "TansactionListView", bundle: nil), forCellReuseIdentifier: "TansactionListView")
        transactionTableView.rowHeight = UITableViewAutomaticDimension
        self.transactionTableView.estimatedRowHeight = 100
        self.transactionTableView.separatorColor = UIColor.clear
        
        
        downloadCsvFileButton.setTitleColor(UIColor().HexToColor(hexString: BUTTON_COLOR), for: .normal)
        downloadCsvFileButton.setTitle(GlobalData.sharedInstance.language(key: "downloadcsvfile"), for: .normal)
        self.downloadCsvFileButton.isHidden = true
        self.topMessageLabel.text = ""
        self.topMessageLabel.isHidden = false
        emptyView = EmptyNewAddressView(frame: self.view.frame)
        emptyView.frame.size.height -= 180
        emptyView.frame.origin.y += 100
        self.view.addSubview(emptyView)
        emptyView.isHidden = true;
        emptyView.emptyImages.image = UIImage(named: "empty_transaction")!
        emptyView.addressButton.setTitle(GlobalData.sharedInstance.language(key: "ok"), for: .normal)
        emptyView.labelMessage.text = GlobalData.sharedInstance.language(key: "emptytransaction")
//        emptyView.addressButton.addTarget(self, action: #selector(browseCategory(sender:)), for: .touchUpInside)
        emptyView.addressButton.isHidden = true
        
        
        loadPageRequestFlag = true
        callingHttppApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
    }
    
    
    
    
    @objc func browseCategory(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func sellerTransactionFilterData(data:Bool,orderid:String,fromDate:String,toDate:String){
        self.dateTo = toDate
        self.dateFrom = fromDate
        self.transactionId = orderid
        
        self.totalCount = 0
        
        if self.myTransactionListViewModel != nil   {
            self.myTransactionListViewModel.myTransactionModel.removeAll()
        }
        callingHttppApi()
        
    }
    
    
    @IBAction func resetClick(_ sender: Any) {
        self.dateTo = ""
        self.dateFrom = ""
        self.transactionId = ""
        callingHttppApi()
    }
    
    
    
    @IBAction func downloadCsVClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "downloads", sender: self)
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
        requstParams["dateTo"] = dateTo
        requstParams["dateFrom"] = dateFrom
        requstParams["transactionId"] = transactionId
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/transactionList", currentView: self){success,responseObject in
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
                        self.myTransactionListViewModel = MyTransactionListViewModel(data:dict)
                        self.totalCount = self.myTransactionListViewModel.totalCount
                        self.transactionTableView.delegate = self
                        self.transactionTableView.dataSource = self
                        self.transactionTableView.reloadData()
                        self.topMessageLabel.text = GlobalData.sharedInstance.language(key: "remainingtransaction") + self.myTransactionListViewModel.remainingTransactionAmount;
                        if self.myTransactionListViewModel.myTransactionModel.count > 0{
                            self.downloadCsvFileButton.isHidden = false
                            self.topMessageLabel.isHidden = false
                            self.emptyView.isHidden = true
                            self.transactionTableView.isHidden = false
                        }else{
                            self.emptyView.isHidden = false
                            self.topMessageLabel.isHidden = false
                            self.transactionTableView.isHidden = true
                        }
                        
                    }else{
                        self.loadPageRequestFlag = true
                        self.myTransactionListViewModel.setTransactionCollectionData(data:dict)
                        self.transactionTableView.reloadData()
                        
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
        return self.myTransactionListViewModel.myTransactionModel.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TansactionListView", for: indexPath) as! TansactionListView
        cell.transactionIdLabelValue.text  = self.myTransactionListViewModel.myTransactionModel[indexPath.row].transactionId
        cell.dateLabelValue.text = self.myTransactionListViewModel.myTransactionModel[indexPath.row].date
        cell.commentMessageLabelValue.text = self.myTransactionListViewModel.myTransactionModel[indexPath.row].comment
        cell.transactionAmountValue.text = self.myTransactionListViewModel.myTransactionModel[indexPath.row].amount
        
        cell.viewButton.addTarget(self, action: #selector(viewClick(sender:)), for: .touchUpInside)
        cell.viewButton.isUserInteractionEnabled = true;
        cell.viewButton.tag = indexPath.row
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellCount = self.transactionTableView.numberOfRows(inSection: 0);
        for cell: UITableViewCell in self.transactionTableView.visibleCells {
            indexPathValue = self.transactionTableView.indexPath(for: cell)!
            if indexPathValue.row == self.transactionTableView.numberOfRows(inSection: 0) - 1 {
                if (totalCount > currentCellCount) && loadPageRequestFlag{
                    pageNumber += 1;
                    loadPageRequestFlag = false
                    callingHttppApi();
                    
                }
            }
        }
    }
    
    
    @IBAction func goToFilter(_ sender: Any) {
        self.performSegue(withIdentifier: "filter", sender: self)
    }
    
    
    
    
    @objc func viewClick(sender: UIButton){
        self.id = self.myTransactionListViewModel.myTransactionModel[sender.tag].id
        self.performSegue(withIdentifier: "transactiondetails", sender: self)
        
        
    }
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "filter") {
            let viewController:MyTransactionFilterController = segue.destination as UIViewController as! MyTransactionFilterController
            viewController.delegate = self
        }else if (segue.identifier! == "transactiondetails") {
            let viewController:MyTransactionDetailsController = segue.destination as UIViewController as! MyTransactionDetailsController
            viewController.id = id
        }
        
    }
    
    
    
    
    
    
}
