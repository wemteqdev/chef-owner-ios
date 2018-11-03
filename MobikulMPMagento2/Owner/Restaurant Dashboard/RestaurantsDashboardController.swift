//
//  RestaurantsDashboardController.swift
//  MobikulMPMagento2
//
//  Created by andonina on 9/18/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

class RestaurantsDashboardController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate , removeFromOwnerHandlerDelegate {
    
    func removeButtonClick(id: Int) {
        print("id:", id);
        
        let alertController = UIAlertController(title: "Alert", message: "Are you sure to remove this restaurant?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            self.callingHttppApiForRemoveRestaurant(id: id);
        }
        let action2 = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
        }
        alertController.addAction(action2)
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var restaurantsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addRestaurantButton: UIBarButtonItem!
    @IBOutlet weak var searchBarView: UIView!
    
    var callingApiSucceed:Bool = false;
    var restaurantDashboardModelView:RestaurantDashboardModelView!;
    
    var searchActive : Bool = false
    var filtered:[RestaurantInfoModel] = [];
    var addRestaurantName:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "back_color"), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage();
        searchBarView.backgroundColor = UIColor(red: 30/255, green: 161/255, blue: 243/255, alpha: 1.0);
        
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "Restaurant")
        restaurantsTableView.register(UINib(nibName: "RestaurantsCell", bundle: nil), forCellReuseIdentifier: "RestaurantsCell")
        restaurantsTableView.rowHeight = UITableViewAutomaticDimension
        self.restaurantsTableView.estimatedRowHeight = 50
        self.restaurantsTableView.separatorColor = UIColor.clear
        let whiteColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0);
        self.searchBar.barTintColor = whiteColor;
        self.searchBar.setSearchFieldBackgroundImage(UIImage(named: "white_color"), for: UIControlState.normal)
        restaurantsTableView.delegate = self
        restaurantsTableView.dataSource = self
        self.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.callingHttppApi();
        restaurantsTableView.dataSource = self
        restaurantsTableView.delegate = self
        restaurantsTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    //---add restaurant------
    
    @IBAction func addRestaurant(_ sender: Any) {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "addRestaurantAlertView") as! AddRestaurantAlertView
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        customAlert.restaurantNames = self.restaurantDashboardModelView.restaurantNames
        self.present(customAlert, animated: true, completion: nil)
 
    }
 
    func callingHttppApi(){
        var requstParams = [String:Any]();
        
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        requstParams = [String:Any]();
        requstParams["websiteId"] = DEFAULT_WEBSITE_ID
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
            requstParams["customerId"] = customerId
        }
        requstParams["customerType"] =  1; //owner
        self.callingApiSucceed = false;
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/owner/getrestaurantinfos", currentView: self){success,responseObject in
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
                    self.restaurantDashboardModelView = RestaurantDashboardModelView(data:dict);
                    self.callingApiSucceed = true;
                    self.restaurantsTableView.reloadData();
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    func callingHttppApiForAddRestaurant(){
        var requstParams = [String:Any]();
        
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        requstParams = [String:Any]();
        requstParams["websiteId"] = DEFAULT_WEBSITE_ID
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
            requstParams["customerId"] = customerId
        }
        requstParams["isChefOrRestaurant"] = 2; //restaurant
        requstParams["addRestaurantName"] = addRestaurantName;
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/owner/addcustomer", currentView: self){success,responseObject in
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
                    print("addRestaurant dict", dict["addRestaurant"]);
                    let restaurantInfo = AddRestaurantInfoModel(data:dict["addRestaurant"]);
                    if restaurantInfo.isAddSuccess == true {
                        print("restaurantInfo:", restaurantInfo.restaurantInfo);
                        self.restaurantDashboardModelView.restaurantInfos.append(restaurantInfo.restaurantInfo);
                        self.restaurantsTableView.reloadData();
                    } else {
                        let alertController = UIAlertController(title: "Error", message: restaurantInfo.errorMessage, preferredStyle: .alert)
                        let action2 = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction) in
                            print("You've pressed cancel");
                        }
                        alertController.addAction(action2)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApiForAddRestaurant()
            }
            print("addRestaurant", responseObject)
        }
    }
    
    func callingHttppApiForRemoveRestaurant(id: Int){
        var requstParams = [String:Any]();
        
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        requstParams = [String:Any]();
        requstParams["websiteId"] = DEFAULT_WEBSITE_ID
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
            requstParams["customerId"] = customerId
        }
        requstParams["restaurantId"] = id; //restaurant
        
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/owner/removerestaurant", currentView: self){success,responseObject in
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
                    var message = "";
                    var title = "";
                    if dict["removeRestaurantSuccess"] == true {
                        message = "Restaurant removed successfully"
                        title = "Success";
                        for index in 0...self.restaurantDashboardModelView.restaurantInfos.count - 1 {
                            if (self.restaurantDashboardModelView.restaurantInfos[index].restaurantId == id){
                                self.restaurantDashboardModelView.restaurantInfos.remove(at: index);
                                break;
                            }
                        }
                        self.restaurantsTableView.reloadData();
                    } else {
                        message = "Restaurant removing is failed"
                        title = "Error";
                    }
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let action2 = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction) in
                        print("You've pressed cancel");
                    }
                    alertController.addAction(action2)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApiForRemoveRestaurant(id: id)
            }
            print("restaurant remove", responseObject)
        }
    }
    //---search bar----
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("searchActive:", searchActive);
        filtered = self.restaurantDashboardModelView.restaurantInfos.filter({ (restaurantInfo: RestaurantInfoModel) -> Bool in
            
            return restaurantInfo.restaurantName.lowercased().contains(searchText.lowercased())
        })
        
        if searchText == "" {
            filtered = self.restaurantDashboardModelView.restaurantInfos
        }
        searchActive = true;
        
        self.restaurantsTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITableViewDataSource and Delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if (searchActive) {
            return filtered.count
        }
        if (self.callingApiSucceed){
            return self.restaurantDashboardModelView.restaurantInfos.count;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RestaurantsCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantsCell") as! RestaurantsCell
        
        if (searchActive) {
            if(filtered.count == 0)
            {
            }
            else {
                cell.restaurantName.text = filtered[indexPath.section].restaurantName as? String;
                cell.restaurantImage.image = UIImage(named: "ic_signin")!
                cell.delegate = self;
                cell.restaurantId = filtered[indexPath.section].restaurantId;
            }
        }
        else
        {
            cell.restaurantName.text = self.restaurantDashboardModelView.restaurantInfos[indexPath.section].restaurantName as? String;
            cell.restaurantImage.image = UIImage(named: "ic_signin")!
            cell.restaurantId = self.restaurantDashboardModelView.restaurantInfos[indexPath.section].restaurantId;
            cell.delegate = self;
        }
        
        //cell.restaurantImage.image = UIImage(named: "ic_signin")!
        cell.selectionStyle = .none
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailPage") as! DetailPage
        vc.pageType = 2;
        vc.customerId = self.restaurantDashboardModelView.restaurantInfos[indexPath.section].restaurantId;
        self.navigationController?.pushViewController(vc, animated: true)
    }
            
}

extension RestaurantsDashboardController: AddRestaurantAlertViewDelegate {
    
    func okButtonTapped(textFieldValue: String) {
        print("TextField has value: \(textFieldValue)")
        self.addRestaurantName = textFieldValue;
        self.callingHttppApiForAddRestaurant();
    }
    
    func cancelButtonTapped() {
        print("cancelButtonTapped")
    }
}
