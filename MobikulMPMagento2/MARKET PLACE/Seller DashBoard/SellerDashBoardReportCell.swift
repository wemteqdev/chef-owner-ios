//
//  SellerDashBoardReportCell.swift
//  MobikulMPMagento2
//
//  Created by kunal on 25/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerDashBoardReportCell: UITableViewCell, UIWebViewDelegate {
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var reportWebView: UIWebView!
    @IBOutlet weak var currentReportName: UILabel!
    @IBOutlet weak var viewAllButotton: UIButton!
    @IBOutlet weak var reportView: UIView!
    
    var position = 0
    
    var data:NSMutableArray = ["Year","Month","Week","Day"]
    var currentIndex:Int!
    var sellerDashBoardViewModel:SellerDashBoardViewModel!
    
    var item: SellerDashBoardViewModel?  {
        didSet  {
            if item != nil  {
                if (reportWebView.request?.url?.absoluteURL == nil) {
                    selectReportData(pos: position)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewAllButotton.setTitle(GlobalData.sharedInstance.language(key: "viewall"), for: .normal)
        currentReportName.text = "Year";
        currentIndex = 0
        
        reportWebView.delegate = self
        reportWebView.scalesPageToFit = true
        reportWebView.contentMode = .scaleAspectFit
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func segmentClick(_ sender: UISegmentedControl) {
        if segmentControl.selectedSegmentIndex == 0{
            currentIndex = 0
            reportView.isHidden = false
            selectReportData(pos: position)
        }else if segmentControl.selectedSegmentIndex == 1{
            currentIndex = 1
            reportView.isHidden = false
            selectReportData(pos: position)
        }else{
            currentIndex = 2
            reportView.isHidden = true
            selectReportData(pos: position)
        }
    }
    
    @IBAction func viewAllClick(_ sender: UIButton) {
        
        let alert = UIAlertController(title: GlobalData.sharedInstance.language(key: "chooseyourselection"), message: nil, preferredStyle: .actionSheet)
        for i in 0..<data.count {
            let action = UIAlertAction(title: data[i] as? String, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.selectReportData(pos:i)
                self.position = i
            })
            alert.addAction(action)
        }
        
        let cancel = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
        })
        alert.addAction(cancel)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.viewController()?.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:(self.viewController()?.view.bounds.size.width)! / 2.0, y: (self.viewController()?.view.bounds.size.height)! / 2.0, width : 1.0, height : 1.0)
        self.viewController()?.present(alert, animated: true, completion: nil)
        
        
    }
    
    func selectReportData(pos:Int){
        let url: URL!
        
        if currentIndex == 0{
            if pos == 0{
                url = URL(string: sellerDashBoardViewModel.extraSaleDashBoardData.yearlySalesLocationReport!)
            }else if pos == 1{
                url = URL(string: sellerDashBoardViewModel.extraSaleDashBoardData.monthlySalesLocationReport!)
            }else if pos == 2{
                url = URL(string: sellerDashBoardViewModel.extraSaleDashBoardData.weeklySalesLocationReport!)
            }else{
                url = URL(string: sellerDashBoardViewModel.extraSaleDashBoardData.dailySalesLocationReport!)
            }
        }else{
            if pos == 0{
                url = URL(string: sellerDashBoardViewModel.extraSaleDashBoardData.yearlySalesStats!)
            }else if pos == 1{
                url = URL(string: sellerDashBoardViewModel.extraSaleDashBoardData.monthlySalesStats!)
            }else if pos == 2{
                url = URL(string: sellerDashBoardViewModel.extraSaleDashBoardData.weeklySalesStats!)
            }else{
                url = URL(string: sellerDashBoardViewModel.extraSaleDashBoardData.dailySalesStats!)
            }
        }
        
        let requestObj = URLRequest(url: url!)
        reportWebView.loadRequest(requestObj)
        
        currentReportName.text = data[pos] as? String
    }
    
    
    
    
}



