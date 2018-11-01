//
//  GlobaData.swift
//  MVVMSwift
//
//  Created by Webkul on 17/06/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftMessages
import UserNotifications




let defaults = UserDefaults.standard;
typealias ServiceResponse = (NSDictionary?, NSError?) -> Void
var queue = OperationQueue()
var profileImageCache = NSCache<AnyObject, AnyObject>()
let progress = GradientCircularProgress()




struct GlobalVariables {
    static var proceedToCheckOut:Bool = false
    static var hometableView:UITableView!
    static var ExecuteShippingAddress:Bool = false
    static var  CurrentIndex:Int = 1;
    static var shippingAndBillingViewModel:BillingAndShipingViewModel!
    static var  selectedCategoryIds:NSMutableArray = [];
    static var  selectedRelatedProductIds:NSMutableArray = [];
    static var  selectedUPSellProductIds:NSMutableArray = [];
    static var  selectedCrossSellProductIds:NSMutableArray = [];
}



class GlobalData: NSObject{
    
    public var languageBundle:Bundle!
    
    class var sharedInstance:GlobalData {
        struct Singleton {
            static let instance = GlobalData()
        }
        return Singleton.instance
        
    }
    
    
    
    
    
    func callingHttpRequest(params:Dictionary<String,Any>, apiname:String,currentView:UIViewController,taskCallback: @escaping (Int,
        AnyObject?) -> Void)  {
        let defaults = UserDefaults.standard;
        let urlString  = HOST_NAME + apiname
        
        print("url",urlString)
        print("params", params)
        
        //        var headers: HTTPHeaders = [:]
        //        if defaults.object(forKey: "authKey") == nil{
        //            headers = [
        //                "authKey":""
        //            ]
        //        }else{
        //            headers = [
        //                "authKey":defaults.object(forKey: "authKey") as! String
        //            ]
        //        }
        
        
        var headers: HTTPHeaders = [:]
        if defaults.object(forKey: "authKey") == nil{
            headers = [
                "apiKey": API_USER_NAME,
                "apiPassword": API_KEY,
                "authKey":""
            ]
        }else{
            headers = [
                "apiKey": API_USER_NAME,
                "apiPassword": API_KEY,
                "authKey":defaults.object(forKey: "authKey") as! String
            ]
        }
        
        
        
        Alamofire.request(urlString,method: HTTPMethod.post,parameters:params,headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let resultData):
                if JSON(resultData)["otherError"].stringValue == "customerNotExist"   {
                    taskCallback(0,resultData as AnyObject)
                }else{
                    taskCallback(1,resultData as AnyObject)
                }
                break
            case .failure(let error):
                let returnData = String(data: response.data! , encoding: .utf8)
                print("returnData" ,response.data!)
                
                if !Connectivity.isConnectedToInternet(){
                    GlobalData.sharedInstance.dismissLoader()
                    currentView.view.isUserInteractionEnabled = true
                    let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "warning"), message: error.localizedDescription, preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "retry"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        taskCallback(2, "" as AnyObject)
                    })
                    let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                    })
                    AC.addAction(okBtn)
                    AC.addAction(noBtn)
                    currentView.present(AC, animated: true, completion: { })
                }
                else{
                    let statusCode =  response.response?.statusCode
                    let errorCode:Int = error._code;
                    
                    let datastring = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                    
                    print("sss", datastring)
                    if  statusCode == 401{
                        
                        
                        if let tokenValue = response.response?.allHeaderFields["token"] as? String {
                            
                            let usernamePasswordMd5:String = (API_USER_NAME+":"+API_KEY).md5;
                            let authkey =  (usernamePasswordMd5+":"+tokenValue).md5;
                            defaults.set(authkey, forKey: "authKey")
                            defaults.synchronize()
                            taskCallback(2, "" as AnyObject)
                            
                        }
                        
                    }
                        
                    else if errorCode != -999 && errorCode != -1005{
                        GlobalData.sharedInstance.dismissLoader()
                        currentView.view.isUserInteractionEnabled = true
                        
                        print("sss")
                        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "warning"), message: error.localizedDescription, preferredStyle: .alert)
                        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "retry"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            taskCallback(2, "" as AnyObject)
                        })
                        let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                        })
                        AC.addAction(okBtn)
                        AC.addAction(noBtn)
                        
                        
                        currentView.present(AC, animated: true, completion: {  })
                    }else if errorCode == -1005{
                        GlobalData.sharedInstance.dismissLoader()
                        taskCallback(2, "" as AnyObject)
                    }
                    /////////////////////////////////////////////
                    
                    
                    
                }
                
                break;
                
            }
            
            
        }
        
    }
    
    func language(key:String) ->String{
        let languageCode = UserDefaults.standard
        if languageCode.object(forKey: "language") != nil {
            let language = languageCode.object(forKey: "language")
            if let path = Bundle.main.path(forResource: language as! String?, ofType: "lproj") {
                languageBundle = Bundle(path: path)
            }
            else{
                languageBundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
            }
        }
        else {
            languageCode.set("en", forKey: "language")
            languageCode.synchronize()
            let language = languageCode.string(forKey: "language")!
            var path = Bundle.main.path(forResource: language, ofType: "lproj")!
            if path .isEmpty {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")!
            }
            languageBundle = Bundle(path: path)
        }
        
        return languageBundle.localizedString(forKey: key, value: "", table: nil)
    }
    
    
    func getImageFromUrl(imageUrl:String,imageView:UIImageView){
        let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let image  = profileImageCache.object(forKey: urlString as AnyObject)
        if image != nil{
            imageView.image = image as? UIImage
        }
        else{
            if  URL(string:urlString!) != nil{
                DispatchQueue.global(qos: .background).async {
                    let operation = BlockOperation(block: {
                        let url =  URL(string:urlString!)
                        let data = try? Data(contentsOf: url!)
                        if data != nil{
                            let img = UIImage(data: data!)
                            OperationQueue.main.addOperation({
                                imageView.image = img;
                                profileImageCache.setObject(img!, forKey: imageUrl as AnyObject)
                            })
                        }
                    })
                    queue.addOperation(operation)
                }
            }else{
                imageView.image = UIImage(named: "ic_placeholder.png")
            }
        }
    }
    
    func removePreviousNetworkCall(){
        print("dismisstheconnection")
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
    
    
    
    func showSuccessSnackBar(msg:String){
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.success)
        //info.applyGradientToTopView(colours: GRADIENTCOLOR, locations:nil)
        
        info.button?.isHidden = true
        info.configureContent(title: GlobalData.sharedInstance.language(key: "success"), body: msg)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .top
        infoConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        infoConfig.duration = .seconds(seconds: 3)
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func showWarningSnackBar(msg:String){
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.warning)
        info.button?.isHidden = true
        info.configureContent(title: GlobalData.sharedInstance.language(key: "warning"), body: msg)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .top
        infoConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        infoConfig.duration = .seconds(seconds: 3)
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    
    func showErrorSnackBar(msg:String){
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.error)
        info.button?.isHidden = true
        info.configureContent(title: GlobalData.sharedInstance.language(key: "error"), body: msg)
        //        info.configureContent(title: GlobalData.sharedInstance.language(key: "error"), body: msg, iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "No Thanks") { _ in
        //            SwiftMessages.hide()
        //        }
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        infoConfig.presentationStyle = .top
        infoConfig.dimMode = .gray(interactive: true)
        infoConfig.duration = .forever
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    
    func showInfoSnackBar(msg:String){
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.info)
        info.configureContent(title: GlobalData.sharedInstance.language(key: "info"), body: msg)
        info.button?.isHidden = true
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        infoConfig.presentationStyle = .top
        infoConfig.dimMode = .gray(interactive: true)
        infoConfig.duration = .forever
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    
    
    
    //    func showErrorMessage(view:UIViewController,message:String){
    //        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "error"), message: message, preferredStyle: .alert)
    //        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
    //        })
    //
    //        AC.addAction(okBtn)
    //        view.present(AC, animated: true, completion: { _ in })
    //    }
    
    func showSuccessMessageWithBack(view:UIViewController,message:String){
        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "success"), message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            view.navigationController?.popViewController(animated: true)
        })
        
        AC.addAction(okBtn)
        view.present(AC, animated: true, completion: {  })
    }
    
    
    func checkValidEmail(data:String) -> Bool{
        var emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}+\\.[A-Za-z]{2,4}"
        var emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        var isValid = false
        isValid = isValid || (emailTest.evaluate(with: data))
        emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return isValid || (emailTest.evaluate(with: data))
    }
    
    func showLoader(){
        progress.show(message: "Loading...", style: BlueIndicatorStyle())
        
    }
    func dismissLoader(){
        progress.dismiss()
        
    }
    
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }
    
    func isUpdateAvailable() throws -> Bool {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            print("version in app store", version,currentVersion);
            
            return version != currentVersion
        }
        throw VersionError.invalidResponse
    }
    
    func getAppStoreVersion() throws ->String{
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            print("version in app store", version,currentVersion,result);
            
            return version
        }
        throw VersionError.invalidResponse
    }
    
    func getAppStoreVersionMessge()throws ->String{
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["releaseNotes"] as? String {
            print("version in app store", version,currentVersion);
            
            return version
        }
        throw VersionError.invalidResponse
        
        
    }
    
    //MARK:- Notification after 2 days app open
    func remainderNotificationCall(){
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            let requestIdentifier = "appuse" // for multiple notification
            content.badge = 1
            content.title = "pleasevisitourstore".localized
            content.subtitle =  "somenewproduct".localized
            content.body = "checkitwonce".localized
            content.categoryIdentifier = "appuse"
            content.sound = UNNotificationSound.default()
            
            // If you want to attach any image to show in local notification
            let url = Bundle.main.url(forResource: "appicon", withExtension: ".png")
            do {
                let attachment = try? UNNotificationAttachment(identifier: requestIdentifier, url: url!, options: nil)
                content.attachments = [attachment!]
            }
            
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval:172800, repeats: false)
            
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                
                if error != nil {
                    print(error?.localizedDescription)
                }
                
            }
        }
    }
    
    func getMimeType(type:String)-> String{
        switch type {
        case "txt":
            return "text/plain";
        case "htm":
            return "text/html";
        case "html":
            return "text/html";
        case "php":
            return "text/html";
        case "css":
            return "text/css";
        case "js":
            return "application/javascript";
        case "json":
            return "application/json";
        case "xml":
            return "application/xml";
        case "swf":
            return "application/x-shockwave-flash";
        case "flv":
            return "video/x-flv";
        case "png":
            return "image/png";
        case "jpe":
            return "image/jpeg";
        case "jpeg":
            return "image/jpeg";
        case "gif":
            return "image/gif";
        case "bmp":
            return "image/bmp";
        case "ico":
            return "image/vnd.microsoft.icon";
        case "tiff":
            return "image/tiff";
        case "tif":
            return "image/tiff";
        case "svg":
            return "image/svg+xml";
        case "svgz":
            return "image/svg+xml";
        case "zip":
            return "application/zip";
        case "rar":
            return "application/x-rar-compressed";
        case "exe":
            return "application/x-msdownload";
        case "msi":
            return "application/x-msdownload";
        case "mp3":
            return "audio/mpeg";
        case "qt":
            return "video/quicktime";
        case "mov":
            return "video/quicktime";
        case "pdf":
            return "application/pdf";
        case "psd":
            return "image/vnd.adobe.photoshop";
        case "ai":
            return "application/postscript";
        case "eps":
            return "application/postscript";
        case "ps":
            return "application/postscript";
        case "doc":
            return "application/msword";
        case "rtf":
            return "application/rtf";
        case "xls":
            return "application/vnd.ms-excel";
        case "ppt":
            return "application/vnd.ms-powerpoint";
        case "odt":
            return "application/vnd.oasis.opendocument.text";
        case "ods":
            return "application/vnd.oasis.opendocument.spreadsheet";
            
        default:
            return ""
        }
    }
}


enum CatalogProductAPI : String {
    case addToCart
    case addToWishlist
    case addToCompare
    case catalogProduct
    case removeFromWishList
    case addreview
}
