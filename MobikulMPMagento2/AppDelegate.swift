//
//  AppDelegate.swift
//  Magento2V4Theme
//
//  Created by Webkul on 07/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit
var deviceTokenData = ""

import FirebaseAnalytics
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import Firebase
import Siren
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    override init() {
        super.init()
        UIFont.overrideInitialize()
    }
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        let appvar = UIApplication.shared.delegate as! AppDelegate
//        return  appvar.sharedInstance().application(app, open: url, options: options)
//        //return UIApplicationDelegate.sharedInstance().application(app, open: url, options: options)
//    }
//
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 11.0, *) {
            UIImageView.appearance().accessibilityIgnoresInvertColors = true
        }
        UITabBar.appearance().tintColor =  UIColor().HexToColor(hexString: BUTTON_COLOR)
        
        //version update
        //self.setupSiren()
        
        IQKeyboardManager.sharedManager().enable = true
        
        let languageCode = UserDefaults.standard
        if languageCode.string(forKey: "language") == "ar" {
            if #available(iOS 9.0, *) {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            } else {
                // Fallback on earlier versions
            }
            
        } else {
            if #available(iOS 9.0, *) {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                // Fallback on earlier versions
            }
            
        }
        IQKeyboardManager.sharedManager().enable = true
        
        //Push
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: Notification.Name.MessagingRegistrationTokenRefreshed,
                                               object: nil)
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            
            FirebaseApp.configure()
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        }else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        if let remoteNotif = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.application(application, didReceiveRemoteNotification: remoteNotif)
            })
        }
        UINavigationBar.appearance().barStyle = .blackOpaque
        
        GMSServices.provideAPIKey("AIzaSyCyCc5s5KSnkWvyT18xEgvHh8qtpxOxPFw")
        return true
    }
    
    //MARK:- Version Update
    func setupSiren() {
        let siren = Siren.shared
        // Optional
        siren.delegate = self
        // Optional
        siren.debugEnabled = true
        
        // Optional - Defaults to .Option
        //        siren.alertType = .option // or .force, .skip, .none
        
        // Optional - Can set differentiated Alerts for Major, Minor, Patch, and Revision Updates (Must be called AFTER siren.alertType, if you are using siren.alertType)
        //        siren.majorUpdateAlertType = .option
        //        siren.minorUpdateAlertType = .option
        //        siren.patchUpdateAlertType = .option
        //        siren.revisionUpdateAlertType = .option
        
        siren.alertType = .option
    }
    
    //MARK:- Push Notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var tokenq = ""
        
        for i in 0..<deviceToken.count {
            tokenq = tokenq + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        deviceTokenData = tokenq;
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        if Messaging.messaging().fcmToken != nil {
            print("SSSSSSSS")
            
            Messaging.messaging().subscribe(toTopic: "/topics/mobikul_ios")
        }
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            deviceTokenData = refreshedToken
            let defaults = UserDefaults.standard;
            defaults.set(refreshedToken, forKey: "deviceToken");
            defaults.synchronize()
            callingHttppApi();
            Messaging.messaging().subscribe(toTopic: "/topics/mobikul_ios")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return;
        }
        
        Messaging.messaging().subscribe(toTopic: "/topics/mobikul_ios")
        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().disconnect()
        
        Messaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func callingHttppApi(){
        var requstParams = [String:Any]();
        let customerId = defaults.object(forKey:"customerId")
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }else{
            requstParams["customerToken"] = ""
        }
        requstParams["token"] = deviceTokenData
        requstParams["os"] = "ios"
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/extra/registerDevice", currentView: UIViewController()){success,responseObject in
            if success == 1{
                print(responseObject)
            }else if success == 2{
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        
        if UIApplication.shared.applicationState == .inactive {// tap
            if userInfo["notificationType"] as! String  == "category"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCategoryOnTap"), object: nil, userInfo: userInfo)
            }else if userInfo["notificationType"] as! String  == "product"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforProductOnTap"), object: nil, userInfo: userInfo)
            }else if userInfo["notificationType"] as! String  == "custom"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCustomCollectionOnTap"), object: nil, userInfo: userInfo)
            }else if userInfo["notificationType"] as! String  == "other"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforOtherOnTap"), object: nil, userInfo: userInfo)
            }else if userInfo["notificationType"] as! String  == "chatNotification"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforChat"), object: nil, userInfo: userInfo)
            }
        }else if UIApplication.shared.applicationState == .background{
            var count:Int = 0;
            if defaults.object(forKey: "notificationCount") != nil{
                let stored = (defaults.object(forKey: "notificationCount") as! String);
                count = Int(stored)! + 1;
                let data =  String(format: "%d", count as CVarArg)
                defaults.set(data, forKey: "notificationCount");
            }else{
                defaults.set("1", forKey: "notificationCount");
                count = 1
            }
            if count > 0{
                application.applicationIconBadgeNumber = count;
            }
        }
    }
    //MARK:-
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        GlobalData.sharedInstance.remainderNotificationCall()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //version update
        //Siren.shared.checkVersion(checkType: .immediately)
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        defaults.set("0", forKey: "notificationCount")
        application.applicationIconBadgeNumber = 0;
        
        //AppEventsLogger.activate(application)
        //version update
        //Siren.shared.checkVersion(checkType: .immediately)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

