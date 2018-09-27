//
//  SellerReviewsController.swift
//  MobikulMPMagento2
//
//  Created by kunal on 01/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerReviewsController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

var sellerId:String!
var pageNumber:Int = 1
var totalCount:Int = 0
var loadPageRequestFlag: Bool = false
var sellerReviewViewModel:SellerReviewViewModel!
@IBOutlet weak var tableView: UITableView!
var indexPathValue:IndexPath!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "sellerreviews")
        tableView.register(UINib(nibName: "SellerReviewsCell", bundle: nil), forCellReuseIdentifier: "SellerReviewsCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorColor = UIColor.clear
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
        requstParams["sellerId"] = sellerId
         requstParams["pageNumber"] = "\(pageNumber)"
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/SellerReviews", currentView: self){success,responseObject in
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
                    self.sellerReviewViewModel = SellerReviewViewModel(data:dict)
                    self.totalCount = self.sellerReviewViewModel.totalCount
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                     }else{
                        self.loadPageRequestFlag = true
                        self.sellerReviewViewModel.setsellerreviewCollectionData(data:dict)
                        self.tableView.reloadData()
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
     return  self.sellerReviewViewModel.sellerReviewCollectionModel.count
    }
    
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellerReviewsCell", for: indexPath) as! SellerReviewsCell
        cell.heading.text = "by"+" "+self.sellerReviewViewModel.sellerReviewCollectionModel[indexPath.section].name+"  "+"on"+" "+self.sellerReviewViewModel.sellerReviewCollectionModel[indexPath.row].date
        cell.message.text = self.sellerReviewViewModel.sellerReviewCollectionModel[indexPath.row].description
        cell.valueRating.text = String(format:"%d",self.sellerReviewViewModel.sellerReviewCollectionModel[indexPath.row].valuerating)
        cell.priceRating.text = String(format:"%d",self.sellerReviewViewModel.sellerReviewCollectionModel[indexPath.row].pricerating)
        cell.qualityRating.text = String(format:"%d",self.sellerReviewViewModel.sellerReviewCollectionModel[indexPath.row].qualityrating)
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellCount = self.tableView.numberOfRows(inSection: 0);
        for cell: UITableViewCell in self.tableView.visibleCells {
            indexPathValue = self.tableView.indexPath(for: cell)!
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
