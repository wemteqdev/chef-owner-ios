//
//  Chef_MyOrders.swift
//  MobikulMPMagento2
//
//  Created by Othello on 19/09/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit
@objc protocol ChefSellerOrderFilterDataHandle: class {
    func sellerOrderFilterData(data:Bool,orderid:String,fromDate:String,toDate:String,status:String)
    
}

class Chef_MyOrders: UIViewController ,UITableViewDelegate, UITableViewDataSource,ChefSellerOrderFilterDataHandle{
    func sellerOrderFilterData(data: Bool, orderid: String, fromDate: String, toDate: String, status: String) {
        self.incrementId = orderid;
        self.fromDate  = fromDate
        self.toDate = toDate
        self.status = status;
        pageNumber = 1;
        loadPageRequestFlag = true;
        callingHttppApi()
    }
    
    
    @IBOutlet weak var myOrderTableView: UITableView!
    
    var totalCount : Int = 0
    var whichApiDataToprocess: String = ""
    var reloadPageData:Bool = false
    var pageNumber:Int = 0
    var loadPageRequestFlag: Bool = false
    var indexPathValue:IndexPath!
    var loaderFlag:Bool = false
    var incrementId:String = ""
    var emptyOrderView:UIView!
    let defaults = UserDefaults.standard
    var myOrderCollectionData:Chef_MyOrdersCollectionViewModel!
    var orderId:String = ""
    var emptyView:EmptyNewAddressView!
    let globalObjectMyOrders = GlobalData()
    var refreshControl:UIRefreshControl!
    var fromDate:String = ""
    var toDate:String = ""
    var status:String = ""

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myOrderTableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "myorder")
        
        //navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.myOrderTableView.reloadData()
        myOrderTableView.isHidden = true
        pageNumber = 1
        loadPageRequestFlag = true
        whichApiDataToprocess = ""
        callingHttppApi()
        myOrderTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.myOrderTableView.separatorColor = UIColor.clear
        
        //myOrderTableView.register(UINib(nibName: "Chef_MyOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "Chef_MyOrderTableViewCell")
        myOrderTableView.register(UINib(nibName: "Chef_MyOrderTableViewCellDesign", bundle: nil), forCellReuseIdentifier: "chef_myorderdesign")
        myOrderTableView.rowHeight = UITableViewAutomaticDimension
        myOrderTableView.rowHeight = 120
        //self.myOrderTableView.estimatedRowHeight = 50
        
        emptyView = EmptyNewAddressView(frame: self.view.frame)
        self.view.addSubview(emptyView)
        emptyView.isHidden = true
        emptyView.emptyImages.image = UIImage(named: "empty_order")!
        emptyView.addressButton.setTitle(GlobalData.sharedInstance.language(key: "browsecategory"), for: .normal)
        emptyView.labelMessage.text = GlobalData.sharedInstance.language(key: "emptyorder")
        emptyView.addressButton.addTarget(self, action: #selector(browseCategory(sender:)), for: .touchUpInside)
        
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "refreshing".localized, attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            myOrderTableView.refreshControl = refreshControl
        }else {
            myOrderTableView.backgroundView = refreshControl
        }

        // Do any additional setup after loading the view.
    }
    @objc func browseCategory(sender: UIButton){
        print("Browse Category Clicked")
        self.tabBarController!.selectedIndex = 1
    }
    override func viewDidAppear(_ animated: Bool) {
        whichApiDataToprocess = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    //MARK:- Pull to refresh
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        pageNumber = 1
        loadPageRequestFlag = true
        whichApiDataToprocess = ""
        callingHttppApi()
        refreshControl.endRefreshing()
    }
    
    //MARK:- API Call
    
    func callingHttppApi(){
        
        if whichApiDataToprocess == "reorder"{
            GlobalData.sharedInstance.showLoader()
            self.view.isUserInteractionEnabled = false
            var requstParams = [String:Any]()
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            requstParams["incrementId"] = orderId
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/reOrder", currentView: self){success,responseObject in
                if success == 1{
                    
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    if errorCode == true{
                        self.tabBarController!.tabBar.items?[3].badgeValue = String(data.object(forKey: "cartCount") as! Int)
                        let AC = UIAlertController(title:self.orderId , message: data.object(forKey: "message") as? String, preferredStyle: .alert)
                        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            self.tabBarController?.selectedIndex =  3
                            
                        })
                        
                        AC.addAction(okBtn)
                        self.present(AC, animated: true, completion: {})
                    }
                    
                    
                }else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }else{
            if pageNumber == 1{
                GlobalData.sharedInstance.showLoader()
            }
            var requstParams = [String:Any]()
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            requstParams["websiteId"] = DEFAULT_WEBSITE_ID
            requstParams["pageNumber"] = "\(pageNumber)"
            requstParams["status"] = status
            requstParams["dateTo"] =  toDate
            requstParams["dateFrom"] = fromDate
            requstParams["incrementId"] = incrementId
            
            if self.defaults.object(forKey: "currency") != nil{
                requstParams["currency"] = self.defaults.object(forKey: "currency") as! String
            }
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/customer/orderList", currentView: self){success,responseObject in
                if success == 1{
                    
                    
                    print("result",responseObject)
                    
                    if self.pageNumber == 1{
                        self.myOrderCollectionData = Chef_MyOrdersCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                    }else{
                        self.myOrderCollectionData.setMyOrderCollectionData(data:JSON(responseObject as! NSDictionary))
                    }
                    self.doFurtherProcessingWithResult()
                }else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }
    }
    @IBAction func filterClick(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "filter", sender: self)
    }
    @IBAction func refreshClick(_ sender: UIBarButtonItem) {
        self.incrementId = ""
        self.fromDate  = ""
        self.toDate = ""
        self.status = ""
        pageNumber = 1;
        
        callingHttppApi()
    }
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            if self.pageNumber == 1{
                GlobalData.sharedInstance.dismissLoader()
            }
            
            self.loadPageRequestFlag = true
            self.view.isUserInteractionEnabled = true
            self.myOrderTableView.isHidden = false
            self.myOrderTableView.delegate = self
            self.myOrderTableView.dataSource = self
            self.myOrderTableView.reloadData()

            if self.myOrderCollectionData.getMyOrdersCollectionData.count > 0{
                self.myOrderTableView.isHidden = false
                self.emptyView.isHidden  = true
            }else{
                self.myOrderTableView.isHidden = true
                self.emptyView.isHidden  = false
            }
        }
    }
    
    //MARK:- UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myOrderCollectionData.getMyOrdersCollectionData.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell:Chef_MyOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Chef_MyOrderTableViewCell") as! Chef_MyOrderTableViewCell
        let cell:Chef_MyOrderTableViewCellDesign = tableView.dequeueReusableCell(withIdentifier: "chef_myorderdesign") as! Chef_MyOrderTableViewCellDesign        
        if self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].status.lowercased() == "pending"{
                    cell.statusButton.backgroundColor = UIColor().HexToColor(hexString: LIGHTGREY).withAlphaComponent(0.1)
                    cell.statusButton.setTitleColor(UIColor().HexToColor(hexString: LIGHTGREY), for: .normal)
            cell.statusButton.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
            
                }else if self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].status.lowercased() == "complete"{
                    cell.statusButton.backgroundColor = UIColor().HexToColor(hexString: GREEN_COLOR).withAlphaComponent(0.1)
                    cell.statusButton.setTitleColor(UIColor().HexToColor(hexString: GREEN_COLOR), for: .normal)
                    cell.statusButton.layer.borderColor = UIColor().HexToColor(hexString: GREEN_COLOR).cgColor
                }else if self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].status.lowercased() == "processing"{
                    cell.statusButton.backgroundColor = UIColor().HexToColor(hexString: ORANGECOLOR).withAlphaComponent(0.1)
                    cell.statusButton.setTitleColor(UIColor().HexToColor(hexString: ORANGECOLOR), for: .normal)
                    cell.statusButton.layer.borderColor = UIColor().HexToColor(hexString: ORANGECOLOR).cgColor
                }else if self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].status.lowercased() == "cancel"{
                    cell.statusButton.backgroundColor = UIColor().HexToColor(hexString: REDCOLOR).withAlphaComponent(0.1)
                    cell.statusButton.setTitleColor(UIColor().HexToColor(hexString: REDCOLOR), for: .normal)
                    cell.statusButton.layer.borderColor = UIColor().HexToColor(hexString: REDCOLOR).cgColor
                }

        cell.statusButton.setTitle(self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].status, for: .normal)
        cell.chefName.text = self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].customerName
        cell.restaurant.text = self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].restaurant
        cell.orderId.text = self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].orderId
        cell.placedonDate.text = self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].order_Date
        cell.ordertotal.text = self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].order_total
        cell.supplierName.text = self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].supplierName