//MARK:- Push in Foreground
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            // topController should now be your topmost view controller
            if let tabVC = topController as? UITabBarController   {
                tabVC.selectedIndex = 0
                let navigation:UINavigationController = (topController as! UITabBarController).viewControllers?[0] as! UINavigationController
                navigation.popToRootViewController(animated: true)
            }
        }
        
        let type =  response.notification.request.identifier
        
        if type != "appuse"{
            if userInfo["notificationType"] as! String  == "category"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCategoryOnTap"), object: nil, userInfo: userInfo)
            }
            else if userInfo["notificationType"] as! String  == "product"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforProductOnTap"), object: nil, userInfo: userInfo)
            }
            else if userInfo["notificationType"] as! String  == "custom"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCustomCollectionOnTap"), object: nil, userInfo: userInfo)
            }
            else if userInfo["notificationType"] as! String  == "other"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforOtherOnTap"), object: nil, userInfo: userInfo)
            }else if userInfo["notificationType"] as! String  == "chatNotification"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforChat"), object: nil, userInfo: userInfo)
            }
        }
        
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        Messaging.messaging().subscribe(toTopic: "/topics/mobikul_ios")
        Messaging.messaging().shouldEstablishDirectChannel = true
        connectToFcm()
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

//MARK:- Font Style
struct AppFontName {
    static let regular = REGULARFONT
    static let bold = BOLDFONT
    static let italic = ITALICFONT
}

extension UIFont {
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }
    
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }
    
    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.italic, size: size)!
    }
    
    @objc convenience init(myCoder aDecoder: NSCoder) {
        if let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor {
            if let fontAttribute = fontDescriptor.fontAttributes[UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")] as? String {
                var fontName = ""
                switch fontAttribute {
                case "CTFontRegularUsage":
                    fontName = AppFontName.regular
                case "CTFontEmphasizedUsage", "CTFontBoldUsage":
                    fontName = AppFontName.bold
                case "CTFontObliqueUsage":
                    fontName = AppFontName.italic
                case "CTFontHeavyUsage":
                    fontName = AppFontName.bold
                    
                default:
                    fontName = AppFontName.regular
                }
                self.init(name: fontName, size: fontDescriptor.pointSize)!
            }
            else {
                self.init(myCoder: aDecoder)
            }
        }
        else {
            self.init(myCoder: aDecoder)
        }
    }
    
    class func overrideInitialize() {
        if self == UIFont.self {
            let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:)))
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:)))
            method_exchangeImplementations(systemFontMethod!, mySystemFontMethod!)
            
            let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:)))
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:)))
            method_exchangeImplementations(boldSystemFontMethod!, myBoldSystemFontMethod!)
            
            let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:)))
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:)))
            method_exchangeImplementations(italicSystemFontMethod!, myItalicSystemFontMethod!)
            
            let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))) // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:)))
            method_exchangeImplementations(initCoderMethod!, myInitCoderMethod!)
        }
    }
}

//MARK:- Siren (App Version)
extension AppDelegate: SirenDelegate
{
    func sirenDidShowUpdateDialog(alertType: Siren.AlertType) {
        print(#function, alertType)
    }
    
    func sirenUserDidCancel() {
        print(#function)
    }
    
    func sirenUserDidSkipVersion() {
        print(#function)
    }
    
    func sirenUserDidLaunchAppStore() {
        print(#function)
    }
    
    func sirenDidFailVersionCheck(error: Error) {
        print(#function, error)
    }
    
    func sirenLatestVersionInstalled() {
        print(#function, "Latest version of app is installed")
    }
    
    func sirenNetworkCallDidReturnWithNewVersionInformation(lookupModel: SirenLookupModel) {
        print(#function, "\(lookupModel)")
    }
    
    // This delegate method is only hit when alertType is initialized to .none
    func sirenDidDetectNewVersionWithoutAlert(title: String, message: String, updateType: UpdateType) {
        print(#function, "\n\(title)\n\(message).\nRelease type: \(updateType.rawValue.capitalized)")
    }
}
