//
//  UpselleViewController.swift
//  ShangMarket
//
//  Created by kunal on 26/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit

class UpselleViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,AddproductFilterDataHandle {

    @IBOutlet weak var tableView: UITableView!
var dict:JSON!
var filterItemkey:NSMutableArray = []
var filterItemValue:NSMutableArray = []
var loadPageRequestFlag: Bool = false
var totalCount:Int = 0
var indexPathValue:IndexPath!
var productId:String = ""
var pageNumber:Int = 1
var upsellProductViewModel:UPsellProductViewModel!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "upsellproducts")
        tableView.register(UINib(nibName: "AddProductViewCell", bundle: nil), forCellReuseIdentifier: "AddProductViewCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorColor = UIColor.clear
        loadPageRequestFlag = true
        self.callingHttppApi()
        
    }

    
    func filterData(data1:NSMutableArray,data2:NSMutableArray){
        filterItemkey = data1
        filterItemValue = data2
        loadPageRequestFlag = true
        pageNumber = 1;
        callingHttppApi()
        
    }
    
    
    func callingHttppApi(){
        
        if pageNumber == 1{
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        }
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
        requstParams["productId"] = productId
        
        let filterData : NSArray = [filterItemValue, filterItemkey]
        do {
            let jsonSortData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
            let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["filterData"] = jsonSortString
            
        }
        catch {
            print(error.localizedDescription)
        }
        
        
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/product/UpsellProductData", currentView: self){success,responseObject in
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        defaults .set(storeId, forKey: "storeId")
                    }
                }
                GlobalData.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
                self.dict = JSON(responseObject as! NSDictionary)
                if self.dict["success"].boolValue == true{
                    if self.pageNumber == 1{
                        self.upsellProductViewModel = UPsellProductViewModel(data:self.dict)
                        self.totalCount = self.upsellProductViewModel.totalCount
                        self.tableView.dataSource = self
                        self.tableView.delegate = self
                        self.tableView.reloadData()
                    }else{
                        self.loadPageRequestFlag = true
                        self.upsellProductViewModel.setProductCollectionData(data: self.dict)
                        self.tableView.reloadData()
                    }
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
        return self.upsellProductViewModel.upsellProductModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddProductViewCell", for: indexPath) as! AddProductViewCell
        cell.name.text = self.upsellProductViewModel.upsellProductModel[indexPath.row].name
        cell.price.text = self.upsellProductViewModel.upsellProductModel[indexPath.row].price
        cell.attributesetValue.text = "Attribute Set: "+upsellProductViewModel.upsellProductModel[indexPath.row].attrinuteSet
        cell.statusValue.text = "Status: "+upsellProductViewModel.upsellProductModel[indexPath.row].status
        cell.typeValue.text = "Type: "+upsellProductViewModel.upsellProductModel[indexPath.row].type
        cell.skuValue.text = "Sku: "+upsellProductViewModel.upsellProductModel[indexPath.row].sku
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:upsellProductViewModel.upsellProductModel[indexPath.row].thumbnail , imageView: cell.productImage)
        if upsellProductViewModel.upsellProductModel[indexPath.row].selected == 1{
            cell.switchValue.setOn(true, animated: true)
            if GlobalVariables.selectedUPSellProductIds.contains(!(upsellProductViewModel.upsellProductModel[indexPath.row].entity_id != nil)){
                GlobalVariables.selectedUPSellProductIds.add(upsellProductViewModel.upsellProductModel[indexPath.row].entity_id)
            }
            
        }else{
            cell.switchValue.setOn(false, animated: true)
        }
        
        cell.switchValue.addTarget(self, action:#selector(self.addIDValues), for: .valueChanged)
        cell.switchValue.tag = indexPath.row
        
        
        cell.selectionStyle = .none
        return cell
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
    
    
    @IBAction func filterClick(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "filter", sender: self)
    }
    
    @IBAction func resetClick(_ sender: UIBarButtonItem) {
        filterItemkey = []
        filterItemValue = []
        pageNumber = 1;
        loadPageRequestFlag = true
        callingHttppApi()
    }
    
    @objc func addIDValues(_ sender: UISwitch) {
        let id = upsellProductViewModel.upsellProductModel[sender.tag].entity_id
        if sender.isOn{
            if !GlobalVariables.selectedUPSellProductIds.contains(id){
                GlobalVariables.selectedUPSellProductIds.add(id)
            }
            upsellProductViewModel.setDataToRelatedModel(data: 1, pos: sender.tag)
        }else{
            if GlobalVariables.selectedUPSellProductIds.contains(id){
                GlobalVariables.selectedUPSellProductIds.remove(id)
            }
            upsellProductViewModel.setDataToRelatedModel(data: 0, pos: sender.tag)
        }
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "filter") {
            let viewController:AddProductFilterController = segue.destination as UIViewController as! AddProductFilterController
            viewController.mainCollection = self.dict
            viewController.delegate = self
        }
        
    }
    
    
    

}