//        cell.shipToValue.text = self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].ship_To
//        cell.statusMessage.text = " "+self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].status+" "
//
//
//
//        if self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].status.lowercased() == "pending"{
//            cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: ORANGECOLOR)
//            cell.statusMessage.textColor = UIColor.white
//        }else if self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].status.lowercased() == "complete"{
//            cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: GREEN_COLOR)
//            cell.statusMessage.textColor = UIColor.white
//        }else if self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].status.lowercased() == "processing"{
//            cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: GREEN_COLOR)
//            cell.statusMessage.textColor = UIColor.white
//        }else if self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].status.lowercased() == "cancel"{
//            cell.statusMessage.backgroundColor = UIColor().HexToColor(hexString: REDCOLOR)
//            cell.statusMessage.textColor = UIColor.white
//        }
//
//        if self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].canReorder  == true {
//            cell.reorderButton.tag = indexPath.row
//            cell.reorderButton.addTarget(self, action: #selector(reorderClick(sender:)), for: .touchUpInside)
//            cell.reorderButton.isUserInteractionEnabled = true
//            cell.reorderButton.isHidden = false
//        }else{
//            cell.reorderButton.isHidden = true
//        }
//
//        cell.viewOrderButton.tag = indexPath.row
//        cell.viewOrderButton.addTarget(self, action: #selector(viewOrderClick(sender:)), for: .touchUpInside)
//        cell.viewOrderButton.isUserInteractionEnabled = true
//        cell.selectionStyle = .none
        return cell
    }
    
    //for showing the activity loader
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            // print("this is the last cell")
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.myOrderTableView.tableFooterView = spinner
            self.myOrderTableView.tableFooterView?.isHidden = false
            
            if self.myOrderCollectionData != nil    {
                if totalCount == self.myOrderCollectionData.getMyOrdersCollectionData.count  {
                    spinner.stopAnimating()
                    self.myOrderTableView.tableFooterView = nil
                    self.myOrderTableView.tableFooterView?.isHidden = true
                }
            }
        }
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
        print("didSelectRow")
        self.incrementId = self.myOrderCollectionData.getMyOrdersCollectionData[indexPath.row].id
        self.performSegue(withIdentifier: "customerorderdetails", sender: self)
    }
    
    @objc func reorderClick(sender: UIButton){
        whichApiDataToprocess = "reorder"
        orderId = self.myOrderCollectionData.getMyOrdersCollectionData[sender.tag].orderId
        callingHttppApi()
    }
    
    @objc func viewOrderClick(sender: UIButton){
        self.orderId = self.myOrderCollectionData.getMyOrdersCollectionData[sender.tag].orderId
        //self.performSegue(withIdentifier: "customerorderdetails", sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellCount = self.myOrderTableView.numberOfRows(inSection: 0)
        for cell: UITableViewCell in self.myOrderTableView.visibleCells {
            indexPathValue = self.myOrderTableView.indexPath(for: cell)!
            if indexPathValue.row == self.myOrderTableView.numberOfRows(inSection: 0) - 1 {
                if (myOrderCollectionData.totalCount > currentCellCount) && loadPageRequestFlag{
                    whichApiDataToprocess = ""
                    pageNumber += 1
                    loadPageRequestFlag = false
                    callingHttppApi()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "customerorderdetails") {
            let viewController:SellerOrderDetailsController = segue.destination as UIViewController as! SellerOrderDetailsController
            viewController.incrementId = self.incrementId
        }
        else if (segue.identifier! == "filter") {
            let viewController:SellerOrderFilterController = segue.destination as UIViewController as! SellerOrderFilterController
            viewController.sellerOrderViewModel = self.myOrderCollectionData
            viewController.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
