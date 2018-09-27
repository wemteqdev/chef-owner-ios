//
//  StoreViewController.swift
//  Magento2V4Theme
//
//  Created by kunal on 10/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
var storeData = [StoreData]()

@IBOutlet weak var storeTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.isNavigationBarHidden = false
        storeTableView.dataSource = self
        storeTableView.delegate = self
        storeTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
    }
    
    
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return storeData[section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return storeData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return storeData[section].stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        cell.textLabel?.text = storeData[indexPath.section].stores[indexPath.row].name
        if defaults .object(forKey: "storeId") != nil{
            if defaults .object(forKey: "storeId") as! String == storeData[indexPath.section].stores[indexPath.row].id{
            cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storeId = storeData[indexPath.section].stores[indexPath.row].id
        let storeCode = storeData[indexPath.section].stores[indexPath.row].code
        defaults.set(storeId, forKey: "storeId");
        defaults.set(storeCode, forKey: "language");
        defaults.synchronize()
        
        if storeCode == "ar" {
            L102Language.setAppleLAnguageTo(lang: "ar")
            if #available(iOS 9.0, *) {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            } else {
                // Fallback on earlier versions
            }
            
        } else {
            
            L102Language.setAppleLAnguageTo(lang: "en")
            if #available(iOS 9.0, *) {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                // Fallback on earlier versions
            }
            
        }
        
        
        
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        
        rootviewcontroller.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "rootnav")
        
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
            
        }) { (finished) -> Void in
            
        }
    
    }
    
    
    
}






let APPLE_LANGUAGE_KEY = "AppleLanguages"

/// L102Language

class L102Language {
    
    /// get current Apple language
    
    class func currentAppleLanguage() -> String{
        
        let userdef = UserDefaults.standard
        
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        
        let current = langArray.firstObject as! String
        
        return current
        
    }
    
    /// set @lang to be the first in Applelanguages list
    
    class func setAppleLAnguageTo(lang: String) {
        
        let userdef = UserDefaults.standard
        
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        
        userdef.synchronize()
        
    }
}

