//
//  ChatSellerListController.swift
//  MobikulMPMagento2
//
//  Created by yogesh on 13/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class ChatSellerListController: UIViewController,UITableViewDelegate, UITableViewDataSource {
var chatSellerListViewModel:ChatSellerListViewModel!
    
@IBOutlet weak var chatTableView: UITableView!
var sellerId:String!
var token:String!
var sellerName:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "sellerlist")
        chatTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        chatTableView.rowHeight = UITableViewAutomaticDimension
        self.chatTableView.estimatedRowHeight = 50
        self.chatTableView.separatorColor = UIColor.clear
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
        let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        requstParams["width"] = width
      
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/chat/sellerList", currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    var dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        self.chatSellerListViewModel = ChatSellerListViewModel(data:dict)
                        self.chatTableView.delegate = self
                        self.chatTableView.dataSource = self
                        self.chatTableView.reloadData()
                        
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                    
                    
                    print("dsd", responseObject)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            
            
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatSellerListViewModel.chatSellerListModel.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 60
    }
    func numberOfSections(in tableView: UITableView) -> Int {
     return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell:ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
       cell.name.text = self.chatSellerListViewModel.chatSellerListModel[indexPath.row].name
      // GlobalData.sharedInstance.getImageFromUrl(imageUrl:  self.chatSellerListViewModel.chatSellerListModel[indexPath.row].profileImage, imageView:cell.profileImage)
       cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       sellerId = self.chatSellerListViewModel.chatSellerListModel[indexPath.row].customerID
       sellerName = self.chatSellerListViewModel.chatSellerListModel[indexPath.row].name
       token = self.chatSellerListViewModel.chatSellerListModel[indexPath.row].token
       self.performSegue(withIdentifier: "chatsellerListToChatMessaging", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  (segue.identifier! == "chatsellerListToChatMessaging") {
            let viewController:ChatMessaging = segue.destination as UIViewController as! ChatMessaging
            viewController.customerId = sellerId
            viewController.token = token
            viewController.customerName = sellerName;
            viewController.apiKey = self.chatSellerListViewModel.apiKey
            
        }
    }
    
    
    
}
