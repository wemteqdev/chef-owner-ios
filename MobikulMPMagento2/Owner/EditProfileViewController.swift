//
//  EditProfileViewController.swift
//  Chef-Supplier
//
//  Created by andonina on 10/14/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation
//
//  MyProductListFilterController.swift
//  ShangMarket
//
//  Created by kunal on 28/03/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

@objc protocol EditProfiledelegate: class {
    func saveData(data:String, id: Int)
    func saveProfileImage()
    func saveProfile()
}

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dataField: SkyFloatingLabelTextField!
    var delegate:EditProfiledelegate!
    var data:String = "";
    var placeholdString:String = "";
    var id = -1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.backgroundColor = UIColor(red: 30/255, green: 161/255, blue: 243/255, alpha: 1.0);
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.setTitle(GlobalData.sharedInstance.language(key: "save"), for: .normal)
        saveButton.layer.cornerRadius = 5;
        saveButton.layer.masksToBounds = true;
        dataField.text = data;
        dataField.placeholder = placeholdString;
    }
    
    @IBAction func saveClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        delegate.saveData(data: self.dataField.text!, id: self.id)
    }
}
