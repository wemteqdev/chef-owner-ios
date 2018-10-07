//
//  MyProfileController.swift
//  Magento2V4Theme
//
//  Created by kunal on 10/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit


class MyProfileController: UIViewController,UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var myProfileTableView: UITableView!
    var logoutData:NSMutableArray = [GlobalData.sharedInstance.language(key: "signin"),GlobalData.sharedInstance.language(key: "notification"),GlobalData.sharedInstance.language(key: "language"),GlobalData.sharedInstance.language(key: "currency"),GlobalData.sharedInstance.language(key: "searchterms"),GlobalData.sharedInstance.language(key: "advancesearchterms"),GlobalData.sharedInstance.language(key: "comparelist"),"Contact US",GlobalData.sharedInstance.language(key: "marketplace")];
    var signInData:NSMutableArray = [GlobalData.sharedInstance.language(key: "myorder"),GlobalData.sharedInstance.language(key: "currency"),GlobalData.sharedInstance.language(key: "language"),GlobalData.sharedInstance.language(key: "mywishlist"),GlobalData.sharedInstance.language(key: "myproductreviews"),GlobalData.sharedInstance.language(key: "accountinformation"),GlobalData.sharedInstance.language(key: "addressbook"),GlobalData.sharedInstance.language(key: "comparelist"),GlobalData.sharedInstance.language(key: "searchterms"),GlobalData.sharedInstance.language(key: "advancesearchterms"),GlobalData.sharedInstance.language(key: "mydownload"),"Contact US"]
    var marketPlaceData:NSMutableArray = [GlobalData.sharedInstance.language(key: "marketplace")]
    var extraData:NSMutableArray = [GlobalData.sharedInstance.language(key: "logout")]
    var cmsData:NSMutableArray = []
    
    var sinInView:NSMutableArray = [""]
    var profileData:NSMutableArray = []
    var showUserProfile:Bool = false
    var homeViewModel : Chef_HomeViewModel!
    var imageForCategoryMenu:String = ""
    var imageData:NSData!
    var uploadImage:String = ""
    var cmsID:String = ""
    var cmsName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        myProfileTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        myProfileTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        myProfileTableView.rowHeight = UITableViewAutomaticDimension
        self.myProfileTableView.estimatedRowHeight = 50
        self.myProfileTableView.separatorColor = UIColor.clear
        let paymentViewNavigationController = self.tabBarController?.viewControllers?[1]
        let nav = paymentViewNavigationController as! UINavigationController;
        let paymentMethodViewController = nav.viewControllers[0] as! Chef_ProductViewController
        homeViewModel = paymentMethodViewController.homeViewModel;
        
        cmsData = []
        if homeViewModel.cmsData.count > 0{
            for i in 0..<homeViewModel.cmsData.count{
                cmsData.add(homeViewModel.cmsData[i].title)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationforChatTap), name: NSNotification.Name(rawValue: "pushNotificationforChat"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if defaults.object(forKey: "customerId") != nil{
            self.navigationController?.isNavigationBarHidden = true
        }else{
            self.navigationController?.isNavigationBarHidden = false
        }
        if defaults.object(forKey: "customerId") != nil{
            showUserProfile = true
            if defaults.object(forKey: "isSeller") as! String == "t" && defaults.object(forKey: "isPending") as! String == "f" {
                
                if defaults.object(forKey: "isAdmin") as? String == "t" {
                    marketPlaceData = [GlobalData.sharedInstance.language(key: "marketplace"),GlobalData.sharedInstance.language(key: "sellerdashboard"),GlobalData.sharedInstance.language(key: "sellerprofile"),GlobalData.sharedInstance.language(key: "sellerorder"),GlobalData.sharedInstance.language(key: "mytransaction"),GlobalData.sharedInstance.language(key: "createattribute"),GlobalData.sharedInstance.language(key:"products"),GlobalData.sharedInstance.language(key:"manageprintpdfheader"),GlobalData.sharedInstance.language(key:"chatwithseller")]
                } else {
                    marketPlaceData = [GlobalData.sharedInstance.language(key: "marketplace"),GlobalData.sharedInstance.language(key: "sellerdashboard"),GlobalData.sharedInstance.language(key: "sellerprofile"),GlobalData.sharedInstance.language(key: "sellerorder"),GlobalData.sharedInstance.language(key: "mytransaction"),GlobalData.sharedInstance.language(key: "createattribute"),GlobalData.sharedInstance.language(key:"products"),GlobalData.sharedInstance.language(key:"manageprintpdfheader"),GlobalData.sharedInstance.language(key:"askquestiontoadmin"),GlobalData.sharedInstance.language(key:"chatwithadmin")]
                }
            }else if defaults.object(forKey: "isSeller") as! String == "t" && defaults.object(forKey: "isPending") as! String == "t"{
                marketPlaceData = [GlobalData.sharedInstance.language(key: "marketplace"),GlobalData.sharedInstance.language(key: "yourrequestunderapproval"),GlobalData.sharedInstance.language(key: "askquestiontoadmin")]
            }else if defaults.object(forKey: "isSeller") as! String == "f" && defaults.object(forKey: "isPending") as! String == "f"{
                marketPlaceData = [GlobalData.sharedInstance.language(key: "marketplace"),GlobalData.sharedInstance.language(key: "wanttobecomeseller")]
            }
            
            
            profileData = [sinInView,logoutData, signInData,marketPlaceData,extraData]
            myProfileTableView.dataSource = self
            myProfileTableView.delegate = self
            myProfileTableView.reloadData()
        }else{
            showUserProfile = false
            profileData = [sinInView,logoutData]
            myProfileTableView.dataSource = self
            myProfileTableView.delegate = self
            myProfileTableView.reloadData()
            self.myProfileTableView.setContentOffset(CGPoint(x: 0, y: -120), animated: true)
        }
        
        if(uploadImage == "true"){
            self.uploadImageRequest();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
        
    //MARK:- Push Notification for Chat Tap
    @objc func pushNotificationforChatTap()  {
        if defaults.object(forKey: "customerId") != nil{
            self.navigationController?.isNavigationBarHidden = true
        }else{
            self.navigationController?.isNavigationBarHidden = false
        }
        
        //open seller chat
        if defaults.object(forKey: "isAdmin") as? String == "t" {
            self.performSegue(withIdentifier: "chatwithseller", sender: self)
        }else {
            self.performSegue(withIdentifier: "chatwithadmin", sender: self)
        }
    }
    
    //MARK:- UITableViewDataSource and Delegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && showUserProfile{
            return 250
        }else if indexPath.section == 0 && !showUserProfile{
            return 0
        }else{
            return 60
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && showUserProfile{
            return 1
        }else if section == 0 && !showUserProfile{
            return 0
        }else if section == 1 && showUserProfile{
            return 0
        }else{
            return (profileData[section] as AnyObject).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell:ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
            if defaults.object(forKey: "customerEmail") != nil{
                cell.profileEmail.text = defaults.object(forKey: "customerEmail") as? String
            }
            if defaults.object(forKey: "customerName") != nil{
                cell.profileName.text = defaults.object(forKey: "customerName") as? String
            }
            if defaults.object(forKey: "profilePicture") != nil{
                let imageUrl = defaults.object(forKey: "profilePicture") as? String
                GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageUrl!, imageView: cell.profileImage)
            }
            if defaults.object(forKey: "profileBanner") != nil{
                let imageUrl = defaults.object(forKey: "profileBanner") as? String
                GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageUrl!, imageView: cell.profileBannerImage)
            }
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyProfileController.uploadProfileORBannerPic))
            cell.editView.addGestureRecognizer(tap)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell:ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            let sectionContents:NSMutableArray = profileData[indexPath.section] as! NSMutableArray
            let contentForThisRow  = sectionContents[indexPath.row]
            cell.name.text = contentForThisRow as? String
            
            if indexPath.section == 1{
                if indexPath.row == 0{
                    cell.profileImage.image = UIImage(named: "ic_signin")!
                }else if indexPath.row == 1{
                    cell.profileImage.image = UIImage(named: "ic_notificationprofile")!
                }else if indexPath.row == 2{
                    cell.profileImage.image = UIImage(named: "ic_language")!
                }else if indexPath.row == 3{
                    cell.profileImage.image = UIImage(named: "ic_currency")!
                }else if indexPath.row == 4{
                    cell.profileImage.image = UIImage(named: "ic_searchterms")!
                }else if indexPath.row == 5{
                    cell.profileImage.image = UIImage(named: "ic_searchterms")!
                }else if indexPath.row == 6{
                    cell.profileImage.image = UIImage(named: "ic_profilecompare")!
                }else if indexPath.row == 7{
                    cell.profileImage.image = UIImage(named: "ic_privacy")!
                }else if indexPath.row == 8{
                    cell.profileImage.image = UIImage(named: "ic_marketplace")!
                }
            }else if indexPath.section == 2{
                if indexPath.row == 0{
                    cell.profileImage.image = UIImage(named: "ic_myorder")!
                }else if indexPath.row == 1{
                    cell.profileImage.image = UIImage(named: "ic_currency")!
                }else if indexPath.row == 2{
                    cell.profileImage.image = UIImage(named: "ic_language")!
                }else if indexPath.row == 3{
                    cell.profileImage.image = UIImage(named: "ic_mywishlist")!
                }else if indexPath.row == 4{
                    cell.profileImage.image = UIImage(named: "ic_productreviews")!
                }else if indexPath.row == 5{
                    cell.profileImage.image = UIImage(named: "ic_accountinfo")!
                }else if indexPath.row == 6{
                    cell.profileImage.image = UIImage(named: "ic_addressbook")!
                }else if indexPath.row == 7{
                    cell.profileImage.image = UIImage(named: "ic_profilecompare")!
                }else if indexPath.row == 8{
                    cell.profileImage.image = UIImage(named: "ic_searchterms")!
                }else if indexPath.row == 9{
                    cell.profileImage.image = UIImage(named: "ic_advancesearch")!
                }else if indexPath.row == 10{
                    cell.profileImage.image = UIImage(named: "ic_downloadable")!
                }else if indexPath.row == 11{
                    cell.profileImage.image = UIImage(named: "ic_privacy")!
                }
            }else if indexPath.section == 3{
                if defaults.object(forKey: "isSeller") as! String == "t" && defaults.object(forKey: "isPending") as! String == "f"{
                    if indexPath.row == 0{
                        cell.profileImage.image = UIImage(named: "ic_marketplace")!
                    }else if indexPath.row == 1{
                        cell.profileImage.image = UIImage(named: "ic_sellerdashboard")!
                    }else if indexPath.row == 2{
                        cell.profileImage.image = UIImage(named: "ic_sellerprofile")!
                    }else if indexPath.row == 3{
                        cell.profileImage.image = UIImage(named: "ic_sellerorder")!
                    }else if indexPath.row == 4{
                        cell.profileImage.image = UIImage(named: "ic_transaction")!
                        
                    }else if indexPath.row == 5{
                        cell.profileImage.image = UIImage(named: "ic_attributes")!
                        
                    }
                    else if indexPath.row == 6{
                        cell.profileImage.image = UIImage(named: "ic_myproduct")!
                    }else if indexPath.row == 7{
                        cell.profileImage.image = UIImage(named: "ic_seller_print")!
                    }
                    
                    if defaults.object(forKey: "isAdmin") as? String == "f" {
                        if indexPath.row == 8{
                            cell.profileImage.image = UIImage(named: "ic_askQuestion")!
                        }else if indexPath.row == 9{
                            cell.profileImage.image = UIImage(named: "ic_chat")!
                        }
                    }else{
                        if indexPath.row == 8{
                            cell.profileImage.image = UIImage(named: "ic_chat")!
                        }
                    }
                    
                }else if defaults.object(forKey: "isSeller") as! String == "t" && defaults.object(forKey: "isPending") as! String == "t"{
                    if indexPath.row == 0{
                        cell.profileImage.image = UIImage(named: "ic_marketplace")!
                    }else if indexPath.row == 1{
                        cell.profileImage.image = UIImage(named: "ic_sellerdashboard")!
                    }else if indexPath.row == 2{
                        cell.profileImage.image = UIImage(named: "ic_askQuestion")!
                    }
                    
                }else if defaults.object(forKey: "isSeller") as! String == "f" && defaults.object(forKey: "isPending") as! String == "f"{
                    if indexPath.row == 0{
                        cell.profileImage.image = UIImage(named: "ic_marketplace")!
                    }else if indexPath.row == 1{
                        cell.profileImage.image = UIImage(named: "ic_becomeseller")!
                    }
                }
            }else if indexPath.section == 4{
                if indexPath.row == 0{
                    cell.profileImage.image = UIImage(named: "ic_logout")!
                }
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            if indexPath.row == 0{
                self.performSegue(withIdentifier: "customerlogin", sender: self)
            }else if indexPath.row == 1{
                self.performSegue(withIdentifier: "notification", sender: self)
            }else if indexPath.row == 2{
                self.performSegue(withIdentifier: "storeview", sender: self)
            }else if indexPath.row == 3{
                self.openCurrencyView()
            }else if indexPath.row == 4{
                self.performSegue(withIdentifier: "searchterms", sender: self)
            }else if indexPath.row == 5{
                self.performSegue(withIdentifier: "advancesearch", sender: self)
            }else if indexPath.row == 6{
                self.performSegue(withIdentifier: "comparelist", sender: self)
            }else if indexPath.row == 7{
                self.showCMSData()
            }else if indexPath.row == 8{
                self.performSegue(withIdentifier: "marketplace", sender: self)
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0{
                self.performSegue(withIdentifier: "myorder", sender: self)
            }else if indexPath.row == 1{
                self.openCurrencyView()
            }else if indexPath.row == 2{
                self.performSegue(withIdentifier: "storeview", sender: self)
            }else if indexPath.row == 3{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyWishList") as! MyWishList
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 4{
                self.performSegue(withIdentifier: "myproductreviews", sender: self)
            }else if indexPath.row == 5{
                self.performSegue(withIdentifier: "accountinfo", sender: self)
            }else if indexPath.row == 6{
                self.performSegue(withIdentifier: "addressbook", sender: self)
            }else if indexPath.row == 7{
                self.performSegue(withIdentifier: "comparelist", sender: self)
            }else if indexPath.row == 8{
                self.performSegue(withIdentifier: "searchterms", sender: self)
            }else if indexPath.row == 9{
                self.performSegue(withIdentifier: "advancesearch", sender: self)
            }else if indexPath.row == 10{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyDownloads") as! MyDownloads
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 11{
                self.showCMSData()
            }            
        }else if indexPath.section == 3{
            
            if defaults.object(forKey: "isSeller") as! String == "t" && defaults.object(forKey: "isPending") as! String == "f"{
                if indexPath.row == 0{
                    self.performSegue(withIdentifier: "marketplace", sender: self)
                }else if indexPath.row == 1{
                    self.performSegue(withIdentifier: "sellerdashboard", sender: self)
                }else if indexPath.row == 2{
                    self.performSegue(withIdentifier: "sellerprofilecontroller", sender: self)
                }else if indexPath.row == 3{
                    self.performSegue(withIdentifier: "sellerorder", sender: self)
                }else if indexPath.row == 4{
                    self.performSegue(withIdentifier: "mytransaction", sender: self)
                }else if indexPath.row == 5{
                    self.performSegue(withIdentifier: "createattributes", sender: self)
                }else if indexPath.row == 6{
                    self.performSegue(withIdentifier: "myproductslist", sender: self)
                }else if indexPath.row == 7{
                    self.performSegue(withIdentifier: "manageprintpdf", sender: self)
                }
                
                if defaults.object(forKey: "isAdmin") as? String == "f" {
                    if indexPath.row == 8{
                        self.performSegue(withIdentifier: "askquestion", sender: self)
                    }else if indexPath.row == 9 {
                        if defaults.object(forKey: "isAdmin") as? String == "t" {
                            self.performSegue(withIdentifier: "chatwithseller", sender: self)
                        }else {
                            self.performSegue(withIdentifier: "chatwithadmin", sender: self)
                        }
                    }
                }else{
                    if indexPath.row == 8{
                        if defaults.object(forKey: "isAdmin") as? String == "t" {
                            self.performSegue(withIdentifier: "chatwithseller", sender: self)
                        }else {
                            self.performSegue(withIdentifier: "chatwithadmin", sender: self)
                        }
                    }
                }
            }else if defaults.object(forKey: "isSeller") as! String == "t" && defaults.object(forKey: "isPending") as! String == "t"{
                if indexPath.row == 0{
                    self.performSegue(withIdentifier: "marketplace", sender: self)
                }else if indexPath.row == 1{
                    GlobalData.sharedInstance.showWarningSnackBar(msg: "Your Seller Accountis Under Approval by the Admin");
                }
            }else if defaults.object(forKey: "isSeller") as! String == "f" && defaults.object(forKey: "isPending") as! String == "f"{
                if indexPath.row == 0{
                    self.performSegue(withIdentifier: "marketplace", sender: self)
                }else if indexPath.row == 1{
                    self.performSegue(withIdentifier: "becomeseller", sender: self)
                }
            }
        }else if indexPath.section == 4{
            let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "warninglogoutmessage"), message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: GlobalData.sharedInstance.language(key: "yes"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    if(key.description == "storeId"||key.description == "language"||key.description == "AppleLanguages" || key.description == "currency" || key.description == "authKey" || key.description == "TouchEmailId" || key.description == "TouchPasswordValue" || key.description == "touchIdFlag" || key.description == "deviceToken" ){
                        continue
                    }else{
                        UserDefaults.standard.removeObject(forKey: key.description)
                    }
                }
                UserDefaults.standard.synchronize();
                self.tabBarController!.tabBar.items?[3].badgeValue = nil
                self.viewWillAppear(true)
            })
            
            let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "no"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
            })
            AC.addAction(ok)
            AC.addAction(noBtn)
            self.parent!.present(AC, animated: true, completion: {  })
        }
    }
    
    //MARK:-
    func showCMSData(){
        let alert = UIAlertController(title: GlobalData.sharedInstance.language(key: "seeprivacypolicy"), message: nil, preferredStyle: .actionSheet)
        for i in 0..<homeViewModel.cmsData.count{
            let str : String = homeViewModel.cmsData[i].title
            let action = UIAlertAction(title: str, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.selectCmsData(pos:i)
            })
            alert.addAction(action)
        }
        
        let cancel = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
        })
        alert.addAction(cancel)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    func selectCmsData(pos:Int){
        cmsID = homeViewModel.cmsData[pos].id
        cmsName = homeViewModel.cmsData[pos].title
        self.performSegue(withIdentifier: "cmsdata", sender: self)
        
        
    }
    
    @objc func uploadProfileORBannerPic(){
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let uploadBanner = UIAlertAction(title: GlobalData.sharedInstance.language(key: "uploadbanner"), style: .default, handler: uploadBannerPic)
        let uploadPic = UIAlertAction(title: GlobalData.sharedInstance.language(key: "uploadpic"), style: .default, handler: uploadProfilePic)
        let cancel = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .cancel, handler: cancelDeletePlanet)
        alert.addAction(uploadBanner)
        alert.addAction(uploadPic)
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func uploadBannerPic(alertAction: UIAlertAction!) {
        imageForCategoryMenu = "uploadBannerPic";
        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "uploadbanner"), message: "", preferredStyle: .alert)
        let clickBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "takepicture") , style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        let cameraRollBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "uploadfromcameraroll"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: {  })
        })
        let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(clickBtn)
        AC.addAction(cameraRollBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: {  })
        
    }
    func uploadProfilePic(alertAction: UIAlertAction!) {
        imageForCategoryMenu = "profilePicture";
        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "uploadpic"), message: "", preferredStyle: .alert)
        let clickBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "takepicture"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        let cameraRollBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "uploadfromcameraroll"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: {  })
        })
        let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(clickBtn)
        AC.addAction(cameraRollBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: {  })
    }
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageData = UIImageJPEGRepresentation(image, 0.5) as NSData!
            uploadImage = "true";
        }
        
        picker.dismiss(animated: true, completion: nil);
    }
    
    
    func uploadImageRequest(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false;
        let defaults = UserDefaults.standard;
        let customerId:String = (defaults.object(forKey:"customerId") as? String)!;
        uploadImage = ""
        var imageSendUrl:String = ""
        if (imageForCategoryMenu == "uploadBannerPic") {
            let url = "\(BASE_DOMAIN)/mobikulhttp/index/uploadBannerPic"
            imageSendUrl = url
        }
        else {
            let url = "\(BASE_DOMAIN)/mobikulhttp/index/uploadProfilePic"
            imageSendUrl = url
        }
        
        print(imageSendUrl)
        
        let request = NSMutableURLRequest(url: URL(string: imageSendUrl)!)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let boundary = "unique-consistent-string"
        
        //define the multipart request type
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let body = NSMutableData()
        let screenWidth:String = String(format:"%f",SCREEN_WIDTH);
        
        // add params (all params are strings)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\("customerToken")\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(customerId)\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\("width")\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(screenWidth)\r\n".data(using: String.Encoding.utf8)!)
        // add image data
        if (imageData != nil) {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\("imageFormKey"); filename=imageName.jpg\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(imageData as Data)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {(
            data, response, error) in
            
            guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                GlobalData.sharedInstance.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key: "servererror"));
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions()) as (AnyObject)
                var dict = json as! [String:AnyObject];
                if(self.imageForCategoryMenu == "uploadBannerPic"){
                    let imageUrl = dict["url"] as! String
                    defaults.set(imageUrl, forKey: "profileBanner")
                    self.myProfileTableView.reloadData()
                }
                else{
                    let imageUrl = dict["url"] as! String
                    defaults.set(imageUrl, forKey: "profilePicture")
                    self.myProfileTableView.reloadData()
                }
                
                
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                
            } catch {
                print("json error: \(error)")
                
            }
            
        }
        
        task.resume()
        
    }
    
    
    
    
    func openCurrencyView(){
        let alert = UIAlertController(title: GlobalData.sharedInstance.language(key: "chooseyourcurrency"), message: nil, preferredStyle: .actionSheet)
        for i in 0..<homeViewModel.currency.count{
            var image = UIImage(named: "")
            if defaults.object(forKey: "currency") != nil{
                let currencyCode = defaults.object(forKey: "currency") as! String
                if currencyCode == homeViewModel.currency[i] as! String{
                    image = UIImage(named: "ic_check")
                }else{
                    image = UIImage(named: "")
                }
            }
            
            let str : String = homeViewModel.currency[i] as! String
            let action = UIAlertAction(title: str, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.selectCurrencyData(pos:i)
            })
            action.setValue(image, forKey: "image")
            alert.addAction(action)
        }
        
        let cancel = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
        })
        alert.addAction(cancel)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func selectCurrencyData(pos:Int){
        
        let contentForThisRow  = homeViewModel.currency[pos] as! String
        defaults.set(contentForThisRow, forKey: "currency");
        defaults.synchronize()
        
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        rootviewcontroller.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "rootnav")
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
            
        }) { (finished) -> Void in
            
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "storeview") {
            let viewController:StoreViewController = segue.destination as UIViewController as! StoreViewController
            viewController.storeData = homeViewModel.storeData
            
        }else if (segue.identifier! == "chatwithadmin") {
            let viewController:ChatMessaging = segue.destination as UIViewController as! ChatMessaging
            viewController.customerId = defaults.object(forKey:"customerId") as! String
            viewController.token = ""
            viewController.customerName = defaults.object(forKey:"customerName") as! String;
            viewController.apiKey = ""
        }else if (segue.identifier! == "cmsdata") {
            let viewController:CMSPageData = segue.destination as UIViewController as! CMSPageData
            viewController.cmsId = self.cmsID
            viewController.cmsName = cmsName
            
            
        }
        
        
    }
    
    
}
