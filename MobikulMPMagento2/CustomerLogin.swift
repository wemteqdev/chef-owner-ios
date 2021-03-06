//
//  CustomerLogin.swift
//  Magento2V4Theme
//
//  Created by kunal on 10/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit
import LocalAuthentication
import FacebookLogin
import FacebookCore
import GoogleSignIn

class CustomerLogin: UIViewController, GIDSignInUIDelegate {
    var isOwner:Bool = false
    
    @IBOutlet weak var emailIdField: UIFloatLabelTextField!
    @IBOutlet weak var passwordtextField: UIFloatLabelTextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var googlesignButton: UIButton!
    @IBOutlet weak var facebooksignButton: UIButton!
    
    @IBOutlet weak var baselineView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    var whichApiToProcess:String = ""
    var emailId:String = ""
    var password:String = ""
    var moveToSignal:String = ""
    var userEmail:String = ""
    var context = LAContext()
    let kMsgShowReason = "🌛 Try to dismiss this screen 🌜"
    var errorMessage:String = ""
    var NotAgainCallTouchId :Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
    }
    /*
     func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
     //myActivityIndicator.stopAnimating()
     print("signin dispatch")
     }
     @IBAction func didTapSignOut(_ sender: AnyObject) {
     GIDSignIn.sharedInstance().signOut()
     }
     
     // Present a view that prompts the user to sign in with Google
     func sign(_ signIn: GIDSignIn!,
     present viewController: UIViewController!) {
     print("signin")
     self.present(viewController, animated: true, completion: nil)
     }
     
     // Dismiss the "Sign in with Google" view
     func sign(_ signIn: GIDSignIn!,
     dismiss viewController: UIViewController!) {
     print("signin dismiss")
     self.dismiss(animated: true, completion: nil)
     }
     */
    /*
     func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
     withError error: Error!) {
     if let error = error {
     print("\(error.localizedDescription)")
     } else {
     // Perform any operations on signed in user here.
     let userId = user.userID                  // For client-side use only!
     let idToken = user.authentication.idToken // Safe to send to the server
     let fullName = user.profile.name
     let givenName = user.profile.givenName
     let familyName = user.profile.familyName
     let email = user.profile.email
     // ...
     print("google email;", email);
     }
     }
     func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
     withError error: Error!) {
     // Perform any operations when the user disconnects from app here.
     // ...
     }
     */
    //    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    //        if let authentication = user.authentication {
    //            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
    //
    //            Auth.auth()?.signIn(with: credential, completion: { (user, error) -> Void in
    //                if error != nil {
    //                    print("Problem at signing in with google with error : \(error)")
    //                } else if error == nil {
    //                    print("user successfully signed in through GOOGLE! uid:\(FIRAuth.auth()!.currentUser!.uid)")
    //                    print("signed in")
    //                    performSegue(withIdentifier: "goToFeed", sender: self)
    //                }
    //            })
    //        }
    //    }
    
    public func googleSignIn(email: String){
        emailId = email
        self.fbLoginSuccess = true
        callingHttppApi()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults.set("1", forKey: "storeId")
        //        GIDSignIn.sharedInstance().uiDelegate = self
        var appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.customerLogin = self
        /* pastelView = PastelView(frame: view.bounds)
         
         // Custom Direction
         pastelView.startPastelPoint = .bottomLeft
         pastelView.endPastelPoint = .topRight
         
         // Custom Duration
         pastelView.animationDuration = 3.0
         
         // Custom Color
         pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
         UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
         UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
         UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
         UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
         UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
         UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
         
         pastelView.startAnimation()
         view.insertSubview(pastelView, at: 0)*/
        
        //emailIdField.floatLabelActiveColor = UIColor.black
        emailIdField.textColor = UIColor.white
        emailIdField.floatLabelActiveColor = UIColor.white
        
        //passwordtextField.floatLabelActiveColor = UIColor.black
        passwordtextField.textColor = UIColor.white
        passwordtextField.floatLabelActiveColor = UIColor.white
        
        //passwordtextField.floatLabelActiveColor = UIColor.black

        
        
        loginButton.setTitleColor(UIColor().HexToColor(hexString: "5897FF"), for: .normal)
        loginButton.backgroundColor = UIColor(red: 1, green: 1, blue:1, alpha: 1)
        
        loginButton.layer.cornerRadius = 25
        loginButton.layer.masksToBounds = true
        
        
        
        //loginButton.setTitle(GlobalData.sharedInstance.language(key: "login"), for: .normal)
        
//        googlesignButton.setTitleColor(UIColor.white, for: .normal)
//        googlesignButton.backgroundColor = UIColor.red
//
//        googlesignButton.layer.cornerRadius = 25
//        googlesignButton.layer.masksToBounds = true
//
//        googlesignButton.setTitle("SIGN IN WITH GOOGLE", for: .normal)
//        facebooksignButton.setTitleColor(UIColor.white, for: .normal)
//        facebooksignButton.backgroundColor = UIColor().HexToColor(hexString: "4265A0")
//
//        facebooksignButton.layer.cornerRadius = 25
//        facebooksignButton.layer.masksToBounds = true
//
//        facebooksignButton.setTitle("SIGN IN WITH FACEBOOK", for: .normal)
        
        
        
        baselineView.layer.cornerRadius = 2.5
        
        
        
        
        forgotPasswordButton.setTitleColor(UIColor.white, for: .normal)
        forgotPasswordButton.setTitle(GlobalData.sharedInstance.language(key: "forgotpassword"), for: .normal)
        
        
        emailIdField.placeholder = GlobalData.sharedInstance.language(key: "email")
        
        
        
        passwordtextField.placeholder = GlobalData.sharedInstance.language(key: "password")
        
        
        
        
        if defaults.object(forKey: "touchIdFlag") == nil{
            defaults.set("0", forKey: "touchIdFlag");
            defaults.synchronize()
        }
        
        context = LAContext()
        
        
        
    }
    var fbLoginSuccess = false
    
    override func viewDidAppear(_ animated: Bool) {
        
        
//        if(self.moveToSignal != "cart"){
//            /*
//             if defaults.object(forKey: "touchIdFlag") as! String == "1"{
//             let  AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "alert"), message: GlobalData.sharedInstance.language(key: "loginbytouchid"), preferredStyle: .alert)
//             let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
//             self.configureTouchIdBeforeLogin()
//
//             })
//             let cancelBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style:.destructive, handler: {(_ action: UIAlertAction) -> Void in
//
//             })
//             AC.addAction(okBtn)
//             AC.addAction(cancelBtn)
//             self.present(AC, animated: true, completion: {  })
//             }
//             */
//            self.configureTouchIdBeforeLogin()
//        }
    }
    
    @IBAction func signupClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createaccount", sender: self)
    }
    @IBAction func facebook_login(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ReadPermission.publicProfile, ReadPermission.email,ReadPermission.userFriends], viewController : self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in")
                
                self.getUserProfile()
                
                
            }
        }
    }
    
    func getUserProfile () {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!, apiVersion: "2.8")) { httpResponse, result in
            print("result == ", result)
            switch result {
            case .success(let response):
                print("Graph Request Succeeded: \(response)")
                print("Custom Graph Request Succeeded: \(response)")
                print("My facebook id is \(response.dictionaryValue?["id"])")
                print("My name is \(response.dictionaryValue?["name"])")
                self.emailId = response.dictionaryValue!["email"] as! String
                print("FORMMAIL \(self.emailId)")
                self.fbLoginSuccess = true
                self.callingHttppApi()
            case .failed(let error):
                print("Graph Request Failed: \(error)")
            }
        }
        
        connection.start()
    }
    @IBAction func google_login(_ sender: UIButton) {
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func clickOnBack(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func callingHttppApi()  {
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        if defaults.object(forKey: "storeId") != nil{
            requstParams["storeId"] = defaults.object(forKey: "storeId") as! String
        }
        let quoteId = defaults.object(forKey:"quoteId");
        let deviceToken = defaults.object(forKey:"deviceToken");
        if(quoteId != nil){
            requstParams["quoteId"] = quoteId
        }
        if deviceToken != nil{
            requstParams["token"] = deviceToken
        }
        
        if(whichApiToProcess == "forgotpassword"){
            requstParams["email"] = self.userEmail
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/forgotpassword", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let dict  = JSON(responseObject as! NSDictionary)
                    print(dict)
                    if dict["success"].boolValue == true{
                        GlobalData.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                    }else{
                        GlobalData.sharedInstance.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                    
                }else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }
        else{
            requstParams["username"] = emailId
            requstParams["password"] = password
            requstParams["websiteId"] = DEFAULT_WEBSITE_ID
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            requstParams["facebooklogged"] = fbLoginSuccess
            GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"wemteqchef/customer/logIn", currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    self.view.isUserInteractionEnabled = true
                    self.doFurtherProcessingWithResult(data:responseObject!)
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data:AnyObject){
        GlobalData.sharedInstance.dismissLoader()
        print(data)
        let responseData = JSON(data as! NSDictionary)
        if responseData["success"].boolValue == true{
            defaults.set(responseData["customerEmail"].stringValue, forKey: "customerEmail")
            defaults.set(responseData["customerToken"].stringValue, forKey: "customerId")
            defaults.set(responseData["customerName"].stringValue, forKey: "customerName")
            defaults.set(responseData["address"]["company"].stringValue, forKey: "companyName")
            print("COMPANY NAME~~~~", responseData["address"]["company"])
            print("DEFAULT COMPANY NAME~~~~", defaults.object(forKey: "companyName") as! String)
            let address = responseData["address"]["street"].stringValue + "," + responseData["address"]["city"].stringValue;
            defaults.set(address, forKey: "address")
            
            if(defaults.object(forKey: "quoteId") != nil){
                defaults.set(nil, forKey: "quoteId")
                defaults.synchronize();
            }
            UserDefaults.standard.removeObject(forKey: "quoteId")
            let profileImage = responseData["profileImage"].stringValue
            let bannerImage  = responseData["bannerImage"].stringValue
            
            if profileImage != ""{
                defaults.set(profileImage, forKey: "profilePicture")
            }
            if bannerImage != ""{
                defaults.set(bannerImage, forKey: "profileBanner")
            }
            
            if responseData["cartCount"].intValue > 0{
                let cartCount  = responseData["cartCount"].stringValue
                if cartCount != ""{
                    /*self.tabBarController!.tabBar.items?[3].badgeValue = cartCount*/
                    badge = cartCount
                }
            }
            
            if responseData["isAdmin"].intValue == 0{
                defaults.set("f", forKey: "isAdmin")
            }else{
                defaults.set("t", forKey: "isAdmin")
            }
            if responseData["isOwner"].intValue == 0{
                defaults.set("f", forKey: "isOwner")
                isOwner = false
            }else{
                defaults.set("t", forKey: "isOwner")
                isOwner = true
            }
            
            if responseData["isSeller"].intValue == 0{
                
                    defaults.set("f", forKey: "isSeller")
            }else{
                GlobalData.sharedInstance.showErrorSnackBar(msg: "Your ID is Seller. Only Customers or Owners are allowed to sign in.")
                return
                defaults.set("t", forKey: "isSeller")
            }
            
            if responseData["isPending"].intValue == 0{
                defaults.set("f", forKey: "isPending")
                
            }else{
                defaults.set("t", forKey: "isPending")
            }
            
            defaults.synchronize()
            self.goToDashBoardWithoutTouchId();
            /*
            if defaults.object(forKey: "touchIdFlag") != nil && self.NotAgainCallTouchId == false{
                if defaults.object(forKey: "touchIdFlag") as! String == "0"{
                    let  AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "alert"), message: GlobalData.sharedInstance.language(key: "wouldyouliketoconnectappwithtouchid"), preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                        self.configureTouchIdafterLogin();
                    })
                    let cancelBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                        defaults.set("0", forKey: "touchIdFlag");
                        defaults.synchronize()
                        self.tabBarController?.tabBar.isHidden = false
                        self.navigationController?.popViewController(animated: true)
                    })
                    AC.addAction(okBtn)
                    AC.addAction(cancelBtn)
                    //self.present(AC, animated: true, completion: {  })
                    self.present(AC, animated: true, completion: {  })
                    
                }else if defaults.object(forKey: "touchIdFlag") as! String == "1" {
                    let  AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "alert"), message: GlobalData.sharedInstance.language(key: "wouldyouliketoresetthepreviouscredentailsandsavethiscredentialfortouchid"), preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                        self.configureTouchIdafterLogin();
                    })
                    let cancelBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                        defaults.set("1", forKey: "touchIdFlag");
                        defaults.synchronize()
                        self.tabBarController?.tabBar.isHidden = false
                        self.navigationController?.popViewController(animated: true)
                    })
                    AC.addAction(okBtn)
                    AC.addAction(cancelBtn)
                    //self.parent!.present(AC, animated: true, completion: {  })
                    self.present(AC, animated: true, completion: {  })
                }
                else{
                    self.tabBarController?.tabBar.isHidden = false
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.popViewController(animated: true)
            }*/
        }else{
            GlobalData.sharedInstance.showErrorSnackBar(msg: responseData["message"].stringValue)
        }
 
        
    }
    
    
    
    @IBAction func forgaotPasswordClick(_ sender: Any) {
        /*let AC = UIAlertController(title:GlobalData.sharedInstance.language(key:"enteremail"), message: "", preferredStyle: .alert)
         AC.addTextField { (textField) in
         textField.placeholder = GlobalData.sharedInstance.language(key:"enteremail");
         }
         let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key:"ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
         let textField = AC.textFields![0]
         if((textField.text?.characters.count)! < 1){
         GlobalData.sharedInstance.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key:"pleasefillemailid") )
         }else if  !GlobalData.sharedInstance.checkValidEmail(data: textField.text!){
         GlobalData.sharedInstance.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key: "pleaseentervalidemail"));
         
         }
         
         else{
         self.userEmail = textField.text!;
         self.whichApiToProcess = "forgotpassword"
         self.callingHttppApi();
         }
         })
         let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key:"cancel"), style:.destructive, handler: {(_ action: UIAlertAction) -> Void in
         })
         AC.addAction(okBtn)
         AC.addAction(noBtn)
         self.present(AC, animated: true, completion: {  })*/
        self.performSegue(withIdentifier: "forgotpassword", sender: self)
    }
    @IBAction func LoginOwnerClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toowner", sender: self)
    }
    @IBAction func LoginClick(_ sender: UIButton) {
        view.endEditing(true)
        fbLoginSuccess = false
        emailId = emailIdField.text!
        password = passwordtextField.text!
        
        
        var isValid = 0;
        var errorMessage = ""
        
        if !GlobalData.sharedInstance.checkValidEmail(data: emailId){
            isValid = 1;
            errorMessage = GlobalData.sharedInstance.language(key: "pleaseentervalidemail");
            
        }else if password == ""{
            isValid = 1;
            errorMessage = GlobalData.sharedInstance.language(key: "enterpassword");
        }
        
        if isValid == 1{
            GlobalData.sharedInstance.showErrorSnackBar(msg: errorMessage)
            
        }else{
            whichApiToProcess = ""
            callingHttppApi()
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////   After Login we are setting /////////////////////////////////////////////////////////////////////////////////
    
    func configureTouchIdafterLogin(){
        
        var policy: LAPolicy?
        if #available(iOS 9.0, *) {
            // iOS 9+ users with Biometric and Passcode verification
            policy = .deviceOwnerAuthentication
        } else {
            // iOS 8+ users with Biometric and Custom (Fallback button) verification
            context.localizedFallbackTitle = ""
            policy = .deviceOwnerAuthenticationWithBiometrics
        }
        var err: NSError?
        guard context.canEvaluatePolicy(policy!, error: &err) else {
            print("sfsf")
            
            //Touch Id not set in device
            
            let  AC = UIAlertController(title: "Error", message: GlobalData.sharedInstance.language(key: "touchidisnotenabledinyourdevice"), preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style:.default, handler: {(_ action: UIAlertAction) -> Void in
                self.goToDashBoardWithoutTouchId()
                
            })
            AC.addAction(okBtn)
            self.present(AC, animated: true, completion: {  })
            return
        }
        
        loginProcessAfterLogin(policy: policy!)
        
    }
    
    private func loginProcessAfterLogin(policy: LAPolicy) {
        // Start evaluation process with a callback that is executed when the user ends the process successfully or not
        /*context.evaluatePolicy(policy, localizedReason: kMsgShowReason, reply: { (success, error) in
         DispatchQueue.main.async {
         
         guard success else {
         guard let error = error else {
         self.showUnexpectedErrorMessageAfterLogin()
         return
         }
         
         switch(error) {
         case LAError.authenticationFailed:
         self.errorMessage = GlobalData.sharedInstance.language(key: "therewasaproblemverifyingyouridentity")
         case LAError.userCancel:
         self.errorMessage = GlobalData.sharedInstance.language(key: "authenticationwascanceledbyuser")
         
         default:
         self.errorMessage = GlobalData.sharedInstance.language(key: "touchidmaynotbeconfigured")
         break
         }
         let  AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "error"), message: self.errorMessage, preferredStyle: .alert)
         let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
         self.goToDashBoardWithoutTouchId();
         
         })
         AC.addAction(okBtn)
         //self.parent!.present(AC, animated: true, completion: {  })
         self.present(AC, animated: true, completion: {  })
         return
         }
         
         // Good news! Everything went fine 👏
         self.goToDashBoardWithTouchId()
         }
         })*/
        self.goToDashBoardWithTouchId()
    }
    
    
    func goToDashBoardWithoutTouchId(){
        defaults.set("0", forKey: "touchIdFlag");
        defaults.synchronize()
        //self.tabBarController?.tabBar.isHidden = false
        if self.isOwner == true{
            self.performSegue(withIdentifier: "toowner", sender: self)
        }
            else{
            self.performSegue(withIdentifier: "tohome", sender: self)
        }
        
    }
    
    func goToDashBoardWithTouchId(){
        defaults.set("1", forKey: "touchIdFlag");
        defaults.set(emailId, forKey: "TouchEmailId")
        defaults.set(password, forKey: "TouchPasswordValue")
        defaults.synchronize()
        //self.tabBarController?.tabBar.isHidden = false
        if self.isOwner == true{
            self.performSegue(withIdentifier: "toowner", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "tohome", sender: self)
        }
    }
    
    
    func showUnexpectedErrorMessageAfterLogin(){
        let  AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "error"), message: GlobalData.sharedInstance.language(key: "erroroccured"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.popViewController(animated: true)
            
        })
        AC.addAction(okBtn)
        self.present(AC, animated: true, completion: {  })
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////   before Login we are setting /////////////////////////////////////////////////////////////////////////////////
    
    func configureTouchIdBeforeLogin(){
        var policy: LAPolicy?
        policy = .deviceOwnerAuthenticationWithBiometrics
        context.localizedFallbackTitle = ""
        
        var err: NSError?
        guard context.canEvaluatePolicy(policy!, error: &err) else {
            return
        }
        loginProcessBeforeLogin(policy: policy!)
    }
    
    private func loginProcessBeforeLogin(policy: LAPolicy) {
        // Start evaluation process with a callback that is executed when the user ends the process successfully or not
        context.evaluatePolicy(policy, localizedReason: kMsgShowReason, reply: { (success, error) in
            DispatchQueue.main.async {
                
                guard success else {
                    guard let error = error else {
                        self.showUnexpectedErrorMessageBeforeLogin()
                        return
                    }
                    switch(error) {
                    case LAError.authenticationFailed:
                        self.errorMessage = GlobalData.sharedInstance.language(key: "therewasaproblemverifyingyouridentity")
                    case LAError.userCancel:
                        self.errorMessage = GlobalData.sharedInstance.language(key: "authenticationwascanceledbyuser")
                        
                    default:
                        self.errorMessage = GlobalData.sharedInstance.language(key: "touchidmaynotbeconfigured")
                        break
                    }
                    let  AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "error"), message: self.errorMessage, preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                        
                    })
                    AC.addAction(okBtn)
                    self.present(AC, animated: true, completion: {  })
                    return
                }
                
                // Good news! Everything went fine 👏
                self.callApiWithSavedCredential()
            }
        })
    }
    
    
    
    func showUnexpectedErrorMessageBeforeLogin(){
        let  AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "error"), message: GlobalData.sharedInstance.language(key: "erroroccured"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
            
        })
        AC.addAction(okBtn)
        self.present(AC, animated: true, completion: {  })
    }
    
    func callApiWithSavedCredential(){
        emailId = defaults.object(forKey: "TouchEmailId") as! String
        password = defaults.object(forKey: "TouchPasswordValue") as! String
        NotAgainCallTouchId = true;
        whichApiToProcess = "";
        callingHttppApi();
    }
}
