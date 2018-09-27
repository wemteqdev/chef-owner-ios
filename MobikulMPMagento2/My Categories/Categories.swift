//
//  Categories.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 24/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class Categories: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoriesTableView: UITableView!
    var tempCategoryData : NSMutableArray = [];
    var tempCategoryId : NSMutableArray = [];
    var categoryMenuData:NSMutableArray = []
    var headingTitleData:NSMutableArray = []
    var categoryDict :NSDictionary = [:]
    var categoryName:String!
    var categoryId:String!
    var homeViewModel : HomeViewModel!
    var categoryChildData:NSArray!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let paymentViewNavigationController = self.tabBarController?.viewControllers?[0]
        let nav = paymentViewNavigationController as! UINavigationController;
        let paymentMethodViewController = nav.viewControllers[0] as! ViewController
        homeViewModel = paymentMethodViewController.homeViewModel;
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "categories")
        
        let categoryDataItemsArray  = homeViewModel.cateoryData;
        categoryChildData =   categoryDataItemsArray!["children"] as? NSArray;
        if let itemsArray = categoryChildData{
            for (item) in itemsArray{
                let cData:NSDictionary = item as! NSDictionary;
                self.tempCategoryData.add(cData["name"] as? String! ?? "empty");
                self.tempCategoryId.add(cData["category_id"] as? String! ?? "empty")
            }
        }
        
        
        
        categoryMenuData = tempCategoryData;
        categoriesTableView.register(UINib(nibName: "CategoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        categoriesTableView.reloadData()
        self.categoriesTableView.separatorStyle = .none
        
        
        let refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: GlobalData.sharedInstance.language(key: "welcometo")+" "+GlobalData.sharedInstance.language(key: "applicationname"), attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            categoriesTableView.refreshControl = refreshControl
        } else {
            categoriesTableView.backgroundView = refreshControl
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        GlobalData.sharedInstance.dismissLoader()
        GlobalData.sharedInstance.removePreviousNetworkCall()
    }
    
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_WIDTH/2.5;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryMenuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CategoriesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoriesTableViewCell
        let contentForThisRow  = categoryMenuData[indexPath.row]
        cell.categoryName.text = contentForThisRow as? String
        cell.backgroundColor = UIColor .black;
        
        if indexPath.section == 0{
            
            for i in 0..<homeViewModel.categoryImage.count{
                if tempCategoryId[indexPath.row] as! String == homeViewModel.categoryImage[i].id{
                    GlobalData.sharedInstance.getImageFromUrl(imageUrl:homeViewModel.categoryImage[i].bannerImage , imageView: cell.backgroundImageView)
                    break;
                }
            }
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            categoryDict  = categoryChildData .object(at: indexPath.row) as! NSDictionary
            let childArray : NSArray = categoryDict .object(forKey:"children") as! NSArray
            print(childArray)
            
            if childArray.count > 0 {
                self.performSegue(withIdentifier: "subCategorySegue", sender: self)
            }
            else {
                categoryName = categoryDict.object(forKey: "name") as! String;
                categoryId = categoryDict.object(forKey: "category_id") as! String
                self.performSegue(withIdentifier: "categorySegue", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "subCategorySegue") {
            let viewController:subCategory = segue.destination as UIViewController as! subCategory
            viewController.categoryName = categoryDict .object(forKey: "name") as! String
            viewController.subCategoryData = categoryDict as NSDictionary
        }
        if(segue.identifier! == "categorySegue"){
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryName = self.categoryName
            viewController.categoryType = ""
            viewController.categoryId = self.categoryId
        }
    }
}
