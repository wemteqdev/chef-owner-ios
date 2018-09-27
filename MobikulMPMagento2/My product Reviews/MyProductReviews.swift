//
//  MyProductReviews.swift
//  DummySwift
//
//  Created by kunal prasad on 22/11/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit

class MyProductReviews: UIViewController    {
    
    @IBOutlet weak var productReviewsTableView: UITableView!
    
    var whichApiDataToprocess: String = ""
    var pageNumber:Int = 0
    var loadPageRequestFlag: Bool = false
    var indexPathValue:IndexPath!
    let defaults = UserDefaults.standard
    var myProductReviewViewModel:MyProductReviewViewModel!
    let globalObjectMyProductReviews = GlobalData()
    var refreshControl:UIRefreshControl!
    var emptyView:EmptyNewAddressView!
    var cellHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyNavigationGradient(colors:GRADIENTCOLOR)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        self.title = GlobalData.sharedInstance.language(key: "myproductreview")
        
        self.productReviewsTableView.separatorStyle = .none
        productReviewsTableView.register(MyProductReviewTableViewCell.nib, forCellReuseIdentifier: MyProductReviewTableViewCell.identifier)
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        productReviewsTableView.estimatedRowHeight = Const.closeCellHeight
        productReviewsTableView.rowHeight = UITableViewAutomaticDimension
//        productReviewsTableView.backgroundColor = UIColor.lightGray
        
        pageNumber = 1
        loadPageRequestFlag = true
        callingHttppApi()
        
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "refreshing".localized, attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            productReviewsTableView.refreshControl = refreshControl
        }else {
            productReviewsTableView.backgroundView = refreshControl
        }
        
        emptyView = EmptyNewAddressView(frame: self.view.frame)
        self.view.addSubview(emptyView)
        emptyView.isHidden = true
        emptyView.emptyImages.image = #imageLiteral(resourceName: "emptyProductReview")
        emptyView.addressButton.isHidden = true
        emptyView.labelMessage.text = GlobalData.sharedInstance.language(key: "emptyproductreviewmessage")
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    //MARK:- Pull to refresh
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        loadPageRequestFlag = true
        pageNumber = 1
        callingHttppApi()
        refreshControl.endRefreshing()
    }
    
    //MARK:- API Call
    func callingHttppApi(){
        if pageNumber == 1{
            GlobalData.sharedInstance.showLoader()
        }
        var requstParams = [String:Any]()
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
        let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        requstParams["width"] = width
        requstParams["pageNumber"] = "1"
        GlobalData.sharedInstance.callingHttpRequest(params:requstParams, apiname:"mobikulhttp/customer/reviewList", currentView: self){success,responseObject in
            if success == 1{
                
                print((responseObject as! NSDictionary))
                self.myProductReviewViewModel = MyProductReviewViewModel(data: JSON(responseObject as! NSDictionary))
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
            self.cellHeights = Array(repeating: Const.closeCellHeight, count: self.myProductReviewViewModel.getMyProductReviewData.count)
            self.view.isUserInteractionEnabled = true
            self.productReviewsTableView.delegate = self
            self.productReviewsTableView.dataSource = self
            self.productReviewsTableView.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellCount = self.productReviewsTableView.numberOfRows(inSection: 0)
        for cell: UITableViewCell in self.productReviewsTableView.visibleCells {
            indexPathValue = self.productReviewsTableView.indexPath(for: cell)!
            if indexPathValue.row == self.productReviewsTableView.numberOfRows(inSection: 0) - 1 {
                if (myProductReviewViewModel.totalCout > currentCellCount) && loadPageRequestFlag{
                    whichApiDataToprocess = ""
                    pageNumber += 1
                    loadPageRequestFlag = false
                    callingHttppApi()
                }
            }
        }
    }
    
    enum Const {
        static let closeCellHeight: CGFloat = 95
        static let openCellHeight: CGFloat = 220
        static let rowsCount = 10
    }
    
    //MARK:- @IBAction
    @IBAction func viewBtnClicked(_ sender: UIButton)   {
        let viewController:ReviewDetails = self.storyboard?.instantiateViewController(withIdentifier: "ReviewDetails") as! ReviewDetails
        viewController.reviewId = myProductReviewViewModel.getMyProductReviewData[sender.tag].id
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK:- UITableViewDataSource
extension MyProductReviews : UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if myProductReviewViewModel.getMyProductReviewData.count > 0    {
            emptyView.isHidden = true
            return myProductReviewViewModel.getMyProductReviewData.count
        }else{
            emptyView.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyProductReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: MyProductReviewTableViewCell.identifier) as! MyProductReviewTableViewCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        cell.data = myProductReviewViewModel.getMyProductReviewData[indexPath.row]
        cell.viewBtn.tag = indexPath.row
        cell.viewBtn.addTarget(self, action: #selector(viewBtnClicked(_:)), for: .touchUpInside)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights.count > 0 ? cellHeights[indexPath.row] : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCells

        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as MyProductReviewTableViewCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
    }
}

extension MyProductReviews: ProductReviewProtocol   {
    func productViewBtnClicked(index: Int) {
        let viewController:ReviewDetails = self.storyboard?.instantiateViewController(withIdentifier: "ReviewDetails") as! ReviewDetails
        viewController.reviewId = myProductReviewViewModel.getMyProductReviewData[index].id
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
