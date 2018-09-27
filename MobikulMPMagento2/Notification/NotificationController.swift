//
//  NotificationController.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 04/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit
import Alamofire

//
//  Notification.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 04/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class NotificationController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard;
    var notificationViewModel:NotificationViewModel!
    

@IBOutlet weak var notificationTableView: UITableView!
var productId:String!
var productName:String!
var imageUrl:String!
var emptyView:EmptyNewAddressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "notification")
        emptyView = EmptyNewAddressView(frame: self.view.frame);
        self.view.addSubview(emptyView)
        emptyView.isHidden = true;
        emptyView.emptyImages.image = UIImage(named: "empty_notification")!
        emptyView.addressButton.setTitle(GlobalData.sharedInstance.language(key: "gotohome"), for: .normal)
        emptyView.labelMessage.text = GlobalData.sharedInstance.language(key: "emptynotification")
        emptyView.addressButton.addTarget(self, action: #selector(browseCategory(sender:)), for: .touchUpInside)
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    @objc func browseCategory(sender: UIButton){
        self.tabBarController!.selectedIndex = 2
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        GlobalData.sharedInstance.removePreviousNetworkCall()
        GlobalData.sharedInstance.dismissLoader()
        callingHttppApi();
    }
    
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]();
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        requstParams["width"] = width
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/extra/notificationList", currentView: self){success,responseObject in
            if success == 1{
                print(responseObject)
                self.notificationViewModel = NotificationViewModel(data:JSON(responseObject as! NSDictionary))
                self.doFurtherProcessingWithResult()
            }else if success == 2{
               GlobalData.sharedInstance.dismissLoader()
               self.callingHttppApi()
            }
        }
        
    }
    
    
    
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            GlobalData.sharedInstance.dismissLoader()
            if self.notificationViewModel.notificationModel.count > 0{
            self.emptyView.isHidden = true
            self.notificationTableView.isHidden = false
            self.notificationTableView.delegate = self
            self.notificationTableView.dataSource = self
            self.notificationTableView.reloadData()
            }else{
                self.notificationTableView.isHidden = true;
                self.emptyView.isHidden = false
            }
        }
    }
    
    
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return notificationViewModel.notificationModel.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier: String = "notificationCell"
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
        let cell:NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! NotificationTableViewCell
        cell.titleText.text = notificationViewModel.notificationModel[indexPath.row].title;
        cell.contentsText.text = notificationViewModel.notificationModel[indexPath.row].contet;
        cell.bannerIMage.image = UIImage(named: "ic_placeholder.png")
        GlobalData.sharedInstance.getImageFromUrl(imageUrl:notificationViewModel.notificationModel[indexPath.row].bannerImage , imageView: cell.bannerIMage)
       
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_WIDTH / 2 + 100
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productType = notificationViewModel.notificationModel[indexPath.row].notificationType
        if productType == "product"{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
            vc.productImageUrl = notificationViewModel.notificationModel[indexPath.row].bannerImage
            vc.productId = notificationViewModel.notificationModel[indexPath.row].id
            vc.productName = notificationViewModel.notificationModel[indexPath.row].productName
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if productType == "category"{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
            vc.categoryId = notificationViewModel.notificationModel[indexPath.row].categoryId
            vc.categoryName = notificationViewModel.notificationModel[indexPath.row].categoryName
            vc.categoryType = ""
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if productType == "custom"{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
            vc.categoryId = notificationViewModel.notificationModel[indexPath.row].id
            vc.categoryName = notificationViewModel.notificationModel[indexPath.row].title
            vc.categoryType = "custom"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if productType == "other"{
            let otherTitle = notificationViewModel.notificationModel[indexPath.row].title
            let otherMessage = notificationViewModel.notificationModel[indexPath.row].contet
            let AC = UIAlertController(title:otherTitle ,message: otherMessage , preferredStyle: .alert)
            let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key:"ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            AC.addAction(okBtn)
            self.parent!.present(AC, animated: true, completion: {  })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        
    }
}



//class Triangle:NSObject{
//    var sideLength: Int = 0
//
//    init(sideLength: Int) { //initializer method
//        self.sideLength = sideLength
//    }
//
//    var perimeter: Int {
//        get { // getter
//            return sideLength
//        }
//        set { //setter
//            sideLength = newValue*5
//        }
//    }
//}

