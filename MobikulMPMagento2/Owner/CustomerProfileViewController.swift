//
//  Chef_ProfileViewController.swift
//  MobikulMPMagento2
//
//  Created by Othello on 07/10/2018.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class CustomerProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var profileTableView: UITableView!
    var customerProfileData:NSMutableArray = ["First Name", "Second Name", "Email", "Phone Number", "Address", "City", "State", "Post Code", "Country"]
    var accountInfoModel:AccountInformationModel!
    var customerId:Int = 0;
    var customerImage:String = "";
    var didload:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        profileTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        profileTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        profileTableView.rowHeight = UITableViewAutomaticDimension
        self.profileTableView.estimatedRowHeight = 50
        self.profileTableView.separatorColor = UIColor.clear
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        self.profileTableView.layer.shadowOpacity = 0;
        self.profileTableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        
        callingHttppApi()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerProfileData.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 210
        }else{
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell:ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
            if didload != false{
                cell.profileName.text = self.accountInfoModel.firstName + " " + self.accountInfoModel.lastName;
                cell.profileEmail.text = self.accountInfoModel.emailId
                cell.editView.isHidden = true;
                
                if(customerImage != ""){
                    GlobalData.sharedInstance.getImageFromUrl(imageUrl: self.customerImage, imageView: cell.profileImage)
                }
                //GlobalData.sharedInstance.getImageFromUrl(imageUrl: self.accountInfoModel., imageView: cell.profileImage)
            }
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell:ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            cell.name.text = customerProfileData[indexPath.row - 1] as! String
            
            if didload != false{
                switch indexPath.row - 1 {
                case 0:
                    cell.nameValue.text = accountInfoModel.firstName
                    break
                case 1:
                    cell.nameValue.text = accountInfoModel.lastName
                    break
                case 2:
                    cell.nameValue.text = accountInfoModel.emailId
                    break
                case 3:
                    cell.nameValue.text = accountInfoModel.mobileNumber
                    break
                case 4:
                    cell.nameValue.text = accountInfoModel.street
                    break
                case 5:
                    cell.nameValue.text = accountInfoModel.city
                    break
                case 6:
                    cell.nameValue.text = accountInfoModel.state
                    break
                case 7:
                    cell.nameValue.text = accountInfoModel.postcode
                    break
                    
                default:
                    cell.nameValue.text = accountInfoModel.country
                    break
                    
                }
            }
            return cell
        }
    }
    func callingHttppApi(){
        DispatchQueue.main.async {
        GlobalData.sharedInstance.showLoader()

        var requstParams = [String:Any]();
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        requstParams["websiteId"] = DEFAULT_WEBSITE_ID
        requstParams["customerId"] = self.customerId;
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/customer/accountInfoData", currentView: self){success,responseObject in
            if success == 1{
                print((responseObject as! NSDictionary))
                self.accountInfoModel  = AccountInformationModel(data: JSON(responseObject as! NSDictionary))
                self.doFurtherProcessingwithResult()
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
      }
    }
    
    func doFurtherProcessingwithResult(){
        GlobalData.sharedInstance.dismissLoader()
        didload = true
      
        profileTableView.reloadData()
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
