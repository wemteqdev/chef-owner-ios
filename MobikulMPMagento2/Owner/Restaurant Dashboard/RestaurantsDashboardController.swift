//
//  RestaurantsDashboardController.swift
//  MobikulMPMagento2
//
//  Created by andonina on 9/18/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

class RestaurantsDashboardController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var restaurantsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addRestaurantButton: UIBarButtonItem!
    @IBOutlet weak var searchBarView: UIView!
    
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
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "customAddAlertView") as! CustomAlertView
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
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
                    var restaurantInfo = AddRestaurantInfoModel(data:dict["addRestaurant"]);
                    if restaurantInfo.isAddSuccess == true {
                        print("restaurantInfo:", restaurantInfo.restaurantInfo);
                        Owner.ownerDashboardModelView.restaurantInfos.append(restaurantInfo.restaurantInfo);
                        self.restaurantsTableView.reloadData();
                    } else {
                        let alertController = UIAlertController(title: "Error", message: "Failed to add restaurant.", preferredStyle: .alert)
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
                self.callingHttppApi()
            }
            print("addRestaurant", responseObject)
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
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /*
        print("searchActive:", searchActive);
        filtered = Owner.ownerDashboardModelView.restaurantInfos.filter({ (restaurantInfo: RestaurantInfoModel) -> Bool in
            
            return restaurantInfo.restaurantName.lowercased().contains(searchText.lowercased())
        })
         */
        /*
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        */
        //self.restaurantsTableView.reloadData()
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
        /*
        if (searchActive) {
            return filtered.count
        }
        if (Owner.callingApiSucceed){
            return Owner.ownerDashboardModelView.restaurantInfos.count;
        }
         */
        return 15;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RestaurantsCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantsCell") as! RestaurantsCell
        /*
        if (searchActive) {
            if(filtered.count == 0)
            {
            }
            else {
                cell.restaurantName.text = filtered[indexPath.section].restaurantName as? String;
                cell.restaurantImage.image = UIImage(named: "ic_signin")!
            }
        }
        else
        {
            cell.restaurantName.text = Owner.ownerDashboardModelView.restaurantInfos[indexPath.section].restaurantName as? String;
            cell.restaurantImage.image = UIImage(named: "ic_signin")!
        }
         */
        cell.restaurantImage.image = UIImage(named: "ic_signin")!
        cell.selectionStyle = .none
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailPage") as! DetailPage
        vc.pageType = 2;
        self.navigationController?.pushViewController(vc, animated: true)
    }
            
}

extension RestaurantsDashboardController: CustomAlertViewDelegate {
    
    func okButtonTapped(textFieldValue: String) {
        print("TextField has value: \(textFieldValue)")
        self.addRestaurantName = textFieldValue;
        //self.callingHttppApi();
    }
    
    func cancelButtonTapped() {
        print("cancelButtonTapped")
    }
}
