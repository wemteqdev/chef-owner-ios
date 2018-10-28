//
//  SearchSuggestion.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 08/08/17.
//  Copyright © 2017 Webkul Parsad. All rights reserved.
//

import UIKit

class SearchSuggestion: UIViewController,UISearchDisplayDelegate,UISearchBarDelegate ,UITableViewDelegate, UITableViewDataSource, SuggestionDataHandlerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var searchActive:Bool = false
    var searchtext:String = ""
    let defaults = UserDefaults.standard
    var searchSuggestionViewModel:SearchSuggestionViewModel!
    var resultArray:Array = [AnyObject]()
    var categoryType = "searchquery"
   // var categoryName = GlobalData.sharedInstance.language(key:"searchresult")
    var categoryName = "Search Result"
    var categoryId = ""
    var searchQuery = ""
    var productImageUrl:String = ""
    var productId:String = ""
    var productName:String = ""
    var signalForViewController = Int()
    
    let IS_IPAD = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
    lazy var searchBars:UISearchBar = UISearchBar(frame: CGRect(x: CGFloat(15), y: CGFloat(5), width: CGFloat(200), height: CGFloat(20)))
    var emptyView:EmptyNewAddressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.setHidesBackButton(true, animated: false)
        tableView.keyboardDismissMode = .onDrag
        searchBars.delegate = self
        searchBars.tintColor = UIColor.black
        self.navigationItem.titleView = searchBars
        emptyView = EmptyNewAddressView(frame: self.view.frame)
        self.view.addSubview(emptyView)
        emptyView.isHidden = true
        emptyView.emptyImages.image = UIImage(named: "empty_search")!
        emptyView.addressButton.setTitle(GlobalData.sharedInstance.language(key: "tryagain"), for: .normal)
        emptyView.labelMessage.text = GlobalData.sharedInstance.language(key: "emptysearch")
        emptyView.addressButton.addTarget(self, action: #selector(browseCategory(sender:)), for: .touchUpInside)
        searchBars.placeholder = GlobalData.sharedInstance.language(key: "searchentirestore")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(SearchSuggestionCell.nib, forCellReuseIdentifier: SearchSuggestionCell.identifier)
        
        cancelButton.title = GlobalData.sharedInstance.language(key: "cancel")
    }
    
    @objc func browseCategory(sender: UIButton){
        self.searchBars.text = ""
        searchBars.isLoading = false
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        tabBarController?.selectedIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.titleView = searchBars
        searchBars.becomeFirstResponder()
    }
    
    func callingHttppApi(){
        var requstParams = [String:Any]()
        let storeId = defaults.object(forKey:"storeId")
        if storeId != nil{
            requstParams["storeId"] = storeId as! String
        }
        requstParams["searchQuery"] = searchtext
        if defaults.object(forKey: "currency") != nil{
            requstParams["currency"] = defaults.object(forKey: "currency") as! String
        }
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/extra/searchSuggestion", currentView: self){success,responseObject in
            if success == 1{
                print("sfsfs", responseObject!)
                self.searchSuggestionViewModel = SearchSuggestionViewModel(data:JSON(responseObject as! NSDictionary))
                self.doFurtherProcessingWithResult()
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    func doFurtherProcessingWithResult(){
        
        if searchSuggestionViewModel.getSuggestedHints.count == 0 && searchSuggestionViewModel.getSuggestedproduct.count == 0{
            self.tableView.isHidden = true
            self.emptyView.isHidden = false
            searchBars.isLoading = false
        }else{
            resultArray = [searchSuggestionViewModel.getSuggestedHints as AnyObject,searchSuggestionViewModel.getSuggestedproduct as AnyObject]
            searchBars.isLoading = false
            tableView.delegate = self
            tableView.dataSource = self
            self.emptyView.isHidden = true
            self.tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0{
            searchBars.isLoading = true
            searchtext = searchText
            GlobalData.sharedInstance.removePreviousNetworkCall()
            callingHttppApi()
        }else{
            searchBar.isLoading = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchQuery = searchBar.text!
        self.performSegue(withIdentifier: "productcategory", sender: self)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        navigationController?.popViewController(animated: true)
    }
    
    func suggestedData(data: String, signalToMove: Int) {
        signalForViewController = signalToMove
        searchBars.text = data
        searchtext = data
        searchBars.isLoading = true
        GlobalData.sharedInstance.removePreviousNetworkCall()
        self.view.endEditing(true)
        callingHttppApi()
    }
    
    @IBAction func cameraBtnAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        let alert = UIAlertController(title: GlobalData.sharedInstance.language(key: "chooseaction"), message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: GlobalData.sharedInstance.language(key: "textDetection"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let vc:TextDetectorController = self.storyboard?.instantiateViewController(withIdentifier: "TextDetectorController") as! TextDetectorController
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        })
        let action2 = UIAlertAction(title: GlobalData.sharedInstance.language(key: "imagedetection"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let vc:ImageDetectorController = self.storyboard?.instantiateViewController(withIdentifier: "ImageDetectorController") as! ImageDetectorController
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        alert.addAction(action1)
        alert.addAction(action2)
        let cancel = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
        })
        alert.addAction(cancel)
        
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return resultArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.subtitle, reuseIdentifier:"cell")
            cell.textLabel?.font = UIFont(name: REGULARFONT, size: 13.0)
            cell.detailTextLabel?.font = UIFont(name: BOLDFONT, size: 13.0)
            
            let suggestedHints:[SearchsuggestionHints] = resultArray[indexPath.section] as! [SearchsuggestionHints]
            cell.textLabel?.text = suggestedHints[indexPath.row].label
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchSuggestionCell.identifier, for: indexPath) as! SearchSuggestionCell
            
            let suggestedProducts:[SearchSuggestionModel] = resultArray[indexPath.section] as! [SearchSuggestionModel]
            
            cell.productImg.image = UIImage(named: "ic_placeholder.png")
            cell.productName.text = suggestedProducts[indexPath.row].productName
            
            //special price case
            if suggestedProducts[indexPath.row].hasSpecialPrice {
                let attributeString = NSMutableAttributedString(string: "\(suggestedProducts[indexPath.row].specialPrice) \(suggestedProducts[indexPath.row].price)")
                attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: (suggestedProducts[indexPath.row].specialPrice).count+1, length: suggestedProducts[indexPath.row].price.count))
                cell.productPrice.attributedText = attributeString
            }else{
                cell.productPrice.text = suggestedProducts[indexPath.row].price
            }
            
            GlobalData.sharedInstance.getImageFromUrl(imageUrl:suggestedProducts[indexPath.row].productImage , imageView: cell.productImg)
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1  && resultArray[section].count > 0 {
            return GlobalData.sharedInstance.language(key: "popularproducts")
        }else{
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 60
        }else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let suggestedHints:[SearchsuggestionHints] = resultArray[indexPath.section] as! [SearchsuggestionHints]
            print(suggestedHints[indexPath.row].label)
            self.searchQuery = suggestedHints[indexPath.row].label
            self.performSegue(withIdentifier: "productcategory", sender: self)
        }else if indexPath.section == 1{
            let suggestedProducts:[SearchSuggestionModel] = resultArray[indexPath.section] as! [SearchSuggestionModel]
            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "chef_productdetail") as! Chef_DashboardViewController
            vc.productName = suggestedProducts[indexPath.row].productName
            vc.productId = suggestedProducts[indexPath.row].id
            vc.productImageUrl = suggestedProducts[indexPath.row].productImage
            vc.supplierNameText = ""
            vc.addShow = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "productcategory") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.categoryName = self.categoryName
            viewController.categoryId = self.categoryId
            viewController.categoryType = self.categoryType
            viewController.searchQuery = self.searchQuery
        }
    }
}

extension UISearchBar {
    
    private var textField: UITextField? {
        return subviews.first?.subviews.compactMap { $0 as? UITextField }.first
    }
    
    private var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    newActivityIndicator.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.color = UIColor().HexToColor(hexString: BUTTON_COLOR)
                    newActivityIndicator.backgroundColor = UIColor.white
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}
