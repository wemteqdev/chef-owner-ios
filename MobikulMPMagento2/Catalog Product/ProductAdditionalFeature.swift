//
//  ProductAdditionalFeature.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 16/09/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class ProductAdditionalFeature: UIViewController,UITableViewDelegate, UITableViewDataSource{


@IBOutlet weak var featureTableView: UITableView!
var catalogProductViewModel:CatalogProductViewModel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = GlobalData.sharedInstance.language(key: "feature")
        
        featureTableView.register(UINib(nibName: "AdditionalFeatureTableViewCell", bundle: nil), forCellReuseIdentifier: "AdditionalFeatureTableViewCell")
        featureTableView.rowHeight = UITableViewAutomaticDimension
        featureTableView.separatorColor = UIColor.clear
        self.featureTableView.estimatedRowHeight = 50
        self.featureTableView.delegate = self
        self.featureTableView.dataSource = self
       
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if catalogProductViewModel.additionalFeature.count == 0  {
            //empty case
            GlobalData.sharedInstance.showWarningSnackBar(msg: GlobalData.sharedInstance.language(key: "NoFeaturesAvailable"))
            self.navigationController?.popViewController(animated: true)
        }
        
        return catalogProductViewModel.additionalFeature.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return 1
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return catalogProductViewModel.additionalFeature[section].label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalFeatureTableViewCell", for: indexPath) as! AdditionalFeatureTableViewCell
        cell.textValue.text  = catalogProductViewModel.additionalFeature[indexPath.section].value
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    
    
    
    
    
   
}
