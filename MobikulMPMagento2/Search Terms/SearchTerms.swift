//
//  SearchTerms.swift
//  DummySwift
//
//  Created by kunal prasad on 28/12/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit

class SearchTerms: UIViewController,UITableViewDelegate, UITableViewDataSource {
@IBOutlet weak var tableViewCell: UITableView!
var searchTermsArray = NSArray();
var searchTermDict:NSDictionary!
let defaults = UserDefaults.standard;
var searchtermsViewModel:SearchTermViewModel!
var  categoryType = "searchquery"
var  categoryName = "Search Result"
var categoryId = ""
var searchQuery = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "searchterms")
    
        self.navigationController?.isNavigationBarHidden = false
        tableViewCell.isHidden = true;
        GlobalData.sharedInstance.removePreviousNetworkCall()
        GlobalData.sharedInstance.dismissLoader()
        callingHttppApi();
    }
    
   
    
    
    
    
    func callingHttppApi(){
        var requstParams = [String:Any]();
        GlobalData.sharedInstance.showLoader()
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/extra/searchTermList", currentView: self){success,responseObject in
            if success == 1{
                
                self.searchtermsViewModel = SearchTermViewModel(data:JSON(responseObject as! NSDictionary))
                self.doFurtherProcessingWithResult()
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if self.isMovingToParentViewController{
            print("4nd pushed")
        }else{
            print("clear the previous")
            GlobalData.sharedInstance.removePreviousNetworkCall()
            GlobalData.sharedInstance.dismissLoader()
        }
         self.navigationController!.isNavigationBarHidden = false
    }
    
    
   
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            GlobalData.sharedInstance.dismissLoader()
            self.view.isUserInteractionEnabled = true;
            self.tableViewCell.delegate = self
            self.tableViewCell.dataSource = self
            self.tableViewCell.isHidden = false
            self.tableViewCell.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchtermsViewModel.getSearchterms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        cell.textLabel?.text = searchtermsViewModel.getSearchterms[indexPath.row].term
        cell.textLabel?.textColor = UIColor().HexToColor(hexString: LINK_COLOR)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    searchQuery = searchtermsViewModel.getSearchterms[indexPath.row].term
    self.performSegue(withIdentifier: "searchtermstoproductcategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "searchtermstoproductcategory") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryName = self.categoryName
            viewController.categoryId = self.categoryId
            viewController.categoryType = self.categoryType
            viewController.searchQuery = self.searchQuery
        }
    }
    
    



}
