//
//  MyProductListController.swift
//  ShangMarket
//
//  Created by kunal on 27/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit

class MyProductListController: UIViewController,UITableViewDelegate, UITableViewDataSource,MyProductListFilerdelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewProductButton: UIButton!
    
    var loadPageRequestFlag: Bool = false
    var totalCount:Int = 0
    var indexPathValue:IndexPath!
    var productId:String = ""
    var pageNumber:Int = 1
    var myProductListViewModel:MyProductListViewModel!
    var whichApiToProcess:String = ""
    var isEdit:Bool = false
    var emptyView:EmptyNewAddressView!
    var productName:String = ""
    var productid:String = ""
    var imageUrl:String = ""
    var statusValue:String = ""
    var nameValue:String = ""
    var toDateValue:String = ""
    var fromDateValue:String = ""
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "myproductlist")
        tableView.register(UINib(nibName: "MyProductListViewCell", bundle: nil), forCellReuseIdentifier: "MyProductListViewCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorColor = UIColor.clear
        self.loadPageRequestFlag = true
        
        addNewProductButton.layer.cornerRadius = 5;
        addNewProductButton.backgroundColor = UIColor().HexToColor(hexString: BUTTON_COLOR)
        addNewProductButton.setTitle(GlobalData.sharedInstance.language(key: "addnewproduct"), for: .normal)
        addNewProductButton.setTitleColor(UIColor.white, for: .normal)
        
        emptyView = EmptyNewAddressView(frame: self.view.frame);
        self.view.addSubview(emptyView)
        emptyView.isHidden = true;
        emptyView.emptyImages.image = UIImage(named: "empty_product")!
        emptyView.addressButton.setTitle(GlobalData.sharedInstance.language(key: "addproduct"), for: .normal)
        emptyView.labelMessage.text = GlobalData.sharedInstance.language(key: "emptyproduct")
        emptyView.addressButton.addTarget(self, action: #selector(addProduct(sender:)), for: .touchUpInside)
        
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "refreshing".localized, attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        }else {
            tableView.backgroundView = refreshControl
        }
    }
    
    //MARK:- Pull to refresh
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        pageNumber = 1
        whichApiToProcess = ""
        self.callingHttppApi()
        refreshControl.endRefreshing()
    }
    
    func myProductFilterData(name:String,fromDate:String,toDate:String,status:String){
        self.nameValue = name
        self.fromDateValue = fromDate
        self.toDateValue = toDate
        self.statusValue = status
        pageNumber = 1;
        whichApiToProcess = ""
        loadPageRequestFlag = true
        callingHttppApi()
    }
    
    @objc func addProduct(sender: UIButton){
        isEdit = false
        self.performSegue(withIdentifier: "editproduct", sender: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        pageNumber = 1
        whichApiToProcess = ""
        self.callingHttppApi()
    }
    
    
    
    func callingHttppApi(){
        var requstParams = [String:Any]();
        
        self.view.isUserInteractionEnabled = false
        let customerId = defaults.object(forKey:"customerId");
        let storeId = defaults.object(forKey: "storeId")
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        
        
        if whichApiToProcess == "delete"{
            GlobalData.sharedInstance.showLoader()
            self.view.isUserInteractionEnabled = false
            requstParams["productId"] = self.productId
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/ProductDelete", currentView: self){success,responseObject in
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
                    if dict["success"].intValue == 1{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                        self.whichApiToProcess = ""
                        self.pageNumber = 1
                        self.callingHttppApi()
                    }
                    
                    print("sss", responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
        else{
            if pageNumber == 1{
                GlobalData.sharedInstance.showLoader()
            }
            requstParams["pageNumber"] = "\(pageNumber)"
            
            requstParams["toDate"] = toDateValue
            requstParams["fromDate"] = fromDateValue
            requstParams["productName"] = nameValue
            requstParams["productStatus"] = statusValue
            
            
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/Productlist", currentView: self){success,responseObject in
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
                    if dict["success"].intValue == 1{
                        
                        if self.pageNumber == 1{
                            self.myProductListViewModel = MyProductListViewModel(data:dict)
                            self.totalCount = self.myProductListViewModel.totalCount
                            self.tableView.dataSource = self
                            self.tableView.delegate = self
                            self.tableView.reloadData()
                            
                            if self.totalCount == 0{
                                self.tableView.isHidden = true
                                self.emptyView.isHidden = false
                            }
                        }else{
                            self.loadPageRequestFlag = true
                            self.myProductListViewModel.setProductCollectionData(data: dict)
                            self.tableView.reloadData()
                        }
                    }else{
                    }
                    
                    print("sss", responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
            
        }
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.myProductListViewModel.myProductListModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyProductListViewCell", for: indexPath) as! MyProductListViewCell
        cell.productName.text = myProductListViewModel.myProductListModel[indexPath.row].name
        cell.priceLabelValue.text = myProductListViewModel.myProductListModel[indexPath.row].price
        cell.typeLabelValue.text = myProductListViewModel.myProductListModel[indexPath.row].type
        cell.statusLabelValue.text = myProductListViewModel.myProductListModel[indexPath.row].status
        cell.earnedAmountLabelValue.text = myProductListViewModel.myProductListModel[indexPath.row].earnedAmount
        cell.qtyConfirmedLabelValue.text = myProductListViewModel.myProductListModel[indexPath.row].qtyConfirmed
        cell.qtypendingLabelValue.text = myProductListViewModel.myProductListModel[indexPath.row].qtypending
        cell.qtysoldLabelValue.text = myProductListViewModel.myProductListModel[indexPath.row].qtySold
        cell.editButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        
        cell.editButton.addTarget(self, action: #selector(editProduct(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteProduct(sender:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openProduct))
        cell.priductImage.addGestureRecognizer(tapGesture)
        cell.priductImage.tag = indexPath.row
        cell.priductImage.isUserInteractionEnabled = true
        
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:myProductListViewModel.myProductListModel[indexPath.row].image , imageView: cell.priductImage)
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    @objc func editProduct(sender: UIButton) {
        isEdit = true
        self.productId = myProductListViewModel.myProductListModel[sender.tag].productId
        self.performSegue(withIdentifier: "editproduct", sender: self)
    }
    
    @objc func deleteProduct(sender: UIButton) {
        self.productId = myProductListViewModel.myProductListModel[sender.tag].productId
        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "pleaseconfirm"), message: GlobalData.sharedInstance.language(key: "deleteproduct"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "delete"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.whichApiToProcess = "delete"
            self.callingHttppApi()
        })
        let noBtn = UIAlertAction(title:GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: {  })
        
    }
    
    @objc func openProduct(_sender : UITapGestureRecognizer){
        if myProductListViewModel.myProductListModel[(_sender.view?.tag)!].openable == 1{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
            vc.productImageUrl = myProductListViewModel.myProductListModel[(_sender.view?.tag)!].image
            vc.productName = myProductListViewModel.myProductListModel[(_sender.view?.tag)!].name
            vc.productId = myProductListViewModel.myProductListModel[(_sender.view?.tag)!].productId
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            GlobalData.sharedInstance.showWarningSnackBar(msg: "This product is not accessible");
        }
    }
    
    
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellCount = self.tableView.numberOfRows(inSection: 0);
        for cell: UITableViewCell in self.tableView.visibleCells {
            if let indexPathValue = self.tableView.indexPath(for: cell){
                if indexPathValue.row == self.tableView.numberOfRows(inSection: 0) - 1 {
                    if (totalCount > currentCellCount) && loadPageRequestFlag{
                        pageNumber += 1;
                        loadPageRequestFlag = false
                        callingHttppApi();
                        
                    }
                }
            }
        }
    }
    
    @IBAction func addNewProductClick(_ sender: UIButton) {
        isEdit = false
        self.performSegue(withIdentifier: "editproduct", sender: self)
    }
    
    @IBAction func filterClick(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "filter", sender: self)
    }
    
    @IBAction func refreshClick(_ sender: Any) {
        statusValue = ""
        nameValue = ""
        toDateValue = ""
        fromDateValue = ""
        pageNumber = 1;
        loadPageRequestFlag = true
        whichApiToProcess = ""
        callingHttppApi()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "editproduct") {
            let viewController:AddProductController = segue.destination as UIViewController as! AddProductController
            viewController.productId = self.productId
            viewController.isProductEdit = isEdit
        }else if (segue.identifier! == "filter") {
            let viewController:MyProductListFilterController = segue.destination as UIViewController as! MyProductListFilterController
            viewController.delegate = self
            viewController.disabledStatusText = self.myProductListViewModel.disabledStatusText
            viewController.enabledStatusText =  self.myProductListViewModel.enabledStatusText
        }
    }
}
